/obj/effect/map_effect/door_helper
	layer = DOOR_CLOSED_LAYER + 0.1

/obj/effect/map_effect/door_helper/unres
	icon_state = "unres_door"

/obj/effect/map_effect/door_helper/unres/Initialize(mapload, ...)
	..()
	for(var/obj/machinery/door/D in loc)
		if(istype(D, /obj/machinery/door/blast) || istype(D, /obj/machinery/door/firedoor))
			continue
		D.unres_dir ^= dir
	return INITIALIZE_HINT_QDEL