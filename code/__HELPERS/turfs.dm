// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall))

/proc/isfloor(turf/T)
	if(locate(/obj/structure/lattice) in T)
		return TRUE
	else if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		return TRUE
	return FALSE


//Edit by Nanako
//This proc is used in only two places, ive changed it to make more sense
//The old behaviour returned zero if there were any simulated atoms at all, even pipes and wires
//Now it just finds if the tile is blocked by anything solid.
/proc/turf_clear(turf/T)
	if (T.density)
		return 0
	for(var/atom/A in T)
		if(A.density)
			return 0
	return 1

/proc/get_random_turf_in_range(var/atom/origin, var/outer_range, var/inner_range, var/check_density, var/check_indoors)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(outer_range, origin))
		if(!(T.z in SSmapping.current_map.sealed_levels)) // Picking a turf outside the map edge isn't recommended
			if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)
				continue
			if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)
				continue
			if(check_density && turf_contains_dense_objects(T))
				continue
			if(check_indoors)
				var/area/A = get_area(T)
				if(A.station_area)
					continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

///Returns a turf based on text inputs, original turf and viewing client
/proc/parse_caught_click_modifiers(list/modifiers, turf/origin, client/viewing_client)
	if(!modifiers)
		return null

	var/screen_loc = splittext(LAZYACCESS(modifiers, SCREEN_LOC), ",")
	var/list/actual_view = getviewsize(viewing_client ? viewing_client.view : world.view)
	var/click_turf_x = splittext(screen_loc[1], ":")
	var/click_turf_y = splittext(screen_loc[2], ":")
	var/click_turf_z = origin.z

	var/click_turf_px = text2num(click_turf_x[2])
	var/click_turf_py = text2num(click_turf_y[2])
	click_turf_x = origin.x + text2num(click_turf_x[1]) - round(actual_view[1] / 2) - 1
	click_turf_y = origin.y + text2num(click_turf_y[1]) - round(actual_view[2] / 2) - 1

	var/turf/click_turf = locate(clamp(click_turf_x, 1, world.maxx), clamp(click_turf_y, 1, world.maxy), click_turf_z)
	LAZYSET(modifiers, ICON_X, "[(click_turf_px - click_turf.pixel_x) + ((click_turf_x - click_turf.x) * ICON_SIZE_X)]")
	LAZYSET(modifiers, ICON_Y, "[(click_turf_py - click_turf.pixel_y) + ((click_turf_y - click_turf.y) * ICON_SIZE_Y)]")
	return click_turf

// This proc will check if a neighboring tile in the stated direction "dir" is dense or not
// Will return 1 if it is dense and zero if not
/proc/check_neighbor_density(turf/T, var/dir)
	if (!T.loc)
		CRASH("The Turf has no location!")
	switch (dir)
		if (NORTH)
			return !turf_clear(get_turf(locate(T.x, T.y+1, T.z)))
		if (NORTHEAST)
			return !turf_clear(get_turf(locate(T.x+1, T.y+1, T.z)))
		if (EAST)
			return !turf_clear(get_turf(locate(T.x+1, T.y, T.z)))
		if (SOUTHEAST)
			return !turf_clear(get_turf(locate(T.x+1, T.y-1, T.z)))
		if (SOUTH)
			return !turf_clear(get_turf(locate(T.x, T.y-1, T.z)))
		if (SOUTHWEST)
			return !turf_clear(get_turf(locate(T.x-1, T.y-1, T.z)))
		if (WEST)
			return !turf_clear(get_turf(locate(T.x-1, T.y, T.z)))
		if (NORTHWEST)
			return !turf_clear(get_turf(locate(T.x-1, T.y+1, T.z)))
		else return

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/turf_contains_dense_objects(var/turf/T)
	return T.contains_dense_objects()

/proc/not_turf_contains_dense_objects(var/turf/T)
	return !turf_contains_dense_objects(T)

/proc/is_station_turf(var/turf/T)
	return T && is_station_level(T.z)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/proc/air_sound(atom/source, var/required_pressure = SOUND_MINIMUM_PRESSURE)
	var/turf/T = get_turf(source)
	if(!istype(T)) return FALSE
	var/datum/gas_mixture/environment = T.return_air()
	var/pressure = (environment)? environment.return_pressure() : 0
	if(pressure < required_pressure)
		return FALSE
	return TRUE
