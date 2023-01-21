/singleton/submap_archetype
	var/map
	var/descriptor = "generic ship archetype"

/singleton/submap_archetype/Destroy()
	if(SSmapping.submap_archetypes[descriptor] == src)
		SSmapping.submap_archetypes -= descriptor
	. = ..()

// Generic ships to populate the list.
/singleton/submap_archetype/derelict
	descriptor = "drifting wreck"

/singleton/submap_archetype/abandoned_ship
	descriptor = "abandoned ship"
