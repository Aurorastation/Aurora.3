/**
 * Get the last ID in the history table.
 * RETURN: Last ID or zero.
 */
/datum/controller/subsystem/persistence/proc/typesHistoryDatabaseGetLastID()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesHistoryDatabaseGetLastID"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id FROM ss13_persistent_type_history ORDER BY id DESC LIMIT 1"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typesHistoryDatabaseGetLastID"))
		qdel(query)
		return 0

	var/last_id = 0
	if(query.NextRow())
		last_id = query.item[1]
	qdel(query)
	return last_id


/**
 * Returns all combinations of types+attributes from persistent history.
 * RETURN:
 * 	Distinct list of lists containing type ID and attribute (possibly null)
 *  Example: (("type_id" = 1, "attribute" = null), ("type_id" = 1, "attribute" = "lorem ipsum"), ("type_id" = 2, "attribute" = "dolor sit amet"))
 *
 */
/datum/controller/subsystem/persistence/proc/typesHistoryDatabaseGetTypeAttributeCombinations()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesHistoryDatabaseGetTypeAttributeCombinations"))
		return

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT DISTINCT type, attribute FROM ss13_persistent_history;"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typesHistoryDatabaseGetTypeAttributeCombinations"))
		qdel(query)
		return null

	var/result = list()
	while(query.NextRow())
		result += list("type_id" = query.item[1], "attribute" = query.item[2])
	qdel(query)
	return result

/**
 * Insert a new history record into the history table.
 * PARAMS:
 * 	type_id =	ID of type. See /singleton/persistent_type and subtypes.
 *  attribute =	Custom attribute of the record, can be null.
 *	value =		Value of the record, cannot be null or empty.
 */
/datum/controller/subsystem/persistence/proc/typesHistoryDatabaseInsertRecord(type_id, attribute, value)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesHistoryDatabaseInsertRecord"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_type_history (type, created_at, attribute, value, game_id) VALUES (:type, NOW(), :attribute, :value, :game_id)",
		list(
			"type" = type_id,
			"attribute" = (attribute == null) ? null : "[attribute]",
			"value" = "[value]",
			"game_id" = "[GLOB.round_id]"
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "typesHistoryDatabaseInsertRecord")
	qdel(insert_query)

/**
 * Get the last X history records for a type+attribute.
 * PARAMS:
 * 	type_id =	ID of type. See /singleton/persistent_type and subtypes.
 *  attribute =	Custom attribute of the record, can be null.
 *	count =		Number of records to be returned.
 * RETURN:
 * List of records, each as a list consisting of keys "id", "created_at" and "value".
 */
/datum/controller/subsystem/persistence/proc/typesHistoryDatabaseGetRecords(type_id, attribute, count)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("typesHistoryDatabaseGetRecords"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, created_at, value FROM ss13_persistent_type_history ORDER BY id DESC LIMIT :count", list("count" = count)
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "typesHistoryDatabaseGetRecords"))
		qdel(query)
		return null

	var/records = list()
	while(query.NextRow())
		records += list("id" = query.item[1], "created_at" = query.item[2], "value" = query.item[3])
	qdel(query)
	return records
