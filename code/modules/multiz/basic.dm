// If you add a more comprehensive system, just untick this file.
// WARNING: Only works for up to 17 z-levels!

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	SSatlas.height_markers += src

/obj/effect/landmark/map_data/proc/setup()
	ASSERT(height <= z)
	// Due to the offsets of how connections are stored v.s. how z-levels are indexed, some magic number silliness happened.
	for(var/i = (z - height) to (z - 2))
		SSatlas.z_levels |= (1 << i)
	qdel(src)

/obj/effect/landmark/map_data/Destroy()
	SSatlas.height_markers -= src
	return ..()

// Legacy shims.
/proc/HasAbove(var/z)
	return HAS_ABOVE(z)

/proc/HasBelow(var/z)
	return HAS_BELOW(z)

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(atom/A)
	if (!A.z)
		A = get_turf(A)
	return A ? GET_ABOVE(A) : null

/proc/GetBelow(atom/A)
	if (!A.z)
		A = get_turf(A)
	return A ? GET_BELOW(A) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HAS_BELOW(level), level--)
		. += level-1
	for(var/level = z, HAS_ABOVE(level), level++)
		. += level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	if (zA == zB)
		return TRUE

	if (SSatlas.connected_z_cache.len >= zA && SSatlas.connected_z_cache[zA])
		return SSatlas.connected_z_cache[zA][zB]

	var/list/levels = GetConnectedZlevels(zA)
	var/list/new_entry = new(max(levels))
	for (var/entry in levels)
		new_entry[entry] = TRUE

	if (SSatlas.connected_z_cache.len < zA)
		SSatlas.connected_z_cache.len = zA

	SSatlas.connected_z_cache[zA] = new_entry

	return new_entry[zB]

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
