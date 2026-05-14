/**
 * Called during subsystem init to upssert persistent type definitions into the database.
 */
/datum/controller/subsystem/persistence/proc/typesInitialize()
	PRIVATE_PROC(TRUE)
	// Types init:
	// Upsert all types found in code into database
	// Get type ID of each type found in code by name lookup
	// -- Records
	// Init history cache
	// Run cleanup on history records
	// -- Generics
	// Init generic cache
	// Run cleanup on generics

	// Types upsert
	// Base types to exclude
	var/base_types = list(/singleton/persistent_type, /singleton/persistent_type/generic, /singleton/persistent_type/history, /singleton/persistent_type/history/character)
	var/custom_types = typesof(/singleton/persistent_type) - base_types // These are the types we are actually dealing with

	// Upsert all persistent type definitions found in code
	// Whether or not it's new, get its database ID
	for (var/C in custom_types)
		CHECK_TICK
		var/singleton/persistent_type/T = GET_SINGLETON(C)
		typesDatabaseUpsertType("[T]", T.title, T.description, T.definition_type_value)
		T.database_id = typesDatabaseGetTypeIdByName("[T]")

	// ### Records

	// Init internal history cache
	history_last_database_id = historyDatabaseGetLastID()
	if(history_last_database_id == 0)
		log_subsystem_persistence_warning("Failed to get last ID of persistent type history records from the database during initialization. Either the table is empty or something went wrong.")
	history_virtual_id = history_last_database_id
	history_cache = alist()

	// Clean history records
	for(var/type_combination in historyDatabaseGetTypeAttributeCombinations()) // Iterate through each distinct type+attribute combination
		CHECK_TICK
		var/type_id = type_combination["type_id"]
		var/attribute = type_combination["attribute"]
		var/singleton/persistent_type/history/found_type
		for (var/C in custom_types)
			var/singleton/persistent_type/T = GET_SINGLETON(C)
			if(istype(T, /singleton/persistent_type/history) && T.database_id == type_id)
				found_type = T
		if(!found_type)
			continue // The type found in the database is no longer available in the codebase
		// Clean by the individual cleanup rule
		if(istype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/row_count))
			var/max_row_count = astype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/row_count).max_row_count
			historyDatabaseCleanByRowCount(found_type.database_id, attribute, max_row_count)
		if(istype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/round_count))
			var/max_round_count = astype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/round_count).max_round_count
			historyDatabaseCleanByRoundCount(found_type.database_id, attribute, max_round_count)
		if(istype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/age))
			var/max_age_days = astype(found_type.expiration_rule, /singleton/persistent_type_history_expiration_rule/age).max_age_days
			historyDatabaseCleanByMaxAgeDays(found_type.database_id, attribute, max_age_days)

	// ### Generics

	// Init internal generic cache
	generic_cache = alist()
	// Cleanup
	genericDatabaseCleanup()

	// ### Char lookup
	char_cache = alist()

/**
 * Finalize persistent types.
 * Adds new persistent generics and history.
 */
/datum/controller/subsystem/persistence/proc/typesFinalize()
	PRIVATE_PROC(TRUE)

	// Subsystem shutdown:
	// Call finalization hook for each known persistent_type
	// Save all history records in cache to database which have an ID higher then last known database ID - Records created during the round.
	// Save all generics in cache to database which have an ID higher then last known database ID - Generics created during the round.

	// ##### Hooks
	var/base_types = list(/singleton/persistent_type, /singleton/persistent_type/generic, /singleton/persistent_type/history, /singleton/persistent_type/history/character)
	var/custom_types = typesof(/singleton/persistent_type) - base_types // These are the types we are actually dealing with
	for (var/C in custom_types)
		CHECK_TICK
		var/singleton/persistent_type/type_instance = GET_SINGLETON(C)
		try
			type_instance.finalization_hook()
		catch(var/exception/e)
			log_subsystem_persistence_error("Unhandled exception during finalization_hook of [type_instance]", e)

	// ##### Saving history
	var/total_saved_count = 0
	for(var/key in history_cache)
		CHECK_TICK
		var/datum/persistent_record_container/container = history_cache[key] // Dictionary<"[type](+[attribute])", container>
		if(!length(container.records))
			continue // Container was queried, got no hits and nothing was added.

		var/list/datum/persistent_record/new_records = list()
		for(var/datum/persistent_record/record in container.records)
			if(record.id > history_last_database_id) // ID assigned by virtual ID is larger then last known database ID, record is new and needs to be saved.
				new_records += record

		sortTim(new_records, /proc/cmp_persistent_record_id_asc) // Sort by ID to preserve creation order, as the virtual IDs get replaced by real database IDs.

		for(var/datum/persistent_record/record in new_records)
			var/singleton/persistent_type/type_instance = GET_SINGLETON(container.type_define)
			historyDatabaseInsertRecord(type_instance.database_id, container.attribute, record.value)
			total_saved_count++

	log_subsystem_persistence_info("Saved new [length(total_saved_count)] persistent history records.")

	// ##### Saving generics
	for(var/key in generic_cache)
		CHECK_TICK
		var/datum/persistent_generic/container = generic_cache[key] // Dictionary<"[type](+[attribute])", container>
		var/singleton/persistent_type/type_instance = GET_SINGLETON(container.type_define)
		genericDatabaseSave(type_instance.database_id, container.attribute, container.expires_in_days, json_encode(container.content))

	log_subsystem_persistence_info("Saved [length(generic_cache)] persistent generics.")

/**
 * Internal proc for assigning new IDs to history records, these are used for internal cache tracking and will be discard by database IDs at finalization.
 */
/datum/controller/subsystem/persistence/proc/typesGetVirtualRecordID()
	PRIVATE_PROC(TRUE)
	history_virtual_id += 1
	return history_virtual_id

/**
 * Internal proc for finding the top K records (by ID) in a record container.
 * Top K insertion sort selection (Manual leaderboard sort).
 * PARAMS:
 * 	k = Number of records to return.
 * 	Container = Container to search in.
 * RETURN:
 * 	List of top K records by ID, sorted from highest to lowest.
 */
/datum/controller/subsystem/persistence/proc/typesHistoryCacheSelectTopK(k, datum/persistent_record_container/container)
	PRIVATE_PROC(TRUE)
	if(length(container.records))
		return list()

	var/list/datum/persistent_record/top = list()

	for(var/datum/persistent_record/r in container.records)
		var/insert_pos = 1

		// Find position for insert when top isn't full yet or when a value in top is smaller then current record to be replaced
		while(insert_pos <= top.len && top[insert_pos].id > r.id)
			insert_pos++

		if(top.len < k) // Top isn't full yet, insert without cutting
			top.Insert(insert_pos, r)
		else if(r.id > top[top.len].id) // Top is full, replace next lowest pos with current record and cut list back to size k
			top.Insert(insert_pos, r)
			top.Cut(k+1)

	return top

/datum/controller/subsystem/persistence/proc/typesGetCacheName(var/singleton/persistent_type/target_type, var/attribute)
	if(attribute && length(attribute) > 0)
		return "[target_type]+[attribute]"
	else
		return "[target_type]"
