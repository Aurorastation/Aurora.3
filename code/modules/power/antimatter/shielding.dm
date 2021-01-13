//like orange but only checks north/south/east/west for one step
proc/cardinalrange(var/center)
	var/list/things = list()
	for(var/direction in cardinal)
		var/turf/T = get_step(center, direction)
		if(!T)
			continue
		things += T.contents
	return things

/obj/machinery/am_shielding
	name = "antimatter reactor section"
	desc = "A shielding component for an antimatter reactor. Looks delicate."
	desc_info = "Antimatter shielding sections must be beside an anchored control unit or another shielding section. If either are destroyed, the section will disappear."
	desc_antag = "Antimatter shielding sections are delicate. Attacking the shielding unit with a damaging object will reduce its stability, as will explosions. If the stability hits zero, the reactor may explode."
	icon = 'icons/obj/machines/new_ame.dmi'
	icon_state = "shield"
	anchored = TRUE
	density = TRUE
	dir = NORTH
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

	var/obj/machinery/power/am_control_unit/control_unit = null
	var/processing = FALSE	//To track if we are in the update list or not, we need to be when we are damaged and if we ever
	var/stability = 100		//If this gets low bad things tend to happen
	var/efficiency = 1		//How many cores this core counts for when doing power processing, phoron in the air and stability could affect this
	var/coredirs = 0
	var/dirs = 0
	var/mapped = FALSE		//Set to 1 to ignore usual suicide if it doesn't immediately find a control_unit

// Stupidly easy way to use it in maps
/obj/machinery/am_shielding/map
	mapped = TRUE

/obj/machinery/am_shielding/Initialize(mapload, var/obj/machinery/power/am_control_unit/AMC)
	..()
	if(!AMC)
		if (!mapped)
			WARNING("AME sector somehow created without a parent control unit!")
		controllerscan()
		return
	link_control(AMC)
	remove_machine(src, FALSE)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/am_shielding/LateInitialize()
	update_icon()

/obj/machinery/am_shielding/proc/link_control(var/obj/machinery/power/am_control_unit/AMC)
	if(!istype(AMC))
		return FALSE
	if(control_unit && control_unit != AMC)
		return FALSE // already have one
	control_unit = AMC
	return control_unit.add_shielding(src, TRUE)

/obj/machinery/am_shielding/Destroy()
	if(control_unit)
		control_unit.remove_shielding(src)
	if(processing)
		shutdown_core()
	visible_message(SPAN_WARNING("\The [src] melts!"))
	// Might want to have it leave a mess on the floor but no sprites for now
	return ..()

/obj/machinery/am_shielding/proc/controllerscan(var/priorscan = FALSE)
	//Make sure we are the only one here
	if(!isturf(loc))
		qdel(src)
		return
	for(var/obj/machinery/am_shielding/AMS in loc.contents - src)
		qdel(src)
		return

	//Search for shielding first
	for(var/obj/machinery/am_shielding/AMS in cardinalrange(src))
		if(AMS && AMS.control_unit && link_control(AMS.control_unit))
			break

	if(!control_unit)//No other guys nearby, look for a control unit
		for(var/obj/machinery/power/am_control_unit/AMC in cardinalrange(src))
			if(AMC.add_shielding(src))
				break
		if(!mapped) // Prevent rescanning and suicide if it's part of the map
			if(!priorscan)
				sleep(20)
				controllerscan(TRUE)//Last chance
				return
			qdel(src)

// Find surrounding unconnected shielding and add them to our controller
/obj/machinery/am_shielding/proc/assimilate()
	if(!control_unit)
		return // nothing to share :'^[
	for(var/obj/machinery/am_shielding/neighbor in cardinalrange(src))
		if(neighbor && !neighbor.control_unit)
			neighbor.link_control(control_unit)
			neighbor.assimilate() // recursion is fun, right?

/obj/machinery/am_shielding/Cross(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(air_group || (height==0))
		return TRUE
	return FALSE

/obj/machinery/am_shielding/machinery_process()
	if(!processing)
		. = PROCESS_KILL
	//TODO: core functions and stability
	//TODO: think about checking the airmix for phoron and increasing power output


/obj/machinery/am_shielding/emp_act()//Immune due to not really much in the way of electronics.
	return FALSE

/obj/machinery/am_shielding/ex_act(severity)
	switch(severity)
		if(1.0)
			stability -= 80
		if(2.0)
			stability -= 40
		if(3.0)
			stability -= 20
	check_stability()

/obj/machinery/am_shielding/update_icon()
	cut_overlays()
	coredirs = 0
	dirs = 0
	for(var/direction in alldirs)
		var/turf/T = get_step(loc, direction)
		for(var/obj/machinery/machine in T)
			// Detect cores
			if(istype(machine, /obj/machinery/am_shielding))
				var/obj/machinery/am_shielding/AMS = machine
				if(AMS.control_unit == control_unit && AMS.processing)
					coredirs |= direction

			// Detect cores, shielding, and control boxen.
			if(direction in cardinal)
				if(istype(machine, /obj/machinery/am_shielding))
					var/obj/machinery/am_shielding/AMS = machine
					if(AMS.control_unit == control_unit)
						dirs |= direction
				else if(istype(machine, /obj/machinery/power/am_control_unit))
					var/obj/machinery/power/am_control_unit/AMCU = machine
					if(AMCU == control_unit)
						dirs |= direction

	var/is_core = core_check()

	// Set our overlay
	if(!is_core)
		icon_state = "shield_[dirs]"
	if(is_core)
		icon_state = "core[control_unit && control_unit.active]"
		if(!processing)
			setup_core()
	else if(processing)
		shutdown_core()

/obj/machinery/am_shielding/attackby(obj/item/W, mob/user)
	if(!istype(W) || !user)
		return
	if(W.force > 10)
		user.do_attack_animation(src, W)
		stability -= W.force / 2
		check_stability()
		return ..()

//Scans cards for shields or the control unit and if all there it
/obj/machinery/am_shielding/proc/core_check()
	for(var/direction in alldirs)
		var/found_am_device = FALSE
		for(var/obj/machinery/machine in get_step(loc, direction))
			if(!machine)
				continue
			if(istype(machine, /obj/machinery/am_shielding) || istype(machine, /obj/machinery/power/am_control_unit))
				found_am_device = TRUE
				break
		if(!found_am_device)
			return FALSE
	return TRUE

/obj/machinery/am_shielding/proc/setup_core()
	processing = TRUE
	if(!control_unit)
		return
	LAZYADD(control_unit.linked_cores, src)
	control_unit.reported_core_efficiency += efficiency

/obj/machinery/am_shielding/proc/shutdown_core()
	processing = 0
	if(!control_unit)
		return
	LAZYREMOVE(control_unit.linked_cores, src)
	control_unit.reported_core_efficiency -= efficiency

/obj/machinery/am_shielding/proc/check_stability(var/injecting_fuel = FALSE)
	if(stability > 0)
		return
	if(injecting_fuel && control_unit)
		control_unit.exploding = TRUE
	qdel(src)

/obj/machinery/am_shielding/proc/recalc_efficiency(var/new_efficiency)//tbh still not 100% sure how I want to deal with efficiency so this is likely temp
	if(!control_unit || !processing)
		return
	if(stability < 50)
		new_efficiency /= 2
	control_unit.reported_core_efficiency += (new_efficiency - efficiency)
	efficiency = new_efficiency

/obj/item/device/am_shielding_container
	name = "packaged antimatter reactor section"
	desc = "A section of antimatter reactor shielding. Do not eat."
	desc_info = "To deploy, drop near an antimatter control unit or an existing deployed section and use your multitool on it."
	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "box"
	item_state = "electronic"
	throwforce = 5
	throw_speed = 1
	throw_range = 2

/obj/item/device/am_shielding_container/attackby(var/obj/item/I, var/mob/user)
	if(I.ismultitool() && isturf(loc))
		if(locate(/obj/machinery/am_shielding) in loc)
			to_chat(user, SPAN_WARNING("There is already an antimatter reactor section there."))
			return

		//Search for shielding first
		for(var/obj/machinery/am_shielding/AMS in cardinalrange(src))
			if(AMS.control_unit)
				new /obj/machinery/am_shielding(loc, AMS.control_unit)
				qdel(src)
				return

		//No other guys nearby, look for a control unit
		var/obj/machinery/power/am_control_unit/AMC = locate() in cardinalrange(src)
		if(AMC?.anchored)
			new /obj/machinery/am_shielding(loc, AMC)
			qdel(src)
		else //Stranded & Alone
			to_chat(user, SPAN_WARNING("\The [src] couldn't connect to an Antimatter Control Unit."))
			return

	..()