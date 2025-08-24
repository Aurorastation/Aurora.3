SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

/*#############################################
				Internal methods
#############################################*/

/**
 * Initialization of the persistence subsystem. Initialization includes loading all persistent data and spawning the related objects.
 */
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	try
		if(!GLOB.config.sql_enabled)
			log_subsystem_persistence("SQL configuration not enabled! Persistence subsystem requires SQL.")
			return SS_INIT_SUCCESS

		GLOB.persistence_register = list()

		if(!SSdbcore.Connect())
			log_subsystem_persistence("SQL ERROR during persistence subsystem init. Failed to connect.")
			return SS_INIT_FAILURE
		else
			// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
			database_clean_entries()

			// Retrieve all persistent data that is not expired
			var/list/persistent_data = database_get_active_entries()
			log_subsystem_persistence("Init: Retrieved [persistent_data.len] entries for instancing this round.")

			// Instantiate all remaining entries based of their type
			// Assign persistence related vars found in /obj, apply content and add to live tracking list.
			for (var/data in persistent_data)
				CHECK_TICK
				var/typepath = text2path(data["type"])
				if (!ispath(typepath)) // Type checking
					continue
				var/obj/instance = new typepath()
				instance.persistence_track_id = data["id"]
				track_apply_content(instance, data["content"], data["x"], data["y"], data["z"])
				register_track(instance, data["author_ckey"])

			return SS_INIT_SUCCESS
	catch(var/exception/e)
		log_subsystem_persistence("Panic: Exception during subsystem initialize: [e]")
		return SS_INIT_FAILURE

/**
 * Shutdown of the persistence subsystem. Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/Shutdown()
	try
		if(!GLOB.config.sql_enabled)
			log_subsystem_persistence("SQL configuration not enabled! Panic - Cannot save current round track changes!")
			return

		// Subsystem shutdown:
		// Create new persistent records for objects that have been created in the round
		// Update tracked objects that have an ID (already existing from previous rounds)
		// Delete persistent records that no longer exist in the registry (removed during the round)

		var/created = 0
		var/updated = 0
		var/expired = 0

		// Get already stored data before saving new tracks so we can compare what has been updated or removed during the round.
		var/list/existing_data = database_get_active_entries()

		for (var/obj/track in GLOB.persistence_register)
			CHECK_TICK
			if (track.persistence_track_id == 0)
				// Tracked object has no ID meaning it is new, create a new persistent record for it
				database_add_entry(track)
				created++

		// Find tracks that have been removed during the round by trying to find the track by database ID
		// If we find the track, we need to check if it requires an update instead
		for (var/record in existing_data)
			var/found = FALSE
			for (var/obj/track in GLOB.persistence_register)
				CHECK_TICK
				if (record["id"] == track.persistence_track_id)
					// A track with the same ID has been found in the register, it still exists, check if we need to update it instead
					found = TRUE // Prevent expiration of track
					var/changed = FALSE
					var/turf/T = get_turf(track)
					if (T && T.x != record["x"])
						changed = TRUE
					else if (T && T.y != record["y"])
						changed = TRUE
					else if (T && T.z != record["z"])
						changed = TRUE
					else if (track_get_content(track) != record["content"])
						changed = TRUE
					if (changed)
						database_update_entry(track)
						updated++
					break // Track found (and perhaps updated), break off loop search as it won't need to be deleted anyways
			if (!found)
				// No track with the same ID has been found in the register, remove it from the database (expire)
				database_expire_entry(record["id"])
				expired++

		log_subsystem_persistence("Shutdown: Tried to create [created], update [updated] and expire [expired] tracks.")
	catch(var/exception/e)
		log_subsystem_persistence("Panic: Exception during subsystem shutdown: [e]")
		return

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistence/stat_entry(msg)
	msg = ("Global register tracks: [GLOB.persistence_register.len]")
	return ..()

/**
 * Safely get JSON persistent content of track.
 * RETURN: JSON formatted content of track or null if an exception occured.
 */
/datum/controller/subsystem/persistence/proc/track_get_content(var/obj/track)
	var/result = json_encode(list())
	try
		var/list/content = track.persistence_get_content()
		if(content && content.len)
			result = json_encode(content)
	catch(var/exception/e)
		log_subsystem_persistence("Track: Failed to get/encode track content: [e]")
	return result

/**
 * Safely apply persistent content to track.
 * PARAMS:
 * 	track = Object to apply content to.
 *  json = Custom persistent content JSON to be applied.
 *	x,y,z = x-y-z coordinates of object, can be null.
 */
/datum/controller/subsystem/persistence/proc/track_apply_content(var/obj/track, var/json, var/x, var/y, var/z)
	try
		track.persistence_apply_content(json_decode(json), x, y, z)
	catch(var/exception/e)
		log_subsystem_persistence("Track: Failed to apply/decode track content: [e]")

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
		if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
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
		if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
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

/*#############################################
				Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 * The ckey is an optional argument and is used for tracking user generated content by adding an author to the persistent data.
 */
/datum/controller/subsystem/persistence/proc/register_track(var/obj/new_track, var/ckey)
	if(new_track.persistence_track_active) // Prevent multiple registers per object and removes the need to check the register if it's already in there
		return

	var/turf/T = get_turf(new_track)
	if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
		return

	new_track.persistence_track_active = TRUE
	new_track.persistence_author_ckey = ckey
	GLOB.persistence_register += new_track

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_track(var/obj/old_track)
	if(!old_track.persistence_track_active) // Prevent multiple deregisters per object and removes the need to check the register if it's not in there
		return

	old_track.persistence_track_active = FALSE
	GLOB.persistence_register -= old_track
