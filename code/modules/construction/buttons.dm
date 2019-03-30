/obj/item/frame/button
	name = "button frame"
	build_machine_type = /obj/machinery/button/
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl-open"

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
		var/new_tag = input(user, "Enter a new master ID tag.", "Master Tag Control") as null|text
		if(new_tag)
			master_tag = new_tag


/obj/item/frame/button/access/try_build(turf/on_wall)
	if(side == "interior")
		build_machine_type = /obj/machinery/access_button/airlock_interior
	if(side == "exterior")
		build_machine_type = /obj/machinery/access_button/airlock_exterior

	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_wall)
	else
		ndir = get_dir(on_wall,usr)

	if (!(ndir in cardinal))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		usr << "<span class='danger'>\The [src] cannot be placed on this spot.</span>"
		return
	if (!A.requires_power || A.name == "Space")
		to_chat(usr, span("danger", "\The [src] cannot be placed in this area."))
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, span("danger", "There's already an item on this wall!"))
		return

	var/obj/machinery/M = new build_machine_type(loc, ndir, 1)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)
