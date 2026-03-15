/**
 * Run cleanup on the persistence entries in the database.
 * Cleanup includes all entries that have expired and have passed the clean up grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS).
 */
/datum/controller/subsystem/persistence/proc/database_clean_entries()
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_clean_entries. Failed to connect.")
	else
		var/datum/db_query/cleanup_query = SSdbcore.NewQuery(
			"DELETE FROM ss13_persistent_data WHERE DATE_ADD(expires_at, INTERVAL :grace_period_days DAY) <= NOW()",
			list("grace_period_days" = PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
		)

		cleanup_query.SetFailCallback(CALLBACK(PROC_REF(database_clean_entries_callback_failure)))
		cleanup_query.SetSuccessCallback(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel)))
		cleanup_query.ExecuteNoSleep(TRUE)

/datum/controller/subsystem/persistence/proc/database_clean_entries_callback_failure(var/datum/db_query/cleanup_query)
	if (cleanup_query.ErrorMsg())
		log_subsystem_persistence("SQL ERROR during persistence database_clean_entries. " + cleanup_query.ErrorMsg())
	qdel(cleanup_query)

/**
 * Retrieve persistent data entries that haven't expired.
 * RETURN: List of JSON, with ID, author_ckey, type, content, x, y, z
 */
/datum/controller/subsystem/persistence/proc/database_get_active_entries()
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_get_active_entries. Failed to connect.")
	else
		var/datum/db_query/get_query = SSdbcore.NewQuery(
			"SELECT id, author_ckey, type, content, x, y, z FROM ss13_persistent_data WHERE NOW() < expires_at"
		)
		get_query.Execute()

		var/list/results = list()
		if (get_query.ErrorMsg())
			log_subsystem_persistence("SQL ERROR during persistence database_get_active_entries. " + get_query.ErrorMsg())
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
/datum/controller/subsystem/persistence/proc/database_add_entry(var/obj/track)
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_add_entry. Failed to connect.")
	else
		var/turf/T = get_turf(track)
		if(!T)
			return

		var/datum/db_query/insert_query = SSdbcore.NewQuery(
			"INSERT INTO ss13_persistent_data (author_ckey, type, created_at, expires_at, content, x, y, z) \
			VALUES (:author_ckey, :type, NOW(), DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), :content, :x, :y, :z)",
			list(
				"author_ckey" = track.persistence_author_ckey,
				"type" = "[track.type]",
				"expire_in_days" = track.persistance_expiration_time_days,
				"content" = track_get_content(track),
				"x" = T.x,
				"y" = T.y,
				"z" = T.z
			)
		)
		insert_query.Execute()

		if (insert_query.ErrorMsg())
			log_subsystem_persistence("SQL ERROR during persistence database_add_entry. " + insert_query.ErrorMsg())
		qdel(insert_query)

/**
 * Updates a persistent data record in the database.
 */
/datum/controller/subsystem/persistence/proc/database_update_entry(var/obj/track)
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_update_entry. Failed to connect.")
	else
		var/turf/T = get_turf(track)
		if(!T)
			return

		var/datum/db_query/update_query = SSdbcore.NewQuery(
			"UPDATE ss13_persistent_data SET author_ckey=:author_ckey, expires_at=DATE_ADD(NOW(), INTERVAL :expire_in_days DAY), content=:content, x=:x, y=:y, z=:z WHERE id = :id",
			list(
				"author_ckey" = track.persistence_author_ckey,
				"expire_in_days" = track.persistance_expiration_time_days,
				"content" = track_get_content(track),
				"x" = T.x,
				"y" = T.y,
				"z" = T.z,
				"id" = track.persistence_track_id
			)
		)
		update_query.Execute()

		if (update_query.ErrorMsg())
			log_subsystem_persistence("SQL ERROR during persistence database_update_entry. " + update_query.ErrorMsg())
		qdel(update_query)

/**
 * Expire a persistent data record in the database by setting it's expiration date to now.
 */
/datum/controller/subsystem/persistence/proc/database_expire_entry(var/track_id)
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_expire_entry. Failed to connect.")
	else
		var/datum/db_query/expire_query = SSdbcore.NewQuery(
			"UPDATE ss13_persistent_data SET expires_at=NOW() WHERE id = :id",
			list("id" = track_id)
		)
		expire_query.Execute()

		if (expire_query.ErrorMsg())
			log_subsystem_persistence("SQL ERROR during persistence database_expire_entry. " + expire_query.ErrorMsg())
		qdel(expire_query)
