/**
 * Initializes persistent objects.
 * This includes cleaning up expired objects from the database and instanciating all active tracks.
 */
/datum/controller/subsystem/persistence/proc/objectsInitialize()
	PRIVATE_PROC(TRUE)
	GLOB.persistence_object_track_register = list()

	if(SSatlas.current_map.path != "sccv_horizon") // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
		log_subsystem_persistence_info("Persistent objects: Current map did not match SCCV Horizon, skipping persistent object initialization.")
		return

	// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
	objectsDatabaseCleanEntries()

	// Retrieve all persistent data that is not expired
	var/list/persistent_data = objectsDatabaseGetActiveEntries()
	log_subsystem_persistence_info("Persistent objects: Retrieved [length(persistent_data)] entries for instancing this round.")

	// Instantiate all remaining entries based of their type
	// Assign persistence related vars found in /obj, apply content and add to live tracking list.
	for (var/data in persistent_data)
		CHECK_TICK
		var/typepath = text2path(data["type"])
		if (!ispath(typepath)) // Type checking
			continue
		// Note that the object here is instantiated without init args.
		// Objects that require init args should fall back to INITALIZE_HINT_LATELOAD during Init,
		// as this will give the subsystem the chance to apply the content and
		// the object to continue with init logic after the subsystem is done in LateInitialize.
		var/obj/instance = new typepath()
		instance.persistent_objects_track_id = data["id"]
		objectsApplyTrackContent(instance, data["content"], data["x"], data["y"], data["z"])
		objectsRegisterTrack(instance, data["author_ckey"])

/**
 * Finalize persistent object tracking.
 * Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/proc/objectsFinalize()
	PRIVATE_PROC(TRUE)

	if(SSatlas.current_map.path != "sccv_horizon") // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
		log_subsystem_persistence_info("Persistent objects: Current map did not match SCCV Horizon, skipping persistent object finalization.")
		if(length(GLOB.persistence_object_track_register) > 0)
			log_subsystem_persistence_warning("Persistent objects: There are [length(GLOB.persistence_object_track_register)] tracked objects at finalization, while the map is not supported! These track will not be saved! Verify that SSatlas.current_map.path has not changed during the round!")
		return

	// Subsystem shutdown:
	// Create new persistent records for objects that have been created in the round
	// Update tracked objects that have an ID (already existing from previous rounds)
	// Delete persistent records that no longer exist in the registry (removed during the round)

	// Run checks on each track that might prevent further persistence
	for (var/obj/track as anything in GLOB.persistence_object_track_register)
		CHECK_TICK
		var/turf/T = get_turf(track)
		if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
			objectsDeregisterTrack(track)
		if(astype(track, /obj/item)?.in_inventory) // Objects that are held by players won't become persistent
			objectsDeregisterTrack(track)

	var/created = 0
	var/updated = 0
	var/expired = 0

	// Get already stored data before saving new tracks so we can compare what has been updated or removed during the round.
	var/list/existing_data = objectsDatabaseGetActiveEntries()

	for (var/obj/track as anything in GLOB.persistence_object_track_register)
		CHECK_TICK
		if (track.persistent_objects_track_id == 0)
			// Tracked object has no ID meaning it is new, create a new persistent record for it
			objectsDatabaseAddEntry(track)
			created++

	// Find tracks that have been removed during the round by trying to find the track by database ID
	// If we find the track, we need to check if it requires an update instead
	for (var/record in existing_data)
		var/found = FALSE
		for (var/obj/track as anything in GLOB.persistence_object_track_register)
			CHECK_TICK
			if (record["id"] == track.persistent_objects_track_id)
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
				else if (objectsGetTrackContent(track) != record["content"])
					changed = TRUE
				if (changed)
					objectsDatabaseUpdateEntry(track)
					updated++
				break // Track found (and perhaps updated), break off loop search as it won't need to be deleted anyways
		if (!found)
			// No track with the same ID has been found in the register, remove it from the database (expire)
			objectsDatabaseExpireEntry(record["id"])
			expired++

	log_subsystem_persistence_info("Persistent objects: Created [created], updated [updated] and expired [expired] tracks.")

/**
 * Safely get JSON persistent content of track.
 * RETURN: JSON formatted content of track or null if an exception occured.
 */
/datum/controller/subsystem/persistence/proc/objectsGetTrackContent(obj/track)
	PRIVATE_PROC(TRUE)
	var/result = json_encode(list())
	try
		var/list/content = track.persistent_objects_get_content()
		if(length(content))
			result = json_encode(content)
	catch(var/exception/e)
		log_subsystem_persistence_error("Error during json serialization for persistent object. Failed to get/encode track content: [e]")
	return result

/**
 * Safely apply persistent content to track.
 * PARAMS:
 * 	track = Object to apply content to.
 *  json = Custom persistent content JSON to be applied.
 *	x,y,z = x-y-z coordinates of object, can be null.
 */
/datum/controller/subsystem/persistence/proc/objectsApplyTrackContent(obj/track, json, x, y, z)
	PRIVATE_PROC(TRUE)
	try
		track.persistent_objects_apply_content(json_decode(json), x, y, z)
	catch(var/exception/e)
		log_subsystem_persistence_error("Error during json deserialization for persistent object. Failed to apply/decode track content: [e]")
