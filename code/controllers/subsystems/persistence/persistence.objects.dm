/**
 * Initializes persistent objects.
 * This includes cleaning up expired objects from the database and instanciating all active tracks.
 */
/datum/controller/subsystem/persistence/proc/initialize_persistent_objects()
	GLOB.persistence_register = list()

	// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
	database_clean_entries()

	// Retrieve all persistent data that is not expired
	var/list/persistent_data = database_get_active_entries()
	log_subsystem_persistence_info("Persistent objects: Retrieved [persistent_data.len] entries for instancing this round.")

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
		instance.persistence_track_id = data["id"]
		track_apply_content(instance, data["content"], data["x"], data["y"], data["z"])
		register_track(instance, data["author_ckey"])

/**
 * Finalize persistent object tracking.
 * Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/proc/finalize_persistent_objects()
	// Subsystem shutdown:
	// Create new persistent records for objects that have been created in the round
	// Update tracked objects that have an ID (already existing from previous rounds)
	// Delete persistent records that no longer exist in the registry (removed during the round)

	// Run checks on each track that might prevent further persistence
	for (var/obj/track in GLOB.persistence_register)
		CHECK_TICK
		var/turf/T = get_turf(track)
		if(!T || !is_station_level(T.z)) // The persistence system only supports objects from the main map levels for multiple reasons, e.g. Z level value, mapping support
			deregister_track(track)
		if(astype(track, /obj/item)?.in_inventory) // Objects that are held by players won't become persistent
			deregister_track(track)

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

	log_subsystem_persistence_info("Persistent objects: Created [created], updated [updated] and expired [expired] tracks.")

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
