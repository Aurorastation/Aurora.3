GLOBAL_LIST_EMPTY(connected_z_cache)

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height

/obj/effect/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, SSmapping.multiz_levels[level][Z_LEVEL_DOWN], level--)
		. |= level-1
	for(var/level = z, SSmapping.multiz_levels[level][Z_LEVEL_UP], level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	if (zA == zB)
		return TRUE

	if(zA == 0 || zB == 0)
		return FALSE

	if (length(GLOB.connected_z_cache) >= zA && GLOB.connected_z_cache[zA])
		return (length(GLOB.connected_z_cache[zA]) >= zB && GLOB.connected_z_cache[zA][zB])

	var/list/levels = GetConnectedZlevels(zA)
	var/list/new_entry = new(max(levels))
	for (var/entry in levels)
		new_entry[entry] = TRUE

	if (GLOB.connected_z_cache.len < zA)
		GLOB.connected_z_cache.len = zA

	GLOB.connected_z_cache[zA] = new_entry

	return (length(GLOB.connected_z_cache[zA]) >= zB && GLOB.connected_z_cache[zA][zB])

/proc/get_zstep(atom/ref, dir)
	if (!isloc(ref))
		CRASH("Expected atom.")
	if (!ref.z)
		ref = get_turf(ref)
	var/turf/T = get_turf(ref)
	switch (dir)
		if (UP)
			. = GET_TURF_ABOVE(T)
		if (DOWN)
			. = GET_TURF_BELOW(T)
		else
			. = get_step(ref, dir)
