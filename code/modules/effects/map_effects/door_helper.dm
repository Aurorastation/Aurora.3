/obj/effect/map_effect/door_helper
	layer = DOOR_CLOSED_LAYER + 0.1

/obj/effect/map_effect/door_helper/Initialize(mapload, ...)
	..()
	for(var/obj/machinery/door/D in loc)
		if(istype(D, /obj/machinery/door/blast) || istype(D, /obj/machinery/door/firedoor))
			continue
		modify_door(D)
	return INITIALIZE_HINT_QDEL

/obj/effect/map_effect/door_helper/proc/modify_door(obj/machinery/door/D)
	return

/obj/effect/map_effect/door_helper/unres
	icon_state = "unres_door"

/obj/effect/map_effect/door_helper/unres/modify_door(obj/machinery/door/D)
	D.unres_dir ^= dir

/obj/effect/map_effect/door_helper/level_access
	icon_state = "level_door"
	/// Example of an appropriate way to set this: list("red" = list(1, 2))
	/// Alternatively, for a door that is free access on a certain code: list("green" = null)
	var/list/access_by_level

/obj/effect/map_effect/door_helper/level_access/modify_door(obj/machinery/door/D)
	if(isairlock(D))
		var/obj/machinery/door/airlock/A = D
		A.access_override_by_level = access_by_level
