/**
 * Get the last ID in the history table.
 * RETURN:
 *  Last ID or zero.
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseGetLastID()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseGetLastID"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id FROM ss13_persistent_history ORDER BY id DESC LIMIT 1"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "historyDatabaseGetLastID"))
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
 * 	Distinct list of list with keys "type_id" and "attribute" (possibly null).
 *  Example: (("type_id" = 1, "attribute" = null), ("type_id" = 1, "attribute" = "lorem ipsum"), ("type_id" = 2, "attribute" = "dolor sit amet"))
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseGetTypeAttributeCombinations()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseGetTypeAttributeCombinations"))
		return

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT DISTINCT type, attribute FROM ss13_persistent_history"
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "historyDatabaseGetTypeAttributeCombinations"))
		qdel(query)
		return null

	var/result = list()
	while(query.NextRow())
		result += list("type_id" = query.item[1], "attribute" = query.item[2])
	qdel(query)
	return result

/**
 * Clean up history records of type+attribute by specified row count
 * PARAMS:
 * 	type_id =	ID of type.
 *  attribute =	Custom attribute of the record, can be null.
 *	row_count =	Count of rows to keep for the specified grouping.
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseCleanByRowCount(type_id, attribute, row_count)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseCleanByRowCount"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"DELETE FROM ss13_persistent_history \
		WHERE type = :type_id \
		AND ( \
				(:attribute IS NULL AND attribute IS NULL) \
				OR attribute = :attribute \
			) \
		AND id NOT IN ( \
				SELECT id FROM ( \
					SELECT id \
					FROM ss13_persistent_history \
					WHERE type = :type_id \
						) \
					AND ( \
							(:attribute IS NULL AND attribute IS NULL) \
							OR attribute = :attribute \
						) \
					ORDER BY id DESC \
					LIMIT :row_count \
				) AS keep_ids \
		);",
		list(
			":type_id" = type_id,
			"attribute" = attribute,
			"row_count" = row_count
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "historyDatabaseCleanByRowCount")
	qdel(insert_query)

/**
 * Clean up history records of type+attribute by specified round count.
 * PARAMS:
 * 	type_id =		Type of ID.
 *  attribute =		Custom attribute of the record, can be null.
 *	round_count =	Number of rounds to keep for specified grouping.
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseCleanByRoundCount(type_id, attribute, round_count)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseCleanByRoundCount"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"DELETE h \
		FROM ss13_persistent_history h \
		JOIN ( \
			SELECT DISTINCT h2.type, \
				h2.attribute, \
				h2.game_id \
			FROM ss13_persistent_history h2 \
			JOIN ( \
				SELECT type, \
					attribute, \
					game_id \
				FROM ss13_persistent_history \
				GROUP BY type, attribute, game_id \
			) g \
			ON g.type = h2.type \
			AND g.attribute <=> h2.attribute \
			JOIN ( \
				SELECT type, \
					attribute, \
					game_id, \
					ROW_NUMBER() OVER ( \
						PARTITION BY type, attribute \
						ORDER BY game_id DESC \
					) AS rn \
				FROM ( \
					SELECT DISTINCT type, attribute, game_id \
					FROM ss13_persistent_history \
				) x \
			) ranked \
			ON ranked.type = h2.type \
			AND ranked.game_id = h2.game_id \
			AND ranked.attribute <=> h2.attribute \
			WHERE ranked.rn > :round_count \
		) to_delete \
		ON to_delete.type = h.type \
		AND to_delete.game_id = h.game_id \
		AND to_delete.attribute <=> h.attribute;",
		list(
			":type_id" = type_id,
			"attribute" = attribute,
			"round_count" = round_count
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "historyDatabaseCleanByRoundCount")
	qdel(insert_query)

/**
 * Clean up history records of type+attribute by max age of record in days
 * PARAMS:
 * 	type_id =		ID of type.
 *  attribute =		Custom attribute of the record, can be null.
 *	max_age_days =	Max age of records in days.
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseCleanByMaxAgeDays(type_id, attribute, max_age_days)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseCleanByMaxAgeDays"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"DELETE h \
		FROM ss13_persistent_history h \
		JOIN ( \
			SELECT type, \
				attribute, \
				NOW() - INTERVAL :max_age_days DAY AS cutoff \
			FROM ss13_persistent_history \
			GROUP BY type, attribute \
		) g \
		ON g.type = h.type \
		AND g.attribute <=> h.attribute \
		WHERE h.created_at < g.cutoff;",
		list(
			"type_id" = type_id,
			"attribute" = attribute,
			"max_age_days" = max_age_days
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "historyDatabaseCleanByMaxAgeDays")
	qdel(insert_query)

/**
 * Insert a new history record into the history table.
 * PARAMS:
 * 	type_id =	ID of type.
 *  attribute =	Custom attribute of the record, can be null.
 *	value =		Value of the record, cannot be null or empty.
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseInsertRecord(type_id, attribute, value)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseInsertRecord"))
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_history (type, created_at, attribute, value, game_id) VALUES (:type_id, NOW(), :attribute, :value, :game_id)",
		list(
			"type_id" = type_id,
			"attribute" = (attribute == null) ? null : "[attribute]",
			"value" = "[value]",
			"game_id" = "[GLOB.round_id]"
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "historyDatabaseInsertRecord")
	qdel(insert_query)

/**
 * Get the last X history records for a type+attribute.
 * PARAMS:
 * 	type_id =	ID of type
 *  attribute =	Custom attribute of the record, can be null.
 *	count =		Number of records to be returned.
 * RETURN:
 *  List of records, each as a list consisting of keys "id", "created_at" and "value".
 */
/datum/controller/subsystem/persistence/proc/historyDatabaseGetRecords(type_id, attribute, count)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("historyDatabaseGetRecords"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, created_at, value FROM ss13_persistent_history \
		WHERE type = :type_id AND attribute = :attribute \
		ORDER BY id DESC LIMIT :count",
		list(
			"type_id" = type_id,
			"attribute" = attribute,
			"count" = count
		)
	)
	query.Execute()

	if(!databaseCheckQueryResult(query, "historyDatabaseGetRecords"))
		qdel(query)
		return null

	var/records = list()
	while(query.NextRow())
		records += list("id" = query.item[1], "created_at" = query.item[2], "value" = query.item[3])
	qdel(query)
	return records
