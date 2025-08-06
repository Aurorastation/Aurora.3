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
	power_channel = AREA_USAGE_ENVIRON
	var/last_process = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone
	var/seclevel
	///looping sound datum for our fire alarm siren.
	var/datum/looping_sound/firealarm/soundloop

/obj/machinery/firealarm/Initialize(mapload, var/dir, var/building = 0)
	. = ..(mapload)

	if(building)
		if(dir)
			src.set_dir(dir)
		buildstage = 0
		panel_open = 1

		update_icon()
		set_pixel_offsets()

	if(isContactLevel(z))
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(set_security_level), (GLOB.security_level ? get_security_level() : "green"))

	soundloop = new(src, FALSE)

	var/area/A = get_area(src)
	RegisterSignal(A, COMSIG_AREA_FIRE_ALARM, TYPE_PROC_REF(/atom, update_icon))

	if(!mapload)
		set_pixel_offsets()

	update_icon()

/obj/machinery/firealarm/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/firealarm/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if((stat & (NOPOWER|BROKEN)) || buildstage != 2)
		return

	. += "The current alert level is [get_security_level()]."

/obj/machinery/firealarm/update_icon()
	ClearOverlays()

	if(panel_open)
		switch(buildstage)
			if(2)
				AddOverlays("fire_b2")
			if(1)
				AddOverlays("fire_b1")
			if(0)
				AddOverlays("fire_b0")
		return

	if(stat & BROKEN)
		AddOverlays("firex")
		set_light(0)
	else if(stat & NOPOWER)
		AddOverlays("firep")
		set_light(0)
	else
		var/area/A = get_area(src)
		if(A.fire)
			AddOverlays("fire1")
			set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = COLOR_RED)
		else
			AddOverlays("fire0")
			set_light(0)

/obj/machinery/firealarm/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	if(src.detecting)
		if(exposed_temperature > T0C+200)
			src.alarm()			// added check of detector status here

/obj/machinery/firealarm/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	src.alarm()

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
		if(!panel_open)
			set_light(0)
		panel_open = !panel_open
		update_icon()
		return TRUE

	if(panel_open)
		set_light(0)
		switch(buildstage)
			if(2)
				if (attacking_item.ismultitool())
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message(SPAN_NOTICE("\The [user] has reconnected [src]'s detecting unit!"),
												SPAN_NOTICE("You have reconnected [src]'s detecting unit."))

					else
						user.visible_message(SPAN_NOTICE("\The [user] has disconnected [src]'s detecting unit!"),
												SPAN_NOTICE("You have disconnected [src]'s detecting unit."))

					return TRUE
				else if (attacking_item.iswirecutter())
					user.visible_message(SPAN_NOTICE("\The [user] has cut the wires inside \the [src]!"),
											SPAN_NOTICE("You have cut the wires inside \the [src]."))

					new/obj/item/stack/cable_coil(get_turf(src), 5)
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					buildstage = 1
					update_icon()
					return TRUE
			if(1)
				if(attacking_item.iscoil())
					var/obj/item/stack/cable_coil/C = attacking_item
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You wire \the [src]."))
						buildstage = 2
					else
						to_chat(user, SPAN_WARNING("You need 5 pieces of cable to wire \the [src]."))
					return TRUE
				else if(attacking_item.iscrowbar())
					to_chat(user, "You pry out the circuit!")
					attacking_item.play_tool_sound(get_turf(src), 50)
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

/obj/machinery/firealarm/process(seconds_per_tick)//Note: this processing was mostly phased out due to other code, and only runs when needed
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
		src.time = src.time - (((world.timeofday - last_process) / 10) * seconds_per_tick)

	last_process = world.timeofday

/obj/machinery/firealarm/power_change()
	..()
	queue_icon_update()

/obj/machinery/firealarm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FireAlarm")
		ui.open()

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if (buildstage != 2 || stat & (NOPOWER|BROKEN))
		return

	if(user.a_intent != I_HURT)
		ui_interact(user)
	else
		alarm()

/obj/machinery/firealarm/ui_data(mob/user)
	var/list/data = list()

	data["alertLevel"] = get_security_level()
	data["time"] = src.time

	var/area/A = get_area(src)
	data["active"] = A.fire

	data["timing"] = src.timing

	return data

/obj/machinery/firealarm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate_alarm")
			src.alarm()
		if("reset_alarm")
			src.reset()
		if("set_timer")
			var/input_time = text2num(params["set_timer"])
			if(!isnum(input_time))
				return

			time = clamp(input_time SECONDS, 1, 600)

		if("start_timer")
			src.timing = 1
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		if("stop_timer")
			src.timing = 0

	return TRUE

/obj/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		GLOB.fire_alarm.clearAlarm(loc, FA)
		FA.soundloop.stop(FA)
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(var/duration = 0)
	if(!(src.working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		GLOB.fire_alarm.triggerAlarm(loc, FA, duration)
		FA.soundloop.start(FA)
	update_icon()
	return

/obj/machinery/firealarm/set_emergency_state(var/new_security_level)
	if(seclevel != new_security_level)
		seclevel = new_security_level

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
	icon = 'icons/obj/module.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = WEIGHT_CLASS_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
