/**
 * Runs a cleanup query on generics that have expired.
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseCleanup()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseCleanup"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"DELETE FROM ss13_persistent_generics WHERE expires_at < NOW()"
	)
	query.Execute()

	databaseCheckQueryResult(query, "genericDatabaseCleanup")
	qdel(query)

/**
 * Save a generic persistent type(+attribute).
 * PARAMS:
 * 	type_id =			Type of ID.
 *  attribute =			Custom attribute of the record, can be null.
 *	expires_in_days =	Number of days until the content expires.
 *  content =			JSON content to be saved.
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseSave(type_id, attribute, expires_in_days, content)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseSave"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_generics (type, attribute, created_at, expires_at, content) VALUES (:type_id, :attribute, DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), :expires_in_days, :content) \
		ON DUPLICATE KEY UPDATE created_at = VALUES(DATE_ADD(NOW(), INTERVAL :expire_in_days DAY)), expires_at = VALUES(expires_in_days), content = VALUES(:content)",
		list(
			"type_id" = type_id,
			"attribute" = attribute,
			"expires_in_days" = expires_in_days,
			"content" = content
		)
	)
	query.Execute()

	databaseCheckQueryResult(query, "genericDatabaseSave")
	qdel(query)

/**
 * Load a generic persistent type(+attribute).
 * PARAMS:
 * 	type_id =			Type of ID.
 *  attribute =			Custom attribute of the record, can be null.
 * RETURN:
 *  Associative list of keys "content" (JSON), "created_at" and "expires_at".
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseLoad(type_id, attribute)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseLoad"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT content, created_at, expires_at FROM ss13_persistent_generics \
		WHERE type = :type_id AND attribute = :attribute",
		list(
			"type_id" = type_id,
			"attribute" = attribute
		)
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "genericDatabaseLoad"))
		qdel(query)
		return null

	var/result = null
	while(query.NextRow())
		result = list("content" = query.item[1], "created_at" = query.item[2], "expires_at")
	qdel(query)
	return result
