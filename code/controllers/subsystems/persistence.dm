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
		// TODO

		// Pull remaining entries
		//var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, type, content FROM ss13_persistent_data")
		//stats_query.Execute() // TODO Handle results
		//qdel(stats_query)

		// Instanciate all remaining entries based of their type
		// They should be added to tracking by their individual implementation, not in here, but we need to assign the persistent_track_id and the existing ckey to the obj.
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

/*#############################################
				Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 */
/datum/controller/subsystem/persistence/proc/register_obj(var/obj/new_track, ckey)
	if(!(new_track in tracks)) // Prevent duplicates
		tracks += new_track
		if(!ckey)
			new_track.persistence_author_ckey = ckey

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/deregister_obj(var/obj/old_track)
	if(old_track in tracks) // Prevent null ref
		tracks -= old_track
