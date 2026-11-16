/singleton/persistent_type/generic/horizon_floor_grime
	/// Whether initialization completed successfully. Prevents a failed load or unsupported map from overwriting saved grime.
	var/grime_initialized = FALSE
	/// Saved grime tile entries waiting to be applied after SSatoms finishes initializing.
	var/list/pending_grime_tiles

/** Loads saved floor grime and schedules application once atom initialization completes. */
/singleton/persistent_type/generic/horizon_floor_grime/initialization_hook()
	grime_initialized = FALSE
	pending_grime_tiles = null
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_floor_grime, skip_caching = TRUE)
	var/list/saved_data = saved_generic?.content
	var/list/saved_tiles = saved_data?["tiles"]
	if(islist(saved_tiles))
		pending_grime_tiles = saved_tiles

	grime_initialized = TRUE
	if(!length(pending_grime_tiles))
		return

	if(SSatoms.initialized)
		apply_saved_grime()
	else
		RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(on_atoms_initialized))

/singleton/persistent_type/generic/horizon_floor_grime/proc/on_atoms_initialized(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE)
	apply_saved_grime()

/** Applies loaded grime entries onto station floor turfs. */
/singleton/persistent_type/generic/horizon_floor_grime/proc/apply_saved_grime()
	if(!length(pending_grime_tiles))
		pending_grime_tiles = null
		return

	for(var/list/entry as anything in pending_grime_tiles)
		CHECK_TICK
		if(!islist(entry) || length(entry) < 4)
			continue

		var/x = entry[1]
		var/y = entry[2]
		var/z = entry[3]
		var/dirt_level = entry[4]
		if(!isnum(x) || !isnum(y) || !isnum(z) || !isnum(dirt_level))
			continue

		var/turf/simulated/floor/floor_turf = locate(x, y, z)
		if(!istype(floor_turf) || !is_station_level(floor_turf.z) || floor_turf.density || floor_turf.is_open())
			continue
		if(istype(floor_turf, /turf/simulated/floor/beach/water))
			continue
		var/area/floor_area = get_area(floor_turf)
		if(!floor_area || (floor_area.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
			continue
		if(locate(/obj/structure/grille, floor_turf) || locate(/obj/structure/window_frame, floor_turf) || locate(/obj/structure/window/full, floor_turf))
			continue

		floor_turf.dirt = max(floor_turf.dirt, clamp(dirt_level, 51, 101))
		var/obj/effect/decal/cleanable/dirt/dirt_overlay = locate(/obj/effect/decal/cleanable/dirt, floor_turf)
		if(!dirt_overlay)
			dirt_overlay = new /obj/effect/decal/cleanable/dirt(floor_turf)
		dirt_overlay.alpha = min((floor_turf.dirt - 50) * 5, 255)

	pending_grime_tiles = null

/** Saves floor grime and converts remaining station bloodstains into grime for subsequent rounds. */
/singleton/persistent_type/generic/horizon_floor_grime/finalization_hook()
	if(!grime_initialized || !SSpersistence.map_supports_persistence)
		return

	var/list/all_grime = list()
	var/list/station_z_levels = SSmapping.levels_by_all_traits(list(ZTRAIT_STATION))
	for(var/z_level in station_z_levels)
		for(var/turf/simulated/floor/floor_turf in block(locate(1, 1, z_level), locate(world.maxx, world.maxy, z_level)))
			CHECK_TICK
			if(floor_turf.density || floor_turf.is_open() || istype(floor_turf, /turf/simulated/floor/beach/water))
				continue
			var/area/floor_area = get_area(floor_turf)
			if(!floor_area || (floor_area.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
				continue

			var/dirt_level = floor_turf.dirt > 50 ? min(floor_turf.dirt, 101) : 0

			var/obj/effect/decal/cleanable/dirt/dirt_overlay = locate(/obj/effect/decal/cleanable/dirt, floor_turf)
			if(dirt_overlay)
				var/decal_dirt = clamp(50 + max(1, round(dirt_overlay.alpha / 5)), 51, 101)
				dirt_level = max(dirt_level, decal_dirt)

			for(var/obj/effect/decal/cleanable/blood/blood_decal in floor_turf)
				if(blood_decal.invisibility >= 100)
					continue
				if(istype(blood_decal, /obj/effect/decal/cleanable/blood/gibs))
					continue
				var/blood_dirt = (istype(blood_decal, /obj/effect/decal/cleanable/blood/drip) || istype(blood_decal, /obj/effect/decal/cleanable/blood/tracks)) ? 65 : 85
				dirt_level = max(dirt_level, blood_dirt)

			if(dirt_level > 50)
				all_grime += list(list(floor_turf.x, floor_turf.y, floor_turf.z, dirt_level))

	// Wrapped in an associative list so an empty tile list still overwrites previous round data.
	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_floor_grime, list("tiles" = all_grime))
