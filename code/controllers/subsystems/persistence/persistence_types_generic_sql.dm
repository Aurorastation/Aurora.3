/**
 * Get the last ID in the generics table.
 * RETURN:
 *  Last ID or zero.
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseGetLastID()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseGetLastID"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id FROM ss13_persistent_generics ORDER BY id DESC LIMIT 1"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "genericDatabaseGetLastID"))
		qdel(query)
		return 0

	var/last_id = 0
	if(query.NextRow())
		last_id = query.item[1]
	qdel(query)
	return last_id

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
		"INSERT INTO ss13_persistent_generics (type, attribute, created_at, expires_at, content) VALUES (:type_id, :attribute, NOW(), DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), :content) \
		ON DUPLICATE KEY UPDATE created_at = VALUES(NOW()), expires_at = VALUES(DATE_ADD(NOW(), INTERVAL :expire_in_days DAY)), content = VALUES(:content)",
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
 *  Associative list of keys "id", "content" (JSON).
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseLoad(type_id, attribute)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseLoad"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, content FROM ss13_persistent_generics \
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
		result = list("id" = query.item[1], "content" = query.item[2])
	qdel(query)
	return result
