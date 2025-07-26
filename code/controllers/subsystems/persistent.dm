SUBSYSTEM_DEF(persistent)
    name =          "Persistent"
    init_order =    INIT_ORDER_PERSISTENT
    flags =         SS_NO_FIRE

/*#############################################
			    Internal vars
#############################################*/

// List of all tracked objects, initially filled by Initialize(), later managed by register_datum() and deregister_datum(), consumed at the end by Destroy().
var/list/tracks[] // => list(list(obj, ckey))

/*#############################################
			    Internal methods
#############################################*/

/**
 * Initialization of the persistent subsystem. Initialization includes loading all persistent data and spawning the related objects.
 */
/datum/controller/subsystem/persistent/Initialize()
	. = ..()
    tracks = list()

    if(!SSdbcore.Connect())
		log_game("SQL ERROR during persistence subsystem init. Failed to connect.")
        return SS_INIT_FAILURE
    else
        // Delete all persistent objects in the database that have expired
        // TODO

        // Pull remaining entries
        var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, type, content FROM ss13_persistent_data")
        stats_query.Execute() // TODO Handle results
		qdel(stats_query)

        // Instanciate all remaining entries based of their type
        // They should be added to tracking by their individual implementation, not in here, but we need to assign the persistent_track_id
        //TODO
	    return SS_INIT_SUCCESS

/**
 * Recovery of the persistent subsystem. Catches all objects registered in the old instance of the subsystem.
 */
/datum/controller/subsystem/persistent/Recover()
    src.tracks = SSpersistency.tracks

/**
 * Destruction of the persistent subsystem. Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistent/Destroy()
    // Saves tracked objects without ID to DB
    //TODO

    // Update tracked objects with ID to DB
    //TODO
    
    // Drop entries from DB that are not in the tracking list
    //TODO

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistent/stat_entry()
    ..("actively tracked objects: [length(tracks)]")

/*#############################################
			    Public methods
#############################################*/

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 * If ckey is not provided, we must either assume it's a SYSTEM owner or the obj already has a ckey and is tracked by an ID
 */
/datum/controller/subsystem/persistent/register_obj(/obj/track, ckey)
    if(!(track in tracks)) // Prevent duplicates
        tracks += list(track, ckey)

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistent/deregister_obj(/obj/track)
    if(track in tracks) // Prevent null ref
        tracks -= track
