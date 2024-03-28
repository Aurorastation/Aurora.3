
/obj/effect/landmark/entry_point
	name = "entry point landmark"
	icon_state = "dir_arrow"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/landmark/entry_point/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/entry_point/LateInitialize()
	if(SSatlas.current_map.use_overmap)
		SSshuttle.entry_points_to_initialize += src
	name += " [x], [y]"

/obj/effect/landmark/entry_point/proc/get_candidate()
	// try to get it using shuttle area first
	var/datum/shuttle/shuttle = SSshuttle.shuttle_area_to_shuttle[get_area(src)]
	if(istype(shuttle))
		var/obj/effect/overmap/visitable/ship/ship = SSshuttle.shuttle_obj_by_name(shuttle.name)
		if(istype(ship))
			return ship

	// do it recursively otherwise
	var/obj/effect/overmap/visitable/sector = GLOB.map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/effect/landmark/entry_point/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/effect/landmark/entry_point/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		return TRUE
	return FALSE

// The four entry point landmarks below are named assuming that fore is facing DOWNWARDS.

/obj/effect/landmark/entry_point/aft
	name = "aft"

/obj/effect/landmark/entry_point/starboard
	name = "starboard"
	dir = 4

/obj/effect/landmark/entry_point/port
	name = "port"
	dir = 8

/obj/effect/landmark/entry_point/fore
	name = "fore"
	dir = 1

/obj/effect/landmark/entry_point/south
	name = "south"

/obj/effect/landmark/entry_point/east
	name = "east"
	dir = 4

/obj/effect/landmark/entry_point/west
	name = "west"
	dir = 8

/obj/effect/landmark/entry_point/north
	name = "north"
	dir = 1
