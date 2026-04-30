/**
 * Insert or update a type definition in the database. If a type with the same name already exists, it will be updated with the new title and description.
 */
/datum/controller/subsystem/persistence/proc/typeDatabaseUpsertType(type, title, description, definition_type)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typeDatabaseUpsertType"))
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

	databaseCheckQueryResult(upsert_query, "typeDatabaseUpsertType")
	qdel(upsert_query)

/datum/controller/subsystem/persistence/proc/typeHistoryDatabaseGetLastID()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typeHistoryDatabaseGetLastID"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id FROM ss13_persistent_type_history ORDER BY id DESC LIMIT 1"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typeHistoryDatabaseGetLastID"))
		qdel(query)
		return 0

	var/last_id = 0
	if(query.NextRow())
		last_id = query.item[1]
	qdel(query)
	return last_id

/datum/controller/subsystem/persistence/proc/typeHistoryDatabaseInsertRecord(type_id, attribute, value, game_id)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typeHistoryDatabaseInsertRecord"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_type_history (type, created_at, attribute, value, game_id) VALUES (:type, NOW(), :attribute, :value, :game_id)",
		list(
			"type" = type_id,
			"attribute" = (attribute == null) ? null : "[attribute]",
			"value" = "[value]",
			"game_id" = game_id
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "typeHistoryDatabaseInsertRecord")
	qdel(insert_query)

/datum/controller/subsystem/persistence/proc/typeHistoryDatabaseGetRecords(type_id, attribute, count)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typeHistoryDatabaseGetRecords"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, value FROM ss13_persistent_type_history ORDER BY id DESC LIMIT :count", list("count" = count)
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typeHistoryDatabaseGetRecords"))
		qdel(query)
		return null

	var/records = list()
	while(query.NextRow())
		records += list("id" = query.item[1], "value" = query.item[2])
	qdel(query)
	return records
