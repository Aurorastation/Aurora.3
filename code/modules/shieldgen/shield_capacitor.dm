/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "Machine that charges a shield generator."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "capacitor"
	obj_flags = OBJ_FLAG_ROTATABLE
	density = TRUE
	/// Doesn't use APC power.
	use_power = POWER_USE_OFF
	req_one_access = list(access_captain, access_security, access_engine)

	var/active = FALSE
	/// Not to be confused with power cell charge, this is in Joules.
	var/stored_charge = 0
	var/last_stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 8e6	//8 MJ
	var/max_charge_rate = 400000	//400 kW
	var/locked = FALSE

	var/charge_rate = 100000	//100 kW
	var/obj/machinery/shield_gen/owned_gen

/obj/machinery/shield_capacitor/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/shield_capacitor/LateInitialize()
	for(var/obj/machinery/shield_gen/possible_gen in range(1, src))
		if(get_dir(src, possible_gen) == dir)
			possible_gen.owned_capacitor = src
			break

/obj/machinery/shield_capacitor/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()
	spark(src, 5, alldirs)

/obj/machinery/shield_capacitor/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/card/id))
		if(allowed(user))
			locked = !locked
			to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, SPAN_ALERT("Access denied."))
	else if(W.iswrench())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by \the [user]."))

		if(anchored)
			for(var/obj/machinery/shield_gen/gen in range(1, src))
				if(get_dir(src, gen) == src.dir && !gen.owned_capacitor)
					owned_gen = gen
					owned_gen.owned_capacitor = src
					owned_gen.updateDialog()
		else
			if(owned_gen && owned_gen.owned_capacitor == src)
				owned_gen.owned_capacitor = null
			owned_gen = null
	else
		..()

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	ui_interact(user)

/obj/machinery/shield_capacitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldCapacitor", "Shield Capacitor", 400, 300)
		ui.open()

/obj/machinery/shield_capacitor/ui_data(mob/user)
	var/list/data = list()
	data["anchored"] = anchored
	data["locked"] = locked
	data["active"] = active
	data["time_since_fail"] = time_since_fail
	data["charge_rate"] = charge_rate
	data["stored_charge"] = stored_charge
	data["max_charge"] = max_charge
	data["max_charge_rate"] = max_charge_rate
	return data

/obj/machinery/shield_capacitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle")
			if(!active && !anchored)
				to_chat(usr, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
				return
			active = !active
			. = TRUE
		if("charge_rate")
			charge_rate = between(10000, params["charge_rate"], max_charge_rate)
			. = TRUE

/obj/machinery/shield_capacitor/process()
	if (!anchored)
		active = FALSE

	//see if we can connect to a power net.
	var/datum/powernet/PN
	var/turf/T = loc

	if (!istype(T))
		active = FALSE
		return

	var/obj/structure/cable/C = T.get_cable_node()

	if (C)
		PN = C.powernet

	if (PN)
		var/power_draw = between(0, max_charge - stored_charge, charge_rate) //what we are trying to draw
		power_draw = PN.draw_power(power_draw) //what we actually get
		stored_charge += power_draw

	time_since_fail++
	if(stored_charge < last_stored_charge)
		time_since_fail = 0 //losing charge faster than we can draw from PN
	last_stored_charge = stored_charge

/obj/machinery/shield_capacitor/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		..()

/obj/machinery/shield_capacitor/multiz
	max_charge_rate = 1250000	//1250 kW
