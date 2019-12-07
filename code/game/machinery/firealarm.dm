/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	var/previous_state = 0
	var/previous_fire_state = FALSE
	var/detecting = 1
	var/working = 1
	var/time = 10
	var/timing = 0
	var/lockdownbyai = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone
	var/seclevel

/obj/machinery/firealarm/update_icon()
	cut_overlays()

	if(wiresexposed)
		switch(buildstage)
			if(2)
				icon_state="fire_b2"
			if(1)
				icon_state="fire_b1"
			if(0)
				icon_state="fire_b0"
		return

	if(stat & BROKEN)
		icon_state = "firex"
		set_light(0)
	else if(stat & NOPOWER)
		icon_state = "firep"
		set_light(0)
	else
		var/area/A = get_area(src)
		if(A.fire)
			icon_state = "fire1"
			set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = COLOR_RED)
		else
			icon_state = "fire0"
			switch(seclevel)
				if("green")
					previous_state = icon_state
					set_light(l_range = L_WALLMOUNT_RANGE, l_power = L_WALLMOUNT_POWER, l_color = LIGHT_COLOR_GREEN)
				if("blue")
					previous_state = icon_state
					set_light(l_range = L_WALLMOUNT_RANGE, l_power = L_WALLMOUNT_POWER, l_color = LIGHT_COLOR_BLUE)
				if("yellow")
					previous_state = icon_state
					set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = LIGHT_COLOR_YELLOW)
				if("red")
					previous_state = icon_state
					set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = LIGHT_COLOR_RED)
				if("delta")
					previous_state = icon_state
					set_light(l_range = L_WALLMOUNT_HI_RANGE, l_power = L_WALLMOUNT_HI_POWER, l_color = LIGHT_COLOR_ORANGE)

		add_overlay("overlay_[seclevel]")

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, temperature, volume)
	if(src.detecting)
		if(temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/bullet_act()
	return src.alarm()

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity))
		alarm(rand(30/severity, 60/severity))
	..()

/obj/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if (W.isscrewdriver() && buildstage == 2)
		if(!wiresexposed)
			set_light(0)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		set_light(0)
		switch(buildstage)
			if(2)
				if (W.ismultitool())
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message("<span class='notice'>\The [user] has reconnected [src]'s detecting unit!</span>", "<span class='notice'>You have reconnected [src]'s detecting unit.</span>")
					else
						user.visible_message("<span class='notice'>\The [user] has disconnected [src]'s detecting unit!</span>", "<span class='notice'>You have disconnected [src]'s detecting unit.</span>")
				else if (W.iswirecutter())
					user.visible_message("<span class='notice'>\The [user] has cut the wires inside \the [src]!</span>", "<span class='notice'>You have cut the wires inside \the [src].</span>")
					new/obj/item/stack/cable_coil(get_turf(src), 5)
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					buildstage = 1
					update_icon()
			if(1)
				if(W.iscoil())
					var/obj/item/stack/cable_coil/C = W
					if (C.use(5))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						buildstage = 2
						return
					else
						to_chat(user, "<span class='warning'>You need 5 pieces of cable to wire \the [src].</span>")
						return
				else if(W.iscrowbar())
					to_chat(user, "You pry out the circuit!")
					playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
					spawn(20)
						var/obj/item/firealarm_electronics/circuit = new /obj/item/firealarm_electronics()
						circuit.forceMove(user.loc)
						buildstage = 0
						update_icon()
			if(0)
				if(istype(W, /obj/item/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(W.iswrench())
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/fire_alarm(get_turf(user))
					playsound(src.loc, W.usesound, 50, 1)
					qdel(src)
		return

	src.alarm()
	return

/obj/machinery/firealarm/machinery_process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	var/area/A = get_area(src)
	if (A.fire != previous_fire_state)
		update_icon()
		previous_fire_state = A.fire

	if (stat != previous_state)
		update_icon()
		previous_state = stat

	if(stat & (NOPOWER|BROKEN))
		return

	if(src.timing)
		if(src.time > 0)
			src.time = src.time - ((world.timeofday - last_process)/10)
		else
			src.alarm()
			src.time = 0
			src.timing = 0
		src.updateDialog()
	last_process = world.timeofday

	if(locate(/obj/fire) in loc)
		alarm()

	return

/obj/machinery/firealarm/power_change()
	..()
	queue_icon_update()

/obj/machinery/firealarm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
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
		time = max(0, input(usr, "Enter time delay", "Fire Alarm Delayed Activation", time) as num)
	else if (href_list["tmr"] == "start")
		src.timing = 1
	else if (href_list["tmr"] == "stop")
		src.timing = 0

/obj/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.clearAlarm(loc, FA)
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(var/duration = 0)
	if (!( src.working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.triggerAlarm(loc, FA, duration)
		playsound(FA.loc, 'sound/ambience/firealarm.ogg', 75, 0)
	update_icon()
	return

/obj/machinery/firealarm/proc/set_security_level(var/newlevel)
	if(seclevel != newlevel)
		seclevel = newlevel
		update_icon()

/obj/machinery/firealarm/Initialize(mapload, ndir = 0, building)
	. = ..(mapload, ndir)

	if(building)
		buildstage = 0
		wiresexposed = 1
		icon_state = "fire_b0"

	// Overwrite the mapped in values.
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

	if(isContactLevel(z))
		set_security_level(security_level ? get_security_level() : "green")

// Convenience subtypes for mappers.
/obj/machinery/firealarm/north
	dir = NORTH
	pixel_y = 28

/obj/machinery/firealarm/east
	dir = EAST
	pixel_x = 28

/obj/machinery/firealarm/west
	dir = WEST
	pixel_x = -28

/obj/machinery/firealarm/south
	dir = SOUTH
	pixel_y = -28

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)


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

/obj/machinery/firealarm/partyalarm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
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
