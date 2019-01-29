/obj/item/frame/controller
	name = "embedded controller frame"
	build_machine_type = /obj/machinery/embedded_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	var/id_tag = ""

/obj/item/frame/controller/attackby(obj/item/C, mob/user)
	if(istype(C,/obj/item/device/debugger))
		var/new_tag = input(user, "Enter a new controller ID tag.", "Embedded Controller Tag Control") as null|text
		if(new_tag)
			id_tag = new_tag

/obj/item/frame/controller/airlock
	name = "airlock controller frame"
	build_machine_type = /obj/machinery/embedded_controller/radio/airlock

/obj/item/frame/controller/docking_hatch
	name = "docking hatch frame"
	build_machine_type = /obj/machinery/embedded_controller/radio/simple_docking_controller

/obj/item/frame/controller/try_build(turf/on_wall)
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
	if (A.requires_power == 0 || A.name == "Space")
		usr << "<span class='danger'>\The [src] cannot be placed in this area.</span>"
		return

	if(gotwallitem(loc, ndir))
		usr << "<span class='danger'>There's already an item on this wall!</span>"
		return

	var/obj/machinery/M = new build_machine_type(loc, ndir, 1)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)