// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/chunk/camera/New(var/datum/visualnet/visualnet, x, y, z)
	src.visualnet = visualnet
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/z_level in get_stack_levels())
		var/turf/center = locate(x + 8, y + 8, z_level)
		if(!center)
			continue
		for(var/turf/t in RANGE_TURFS(10, center))
			if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
				turfs[t] = t

	add_sources(visualnet.sources)
	acquire_visible_turfs(visibleTurfs)

	visibleTurfs &= turfs
	obscuredTurfs = turfs - visibleTurfs

	for(var/turf in obscuredTurfs)
		var/turf/t = turf
		obscured += obfuscation.get_obfuscation(t)

/datum/chunk/camera/proc/get_stack_levels()
	var/list/stack = SSmapping.get_connected_levels(z)
	if(length(stack))
		return stack
	return list(z)

/datum/chunk/camera/proc/source_in_chunk_range(var/atom/source)
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return FALSE

	var/list/stack = get_stack_levels()
	if(!(source_turf.z in stack))
		return FALSE

	return max(abs(source_turf.x - (x + 8)), abs(source_turf.y - (y + 8))) <= 16

/datum/chunk/camera/add_sources(var/list/sources)
	for(var/entry in sources)
		var/atom/A = entry
		add_source(A)

/datum/chunk/camera/add_source(var/atom/source)
	if(!source_in_chunk_range(source))
		return FALSE
	return ..()

/datum/chunk/camera/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		if(istype(source, /obj/structure/machinery/camera))
			var/obj/structure/machinery/camera/c = source
			if(!c.can_use())
				continue

			for(var/turf/t in c.can_see())
				visible[t] = t
		else if(isAI(source))
			var/mob/living/silicon/ai/AI = source
			if (AI.stat == DEAD)
				continue
			for(var/T in seen_turfs_in_range(AI, world.view))
				var/turf/t = T
				visible[t] = t
		else
			log_visualnet("Contained an unhandled source", source)
			sources -= source
