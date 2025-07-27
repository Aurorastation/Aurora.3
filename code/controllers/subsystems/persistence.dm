SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

/*#############################################
				Internal vars
#############################################*/

// List of all tracked objects, initially filled by Initialize(), later managed by register_datum() and deregister_datum(), consumed at the end by Shutdown().
GLOBAL_VAR_INIT(tracks, list())
var/list/tracks

/*#############################################
				Internal methods
#############################################*/

/**
 * Initialization of the persistence subsystem. Initialization includes loading all persistent data and spawning the related objects.
 */
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	tracks = list()

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
			register_obj(instance)

		return SS_INIT_SUCCESS

/**
 * Recovery of the persistence subsystem. Catches all objects registered in the old instance of the subsystem.
 */
/datum/controller/subsystem/persistence/Recover()
	// TODO, recover last data?		tracks = SSpersistence.tracks

/**
 * Shutdown of the persistence subsystem. Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/Shutdown()
	// Saves tracked objects without ID to DB
	//TODO

	// Update tracked objects with ID to DB
	//TODO

	// Drop entries from DB that are not in the tracking list
	//TODO

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistence/stat_entry()
	..("actively tracked objects: [length(tracks)]")

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
				var/list/entry[] = list()
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

/*#############################################
				Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 */
/datum/controller/subsystem/persistence/proc/register_obj(var/obj/new_track, ckey)
	if(!(new_track in tracks)) // Prevent multiple registers per
		tracks += new_track
		if(!ckey) // Some persistent data may not have an actual owner, for example auto generated types like decals or similar.
			new_track.persistence_author_ckey = ckey

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_obj(var/obj/old_track)
	old_track.persistence_track_id = null
	old_track.persistence_author_ckey = null
	if(old_track in tracks)
		tracks -= old_track
