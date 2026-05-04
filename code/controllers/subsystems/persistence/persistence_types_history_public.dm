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

	if(target_type.requires_attribute && !length(attribute))
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
	for(var/datum/persistent_record_container/c as anything in history_cache)
		if(c.type_define == target_type.type && c.attribute == attribute)
			container = c
			break

	if(!container)
		container = new /datum/persistent_record_container
		container.type_define = target_type.type
		container.attribute = attribute
		container.records = list()
		history_cache += container

	// Create record and add to container
	var/datum/persistent_record/r = new /datum/persistent_record
	r.id = typesGetVirtualRecordID()
	r.created_at = "[worlddate2text()] [worldtime2text()]" // TODO - Verify this is equvialent to NOW() in SQL
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
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache, defaults to FALSE. Can be used for rare but large count queries.
 * RETURN:
 * 	List of /persistent_record or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecords(var/singleton/persistent_type/history/target_type, attribute, limit, skip_caching = FALSE)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to get history records with null target type.")
		return list()

	if(target_type.requires_attribute && !attribute)
		log_subsystem_persistence_warning("Attempted to get history records of type [target_type] without required attribute.")
		return list()

	// Query order
	// 1 - Check if record container exists, if so, check if last X records are in there, aggregate found records, step to DB (2) for missing remainders.
	// 2 - Query database for last X records of type and add it to record container as new cache

	var/datum/persistent_record_container/container = null
	for(var/datum/persistent_record_container/c as anything in history_cache)
		if(c.type_define == target_type.type && c.attribute == attribute)
			container = c
			break

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
		history_cache += container

	// Query order - 2
	var/list/results = historyDatabaseGetRecords(target_type.database_id, attribute, limit - length(top)) // Draw remaining missing records from DB
	var/len = length(results)
	if(!len)
		return list()

	if(!skip_caching)
		history_cache_count += len

	for(var/result in results)
		var/datum/persistent_record/r = new /datum/persistent_record
		r.id = result["id"]
		r.created_at = result["created_at"]
		r.value = result["value"]
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
 *  skip_caching =	If set to TRUE, the results won't be added to the types cache. Recommended to be TRUE for this proc unless further queries are ran for the type+attribute.
 * RETURN:
 * 	List of /persistent_record or empty list.
 */
/datum/controller/subsystem/persistence/proc/historyGetAllRecords(var/singleton/persistent_type/history/target_type, attribute, skip_caching)
	var/result = historyGetLastRecords(target_type, attribute, 1000, skip_caching) // TODO 1000 okay?
	if(length(result) == 0)
		return null
	else
		return result[1]
