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
		if(!(T.z in current_map.sealed_levels)) // Picking a turf outside the map edge isn't recommended
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

/proc/screen_loc2turf(text, turf/origin)
	if(!origin)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	tX = max(1, min(origin.x + 7 - tX, world.maxx))
	tY = max(1, min(origin.y + 7 - tY, world.maxy))
	return locate(tX, tY, tZ)

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

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			log_world("ERROR: Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map

/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf, var/ignore_background)
	. = list()
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area)
				ChangeArea(target, get_area(source))
				. += transport_turf_contents(source, target, ignore_background)
				ChangeArea(source, base_area)
			else
				. += transport_turf_contents(source, target, ignore_background)
	//change the old turfs
	for(var/turf/source in translation)
		if(ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND))
			continue
		var/old_turf = base_turf || get_base_turf_by_area(source)
		source.ChangeTurf(old_turf)


//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
//If ignore_background is set to true, turfs with TURF_FLAG_BACKGROUND set will only translate anchored contents.
//Returns the new turf, or list(new turf, source) if a background turf was ignored and things may have been left behind.
/proc/transport_turf_contents(turf/source, turf/target, ignore_background)
	var/turf/new_turf

	var/is_background = ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND)
	var/supported = FALSE // Whether or not there's an object in the turf which can support other objects.
	if(is_background)
		new_turf = target
	else
		new_turf = target.ChangeTurf(source.type, 1, 1)
		new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.obj_flags & OBJ_FLAG_NOFALL)
			supported = TRUE
			break

	for(var/obj/O in source)
		if(O.simulated && (!is_background || supported || O.obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED))
			O.forceMove(new_turf)
		else if(istype(O,/obj/effect)) // This is used for non-game objects like spawnpoints, so ignore the background check.
			var/obj/effect/E = O
			if(E.movable_flags & MOVABLE_FLAG_EFFECTMOVE)
				E.forceMove(new_turf)

	for(var/mob/M in source)
		if(is_background && !supported)
			continue
		if(isEye(M))
			continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	if(is_background)
		return list(new_turf, source)

	return new_turf

/proc/air_sound(atom/source, var/required_pressure = SOUND_MINIMUM_PRESSURE)
	var/turf/T = get_turf(source)
	if(!istype(T)) return FALSE
	var/datum/gas_mixture/environment = T.return_air()
	var/pressure = (environment)? environment.return_pressure() : 0
	if(pressure < required_pressure)
		return FALSE
	return TRUE
