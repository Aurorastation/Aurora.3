/**
 * Add a new record to the history for the given type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistency_type_definition and subtypes.
 *					If the type definition is a character record type, the attribute must be a valid character ID or the record will be rejected.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 *	value =			Value of the record, cannot be null or empty.
 */
/datum/controller/subsystem/persistence/proc/historyAddRecord(var/singleton/persistency_type_definition/history/target_type, attribute, value)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to add history record with null target type.")
		return

	if(target_type.requires_attribute && !attribute)
		log_subsystem_persistence_warning("Attempted to add history record of type [target_type] without required attribute.")
		return

	if(!value)
		log_subsystem_persistence_warning("Attempted to add history record of type [target_type] with empty value.")
		return

	if(istype(target_type, /singleton/persistency_type_definition/history/character))
		CRASH("TODO")
		// For character history types, we want to validate the attribute is a character ID
		//if(attribute is an integer) // TODO

	// Add record to cache for later insert and quick access
	// Check if record container exists, if not, create it
	var/persistency_record_container/container = null
	for(var/persistency_record_container/c as anything in history_cache)
		if(c.type_id == target_type.definition_type_value && c.attribute == attribute)
			container = c
			break

	if(!container)
		container = new /persistency_record_container
		container.type_id = target_type.definition_type_value
		container.attribute = attribute
		container.records_lookup = list()
		history_cache += container

	// Create record and add to container
	history_virtual_id += 1
	container.records_lookup[history_virtual_id] = value

/**
 * Queries the last record of a specified type/attribute.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistency_type_definition and subtypes.
 *					If the type definition is a character record type, the attribute must be a valid character ID or the record will be rejected.
 *  attribute =		Custom attribute of the record, can be null if the type definition doesn't require it.
 */
/datum/controller/subsystem/persistence/proc/historyGetLastRecord(var/singleton/persistency_type_definition/history/target_type, attribute)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to get history record with null target type.")
		return null

	if(target_type.requires_attribute && !attribute)
		log_subsystem_persistence_warning("Attempted to get history record of type [target_type] without required attribute.")
		return null

	// Query order
	// 1 - Check if record container exists, if so, check if a record is in there, return with highest ID, if the ID is higher than history_last_id
	// 2 - Query database for last record of type and add it to record container as new cache

	var/persistency_record_container/container = null
	for(var/persistency_record_container/c as anything in history_cache)
		if(c.type_id == target_type.definition_type_value && c.attribute == attribute)
			container = c
			break

	// Query order - 1
	if(container)
		if(length(container.records_lookup))
			var/highest_id = 0
			for(var/id in container.records_lookup)
				if(id > highest_id)
					highest_id = id
			if(highest_id > history_last_id) // Record found in cache and record is newer then last database record
				return container.records_lookup[highest_id]
	else
		container = new /persistency_record_container
		container.type_id = target_type.definition_type_value
		container.attribute = attribute
		container.records_lookup = list()
		history_cache += container

	// Query order - 2
	var/list/results = typeHistoryDatabaseGetRecords(target_type.definition_type_value, attribute, 1)
	if(length(results))
		return null

	// Update cache
	container.records_lookup[results[1]["id"]] = results[1]["value"]
