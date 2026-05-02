/**
 * Called during subsystem init to upssert persistent type definitions into the database.
 */
/datum/controller/subsystem/persistence/proc/typesInitialize()
	PRIVATE_PROC(TRUE)
	// Types init:
	// Upsert persistent types, excluding base types
	// Clean persistent history types by type-specified expiration rules
	// Persistent history cache init

	// Types upsert
	// Base types to exclude
	var/base_types = list(/singleton/persistent_type, /singleton/persistent_type/generic, /singleton/persistent_type/history, /singleton/persistent_type/history/character)
	var/custom_types = typesof(/singleton/persistent_type) - base_types

	// Upsert all persistent type definitions found in code
	for (var/singleton/persistent_type/T in custom_types)
		typesDatabaseUpsertType("[T]", T.title, T.description, T.definition_type_value)

	// Clean persistent history
	// - Get each used type from database in combination with it's attribute (type+attribute combination called container)
	// - Check what needs to be done to clean it
	// - Clean type+attribute combination based of its types expiration rule
	var/list/containers = list()

	for(var/singleton/persistent_type/T in custom_types) // Iterate through each type to clean by it's own rule
		if(!istype(T, /singleton/persistent_type/history)) // Only history has such rules
			continue
		var/singleton/persistent_type/history/H = T
		// Each rule has a different execution flow
		if(istype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/row_count))
			var/max_row_count = astype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/row_count).max_row_count

		if(istype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/round_count))
			var/max_round_count = astype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/round_count).max_round_count

		if(istype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/age))
			var/max_age_days = astype(H.expiration_rule, /singleton/persistent_type_history_expiration_rule/age).max_age_days



	// Init internal history cache
	history_last_id = typesHistoryDatabaseGetLastID()
	if(history_last_id <= 0)
		CRASH("Failed to get last ID of persistent type history records from the database during initialization. History record caching cannot be prepared!")
	else
		history_virtual_id = history_last_id
		history_cache = list()

/**
 * Finalize persistent types.
 * Adds new persistent generics and history.
 */
/datum/controller/subsystem/persistence/proc/typesFinalize()
	PRIVATE_PROC(TRUE)

	// Subsystem shutdown:
	// Save all history records in cache to database which have an ID higher then last known database ID - Records created during the round.

	for(var/datum/persistent_record_container/c in history_cache)
		if(length(c.records)) // Container was queried, got no hits and nothing was added.
			continue
		var/list/datum/persistent_record/new_records = list()
		for(var/datum/persistent_record/r in c.records)
			if(r.id > history_last_id) // ID assigned by virtual ID > last known database ID, record is new and needs to be saved.
				new_records += r
		sortTim(new_records, /proc/cmp_persistent_record_id_asc) // Sort by ID to preserve creation order, as the virtual IDs get replaced by real database IDs.
		for(var/datum/persistent_record/r in new_records)
			typesHistoryDatabaseInsertRecord(c.type_id, c.attribute, r.value)

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
