// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))


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
	return T && isStationLevel(T.z)
