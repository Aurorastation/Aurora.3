/obj/item/frame/button
	name = "button frame"
	build_machine_type = /obj/machinery/button
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl-open"
	reverse = 1

/obj/item/frame/button/mass_driver
	name = "mass driver button frame"
	build_machine_type = /obj/machinery/button/mass_driver

/obj/item/frame/button/door
	name = "door button frame"
	build_machine_type = /obj/machinery/button/toggle/door

/obj/item/frame/button/access
	name = "door button frame"
	build_machine_type = /obj/machinery/access_button
	var/side = "interior"
	var/master_tag = ""

/obj/item/frame/button/access/examine(mob/user)
	. = ..()
	to_chat(user, "It is set to [side].")

/obj/item/frame/button/access/attack_self(mob/user)
	side = side == "interior" ? "exterior" : "interior"
	to_chat(user, span("notice", "You set \the [src] to [side]."))

/obj/item/frame/button/access/attackby(obj/item/C, mob/user)
	if(istype(C,/obj/item/device/debugger))
		var/new_tag = sanitize(input(user, "Enter a new master ID tag.", "Master Tag Control") as null|text)
		if(new_tag)
			master_tag = new_tag

/obj/item/frame/button/access/try_build(turf/on_wall, mob/user)
	if(side == "interior")
		build_machine_type = /obj/machinery/access_button/airlock_interior
	if(side == "exterior")
		build_machine_type = /obj/machinery/access_button/airlock_exterior
	. = ..()
