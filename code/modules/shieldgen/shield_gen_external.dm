//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"
	multi_unlocked = TRUE

//Search for space turfs within range that are adjacent to a simulated turf.
/obj/machinery/shield_gen/external/get_shielded_turfs()
	set background = 1
	var/list/out = list()

	var/turf/gen_turf = get_turf(src)
	if (!gen_turf)
		return

	var/turf/U
	var/turf/T

	for (var/tt in RANGE_TURFS(field_radius, gen_turf))
		T = tt
		// Ignore station areas.
		if (the_station_areas[T.loc] || is_shuttle_area(T.loc))
			continue
		else if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
			for (var/uu in RANGE_TURFS(1, T))
				U = uu
				if (T == U)
					continue

				if (the_station_areas[U.loc] || istype(U, /turf/simulated/mineral/surface))
					out += T
					break

	if(multiz)
		var/connected_levels = list()
		var/turf/above = getzabove(src)
		var/turf/below = getzbelow(src)
		if(above)
			for(var/turf/z as anything in above)
				connected_levels += z
		if(below)
			for(var/turf/z as anything in below)
				connected_levels += z
		for(var/turf/z in connected_levels)
			for (var/tt in RANGE_TURFS(field_radius, z))
				T = tt
				// Ignore station areas.
				if (the_station_areas[T.loc] || istype(T.loc, /area/shuttle))
					continue
				else if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
					for (var/uu in RANGE_TURFS(1, T))
						U = uu
						if (T == U)
							continue

						if (the_station_areas[U.loc])
							out += T
							break
	return out
