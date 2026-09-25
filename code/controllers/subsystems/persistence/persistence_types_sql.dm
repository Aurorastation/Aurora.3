/**
 * Insert or update a type definition in the database. If a type with the same name already exists, it will be updated with the new title and description.
 * PARAMS:
 * 	type =				Name of type to be upserted.
 *  title =				Custom display title of the type.
 *  description =		Custom display description of the type.
 *  definition_type =	Enum value of the definition type. See /singleton/persistent_type.
 */
/datum/controller/subsystem/persistence/proc/typesDatabaseUpsertType(type, title, description, definition_type)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesDatabaseUpsertType"))
		return

	var/datum/db_query/upsert_query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_type_definitions (type, title, description, definition_type) VALUES (:type, :title, :description, :definition_type) \
		ON DUPLICATE KEY UPDATE title = VALUES(title), description = VALUES(description)",
		list(
			"type" = type,
			"title" = title,
			"description" = description,
			"definition_type" = definition_type
		)
	)
	upsert_query.Execute()

	databaseCheckQueryResult(upsert_query, "typesDatabaseUpsertType")
	qdel(upsert_query)

/**
 * Get ID of type definition.
 * PARAMS:
 *	type_name = Type name of singleton definition.
 * RETURN:
 *	Database ID of type.
 */
/datum/controller/subsystem/persistence/proc/typesDatabaseGetTypeIdByName(type_name)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesDatabaseGetTypeIdByName"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id FROM ss13_persistent_type_definitions WHERE type = :type_name",
		list("type_name" = type_name)
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typesDatabaseGetTypeIdByName"))
		qdel(query)
		return 0

	var/database_id = null
	if(query.NextRow())
		database_id = query.item[1]
	qdel(query)
	return database_id
