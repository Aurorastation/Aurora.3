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
	if(!GLOB.config.sql_enabled)
		log_subsystem_persistence("SQL configuration not enabled! Persistence subsystem requires SQL.")
		return SS_INIT_FAILURE // Subsystem depends on SQL

	GLOB.persistence_register = list()

	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence subsystem init. Failed to connect.")
		return SS_INIT_FAILURE
	else
		// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
		database_clean_entries()

		// Retrieve all persistent data that is not expired
		var/list/persistent_data = database_get_active_entries()

		// Instantiate all remaining entries based of their type
		// Assign persistence related vars found in /obj, apply content and add to live tracking list.
		for (var/data in persistent_data)
			CHECK_TICK
			var/typepath = text2path(data["type"])
			if (!ispath(typepath)) // Type checking
				continue
			var/obj/instance = new typepath()
			instance.persistence_track_id = data["id"]
			instance.persistence_author_ckey = data["author_ckey"]
			instance.persistence_apply_content(data["content"], data["x"], data["y"], data["y"])
			register_track(instance)

		return SS_INIT_SUCCESS

/**
 * Shutdown of the persistence subsystem. Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/Shutdown()
	if(!GLOB.config.sql_enabled)
		log_subsystem_persistence("SQL configuration not enabled! Panic - Cannot save current round track changes!")
		return

	// Subsystem shutdown:
	// Create new persistent records for objects that have been created in the round
	// Update tracked objects that have an ID (already existing from previous rounds) if they have changed
	// Delete persistent records that no longer exist in the registry (removed during the round)

	var/list/track_lookup = list()

	// Iterate through the register to sort tracks with no ID and tracks that may need an update (tracks with ID)
	// We are using a dictionary look-up to find no longer existing records by comparing them with a live dataset later on
	for (var/obj/track in GLOB.persistence_register)
		CHECK_TICK
		if(track.persistence_track_id > 0) // (0 is the default tracking ID value)
			// Tracked object has an ID, add it to lookup
			track_lookup[track.persistence_track_id] = track
		else
			// Tracked object has no ID, create a new persistent record for it
			database_add_entry(track)

	for(var/record in database_get_active_entries())
		CHECK_TICK
		// Find removed objects by looking them up using the live dataset
		var/obj/track = track_lookup[record["id"]]

		if (track)
			// The record still exists as an active track, check if it may need an update
			var/changed = FALSE
			var/turf/T = get_turf(track)
			if (track.persistence_author_ckey != record["author_ckey"])
				changed = TRUE
			else if (track.persistence_get_content() != record["content"])
				changed = TRUE
			else if (T.x != record["x"])
				changed = TRUE
			else if (T.y != record["y"])
				changed = TRUE
			else if (T.z != record["z"])
				changed = TRUE
			if (changed == TRUE)
				database_update_entry(track)
		else
			// There was no match in the lookup meaning the object got removed this round
			// We delete persistent data by setting it's expiration date to now, actual deletion has more logic and is handled in cleanup during init.
			database_expire_entry(record["id"])

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistence/stat_entry()
	..("actively tracked objects: [length(GLOB.persistence_register)]")

/**
 * Run cleanup on the persistence entries in the database.
 * Cleanup includes all entries that have expired and have passed the clean up grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS).
 */
/datum/controller/subsystem/persistence/proc/database_clean_entries()
	if(!SSdbcore.Connect())
		log_subsystem_persistence("SQL ERROR during persistence database_clean_entries. Failed to connect.")
	else
		var/datum/db_query/cleanup_query = SSdbcore.NewQuery(
			"DELETE FROM ss13_persistent_data WHERE DATE_ADD(expires_at, INTERVAL :grace_period_days: DAY) <= NOW()",
			list("grace_period_days"=PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
		)

		cleanup_query.SetFailCallback(CALLBACK(src, .proc/database_clean_entries_callback_failure))
		cleanup_query.SetSuccessCallback(CALLBACK(GLOBAL_PROC, /proc/qdel))
		cleanup_query.ExecuteNoSleep(TRUE)

/datum/controller/subsystem/persistence/proc/database_clean_entries_callback_failure(var/datum/db_query/cleanup_query)
	if (cleanup_query.ErrorMsg())
		log_subsystem_persistence("SQL ERROR during persistence database_clean_entries. " + cleanup_query.ErrorMsg())
	qdel(cleanup_query)

/**
 * Retrieve persistent data entries that haven't expired.
 * RETURN:
 *	List of JSON, with ID, author_ckey, type, content, x, y, z
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
				var/list/entry = list()
				entry["id"] = text2num(get_query.item[1])
				entry["author_ckey"] = get_query.item[2]
				entry["type"] = get_query.item[3]
				entry["content"] = get_query.item[4]
				entry["x"] = text2num(get_query.item[5])
				entry["y"] = text2num(get_query.item[6])
				entry["z"] = text2num(get_query.item[7])
				results += entry
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
		var/datum/db_query/insert_query = SSdbcore.NewQuery(
			"INSERT INTO ss13_persistent_data (author_ckey, type, created_at, updated_at, expires_at, content, x, y, z) \
			VALUES (:author_ckey:, :type:, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL :expire_in_days: DAY), :content:, :x:, :y:, :z:)",
			list(
				"author_ckey"=length(track.persistence_author_ckey) ? track.persistence_author_ckey : null,
				"type"="[track.type]",
				"expire_in_days"=track.persistance_initial_expiration_time_days,
				"content"=track.persistence_get_content(),
				"x"=T.x,
				"y"=T.y,
				"z"=T.z
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
		var/datum/db_query/update_query = SSdbcore.NewQuery(
			"UPDATE ss13_persistent_data SET author_ckey=:author_ckey:, updated_at=NOW(), content=:content:, x=:x:, y=:y:, z=:z: WHERE id = :id:",
			list(
				"author_ckey"=length(track.persistence_author_ckey) ? track.persistence_author_ckey : null,,
				"content"=track.persistence_get_content(),
				"x"=T.x,
				"y"=T.y,
				"z"=T.z,
				"id"=track.persistence_track_id
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
			"UPDATE ss13_persistent_data SET expires_at=NOW() WHERE id = :id:",
			list("id"=track_id)
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
 */
/datum/controller/subsystem/persistence/proc/register_track(var/obj/new_track, var/ckey)
	if(new_track.persistence_track_active) // Prevent multiple registers per object and removes the need to check the register if it's already in there
		return

	new_track.persistence_track_active = TRUE
	GLOB.persistence_register += new_track
	if(!ckey) // Some persistent data may not have an actual owner, for example auto generated types like decals or similar.
		new_track.persistence_author_ckey = ckey

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_track(var/obj/old_track)
	if(!old_track.persistence_track_active) // Prevent multiple deregisters per object and removes the need to check the register if it's not in there
		return

	old_track.persistence_track_active = FALSE
	old_track.persistence_track_id = 0
	old_track.persistence_author_ckey = null
	GLOB.persistence_register -= old_track
