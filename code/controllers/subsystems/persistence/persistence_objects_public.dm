/* This partial file contains all procs that are meant for public access. */
/* Other procs should be made private. */

/**
 * Adds the given object to the list of tracked objects. At shutdown the tracked object will be either created or updated in the database.
 * The ckey is an optional argument and is used for tracking user generated content by adding an author to the persistent data.
 */
/datum/controller/subsystem/persistence/proc/objectsRegisterTrack(obj/new_track, ckey)
	if(new_track.persistent_objects_track_active) // Prevent multiple registers per object and removes the need to check the register if it's already in there
		return

	var/turf/T = get_turf(new_track)
	if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
		return

	new_track.persistent_objects_track_active = TRUE
	new_track.persistent_objects_author_ckey = ckey
	GLOB.persistence_object_track_register += new_track

/**
 * Removes the given object from the list of tracked objects. At shutdown the tracked object will be remove from the database.
 */
/datum/controller/subsystem/persistence/proc/objectsDeregisterTrack(obj/old_track)
	if(!old_track.persistent_objects_track_active) // Prevent multiple deregisters per object and removes the need to check the register if it's not in there
		return

	old_track.persistent_objects_track_active = FALSE
	GLOB.persistence_object_track_register -= old_track
