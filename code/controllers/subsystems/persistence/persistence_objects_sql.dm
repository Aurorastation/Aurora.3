/**
 * Run cleanup on the persistence entries in the database.
 * Cleanup includes all entries that have expired and have passed the clean up grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS).
 */
/datum/controller/subsystem/persistence/proc/objectsDatabaseCleanEntries()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("objectsDatabaseCleanEntries"))
		return

	var/datum/db_query/cleanup_query = SSdbcore.NewQuery(
		"DELETE FROM ss13_persistent_objects WHERE DATE_ADD(expires_at, INTERVAL :grace_period_days DAY) <= NOW()",
		list("grace_period_days" = PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
	)

	cleanup_query.SetFailCallback(CALLBACK(PROC_REF(objectsDatabaseCleanEntries_CallbackFailure)))
	cleanup_query.SetSuccessCallback(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel)))
	cleanup_query.ExecuteNoSleep(TRUE)

/datum/controller/subsystem/persistence/proc/objectsDatabaseCleanEntries_CallbackFailure(datum/db_query/cleanup_query)
	databaseCheckQueryResult(cleanup_query, "objectsDatabaseCleanEntries")
	qdel(cleanup_query)

/**
 * Retrieve persistent data entries that haven't expired.
 * RETURN: List of JSON, with ID, author_ckey, type, content, x, y, z
 */
/datum/controller/subsystem/persistence/proc/objectsDatabaseGetActiveEntries()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("objectsDatabaseGetActiveEntries"))
		return

	var/datum/db_query/get_query = SSdbcore.NewQuery(
		"SELECT id, author_ckey, type, content, x, y, z FROM ss13_persistent_objects WHERE NOW() < expires_at"
	)
	get_query.Execute()

	var/list/results = list()
	if (!databaseCheckQueryResult(get_query, "objectsDatabaseGetActiveEntries"))
		return
	else
		while (get_query.NextRow())
			CHECK_TICK
			var/list/entry = list(
				"id" = get_query.item[1],
				"author_ckey" = get_query.item[2],
				"type" = get_query.item[3],
				"content" = get_query.item[4],
				"x" = get_query.item[5],
				"y" = get_query.item[6],
				"z" = get_query.item[7]
			)
			results += list(entry)
	qdel(get_query)
	return results

/**
 * Adds a persistent data record to the database.
 */
/datum/controller/subsystem/persistence/proc/objectsDatabaseAddEntry(obj/track)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("objectsDatabaseAddEntry"))
		return

	var/turf/T = get_turf(track)
	if(!T)
		return

	var/datum/db_query/insert_query = SSdbcore.NewQuery(
		"INSERT INTO ss13_persistent_objects (author_ckey, type, created_at, expires_at, content, x, y, z) \
		VALUES (:author_ckey, :type, NOW(), DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), :content, :x, :y, :z)",
		list(
			"author_ckey" = track.persistent_objects_author_ckey,
			"type" = "[track.type]",
			"expire_in_days" = track.persistant_objects_expiration_time_days,
			"content" = objectsGetTrackContent(track),
			"x" = T.x,
			"y" = T.y,
			"z" = T.z
		)
	)
	insert_query.Execute()

	databaseCheckQueryResult(insert_query, "objectsDatabaseAddEntry")
	qdel(insert_query)

/**
 * Updates a persistent data record in the database.
 */
/datum/controller/subsystem/persistence/proc/objectsDatabaseUpdateEntry(obj/track)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("objectsDatabaseUpdateEntry"))
		return

	var/turf/T = get_turf(track)
	if(!T)
		return

	var/datum/db_query/update_query = SSdbcore.NewQuery(
		"UPDATE ss13_persistent_objects SET author_ckey=:author_ckey, expires_at=DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), content=:content, x=:x, y=:y, z=:z WHERE id = :id",
		list(
			"author_ckey" = track.persistent_objects_author_ckey,
			"expire_in_days" = track.persistant_objects_expiration_time_days,
			"content" = objectsGetTrackContent(track),
			"x" = T.x,
			"y" = T.y,
			"z" = T.z,
			"id" = track.persistent_objects_track_id
		)
	)
	update_query.Execute()

	databaseCheckQueryResult(update_query, "objectsDatabaseUpdateEntry")
	qdel(update_query)

/**
 * Expire a persistent data record in the database by setting it's expiration date to now.
 */
/datum/controller/subsystem/persistence/proc/objectsDatabaseExpireEntry(track_id)
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("objectsDatabaseExpireEntry"))
		return

	var/datum/db_query/expire_query = SSdbcore.NewQuery(
		"UPDATE ss13_persistent_objects SET expires_at=NOW() WHERE id = :id",
		list("id" = track_id)
	)
	expire_query.Execute()

	databaseCheckQueryResult(expire_query, "objectsDatabaseExpireEntry")
	qdel(expire_query)
