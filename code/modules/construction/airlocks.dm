/obj/item/frame/controller
	name = "embedded controller frame"
	build_machine_type = /obj/machinery/embedded_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"

/obj/item/frame/controller/radio/
	build_machine_type = /obj/machinery/embedded_controller/radio
	var/id_tag = ""

/obj/item/frame/controller/radio/attackby(obj/item/C, mob/user)
	if(istype(C,/obj/item/device/debugger))
		var/new_tag = sanitize(input(user, "Enter a new controller ID tag.", "Embedded Controller Tag Control") as null|text)
		if(new_tag)
			id_tag = new_tag

/obj/item/frame/controller/radio/airlock
	name = "airlock controller frame"
	build_machine_type = /obj/machinery/embedded_controller/radio/airlock

/obj/item/frame/controller/radio/docking_hatch
	name = "docking hatch frame"
	build_machine_type = /obj/machinery/embedded_controller/radio/simple_docking_controller

/obj/item/frame/controller/radio/do_special_build(var/obj/machinery/embedded_controller/radio/result)
	if(!istype(result))
		return FALSE
	id_tag = id_tag
	return ..()

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
		switch(input(user, "What setting would you like to change?", "Airlock Selection") as null|anything in list("Master Tag","ID Tag","Frequency", "Command"))
			if("Master Tag")
				var/newmaster = sanitize(input(user, "Enter a new master tag.", "Sensor Master Control") as null|text)
				if(newmaster)
					master_tag = newmaster
			if("ID Tag")
				var/newtag = sanitize(input(user, "Enter a new sensor ID tag.", "Sensor ID Control") as null|text)
				if(newtag)
					id_tag = newtag
			if("Frequency")
				var/newfreq = sanitize(input(user, "Enter a new sensor radio frequency.", "Sensor Radio Control") as null|text)
				if(newfreq)
					frequency = newfreq
			if("Command")
				var/newcommand = input(user, "Select a new airlock command.", "Sensor Command Control") as null|anything in list("cycle", "cycle_interior", "cycle_exterior")
				if(newcommand)
					command = newcommand

/obj/item/frame/sensor/do_special_build(var/obj/machinery/airlock_sensor/result)
	if(!istype(result))
		return FALSE
	result.id_tag = id_tag
	result.master_tag = master_tag
	result.frequency = frequency
	result.command = command
	result.fingerprints = fingerprints
	result.fingerprintshidden = fingerprintshidden
	result.fingerprintslast = fingerprintslast
	return ..()