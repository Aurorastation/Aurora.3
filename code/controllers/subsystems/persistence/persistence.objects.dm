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
