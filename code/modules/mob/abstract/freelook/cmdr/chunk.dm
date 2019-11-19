/* SYNDICATE CHUNK

A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
Allows the Eye to stream these chunks and know what it can and cannot see. */

/datum/chunk/syndicate
	var/list/cameras = list()

/datum/chunk/syndicate/acquireVisibleTurfs(var/list/visible)
	var/turf/point = locate(src.x + 8, src.y + 8, src.z)
	for(var/camera in cameras)
		var/obj/machinery/camera/c = camera

		if(!istype(c))
			cameras -= c
			continue

		if(!c.can_use())
			continue

		if(get_dist(point, c) > 24)
			cameras -= c
			continue

		for(var/turf/t in c.can_see())
			visible[t] = t

// Create a new camera chunk, since the chunks are made as they are needed.

/datum/chunk/syndicate/New(loc, x, y, z)
	for(var/obj/machinery/camera/c in range(16, locate(x + 8, y + 8, z)))
		if(c.can_use() && NETWORK_SYNDICATE in c.network)
			cameras += c
	..()

/mob/living/silicon/proc/provides_synd_vision()
	return 0

/mob/living/silicon/robot/provides_synd_vision()
	return src.camera && src.camera.network.len && src.emagged