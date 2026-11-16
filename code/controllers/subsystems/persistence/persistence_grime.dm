/singleton/persistent_type/generic/horizon_floor_grime
	/// Whether initialization completed successfully. Prevents a failed load or unsupported map from overwriting saved grime.
	var/grime_initialized = FALSE
	/// Saved grime tile entries waiting to be applied after SSatoms finishes initializing.
	var/list/pending_grime_tiles
	/// Saved vomit decal entries waiting to be applied after SSatoms finishes initializing.
	var/list/pending_vomit_tiles

/** Loads saved floor grime and schedules application once atom initialization completes. */
/singleton/persistent_type/generic/horizon_floor_grime/initialization_hook()
	grime_initialized = FALSE
	pending_grime_tiles = null
	pending_vomit_tiles = null
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_floor_grime, skip_caching = TRUE)
	var/list/saved_data = saved_generic?.content
	var/list/saved_tiles = saved_data?["tiles"]
	var/list/saved_vomit = saved_data?["vomit"]
	if(islist(saved_tiles))
		pending_grime_tiles = saved_tiles
	if(islist(saved_vomit))
		pending_vomit_tiles = saved_vomit

	grime_initialized = TRUE
	if(!length(pending_grime_tiles) && !length(pending_vomit_tiles))
		return

	if(SSatoms.initialized)
		apply_saved_grime()
	else
		RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(on_atoms_initialized))

/singleton/persistent_type/generic/horizon_floor_grime/proc/on_atoms_initialized(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE)
	INVOKE_ASYNC(src, PROC_REF(apply_saved_grime))

/** Checks whether a turf is a valid public station floor for grime/vomit persistence. */
/singleton/persistent_type/generic/horizon_floor_grime/proc/is_valid_persistent_floor(turf/simulated/floor/floor_turf)
	if(!istype(floor_turf) || !is_station_level(floor_turf.z) || floor_turf.density || floor_turf.is_open())
		return FALSE
	if(istype(floor_turf, /turf/simulated/floor/beach/water))
		return FALSE
	var/area/floor_area = get_area(floor_turf)
	if(!floor_area || (floor_area.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
		return FALSE
	if(locate(/obj/structure/grille, floor_turf) || locate(/obj/structure/window_frame, floor_turf) || locate(/obj/structure/window/full, floor_turf))
		return FALSE
	return TRUE

/** Applies loaded grime and vomit entries onto station floor turfs. */
/singleton/persistent_type/generic/horizon_floor_grime/proc/apply_saved_grime()
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
		if(!is_valid_persistent_floor(floor_turf))
			continue

		floor_turf.dirt = max(floor_turf.dirt, clamp(dirt_level, 51, 101))
		var/obj/effect/decal/cleanable/dirt/dirt_overlay = locate(/obj/effect/decal/cleanable/dirt, floor_turf)
		if(!dirt_overlay)
			dirt_overlay = new /obj/effect/decal/cleanable/dirt(floor_turf)
		dirt_overlay.alpha = min((floor_turf.dirt - 50) * 5, 255)

	for(var/list/entry as anything in pending_vomit_tiles)
		CHECK_TICK
		if(!islist(entry) || length(entry) < 3)
			continue

		var/x = entry[1]
		var/y = entry[2]
		var/z = entry[3]
		var/vomit_icon_state = length(entry) >= 4 ? entry[4] : null
		if(!isnum(x) || !isnum(y) || !isnum(z))
			continue

		var/turf/simulated/floor/floor_turf = locate(x, y, z)
		if(!is_valid_persistent_floor(floor_turf))
			continue
		if(locate(/obj/effect/decal/cleanable/vomit, floor_turf))
			continue

		var/obj/effect/decal/cleanable/vomit/vomit_decal = new /obj/effect/decal/cleanable/vomit(floor_turf)
		if(istext(vomit_icon_state) && length(vomit_icon_state))
			vomit_decal.icon_state = vomit_icon_state

	pending_grime_tiles = null
	pending_vomit_tiles = null

/** Saves floor grime, vomit, and converts remaining station bloodstains into grime for subsequent rounds. */
/singleton/persistent_type/generic/horizon_floor_grime/finalization_hook()
	if(!grime_initialized || !SSpersistence.map_supports_persistence)
		return

	var/list/all_grime = list()
	var/list/all_vomit = list()
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

			var/obj/effect/decal/cleanable/vomit/vomit_decal = locate(/obj/effect/decal/cleanable/vomit, floor_turf)
			if(vomit_decal)
				all_vomit += list(list(floor_turf.x, floor_turf.y, floor_turf.z, vomit_decal.icon_state))

	// Wrapped in an associative list so empty tile lists still overwrite previous round data.
	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_floor_grime, list("tiles" = all_grime, "vomit" = all_vomit))
