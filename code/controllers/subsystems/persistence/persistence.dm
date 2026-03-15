SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

/**
 * Initialization of the persistence subsystem. Initialization includes loading all persistent data and spawning the related objects.
 */
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	try
		if(!GLOB.config.sql_enabled)
			log_subsystem_persistence("SQL configuration not enabled! Persistence subsystem requires SQL.")
			return SS_INIT_SUCCESS

		GLOB.persistence_register = list()

		if(!SSdbcore.Connect())
			log_subsystem_persistence("SQL ERROR during persistence subsystem init. Failed to connect.")
			return SS_INIT_FAILURE
		else
			// Delete all persistent objects in the database that have expired and have passed the cleanup grace period (PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS)
			database_clean_entries()

			// Retrieve all persistent data that is not expired
			var/list/persistent_data = database_get_active_entries()
			log_subsystem_persistence("Init: Retrieved [persistent_data.len] entries for instancing this round.")

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

			return SS_INIT_SUCCESS
	catch(var/exception/e)
		log_subsystem_persistence("Panic: Exception during subsystem initialize: [e]")
		return SS_INIT_FAILURE

/**
 * Shutdown of the persistence subsystem. Adds new persistent objects, removes no longer existing persistent objects and updates changed persistent objects in the database.
 */
/datum/controller/subsystem/persistence/Shutdown()
	try
		if(!GLOB.config.sql_enabled)
			log_subsystem_persistence("SQL configuration not enabled! Panic - Cannot save current round track changes!")
			return

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

		log_subsystem_persistence("Shutdown: Tried to create [created], update [updated] and expire [expired] tracks.")
	catch(var/exception/e)
		log_subsystem_persistence("Panic: Exception during subsystem shutdown: [e]")
		return

/**
 * Generates StatEntry. Returns information about currently tracked objects.
 */
/datum/controller/subsystem/persistence/stat_entry(msg)
	msg = ("Global register tracks: [GLOB.persistence_register.len]")
	return ..()
