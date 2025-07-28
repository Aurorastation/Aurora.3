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
	GLOB.persistence_register = list()

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence subsystem init. Failed to connect.")
		return SS_INIT_FAILURE
	else
		// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
		database_clean()

		// Retrieve all persistent data that is not expired
		var/list/persistent_data = database_get_active_entries()

		// Instantiate all remaining entries based of their type
		// Assign persistence related vars found in /obj, apply content and add to live tracking list.
		for (var/data in persistent_data)
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
	var/list/create = list() // obj
	var/list/update = list() // obj
	var/list/delete = list() // int ID

	// Iterate through the register to sort tracks with no ID and tracks that need an update (with ID)
	for (var/obj/track in GLOB.persistence_register)
		if(track.persistence_track_id) // Track has an ID, update record
			update += track
		else // Track has no ID, create record
			create += track

	// Identify tracks that have been deleted and need to be removed by setting their expiration date to now
	// Look-up approach for faster set-to-set comparison
	var/list/tracks_dict = list()
	for (var/obj/track in update) // Only tracks with an ID could've been deleted in the first place, anything in the create-list is irrelevant
		tracks_dict[track.persistence_track_id] = TRUE

	var/list/live = database_get_active_entries()
	for(var/record in live)
		if (!tracks_dict[record["id"]]) // No match with dict means it got removed in the round
			delete += record["id"]

	// Free register as we have sorted everything
	GLOB.persistence_register = list()

	database_add_entries(create)
	// TODO Update
	// TODO Delete (set expiration date to NOW to allow the delete period to work, clean up on round start)

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistence/stat_entry()
	..("actively tracked objects: [length(GLOB.persistence_register)]")

/**
 * Run cleanup on the persistence entries in the database.
 * Cleanup includes all entries that have expired and have passed the clean up grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS).
 */
/datum/controller/subsystem/persistence/proc/database_clean()
	if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence database_clean. Failed to connect.")
	else
		var/datum/db_query/cleanup_query = SSdbcore.NewQuery("DELETE FROM ss13_persistent_data WHERE DATE_ADD(expires_at, INTERVAL :grace_period_days: DAY) <= NOW()")
		cleanup_query.Execute(list("grace_period_days"=PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS))
		if (cleanup_query.ErrorMsg())
			log_game("SQL ERROR during persistence database_clean. " + cleanup_query.ErrorMsg())
		qdel(cleanup_query)

/**
 * Retrieve persistent data entries that haven't expired.
 * RETURN:
 *	List of JSON, with ID, author_ckey, type, content, x, y, z
 */
/datum/controller/subsystem/persistence/proc/database_get_active_entries()
	if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence database_get_active_entries. Failed to connect.")
	else
		var/datum/db_query/get_query = SSdbcore.NewQuery("SELECT id, author_ckey, type, content, x, y, z FROM ss13_persistent_data WHERE NOW() < expires_at")
		get_query.Execute()
		var/list/results = list()
		if (get_query.ErrorMsg())
			log_game("SQL ERROR during persistence database_get_active_entries. " + get_query.ErrorMsg())
			return
		else
			while (get_query.NextRow())
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
 * Adds the given objects to the database as new persistent data.
 */
/datum/controller/subsystem/persistence/proc/database_add_entries(var/list/objects)
	if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence database_add_entries. Failed to connect.")
	else
		var/datum/db_query_template/query_template = SSdbcore.NewQueryTemplate("\
		INSERT INTO ss13_persistent_data (author_ckey, type, created_at, updated_at, expires_at, content, x, y, z) \
		VALUES (:author_ckey:, :type:, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL :expire_in_days: DAY), :content:, :x:, :y:, :z:)")

		for(var/object in objects)
			if (!istype(object, /obj)) // Type checking
				continue
			var/obj/entry = object
			var/datum/db_query/add_query = query_template.Execute(list(
				"author_ckey"=length(entry.persistence_author_ckey) ? entry.persistence_author_ckey : null,
				"type"="[entry.type]",
				"expire_in_days"=entry.persistance_initial_expiration_time_days,
				"content"=entry.persistence_get_content(),
				"x"=entry.x,
				"y"=entry.y,
				"z"=entry.z
			))
			if (add_query.ErrorMsg())
				log_game("SQL ERROR during persistence database_add_entries. " + add_query.ErrorMsg())
			qdel(add_query)

/*#############################################
				Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 */
/datum/controller/subsystem/persistence/proc/register_track(var/obj/new_track, ckey)
	if(!(new_track in GLOB.persistence_register)) // Prevent multiple registers per
		GLOB.persistence_register += new_track
		if(!ckey) // Some persistent data may not have an actual owner, for example auto generated types like decals or similar.
			new_track.persistence_author_ckey = ckey

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_track(var/obj/old_track)
	old_track.persistence_track_id = null
	old_track.persistence_author_ckey = null
	if(old_track in GLOB.persistence_register)
		GLOB.persistence_register -= old_track
