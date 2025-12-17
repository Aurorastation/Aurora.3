//renwicks: fictional unit to describe shield strength
//a small meteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light, medium and heavy damage, it will take a hit from all three

/obj/machinery/shield_gen
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
	/// The shield capacitor attached to this shield generator.
	var/obj/machinery/shield_capacitor/owned_capacitor
	/// If this shield generator supports multi-z.
	var/multiz = TRUE

/obj/machinery/shield_gen/Initialize()
	for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
		if(get_dir(possible_cap, src) == possible_cap.dir)
			owned_capacitor = possible_cap
			break
	energy_field = new(src, get_shielded_turfs())
	. = ..()

/obj/machinery/shield_gen/Destroy()
	owned_capacitor = null
	return ..()

/obj/machinery/shield_gen/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()

	spark(src, 5, GLOB.alldirs)

/obj/machinery/shield_gen/attackby(obj/item/attacking_item, mob/user)
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
			for(var/obj/machinery/shield_capacitor/cap in range(1, src))
				if(cap.owned_gen)
					continue
				if(get_dir(cap, src) == cap.dir && cap.anchored)
					owned_capacitor = cap
					owned_capacitor.owned_gen = src
					break
		else
			if(owned_capacitor && owned_capacitor.owned_gen == src)
				owned_capacitor.owned_gen = null
			owned_capacitor = null
	else
		..()

/obj/machinery/shield_gen/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/shield_gen/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	interact(user)

/obj/machinery/shield_gen/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return
	else
		if(owned_capacitor)
			if(!((owned_capacitor in range(1, src)) && get_dir(owned_capacitor, src) == owned_capacitor.dir && owned_capacitor.anchored))
				if(owned_capacitor.owned_gen == src)
					owned_capacitor.owned_gen = null
				owned_capacitor = null
	if(!owned_capacitor)
		for(var/obj/machinery/shield_capacitor/cap in range(1, src))
			if(cap.owned_gen)
				continue
			if(get_dir(cap, src) == cap.dir && cap.anchored)
				owned_capacitor = cap
				owned_capacitor.owned_gen = src
				updateDialog()
				break
	return ui_interact(user)

/obj/machinery/shield_gen/process()
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
 * Called whenever the field needs to take charge from the capacitor.
 */
/obj/machinery/shield_gen/proc/assume_charge(required_energy)
	if(!owned_capacitor)
		return 0
	var/assumed_charge = min(owned_capacitor.stored_charge, required_energy)
	assumed_charge = max(assumed_charge, 0)
	owned_capacitor.stored_charge -= assumed_charge
	return assumed_charge

/obj/machinery/shield_gen/ex_act(var/severity)
	if(active)
		toggle()
	return ..()

/obj/machinery/shield_gen/proc/toggle()
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

/obj/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if (active)
			icon_state = "generator1"
		else
			icon_state = "generator0"

//grab the border tiles in a square around this machine
/obj/machinery/shield_gen/proc/get_shielded_turfs()
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

/obj/machinery/shield_gen/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldGenerator", "Shield Generator", 480, 400)
		ui.open()

/obj/machinery/shield_gen/ui_data(mob/user)
	var/list/data = list()

	data["owned_capacitor"] = !!owned_capacitor
	data["active"] = active
	data["time_since_fail"] = energy_field ? energy_field.time_since_fail : 0
	data["multiz"] = multiz
	data["field_radius"] = field_radius
	data["min_field_radius"] = 1
	data["max_field_radius"] = max_field_radius
	data = energy_field.add_field_ui_data(data)

	return data

/obj/machinery/shield_gen/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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

/obj/machinery/shield_gen/proc/getzabove(var/turf/location)
	var/connected = list()
	var/turf/above = GET_TURF_ABOVE(location)

	if(above)
		connected += above
		var/connected_levels = getzabove(above)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected

/obj/machinery/shield_gen/proc/getzbelow(var/turf/location)
	var/connected = list()
	var/turf/below = GET_TURF_BELOW(location)

	if(below)
		connected += below
		var/connected_levels = getzbelow(below)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected
