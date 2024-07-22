/datum/space_level/proc/set_linkage(new_linkage)
	linkage = new_linkage
	if(linkage == SELFLOOPING)
		neigbours = list(TEXT_NORTH,TEXT_SOUTH,TEXT_EAST,TEXT_WEST)
		for(var/A in neigbours)
			neigbours[A] = src
