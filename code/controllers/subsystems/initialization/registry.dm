/*
 * Registry subsystem
 * Subsystem for managing any form of persistent configurations across rounds.
 */

SUBSYSTEM_DEF(registry)
	name = "Registry"
	init_order = INIT_ORDER_REGISTRY
	flags = SS_NO_FIRE // This subsystem has no continuous workload, it's init only.
	var/cache = list() // Read-through and write-through cache of registry entries.

/**
 * Subsystem info stub message generation.
 */
/datum/controller/subsystem/registry/stat_entry(msg)
	msg = ("Cache size:[length(cache)]")
	return msg

/**
 * Helper method to check database connection.
 * RETURN: True if connection is successful, false if not.
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

	if(!GLOB.config.sql_enabled || !databaseCheckConnection())
		internal_log("SQL connection unavailable. Registry subsystem init not possible.")
		to_world(SPAN_INFO("Configuration registry unreachable, only local configs are available.")) // Even if the prod instance relies on the DB, we still need to support non-DB local instances.
		return SS_INIT_SUCCESS // If the database is unavailable, local configs may be used.

	return SS_INIT_SUCCESS

/**
 * Writes a message to the registry subsystem log when logging is enabled.
 */
/datum/controller/subsystem/registry/proc/internal_log(message)
	PRIVATE_PROC(TRUE)
	if (GLOB.config?.logsettings["log_subsystems_registry"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_registry_log"], "SSRegistry: [message]")

/**
 * Retrieves a registry value by key, using the cache before querying the database.
 * PARAMS:
 * 	key = The key of the registry entry to retrieve.
 * 	fallback_value = The value to return if the key is not found or on error.
 * RETURN: The value of the registry entry, or the fallback_value if not found or on error.
 */
/datum/controller/subsystem/registry/proc/getValue(key, fallback_value = null)
	if(!key)
		internal_log("Attempted to get registry value with null key.")
		return fallback_value
	key = LOWER_TEXT(key)
	if(key == "")
		internal_log("Attempted to get registry value with empty key.")
		return fallback_value

	var/cached_value = cache[key]
	if(cached_value)
		return cached_value

	if(!databaseCheckConnection())
		internal_log("No DB connection, attempted: [key]")
		return fallback_value

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT content FROM ss13_registry WHERE lookup = :key",
		list("key" = key)
	)
	query.Execute()

	var/value = fallback_value
	if (!query)
		internal_log("Unknown SQL error, attempted: [key]")
		return fallback_value
	else if (query.ErrorMsg())
		internal_log("SQL error, attempted: [key], " + query.ErrorMsg())
		return fallback_value
	else
		if(query.NextRow())
			value = query.item[1]
			cache[key] = query.item[1]
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
		internal_log("Attempted to set registry value with null key.")
		return FALSE
	key = LOWER_TEXT(key)
	if(key == "")
		internal_log("Attempted to set registry value with empty key.")
		return FALSE

	if (length(key) > 128)
		internal_log("Attempted to set registry value with key exceeding 128 characters: [key]")
		return FALSE
	if (value == null || value == "")
		return clearKey(key) // If the value is null or empty, we treat it as a request to clear the key.
	if (length(value) > 1024)
		internal_log("Attempted to set registry value with value exceeding 1024 characters for key: [key]")
		return FALSE

	if(!databaseCheckConnection())
		internal_log("No DB connection, attempted to set: [key], with: [value]")
		return FALSE

	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO ss13_registry (lookup, content) VALUES (:key, :value) \
		ON DUPLICATE KEY UPDATE content = :value",
		list(
			"key" = key,
			"value" = value
		)
	)
	query.Execute()

	if (!query)
		internal_log("Unknown SQL error, attempted to set: [key], with: [value]")
		return FALSE
	else if (query.ErrorMsg())
		internal_log("SQL error, attempted to set: [key], with: [value], " + query.ErrorMsg())
		return FALSE
	qdel(query)

	cache[key] = value
	return TRUE

/**
 * Removes a registry value from the database and cache.
 * PARAMS:
 * 	key = The key of the registry entry.
 * RETURN: True if the operation was successful, false if not.
 */
/datum/controller/subsystem/registry/proc/clearKey(key)
	if(!key)
		internal_log("Attempted to clear registry value with null key.")
		return FALSE
	key = LOWER_TEXT(key)
	if(key == "")
		internal_log("Attempted to clear registry value with empty key.")
		return FALSE

	if(!databaseCheckConnection())
		internal_log("No DB connection, attempted to clear: [key]")
		return FALSE

	var/datum/db_query/query = SSdbcore.NewQuery(
		"DELETE FROM ss13_registry WHERE lookup = :key",
		list("key" = key)
	)
	query.Execute()

	if (!query)
		internal_log("Unknown SQL error, attempted to clear: [key]")
		return FALSE
	else if (query.ErrorMsg())
		internal_log("SQL error, attempted to clear: [key], " + query.ErrorMsg())
		return FALSE
	qdel(query)

	if(key in cache)
		cache -= key
	return TRUE

