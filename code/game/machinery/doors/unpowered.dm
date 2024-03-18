/obj/machinery/door/unpowered
	icon = 'icons/turf/shuttle.dmi'
	autoclose = 0
	var/locked = 0

/obj/machinery/door/unpowered/CollidedWith(atom/AM)
	if(src.locked)
		return
	..()
	return

/obj/machinery/door/unpowered/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/melee/energy/blade))
		return TRUE

	if(src.locked)
		return TRUE

	return ..()

/obj/machinery/door/unpowered/emag_act()
	return -1

/obj/machinery/door/unpowered/shuttle
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1
