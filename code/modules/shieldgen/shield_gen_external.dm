//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"

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
		else if (istype(T, /turf/space) || istype(T, /turf/simulated/floor/asteroid) || isopenturf(T))
			for (var/uu in RANGE_TURFS(1, T))
				U = uu
				if (T == U)
					continue

				if (the_station_areas[U.loc])
					out += T
					break

	return out
