/singleton/persistent_type/generic/horizon_cleanliness
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved cleanliness.
	var/cleanliness_initialized = FALSE

	/// Cap per-tile cleanable count so localized firefights don't disproportionately skew ship-wide dirtiness.
	var/const/max_cleanables_per_tile = 3
	/// Maximum persisted dirtiness stat.
	var/const/max_dirtiness = 100
	/// Maximum percentage of eligible floor tiles that can spawn persistent grime at round start.
	var/const/max_spawn_chance = 25

/**
 * Loads the Horizon's persisted cleanliness stat and configures eligible areas to generate variable-alpha grime during turf initialization.
 */
/singleton/persistent_type/generic/horizon_cleanliness/initialization_hook()
	cleanliness_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_cleanliness, skip_caching = TRUE)
	var/list/saved_content = saved_generic?.content
	var/saved_dirtiness = saved_content?["dirtiness"]
	var/dirtiness = isnum(saved_dirtiness) ? clamp(saved_dirtiness, 0, max_dirtiness) : 0

	if(dirtiness > 0)
		var/spawn_chance = clamp(dirtiness * (max_spawn_chance / max_dirtiness), 0, max_spawn_chance)
		// update_dirt() increments dirt by 1 and sets alpha = min((dirt - 50) * 5, 255),
		// so 53..100 maps to roughly 20..255 alpha as dirtiness scales from 0..100.
		var/base_dirt_level = clamp(round(52 + (dirtiness * 0.48)), 53, 100)

		for(var/area/A as anything in GLOB.areas)
			CHECK_TICK
			if(!A.station_area || (A.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
				continue
			A.persistent_dirt_chance = spawn_chance
			A.persistent_dirt_level = base_dirt_level

	cleanliness_initialized = TRUE

/**
 * Scans eligible non-maintenance Horizon areas at round end and saves a logarithmically scaled dirtiness stat.
 * A spotless ship saves 0 so the next round starts clean.
 */
/singleton/persistent_type/generic/horizon_cleanliness/finalization_hook()
	if(!cleanliness_initialized || !SSpersistence.map_supports_persistence)
		return

	var/eligible_turfs = 0
	var/mess_points = 0

	for(var/area/A as anything in GLOB.areas)
		CHECK_TICK
		if(!A.station_area || (A.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
			continue

		for(var/turf/simulated/floor/T in A)
			CHECK_TICK
			if(!is_station_level(T.z) || T.density || T.is_open())
				continue
			eligible_turfs++

			var/tile_cleanables = 0
			for(var/obj/effect/decal/cleanable/C in T.contents)
				tile_cleanables++
				if(tile_cleanables >= max_cleanables_per_tile)
					break
			mess_points += tile_cleanables

	if(eligible_turfs <= 0)
		return

	var/raw_dirtiness = (mess_points / eligible_turfs) * 100
	var/new_dirtiness = raw_dirtiness > 0 ? clamp(round(log(1 + raw_dirtiness) * 18, 0.01), 0, max_dirtiness) : 0

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_cleanliness, list("dirtiness" = new_dirtiness))
