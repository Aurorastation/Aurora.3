SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

/*#############################################
				Internal vars
#############################################*/

// List of all tracked objects, initially filled by Initialize(), later managed by register_datum() and deregister_datum(), consumed at the end by Destroy().
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

		// Instantiate all remaining entries based of their type
		// Assign persistence related vars found in /obj, apply content and add to live tracking list.
		//TODO
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
/datum/controller/subsystem/persistence/database_clean()
	if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence database_clean. Failed to connect.")
	else
		var/datum/db_query/cleanup_query = SSdbcore.NewQuery("DELETE FROM ss13_persistent_data WHERE DATE_ADD(expires_at, INTERVAL :grace_period_days: DAY) <= NOW()")
		cleanup_query.Execute(list("grace_period_days"=PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS))
		if (cleanup_query.ErrorMsg())
			log_game("SQL ERROR during persistence database_clean. " + cleanup_query.ErrorMsg())		
		qdel(cleanup_query)

/*#############################################
				Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 */
/datum/controller/subsystem/persistence/proc/register_obj(var/obj/new_track, ckey)
	if(!(new_track in tracks)) // Prevent duplicates
		tracks += new_track
		if(!ckey) // Some persistent data may not have an actual owner, for example auto generated types like decals or similar.
			new_track.persistence_author_ckey = ckey

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_obj(var/obj/old_track)
	if(old_track in tracks) // Prevent null ref
		tracks -= old_track
