/**
 * Helper proc for history/character persistent types to retrieve a character name based of it's character ID.alist
 * PARAMS:
 *  char_id = ID of character.
 * RETURN:
 *  Character name or null if not found.
 */
/datum/controller/subsystem/persistence/proc/historyGetCharnameByID(char_id)
	if(!char_id)
		return null

	var/char_id_num = text2num(char_id)
	if(char_id_num <= 0)
		return null

	var/cache_hit = char_cache[char_id_num]
	if(cache_hit)
		return cache_hit

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT name FROM ss13_characters WHERE id = :char_id",
		list("char_id" = char_id_num)
	)
	query.Execute()

	var/char_name
	while(query.NextRow())
		char_name += query.item[1]
	qdel(query)
	if(!char_name)
		return null
	else
		char_cache[char_id_num] = char_name
		return char_name

/**
 * Add a new record to the history for the given type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/history and subtypes.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 *	value =			Value of the record, cannot be null or empty.
 */
/datum/controller/subsystem/persistence/proc/historyAddRecord(var/singleton/persistent_type/history/target_type, attribute, value)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to add history record with null target type.")
		return

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(type_instance.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to add history record of type [target_type] without required attribute.")
		return

	if(!length(value))
		log_subsystem_persistence_warning("Attempted to add history record of type [target_type] with empty value.")
		return

	// Sanity check if a character record is added using this proc directly instead of the overload historyAddCharacterRecord.
	if(istype(target_type, /singleton/persistent_type/history/character) && (!length(attribute) || !isnum(attribute)))
		log_subsystem_persistence_warning("Attempted to add character history record of target type [target_type], but the attribute was either empty or failed the isnum check.")
		return

	// Add record to cache for DB insert at finalization and quick access
	// Check if record container exists, if not, create it
	var/datum/persistent_record_container/container = null
	attribute = length(attribute) > 0 ? attribute : null
	container = history_cache[typesGetCacheName(target_type, attribute)]

	if(!container)
		container = new /datum/persistent_record_container
		container.type_define = target_type.type
		container.attribute = attribute
		container.records = list()
		history_cache[typesGetCacheName(target_type, attribute)] = container

	// Create record and add to container
	var/datum/persistent_record/r = new /datum/persistent_record
	r.id = typesGetVirtualRecordID()
	r.created_at = "[worlddate2text()] [worldtime2text()]"
	r.game_id = GLOB.round_id
	r.value = value
	container.records += r
	history_cache_count++

/**
 * Add a new record that belongs to a specific character to the history for the given type.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/history/character and subtypes.
 *  char_id =		Character ID that the record should belong to.
 *	value =			Value of the record, cannot be null or empty.
 */
/datum/controller/subsystem/persistence/proc/historyAddCharacterRecord(var/singleton/persistent_type/history/character/target_type, char_id, value)
	if(!istype(target_type, /singleton/persistent_type/history/character))
		log_subsystem_persistence_warning("Attempted to add character history record, but the provided target type didn't match a character persistent type, provided was [target_type]")
		return
	if(!isnum(char_id))
		log_subsystem_persistence_warning("Attempted to add character history record of type [target_type] but char_id failed the isnum check.")
		return
	return historyAddRecord(target_type, char_id, value)

/**
 * Queries the last record of a specified type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 *					If the type definition is a character record type, the attribute must be a valid character ID or the record will be rejected.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 * RETURN:
 * 	Single /persistent_record or null.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecord(var/singleton/persistent_type/history/target_type, attribute)
	var/result = historyGetLastRecords(target_type, attribute, 1)
	if(length(result) == 0)
		return null
	else
		return result[1]

/**
 * Queries the last X records of a specified type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 *					If the type definition is a character record type, the attribute must be a valid character ID or the record will be rejected.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 *  limit =			Number of records to retrieve.
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache, defaults to FALSE.
 * RETURN:
 * 	List of /persistent_record or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecords(var/singleton/persistent_type/history/target_type, attribute, limit, skip_caching = FALSE)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to get history records with null target type.")
		return list()

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(type_instance.requires_attribute && !attribute)
		log_subsystem_persistence_warning("Attempted to get history records of type [target_type] without required attribute.")
		return list()

	// Query order
	// 1 - Check if record container exists, if so, check if last X records are in there, aggregate found records, step to DB (2) for missing remainders.
	// 2 - Query database for last X records of type and add it to record container as new cache

	var/datum/persistent_record_container/container = null
	attribute = length(attribute) > 0 ? attribute : null
	container = history_cache[typesGetCacheName(target_type, attribute)]

	var/list/datum/persistent_record/top = list()

	// Query order - 1
	if(container)
		top = typesHistoryCacheSelectTopK(limit, container)
		if(length(top) == limit) // All X records got hit in cache, return
			return top
	else
		container = new /datum/persistent_record_container
		container.type_define = target_type.type
		container.attribute = attribute
		container.records = list()
		history_cache[typesGetCacheName(target_type, attribute)] = container

	// Query order - 2
	var/list/db_records = historyDatabaseGetRecords(type_instance.database_id, attribute, limit - length(top)) // Draw remaining missing records from DB
	var/len = length(db_records)
	if(!len)
		return list()

	if(!skip_caching)
		history_cache_count += len

	for(var/alist/record in db_records)
		var/datum/persistent_record/r = new /datum/persistent_record
		r.id = record["id"]
		r.created_at = record["created_at"]
		r.game_id = record["game_id"]
		r.value = record["value"]
		if(!skip_caching)
			container.records += r // Add to cache
		top += r // Records in top are either newly created or read from DB already, append newly queries records.

	return top

/**
 * Queries all records of a specified type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 *					If the type definition is a character record type, the attribute must be a valid character ID or the record will be rejected.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache, defaults to TRUE.
 * RETURN:
 * 	List of /persistent_record or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetAllRecords(var/singleton/persistent_type/history/target_type, attribute, skip_caching = TRUE)
	var/result = historyGetLastRecords(target_type, attribute, 1000, skip_caching) // TODO 1000 okay?
	if(length(result) == 0)
		return null
	else
		return result[1]

/**
 * Queries the last record of the specified type for all attributes.
 * PARAMS:
 * 	target_type = Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 * RETURN:
 * 	Associative list with "attribute" and "records" of type list(/persistent_record) or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecordForAllAttributes(var/singleton/persistent_type/history/target_type)
	var/result = historyGetLastRecordsForAllAttributes(target_type, 1)
	if(length(result) == 0)
		return list()
	else
		return result

/**
 * Queries the last X records of a specified type for all attributes.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 *  limit =			Number of records to retrieve.
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache, defaults to TRUE.
 * RETURN:
 * 	List of associative list with "attribute" and "records" of type list(/persistent_record) or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecordsForAllAttributes(var/singleton/persistent_type/history/target_type, limit, skip_caching = TRUE)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to get history records with null target type.")
		return list()

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	var/list/result = list()

	var/attributes = historyDatabaseGetAllAttributes(type_instance.database_id)
	if(attributes && length(attributes) > 0)
		for(var/attribute in attributes)
			result += alist("attribute" = attribute, "records" = historyGetAllRecords(target_type, attribute, skip_caching))
	else
		var/no_attribute_records = historyGetAllRecords(target_type, null, skip_caching)
		if(no_attribute_records && length(no_attribute_records) > 0)
			result = alist("attribute" = null, "records" = no_attribute_records)
	return result

/**
 * Queries all records of a specified type for all attributes.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type and subtypes.
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache, defaults to TRUE.
 * RETURN:
 * 	List of associative list with "attribute" and "records" of type list(/persistent_record) or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetAllRecordsForAllAttributes(var/singleton/persistent_type/history/target_type, skip_caching = TRUE)
	var/result = historyGetLastRecordsForAllAttributes(target_type, 1000, skip_caching) // TODO 1000 okay?
	if(length(result) == 0)
		return null
	else
		return result
