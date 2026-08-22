/*
 * Registry subsystem
 * Subsystem for managing any form of persistent configurations across rounds.
 */

SUBSYSTEM_DEF(registry)
	name = "Registry"
	init_order = INIT_ORDER_REGISTRY
	flags = SS_NO_FIRE // This subsystem has no continues workload, it's init only.
	var/cache = list() // Read-through cache of registry entries.

/**
 * Subsystem info stub message generation.
 */
/datum/controller/subsystem/registry/stat_entry(msg)
	msg = ("Cache size:[length(cache)]")
	return msg

/**
 * Helper method to check database connection.
 * RETURN: True if connection is scuccessful, false if not.
 */
/datum/controller/subsystem/registry/proc/databaseCheckConnection()
	PRIVATE_PROC(TRUE)
	if(!SSdbcore.Connect())
		return FALSE
	return TRUE

/**
 * Initialization of the registry subsystem.
 * Includes a DB connection check.
 */
/datum/controller/subsystem/registry/Initialize()
	. = ..()
	if(!GLOB.config.sql_enabled)
		log("SQL configuration not enabled. Registry subsystem requires SQL. Skipping init.")
		return SS_INIT_SUCCESS

	if(!databaseCheckConnection())
		log("SQL connection unavailable. Registry subsystem init not possible.")
		return SS_INIT_FAILURE

	return SS_INIT_SUCCESS

/**
 * Writes a message to the registry subsystem log when logging is enabled.
 */
/datum/controller/subsystem/registry/proc/log(message)
	PRIVATE_PROC(TRUE)
	if (GLOB.config?.logsettings["log_subsystems_registry"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_registry_log"], "SSRegistry: [message]")

/**
 * Retrieves a registry value by key, using the cache before querying the database.
 * RETURN: The value of the registry entry, or null if not found or on error.
 */
/datum/controller/subsystem/registry/proc/getValue(key)
	if(!key)
		log("Attempted to get registry value with null key.")
		return null
	key = LOWER_TEXT(key)
	if(key == "")
		log("Attempted to get registry value with empty key.")
		return null

	var/cached_value = cache[key]
	if(cached_value)
		return cached_value

	if(!databaseCheckConnection())
		log("No DB connnection, attempted: [key]")
		return null

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT value FROM ss13_registry WHERE key = :lookup",
		list("lookup" = key)
	)
	query.Execute()

	var/value = null
	if (!query)
		log("Unkown SQL error, attempted: [key]")
		return null
	else if (query.ErrorMsg())
		log("SQL error, attempted: [key], " + query.ErrorMsg())
		return null
	else
		if(query.NextRow())
			value = query.item[1]
		cache[key] = value
	qdel(query)
	return value

/**
 * Inserts or updates a registry value in the database.
 * PARAMS:
 * 	key = The key of the registry entry.
 * 	value = The value to set for the registry entry.
 * RETURN: True if the operation was successful, false if not.
 */
/datum/controller/subsystem/registry/proc/setValue(key, value)
	if(!key)
		log("Attempted to set registry value with null key.")
		return FALSE
	key = LOWER_TEXT(key)
	if(key == "")
		log("Attempted to set registry value with empty key.")
		return FALSE

	if(!databaseCheckConnection())
		log("No DB connnection, attempted to set: [key], with: [value]")
		return FALSE

	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO ss13_registry (key, value) VALUES (:lookup, :input) \
		ON DUPLICATE KEY UPDATE value = :input",
		list(
			"lookup" = key,
			"input" = value
		)
	)
	query.Execute()

	if (!query)
		log("Unknown SQL error, attempted to set: [key], with: [value]")
		return FALSE
	else if (query.ErrorMsg())
		log("SQL error, attempted to set: [key], with: [value], " + query.ErrorMsg())
		return FALSE
	qdel(query)

	cache[key] = value
	return TRUE
