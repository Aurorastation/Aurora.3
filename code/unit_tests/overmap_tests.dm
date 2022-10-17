// 513 does not allow white or no color as a filter color
/datum/unit_test/overmap_effects_shall_have_non_white_color
	name = "OVERMAP: Shall have non-white color"

/datum/unit_test/overmap_effects_shall_have_non_white_color/start_test()
	var/list/invalid_overmap_types = list()
	for(var/omt in subtypesof(/obj/effect/overmap))
		var/obj/overmap = omt
		var/color = initial(overmap.color)
		if(!color || color == COLOR_WHITE)
			invalid_overmap_types += omt

	if(invalid_overmap_types.len)
		fail("Following /obj/effect/overmap types types have invalid colors: [english_list(invalid_overmap_types)]")
	else
		pass("All /obj/effect/overmap types have a valid color")

	return TRUE

/datum/unit_test/overmap_ships_shall_have_entrypoints
	name = "OVERMAP: Ships shall have at least four valid entry points"

/datum/unit_test/overmap_ships_shall_have_entrypoints/start_test()
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.initialized_sectors)
		if(length(S.entry_points) >= 4)
			pass("[S.name] ([S.type]) has at least four entry points.")
		else
			fail("[S.name] ([S.type]) does not have at least four entry points!")
	return TRUE

/datum/unit_test/overmap_ships_shall_have_class
	name = "OVERMAP: Ships shall have class and designation"

/datum/unit_test/overmap_ships_shall_have_class/start_test()
	var/failures = 0
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.initialized_sectors)
		if(!length(S.class))
			fail("[S.name] ([S.type]) does not have a class defined.")
			failures++
		else
			fail("[S.name] ([S.type]) does not have a designation defined.")
			failures++
	if(!failures)
		pass("All ships have a class and designation.")
	return TRUE