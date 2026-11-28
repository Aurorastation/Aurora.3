/singleton/persistent_type/generic/horizon_cleanliness
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved cleanliness.
	var/cleanliness_initialized = FALSE

	/// Cap per-tile cleanable count so localized firefights don't disproportionately skew an area's dirtiness.
	var/const/max_cleanables_per_tile = 3
	/// Maximum persisted dirtiness stat per area (also the maximum spawn chance percentage).
	var/const/max_dirtiness = 100

/**
 * Loads the Horizon's persisted per-area cleanliness stats and configures eligible areas to generate variable-alpha grime during turf initialization.
 */
/singleton/persistent_type/generic/horizon_cleanliness/initialization_hook()
	cleanliness_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_cleanliness, skip_caching = TRUE)
	var/list/saved_content = saved_generic?.content
	var/list/saved_areas = saved_content?["areas"]

	if(islist(saved_areas) && length(saved_areas))
		for(var/area/A as anything in GLOB.areas)
			CHECK_TICK
			if(!A.station_area || (A.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
				continue

			var/saved_dirtiness = saved_areas["[A.type]"]
			if(!isnum(saved_dirtiness) || saved_dirtiness <= 0)
				continue

			var/dirtiness = clamp(saved_dirtiness, 0, max_dirtiness)
			A.persistent_dirt_chance = dirtiness
			// update_dirt() increments dirt by 1 and sets alpha = min((dirt - 50) * 5, 255),
			// so 53..100 maps to roughly 20..255 alpha as dirtiness scales from 0..100.
			A.persistent_dirt_level = clamp(round(52 + (dirtiness * 0.48)), 53, 100)

	cleanliness_initialized = TRUE

/**
 * Scans eligible non-maintenance Horizon areas at round end and saves a 1:1 dirtiness percentage per dirty area.
 * Clean areas are omitted so a spotless area starts clean next round, while keeping the saved JSON compact in a single DB row.
 */
/singleton/persistent_type/generic/horizon_cleanliness/finalization_hook()
	if(!cleanliness_initialized || !SSpersistence.map_supports_persistence)
		return

	var/list/area_eligible_turfs = list()
	var/list/area_mess_points = list()

	for(var/area/A as anything in GLOB.areas)
		CHECK_TICK
		if(!A.station_area || (A.area_flags & AREA_FLAG_PREVENT_PERSISTENT_TRASH))
			continue

		var/area_key = "[A.type]"
		for(var/turf/simulated/floor/T in A)
			CHECK_TICK
			if(!is_station_level(T.z) || T.density || T.is_open())
				continue
			area_eligible_turfs[area_key] = (area_eligible_turfs[area_key] || 0) + 1

			var/tile_cleanables = 0
			for(var/obj/effect/decal/cleanable/C in T.contents)
				tile_cleanables++
				if(tile_cleanables >= max_cleanables_per_tile)
					break
			if(tile_cleanables > 0)
				area_mess_points[area_key] = (area_mess_points[area_key] || 0) + tile_cleanables

	var/list/areas_to_save = list()
	for(var/area_key in area_mess_points)
		var/eligible_turfs = area_eligible_turfs[area_key]
		if(!eligible_turfs || eligible_turfs <= 0)
			continue
		var/raw_dirtiness = (area_mess_points[area_key] / eligible_turfs) * 100
		var/dirtiness = clamp(round(raw_dirtiness, 0.01), 0, max_dirtiness)
		if(dirtiness > 0)
			areas_to_save[area_key] = dirtiness

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_cleanliness, list("areas" = areas_to_save))
