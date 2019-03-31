/obj/item/frame/controller
	name = "embedded controller frame"
	build_machine_type = /obj/machinery/embedded_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"

/obj/item/frame/controller/radio/
	var/id_tag = ""

/obj/item/frame/controller/radio/attackby(obj/item/C, mob/user)
	if(istype(C,/obj/item/device/debugger))
		var/new_tag = input(user, "Enter a new controller ID tag.", "Embedded Controller Tag Control") as null|text
		if(new_tag)
			id_tag = new_tag

/obj/item/frame/controller/radio/airlock
	name = "airlock controller frame"
	build_machine_type = /obj/machinery/embedded_controller/radio/airlock

/obj/item/frame/controller/radio/docking_hatch
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
	if(gotwallitem(loc, ndir))
		to_chat(usr, span("danger", "There's already an item on this wall!"))
		return

	var/obj/machinery/embedded_controller/M = new build_machine_type(loc, ndir, 1)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/controller/radio/try_build(turf/on_wall)
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
	if(gotwallitem(loc, ndir))
		to_chat(usr, span("danger", "There's already an item on this wall!"))
		return

	var/obj/machinery/embedded_controller/radio/M = new build_machine_type(loc, ndir, 1) // so we can use this for airlock and docking controllers
	M.id_tag = id_tag
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/sensor
	name = "sensor frame"
	build_machine_type = /obj/machinery/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	var/id_tag = ""
	var/master_tag = ""
	var/frequency = 1379
	var/command = "cycle"

/obj/item/frame/sensor/attackby(obj/item/C, mob/user)
	if(istype(C,/obj/item/device/debugger))
		switch(input(user, "Would you like to change the master tag or the ID tag?", "Airlock Selection") as null|anything in list("Master Tag","ID Tag","Frequency", "Command"))
			if("Master Tag")
				var/newmaster = input(user, "Enter a new master tag.", "Sensor Master Control") as null|text
				if(newmaster)
					master_tag = newmaster
			if("ID Tag")
				var/newtag = input(user, "Enter a new sensor ID tag.", "Sensor ID Control") as null|text
				if(newtag)
					id_tag = newtag
			if("Frequency")
				var/newfreq = input(user, "Enter a new sensor radio frequency.", "Sensor Radio Control") as null|text
				if(newfreq)
					frequency = newfreq
			if("Command")
				var/newcommand = input(user, "Select a new airlock command.", "Sensor Command Control") as null|anything in list("cycle", "cycle_interior", "cycle_exterior")
				if(newcommand)
					command = newcommand

/obj/item/frame/sensor/try_build(turf/on_wall)
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
	if(gotwallitem(loc, ndir))
		to_chat(usr, span("danger", "There's already an item on this wall!"))
		return

	var/obj/machinery/airlock_sensor/M = new build_machine_type(loc, ndir, 1)
	M.id_tag = id_tag
	M.master_tag = master_tag
	M.frequency = frequency
	M.command = command
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)
