/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "firealarm"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/detecting = 1
	var/working = 1
	var/time = 10
	var/timing = 0
	init_flags = 0 // Processing is only for timed alarms now
	anchored = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone
	var/seclevel
	///looping sound datum for our fire alarm siren.
	var/datum/looping_sound/firealarm/soundloop

/obj/machinery/firealarm/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if((stat & (NOPOWER|BROKEN)) || buildstage != 2)
		return

	. += "The current alert level is [get_security_level()]."

/obj/machinery/firealarm/update_icon()
	cut_overlays()

	if(wiresexposed)
		switch(buildstage)
			if(2)
				add_overlay("fire_b2")
			if(1)
				add_overlay("fire_b1")
			if(0)
				add_overlay("fire_b0")
		return

	if(stat & BROKEN)
		add_overlay("firex")
		set_light(0)
	else if(stat & NOPOWER)
		add_overlay("firep")
		set_light(0)
	else
		var/area/A = get_area(src)
		if(A.fire)
			add_overlay("fire1")
			set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = COLOR_RED)
		else
			add_overlay("fire0")
			set_light(0)

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, temperature, volume)
	if(src.detecting)
		if(temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/bullet_act()
	return src.alarm()

/obj/machinery/firealarm/emp_act(severity)
	. = ..()

	if(prob(50/severity))
		alarm(rand(30/severity, 60/severity))

/obj/machinery/firealarm/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)
	else
		return TRUE

	if (attacking_item.isscrewdriver() && buildstage == 2)
		if(!wiresexposed)
			set_light(0)
		wiresexposed = !wiresexposed
		update_icon()
		return TRUE

	if(wiresexposed)
		set_light(0)
		switch(buildstage)
			if(2)
				if (attacking_item.ismultitool())
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message("<span class='notice'>\The [user] has reconnected [src]'s detecting unit!</span>", "<span class='notice'>You have reconnected [src]'s detecting unit.</span>")
					else
						user.visible_message("<span class='notice'>\The [user] has disconnected [src]'s detecting unit!</span>", "<span class='notice'>You have disconnected [src]'s detecting unit.</span>")
					return TRUE
				else if (attacking_item.iswirecutter())
					user.visible_message("<span class='notice'>\The [user] has cut the wires inside \the [src]!</span>", "<span class='notice'>You have cut the wires inside \the [src].</span>")
					new/obj/item/stack/cable_coil(get_turf(src), 5)
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					buildstage = 1
					update_icon()
					return TRUE
			if(1)
				if(attacking_item.iscoil())
					var/obj/item/stack/cable_coil/C = attacking_item
					if (C.use(5))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						buildstage = 2
					else
						to_chat(user, "<span class='warning'>You need 5 pieces of cable to wire \the [src].</span>")
					return TRUE
				else if(attacking_item.iscrowbar())
					to_chat(user, "You pry out the circuit!")
					attacking_item.play_tool_sound(get_turf(src), 50)
					spawn(20)
						var/obj/item/firealarm_electronics/circuit = new /obj/item/firealarm_electronics()
						circuit.forceMove(user.loc)
						buildstage = 0
						update_icon()
					return TRUE
			if(0)
				if(istype(attacking_item, /obj/item/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(attacking_item)
					buildstage = 1
					update_icon()
					return TRUE
				else if(attacking_item.iswrench())
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/fire_alarm(get_turf(user))
					attacking_item.play_tool_sound(get_turf(src), 50)
					qdel(src)
					return TRUE
		return TRUE

	src.alarm()

/obj/machinery/firealarm/process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	if(stat & (NOPOWER|BROKEN))
		return

	if(!timing)
		return PROCESS_KILL

	if(src.time <= 0)
		alarm()
		src.time = 0
		timing = FALSE
		. = PROCESS_KILL
	else
		src.time = src.time - ((world.timeofday - last_process) / 10)

	updateDialog()

	last_process = world.timeofday

/obj/machinery/firealarm/power_change()
	..()
	queue_icon_update()

/obj/machinery/firealarm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/ui_state/state = GLOB.default_state)
	var/data[0]
	data["alertLevel"] = get_security_level()
	data["time"] = src.time
	var/area/A = get_area(src)
	data["active"] = A.fire

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "firealarm.tmpl", "Fire Alarm", 325, 325, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if (buildstage != 2 || stat & (NOPOWER|BROKEN))
		return

	ui_interact(user)
	return

/obj/machinery/firealarm/Topic(href, href_list)
	..()

	if (href_list["state"] == "active")
		src.alarm()
	else if (href_list["state"] == "inactive")
		src.reset()
	if (href_list["tmr"] == "set")
		time = Clamp(input(usr, "Enter time delay", "Fire Alarm Delayed Activation", time) as num, 0, 600)
	else if (href_list["tmr"] == "start")
		src.timing = 1
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else if (href_list["tmr"] == "stop")
		src.timing = 0

/obj/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.clearAlarm(loc, FA)
		FA.soundloop.stop(FA)
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(var/duration = 0)
	if(!(src.working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.triggerAlarm(loc, FA, duration)
		FA.soundloop.start(FA)
	update_icon()
	return

/obj/machinery/firealarm/set_emergency_state(var/new_security_level)
	if(seclevel != new_security_level)
		seclevel = new_security_level

/obj/machinery/firealarm/Initialize(mapload, ndir = 0, building)
	. = ..(mapload, ndir)

	update_icon()

	if(isContactLevel(z))
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(set_security_level), (GLOB.security_level ? get_security_level() : "green"))

	soundloop = new(src, FALSE)

	var/area/A = get_area(src)
	RegisterSignal(A, COMSIG_AREA_FIRE_ALARM, TYPE_PROC_REF(/atom, update_icon))

	if(!mapload)
		set_pixel_offsets()

/obj/machinery/firealarm/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/firealarm/set_pixel_offsets()
	// Overwrite the mapped in values.
	pixel_x = ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? 22 : -22))
	pixel_y = ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? 32 : -17) : 0)

// Convenience subtypes for mappers.
/obj/machinery/firealarm/north
	dir = NORTH
	pixel_y = 32

/obj/machinery/firealarm/east
	dir = EAST
	pixel_x = 22

/obj/machinery/firealarm/west
	dir = WEST
	pixel_x = -22

/obj/machinery/firealarm/south
	dir = SOUTH
	pixel_y = -17

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/device.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)


/obj/machinery/firealarm/partyalarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"

/obj/machinery/firealarm/partyalarm/alarm(var/duration = 0)
	if (!( working ))
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	A.partyalert()
	return

/obj/machinery/firealarm/partyalarm/reset()
	if (!( working ))
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	A.partyreset()
	return

/obj/machinery/firealarm/partyalarm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/ui_state/state = GLOB.default_state)
	var/data[0]
	data["alertLevel"] = get_security_level()
	data["time"] = src.time
	var/area/A = get_area(src)
	data["active"] = A.party

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "partyalarm.tmpl", "PARTY ALARM", 325, 325, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
