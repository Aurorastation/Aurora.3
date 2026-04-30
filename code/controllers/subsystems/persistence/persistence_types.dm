/**
 * Called during subsystem init to upssert persistent type definitions into the database.
 */
/datum/controller/subsystem/persistence/proc/typeDefinitionInitialize()
	for (var/singleton/persistency_type_definition/T in typesof(/singleton/persistency_type_definition) - /singleton/persistency_type_definition)
		typeDefinitionDatabaseUpsertType("[T]", T.title, T.description, T.definition_type_value)
