// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/chunk/syndicate/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		if(istype(source, /obj/machinery/camera))
			var/obj/machinery/camera/c = source
			if(!c.can_use())
				continue

			for(var/turf/t in c.can_see())
				visible[t] = t
		else
			log_visualnet("Contained an unhandled source", source)
			sources -= source