//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/structure/machinery/shield_gen/external
	name = "hull shield generator"

	component_types = list(
		/obj/item/circuitboard/shield_gen_ex,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/subspace/transmitter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

//Search for space turfs within range that are adjacent to a simulated turf.
/obj/structure/machinery/shield_gen/external/get_shielded_turfs()
	var/list/out = list()

	var/turf/gen_turf = get_turf(src)
	if (!gen_turf)
		return

	var/turf/U
	var/turf/T

	for (var/tt in RANGE_TURFS(field_radius, gen_turf))
		T = tt
		// Ignore station areas.
		if ((GLOB.the_station_areas[T.loc] && !is_shieldless_exterior(T.loc)) || is_shuttle_area(T.loc))
			continue
		else if (istype(T, /turf/space) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
			for (var/uu in RANGE_TURFS(1, T))
				U = uu
				if (T == U)
					continue

				if (GLOB.the_station_areas[U.loc] && !is_shieldless_exterior(U.loc))
					out += T
					break

	if(multiz)
		var/connected_levels = list()
		var/list/turf/above = getzabove(get_turf(src))
		var/list/turf/below = getzbelow(get_turf(src))
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
				if ((GLOB.the_station_areas[T.loc] && !is_shieldless_exterior(T.loc)) || istype(T.loc, /area/shuttle))
					continue

				else if (istype(T, /turf/space) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
					for (var/uu in RANGE_TURFS(1, T))
						U = uu
						if (T == U)
							continue

						if (GLOB.the_station_areas[U.loc] && !is_shieldless_exterior(U.loc))
							out += T
							break
	return out
