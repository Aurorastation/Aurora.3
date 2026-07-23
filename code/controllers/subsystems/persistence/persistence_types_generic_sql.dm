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

	// Because MariaDB doesn't consider NULL in the attribute to be a violation of the UNIQUE constraint,
	// we have to verify if the generic already exists, if the attribute is null.
	// If the attribute is null and the generic exists, manually update the row instead of INSERT + ON DUPLICATE KEY.
	// Otherwise, with valid unique constraint (not null attributes), we can continue with the regular INSERT + ON DUPLICATE KEY directly.
	if(!attribute)
		var/datum/db_query/null_attribute_query = SSdbcore.NewQuery(
			"SELECT id FROM ss13_persistent_generics WHERE type = :type_id AND attribute IS NULL",
			list(
				"type_id" = type_id
			)
		)
		null_attribute_query.Execute()

		if(!databaseCheckQueryResult(null_attribute_query, "genericDatabaseSaveNullAttributeCheck"))
			qdel(null_attribute_query)
			return 0

		var/id = 0
		if(null_attribute_query.NextRow())
			id = null_attribute_query.item[1]
		qdel(null_attribute_query)
		if(id > 0) // Attribute null and row found - Invalid unique contraint for MariaDB - Update manually.
			var/datum/db_query/update_query = SSdbcore.NewQuery(
				"UPDATE ss13_persistent_generics SET created_at = NOW(), expires_at = DATE_ADD(NOW(), INTERVAL :expires_in_days DAY), content = :content WHERE id = :id",
				list(
					"expires_in_days" = expires_in_days,
					"content" = content,
					"id" = id
				)
			)
			update_query.Execute()

			databaseCheckQueryResult(update_query, "genericDatabaseSaveNullAttributeUpdate")
			qdel(update_query)
			return // Skip regular upcoming query due to the reasons above

	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_generics (type, attribute, created_at, expires_at, content) VALUES (:type_id, :attribute, NOW(), DATE_ADD(NOW(), INTERVAL :expires_in_days DAY), :content) \
		ON DUPLICATE KEY UPDATE created_at = NOW(), expires_at = DATE_ADD(NOW(), INTERVAL :expires_in_days DAY), content = :content",
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
		WHERE type = :type_id AND attribute <=> :attribute",
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
