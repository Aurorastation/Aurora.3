//renwicks: fictional unit to describe shield strength
//a small meteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light, medium and heavy damage, it will take a hit from all three

/obj/structure/machinery/shield_gen
	name = "bubble shield generator"
	desc = "Machine that generates an impenetrable field of energy when activated."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "generator0"
	density = TRUE
	use_power = POWER_USE_OFF	//doesn't use APC power
	req_one_access = list(ACCESS_CAPTAIN, ACCESS_SECURITY, ACCESS_ENGINE)
	/// Our owned energy field.
	var/datum/energy_field/energy_field
	/// If the machine is powered or not.
	var/powered = FALSE
	/// Whether the shield generator is active or not.
	var/active = FALSE
	/// ID lock.
	var/locked = FALSE
	/// Radius of the field.
	var/field_radius = 3
	/// Maximum field radius.
	var/max_field_radius = 100
	/// The shield capacitors attached to this shield generator.
	var/list/owned_capacitors = list()
	/// If this shield generator supports multi-z.
	var/multiz = TRUE
	///How much the manipulator rating increases the maximum field strengthen rate. This increases how fast the shield can strengthen, allowing it to recover faster.
	var/manipulator_bonus = 0.1 //Maximum recovery rate with base components is 0.5 renwicks per second, with maxed out manipulators it's 0.9 renwicks per second.
	///How much the capacitor rating increases the field conversion rate. This increases the efficiency of converting power into shield strength, decreasing all shield power costs.
	var/capacitor_bonus = 0.000005
	///How much the micro laser rating decreased the field dissipation rate. This reduces the amount of shield strength lost per tick, reducing the shield upkeep.
	var/micro_laser_bonus = 0.002

	component_types = list(
		/obj/item/circuitboard/shield_gen,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/subspace/transmitter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/obj/structure/machinery/shield_gen/Initialize()
	owned_capacitors = list()
	for(var/obj/structure/machinery/shield_capacitor/possible_cap in range(1, src)) //Attach nearby capacitors
		attach_capacitor(possible_cap)
	energy_field = new(src, get_shielded_turfs())
	. = ..()

/obj/structure/machinery/shield_gen/Destroy()
	for(var/obj/structure/machinery/shield_capacitor/cap in owned_capacitors) //Detach any owned capacitors
		detach_capacitor(cap)
	owned_capacitors = list()
	return ..()

/obj/structure/machinery/shield_gen/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>manipulators</b> will increase the maximum field strengthen rate."
	. += SPAN_NOTICE("\t- The current maximum field strengthen rate is <b>[energy_field.max_strengthen_rate]</b> renwicks per second.")
	. += "Upgraded <b>capacitors</b> will increase the field conversion rate."
	. += SPAN_NOTICE("\t- The current field conversion efficiency increase is: <b>[(initial(energy_field.energy_conversion_rate) + (2 * capacitor_bonus)) / energy_field.energy_conversion_rate * 100]%</b>")
	. += "Upgraded <b>micro lasers</b> will decrease the energy field dispersion rate."
	. += SPAN_NOTICE("\t- The current field dissipation rate decrease is: <b>[(initial(energy_field.dissipation_rate) - (2 * micro_laser_bonus)) / energy_field.dissipation_rate * 100]%</b>")


/obj/structure/machinery/shield_gen/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()

	spark(src, 5, GLOB.alldirs)

/obj/structure/machinery/shield_gen/attackby(obj/item/attacking_item, mob/user)
	if(default_part_replacement(user, attacking_item))
		return TRUE
	else if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	else if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE

	if(istype(attacking_item, /obj/item/card/id))
		if(allowed(user))
			locked = !locked
			to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, SPAN_ALERT("Access denied."))
	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor":"unbolted from the floor"] by \the [user]."))

		if(active)
			toggle()
		if(anchored)
			// Attach nearby capacitors wrenching down the shield
			owned_capacitors = list()
			for(var/obj/structure/machinery/shield_capacitor/cap in range(1, src))
				attach_capacitor(cap)
		else
			// Detach any owned capacitors when unwrenching
			for(var/obj/structure/machinery/shield_capacitor/cap in owned_capacitors)
				detach_capacitor(cap)
			owned_capacitors = list()
	else
		..()

/obj/structure/machinery/shield_gen/RefreshParts()
	..()
	var/max_strengthen_rate_increase = 0
	var/energy_conversion_rate_increase = 0
	var/dissipation_rate_decrease = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismanipulator(P))
			max_strengthen_rate_increase += P.rating
		else if(iscapacitor(P))
			energy_conversion_rate_increase += P.rating
		else if(ismicrolaser(P))
			dissipation_rate_decrease += P.rating

	if(energy_field)
		energy_field.max_strengthen_rate = initial(energy_field.max_strengthen_rate) + (max_strengthen_rate_increase * manipulator_bonus)
		energy_field.energy_conversion_rate = initial(energy_field.energy_conversion_rate) + (energy_conversion_rate_increase * capacitor_bonus)
		energy_field.dissipation_rate = max(0, initial(energy_field.dissipation_rate) - (dissipation_rate_decrease * micro_laser_bonus))
		energy_field.strengthen_rate = min(energy_field.strengthen_rate, energy_field.max_strengthen_rate) ///If the strengthen rate got decreased and the current strengthen rate is now above the max, reduce it to the max.

/obj/structure/machinery/shield_gen/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/structure/machinery/shield_gen/attack_hand(mob/user)
	. = ..()
	if(stat & BROKEN)
		return
	interact(user)

/obj/structure/machinery/shield_gen/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return
	else
		for(var/obj/structure/machinery/shield_capacitor/cap in owned_capacitors) //Make sure the capacitors weren't blown up
			if(!(cap in range(1, src)) || get_dir(cap, src) != cap.dir || !cap.anchored)
				if(cap && cap.owned_gen == src)
					cap.owned_gen = null
				owned_capacitors -= cap
	if(!owned_capacitors || owned_capacitors.len == 0) // Try to attach any valid adjacent capacitors
		for(var/obj/structure/machinery/shield_capacitor/cap in range(1, src))
			attach_capacitor(cap)
	return ui_interact(user)

/obj/structure/machinery/shield_gen/proc/attach_capacitor(obj/structure/machinery/shield_capacitor/cap)
	if(!cap || cap.owned_gen || !cap.anchored)
		return FALSE
	if(!(cap in range(1, src)) || get_dir(cap, src) != cap.dir)
		return FALSE
	if(!owned_capacitors)
		owned_capacitors = list()
	owned_capacitors += cap
	cap.owned_gen = src
	updateDialog()
	return TRUE

/obj/structure/machinery/shield_gen/proc/detach_capacitor(obj/structure/machinery/shield_capacitor/cap)
	if(!cap)
		return FALSE
	if(owned_capacitors && (cap in owned_capacitors))
		owned_capacitors -= cap
	if(cap.owned_gen == src)
		cap.owned_gen = null
	updateDialog()
	return TRUE

/obj/structure/machinery/shield_gen/process()
	if(active)
		if(!anchored)
			toggle()
		if(stat & BROKEN)
			toggle()
			return PROCESS_KILL

	if(istype(energy_field))
		var/required_energy = energy_field.get_required_energy()
		var/assumed_charge = assume_charge(required_energy)
		energy_field.handle_strength(assumed_charge)

/**
 * Called whenever the field needs to take charge from attached capacitors.
 */
/obj/structure/machinery/shield_gen/proc/assume_charge(required_energy)
	if(!owned_capacitors || owned_capacitors.len == 0)
		return 0
	var/list/active_capacitors = list()
	var/available_charge = 0
	for(var/obj/structure/machinery/shield_capacitor/cap in owned_capacitors) //Loop through capacitors that can provide charge
		if(!cap || !cap.active || cap.stored_charge <= 0)
			continue
		active_capacitors += cap
		available_charge += cap.stored_charge

	if(!active_capacitors.len || available_charge <= 0) //If we have no capacitors, or they're not charged stop
		return 0

	var/assumed_charge = min(available_charge, required_energy)
	if(assumed_charge >= available_charge)
		for(var/obj/structure/machinery/shield_capacitor/cap in active_capacitors)
			cap.stored_charge = 0
		return assumed_charge

	var/remaining = assumed_charge
	for(var/i = 1, i <= active_capacitors.len, i++)
		var/obj/structure/machinery/shield_capacitor/cap = active_capacitors[i]
		var/took = (i == active_capacitors.len) ? remaining : round(assumed_charge * (cap.stored_charge / available_charge))
		took = min(took, cap.stored_charge, remaining)
		if(took <= 0)
			continue
		cap.stored_charge -= took
		remaining -= took
		if(remaining <= 0)
			break

	return assumed_charge - remaining

/obj/structure/machinery/shield_gen/ex_act(var/severity)
	if(active)
		toggle()
	return ..()

/obj/structure/machinery/shield_gen/proc/toggle()
	if(!active)
		if(!owned_capacitors || owned_capacitors.len == 0)
			balloon_alert_to_viewers("no capacitor")
			return
		else
			var/has_active = FALSE
			for(var/obj/structure/machinery/shield_capacitor/cap in owned_capacitors)
				if(cap && cap.active)
					has_active = TRUE
					break
			if(!has_active)
				balloon_alert_to_viewers("capacitors offline")
				return
	active = !active
	update_icon()
	if(active)
		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, SPAN_NOTICE("[icon2html(src, M)] You hear heavy droning start up."))
			energy_field.set_shielded_turfs(get_shielded_turfs())
	else
		for(var/mob/M as anything in hearers(5,src))
			to_chat(M, SPAN_NOTICE("[icon2html(src, M)] You hear heavy droning fade out."))
			energy_field.clear_field()

/obj/structure/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if (active)
			icon_state = "generator1"
		else
			icon_state = "generator0"

//grab the border tiles in a square around this machine
/obj/structure/machinery/shield_gen/proc/get_shielded_turfs()
	var/turf/T = get_turf(src)
	. = list()

	if(field_radius > 0 && T)
		var/connected_levels = list(T.z)
		if(multiz)
			for(var/turf/connected_z_turf as anything in (getzabove(T) + getzbelow(T)))
				connected_levels += connected_z_turf.z

		. += block(\
			locate(T.x - field_radius, T.y + field_radius, min(connected_levels)),\
			locate(T.x + field_radius - 1, T.y + field_radius, max(connected_levels))\
			)

		. += block(\
			locate(T.x + field_radius, T.y - field_radius, min(connected_levels)),\
			locate(T.x - field_radius + 1, T.y - field_radius, max(connected_levels))\
		)

		. += block(\
			locate(T.x - field_radius, T.y + field_radius - 1, min(connected_levels)),\
			locate(T.x - field_radius, T.y - field_radius, max(connected_levels))\
			)

		. += block(\
			locate(T.x + field_radius, T.y + field_radius, min(connected_levels)),\
			locate(T.x + field_radius, T.y - field_radius + 1, max(connected_levels))\
			)

	return . - get_turf(src)

/obj/structure/machinery/shield_gen/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldGenerator", "Shield Generator", 480, 400)
		ui.open()

/obj/structure/machinery/shield_gen/ui_data(mob/user)
	var/list/data = list()

	data["owned_capacitor"] = length(owned_capacitors)
	data["owned_capacitor_count"] = length(owned_capacitors)
	data["active"] = active
	data["time_since_fail"] = energy_field ? energy_field.time_since_fail : 0
	data["multiz"] = multiz
	data["field_radius"] = field_radius
	data["min_field_radius"] = 1
	data["max_field_radius"] = max_field_radius
	data = energy_field.add_field_ui_data(data)

	return data

/obj/structure/machinery/shield_gen/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			toggle()

		if("multiz")
			multiz = !multiz

		if ("size_set")
			field_radius = between(1, text2num(params["size_set"]), max_field_radius)

		if ("charge_set")
			energy_field.strengthen_rate = (between(1, text2num(params["charge_set"]), (energy_field.max_strengthen_rate * 10)) / 10)

		if ("field_set")
			energy_field.target_field_strength = between(1, text2num(params["field_set"]), 10)

	add_fingerprint(usr)

/obj/structure/machinery/shield_gen/proc/getzabove(var/turf/location)
	var/connected = list()
	var/turf/above = GET_TURF_ABOVE(location)

	if(above)
		connected += above
		var/connected_levels = getzabove(above)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected

/obj/structure/machinery/shield_gen/proc/getzbelow(var/turf/location)
	var/connected = list()
	var/turf/below = GET_TURF_BELOW(location)

	if(below)
		connected += below
		var/connected_levels = getzbelow(below)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected
