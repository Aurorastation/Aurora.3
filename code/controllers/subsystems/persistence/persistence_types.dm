/**
 * Called during subsystem init to upssert persistent type definitions into the database.
 */
/datum/controller/subsystem/persistence/proc/typesInitialize()
	// Upsert all persistent type definitions found in code
	for (var/singleton/persistency_type_definition/T in typesof(/singleton/persistency_type_definition) - /singleton/persistency_type_definition)
		typeDatabaseUpsertType("[T]", T.title, T.description, T.definition_type_value)

	// Init history record cache
	history_last_id = typeHistoryDatabaseGetLastID()
	if(history_last_id <= 0)
		CRASH("Failed to get last ID of persistent type history records from the database during initialization. History record caching cannot be prepared!")
	else
		history_cache = list()
