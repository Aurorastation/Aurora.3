// If you add a more comprehensive system, just untick this file.
// Because this shit before was, for some reason, a bitfield.
var/global/list/z_levels = list()
var/list/list/connected_z_cache = list()

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height
	for(var/i = (loc.z - height + 1) to (loc.z-1))
		if (z_levels.len <i)
			z_levels.len = i
		z_levels[i] = TRUE

/obj/effect/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/proc/HasAbove(var/z)
	if(z >= world.maxz || z < 1 || z > z_levels.len)
		return 0
	return z_levels[z]

/proc/HasBelow(var/z)
	if(z > world.maxz || z < 2 || (z-1) > z_levels.len)
		return 0
	return z_levels[z-1]

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	if (zA == zB)
		return TRUE
	
	if(zA == 0 || zB == 0)
		return FALSE

	if (connected_z_cache.len >= zA && connected_z_cache[zA])
		return (connected_z_cache[zA].len >= zB && connected_z_cache[zA][zB])

	var/list/levels = GetConnectedZlevels(zA)
	var/list/new_entry = new(max(levels))
	for (var/entry in levels)
		new_entry[entry] = TRUE

	if (connected_z_cache.len < zA)
		connected_z_cache.len = zA

	connected_z_cache[zA] = new_entry

	return (connected_z_cache[zA].len >= zB && connected_z_cache[zA][zB])

/proc/get_zstep(atom/ref, dir)
	if (!isloc(ref))
		CRASH("Expected atom.")
	if (!ref.z)
		ref = get_turf(ref)
	switch (dir)
		if (UP)
			. = GET_ABOVE(ref)
		if (DOWN)
			. = GET_BELOW(ref)
		else
			. = get_step(ref, dir)
