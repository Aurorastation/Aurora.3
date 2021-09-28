//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"
	multi_unlcoked = TRUE

//NOT MULTIZ COMPATIBLE
//Search for space turfs within range that are adjacent to a simulated turf.
/obj/machinery/shield_gen/external/get_shielded_turfs()
	var/list/out = list()

	var/turf/gen_turf = get_turf(src)
	if (!gen_turf)
		return

	var/turf/U
	var/turf/T

	for (var/tt in RANGE_TURFS(field_radius, gen_turf))
		T = tt
		// Ignore station areas.
		if (the_station_areas[T.loc])
			continue
		else if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T))
			for (var/uu in RANGE_TURFS(1, T))
				U = uu
				if (T == U)
					continue

				if (the_station_areas[U.loc])
					out += T
					break

	if(multiz)
		log_and_message_admins("mutliz is active")
		var/connected_levels = list()
		var/turf/above = getzabove(src)
		var/turf/below = getzbelow(src)
		if(above)
			for(var/turf/z in above)
				connected_levels += z
				log_and_message_admins("adding [z]")
		if(below)
			for(var/turf/z in below)
				connected_levels += z
		for(var/turf/z in connected_levels)
			log_and_message_admins("mutliz is checking [z]")
			for (var/tt in RANGE_TURFS(field_radius, z))
				T = tt
				// Ignore station areas.
				if (the_station_areas[T.loc])
					continue
				else if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T))
					for (var/uu in RANGE_TURFS(1, T))
						U = uu
						if (T == U)
							continue

						if (the_station_areas[U.loc])
							out += T
							break
	else
		log_and_message_admins("mutliz is broken")
	return out

/obj/machinery/shield_gen/external/proc/getzabove(var/turf/location)
	var/connected = list()
	var/turf/above = GetAbove(location)

	if(above)
		connected += above
		var/connected_levels = getzabove(above)
		for(var/turf/z in connected_levels)
			connected += z
	
	return connected

/obj/machinery/shield_gen/external/proc/getzbelow(var/turf/location)
	var/connected = list()
	var/turf/below = GetBelow(location)

	if(below)
		connected += below
		var/connected_levels = getzbelow(below)
		for(var/turf/z in connected_levels)
			connected += z
	
	return connected