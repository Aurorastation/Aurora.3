/obj/machinery/power/am_control_unit
	name = "antimatter control unit"
	desc = "The control unit for an antimatter reactor. Probably safe."
	desc_info = "Use a wrench to attach the control unit to the ground, then arrange the reactor sections nearby. Reactor sections can only be activated if they are near the control unit, but otherwise are not restricted in how they must be placed."
	desc_antag = "The antimatter engine will quickly destabilize if the fuel injection rate is set too high, causing a large explosion."
	icon = 'icons/obj/machinery/new_ame.dmi'
	icon_state = "control"
	var/icon_mod = "on" // on, critical, or fuck
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 1000

	var/list/obj/machinery/am_shielding/linked_shielding
	var/list/obj/machinery/am_shielding/linked_cores
	var/obj/item/am_containment/fueljar
	var/update_shield_icons = FALSE
	var/stability = 100
	var/exploding = FALSE
	var/exploded = FALSE

	var/active = FALSE				//On or not
	var/fuel_injection = 2			//How much fuel to inject
	var/shield_icon_delay = FALSE	//delays resetting for a short time
	var/reported_core_efficiency = 0

	var/power_cycle = 0
	var/power_cycle_delay = 4		//How many ticks till produce_power is called
	var/stored_core_stability = 0
	var/stored_core_stability_delay = 0

	var/stored_power = 0			//Power to deploy per tick

/obj/machinery/power/am_control_unit/Destroy()//Perhaps damage and run stability checks rather than just del on the others
	for(var/obj/machinery/am_shielding/AMS in linked_shielding)
		AMS.control_unit = null
		qdel(AMS)
	for(var/obj/machinery/am_shielding/AMS in linked_cores)
		AMS.control_unit = null
		qdel(AMS)

	QDEL_NULL(fueljar)
	return ..()

/obj/machinery/power/am_control_unit/process()
	if(exploding && !exploded)
		message_admins("AME explosion at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) - Last touched by [fingerprintslast]",0,1)
		exploded=1
		explosion(get_turf(src),8,10,12,15)
		if(src)
			qdel(src)

	if(update_shield_icons && !shield_icon_delay)
		check_shield_icons()
		update_shield_icons = 0

	if(stat & (NOPOWER|BROKEN) || !active)//can update the icons even without power
		return

	if(!fueljar)//No fuel but we are on, shutdown
		toggle_power()
		//Angry buzz or such here
		return

	check_core_stability()

	add_avail(stored_power)

	power_cycle++
	if(power_cycle >= power_cycle_delay)
		produce_power()
		power_cycle = 0

/obj/machinery/power/am_control_unit/proc/produce_power()
	playsound(get_turf(src), 'sound/effects/air_seal.ogg', 25, TRUE)
	for(var/thing in linked_cores)
		flick("core2", thing)
	if(reported_core_efficiency <= 0)
		return FALSE //Something is wrong
	var/core_damage = 0
	var/fuel = fueljar.usefuel(fuel_injection)

	stored_power = fuel * AM_POWER_FACTOR
	// Now check if the cores could deal with it safely, this is done after so you can overload for more power if needed, still a bad idea
	if(fuel > (2 * reported_core_efficiency))	//More fuel has been put in than the current cores can deal with
		if(prob(50))
			core_damage = 1	//Small chance of damage
		if((fuel - reported_core_efficiency) > 5)
			core_damage = 5	//Now its really starting to overload the cores
		if((fuel - reported_core_efficiency) > 10)
			core_damage = 20	//Welp now you did it, they wont stand much of this
		if(core_damage == 0)
			return
		for(var/obj/machinery/am_shielding/AMS in linked_cores)
			AMS.stability -= core_damage
			AMS.check_stability(TRUE)
		playsound(get_turf(src), 'sound/effects/bang.ogg', 50, 1)

/obj/machinery/power/am_control_unit/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			if(active)
				toggle_power()
			stability -= rand(15, 30)
		if(EMP_LIGHT)
			if(active)
				toggle_power()
			stability -= rand(10, 20)
	check_stability()

/obj/machinery/power/am_control_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			stability -= 60
		if(2.0)
			stability -= 40
		if(3.0)
			stability -= 20
	check_stability()

/obj/machinery/power/am_control_unit/power_change()
	..()
	if(stat & NOPOWER && active)
		toggle_power()

/obj/machinery/power/am_control_unit/update_icon()
	if(active)
		icon_state = "control_[icon_mod]"
	else
		icon_state = "control"

/obj/machinery/power/am_control_unit/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(!anchored)
			attacking_item.play_tool_sound(get_turf(src), 75)
			user.visible_message("<b>[user.name]</b> secures \the [src] to the floor.", \
				SPAN_NOTICE("You secure the anchor bolts to the floor."), \
				SPAN_NOTICE("You hear a ratcheting noise."))
			anchored = TRUE
			update_shield_icons = 2
			check_shield_icons()
			connect_to_network()
		else if(!LAZYLEN(linked_shielding))
			attacking_item.play_tool_sound(get_turf(src), 75)
			user.visible_message("<b>[user]</b> unsecures \the [src].", \
				SPAN_NOTICE("You remove the anchor bolts."), \
				SPAN_NOTICE("You hear a ratcheting noise."))
			anchored = FALSE
			disconnect_from_network()
		else
			to_chat(user, SPAN_WARNING("Once bolted and linked to a shielding unit it \the [src] is unable to be moved!"))
		return

	if(istype(attacking_item, /obj/item/am_containment))
		if(fueljar)
			to_chat(user, SPAN_WARNING("There is already \a [fueljar] loaded!"))
			return
		fueljar = attacking_item
		user.drop_from_inventory(attacking_item, src)
		message_admins("AME loaded with fuel by [user.real_name] ([user.key]) at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		user.visible_message("<b>[user]</b> loads \the [attacking_item] into \the [src].",
							SPAN_NOTICE("You load \the [attacking_item] into \the [src]."),
							SPAN_NOTICE("You hear a thunk."))
		return

	if(attacking_item.force >= 20)
		user.do_attack_animation(src, attacking_item)
		stability -= attacking_item.force / 2
		check_stability()
		return ..()

/obj/machinery/power/am_control_unit/attack_hand(mob/user)
	if(anchored)
		interact(user)

/obj/machinery/power/am_control_unit/proc/add_shielding(var/obj/machinery/am_shielding/AMS, var/AMS_linking = 0)
	if(!istype(AMS))
		return FALSE
	if(!anchored)
		return FALSE
	if(!AMS_linking && !AMS.link_control(src))
		return FALSE
	LAZYDISTINCTADD(linked_shielding, AMS)
	update_shield_icons = 1
	return TRUE

/obj/machinery/power/am_control_unit/proc/remove_shielding(var/obj/machinery/am_shielding/AMS)
	if(!istype(AMS))
		return FALSE
	LAZYREMOVE(linked_shielding, AMS)
	update_shield_icons = 2
	if(active)
		toggle_power()
	return TRUE

/obj/machinery/power/am_control_unit/proc/check_stability()//TODO: make it break when low also might want to add a way to fix it like a part or such that can be replaced
	if(stability <= 0)
		qdel(src)

/obj/machinery/power/am_control_unit/toggle_power()
	active = !active
	if(active)
		update_use_power(POWER_USE_ACTIVE)
		visible_message(SPAN_NOTICE("\The [src] starts up."))
	else
		update_use_power(POWER_USE_IDLE)
		visible_message(SPAN_NOTICE("\The [src] shuts down."))
	for(var/obj/machinery/am_shielding/AMS in linked_cores)
		AMS.update_icon()
	update_icon()

/obj/machinery/power/am_control_unit/proc/check_shield_icons()//Forces icon_update for all shields
	if(shield_icon_delay)
		return
	shield_icon_delay = TRUE
	if(update_shield_icons == 2)//2 means to clear everything and rebuild
		for(var/obj/machinery/am_shielding/neighbor in cardinalrange(loc))
			if(!neighbor.control_unit)
				LAZYADD(linked_shielding, neighbor)
		for(var/obj/machinery/am_shielding/AMS in linked_shielding)
			if(AMS.processing)
				AMS.shutdown_core()
			AMS.control_unit = null
			addtimer(CALLBACK(src, PROC_REF(ams_do_scan), AMS), 1 SECOND)
		LAZYCLEARLIST(linked_shielding)
	else
		for(var/obj/machinery/am_shielding/AMS in linked_shielding)
			AMS.update_icon()
	addtimer(CALLBACK(src, PROC_REF(clear_shield_icon_delay)), 2 SECONDS)

/obj/machinery/power/am_control_unit/proc/ams_do_scan(var/obj/machinery/am_shielding/AMS)
	AMS.controllerscan()
	AMS.assimilate()

/obj/machinery/power/am_control_unit/proc/clear_shield_icon_delay()
	shield_icon_delay = FALSE

/obj/machinery/power/am_control_unit/proc/check_core_stability()
	if(!LAZYLEN(linked_cores))
		return
	stored_core_stability = 0
	for(var/thing in linked_cores)
		var/obj/machinery/am_shielding/AMS = thing
		if(QDELETED(AMS))
			continue
		stored_core_stability += AMS.stability
	stored_core_stability /= LAZYLEN(linked_cores)
	switch(stored_core_stability)
		if(0 to 24)
			icon_mod = "fuck"
		if(25 to 49)
			icon_mod = "critical"
		if(50 to INFINITY)
			icon_mod = "on"
	update_icon()

/obj/machinery/power/am_control_unit/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
		if(!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=AMcontrol")
			return
	return ui_interact(user)

/obj/machinery/power/am_control_unit/ui_interact(mob/user, ui_key = "main")
	if(!user)
		return

	var/list/fueljar_data = null
	if(fueljar)
		fueljar_data = list(
			"fuel" = fueljar.fuel,
			"fuel_max" = initial(fueljar.fuel),
			"injecting" = fuel_injection
		)

	var/list/data = list(
		"active" = active,
		"linked_shields" = LAZYLEN(linked_shielding),
		"linked_cores" = LAZYLEN(linked_cores),
		"efficiency" = reported_core_efficiency,
		"stability" = stored_core_stability,
		"stored_power" = stored_power,
		"fueljar" = fueljar_data,
		"siliconUser" = issilicon(user)
	)

	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, ui_key)
	if (!ui)
		// the ui does not exist, so we'll create a new one
		ui = new(user, src, ui_key, "ame.tmpl", "Antimatter Control Unit", 500, data["siliconUser"] ? 465 : 390)
		// When the UI is first opened this is the data it will use
		ui.set_initial_data(data)
		ui.open()
		// Auto update every Master Controller tick
		ui.set_auto_update(TRUE)
	else
		// The UI is already open so push the new data to it
		ui.push_data(data)


/obj/machinery/power/am_control_unit/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["close"])
		if(usr.machine == src)
			usr.unset_machine()
		return TRUE
	//Ignore input if we are broken or guy is not touching us, AI can control from a ways away
	if(stat & (BROKEN|NOPOWER))
		usr.unset_machine()
		usr << browse(null, "window=AMcontrol")
		return

	if(href_list["close"])
		usr << browse(null, "window=AMcontrol")
		usr.unset_machine()
		return

	if(href_list["togglestatus"])
		toggle_power()
		message_admins("AME toggled [active?"on":"off"] by [usr.real_name] ([usr.key]) at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		return TRUE

	if(href_list["refreshicons"])
		update_shield_icons = 2 // Fuck it
		return TRUE

	if(href_list["ejectjar"])
		if(fueljar)
			message_admins("AME fuel jar ejected by [usr.real_name] ([usr.key]) at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			fueljar.forceMove(src.loc)
			fueljar = null
			//fueljar.control_unit = null currently it does not care where it is
			//update_icon() when we have the icon for it
		return TRUE

	if(href_list["set_strength"])
		var/newval = input("Enter new injection strength") as num|null
		if(isnull(newval))
			return
		fuel_injection = newval
		fuel_injection = max(1, fuel_injection)
		message_admins("AME injection strength set to [fuel_injection] by [usr.real_name] ([usr.key]) at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		return TRUE

	if(href_list["refreshstability"])
		check_core_stability()
		return TRUE

	updateDialog()
	return TRUE
