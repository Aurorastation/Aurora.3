
//---------- shield capacitor
//pulls energy out of a power net and charges an adjacent generator

/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "A machine which converts electrical power in Force Renwicks for use by a shield generator."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "capacitor"
	obj_flags = OBJ_FLAG_ROTATABLE
	var/active = FALSE
	density = TRUE
	var/stored_charge = 0	//not to be confused with power cell charge, this is in Joules
	var/last_stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 8e6	//8 MJ
	var/max_charge_rate = 400000	//400 kW
	var/locked = FALSE
	use_power = POWER_USE_OFF //doesn't use APC power
	var/charge_rate = 100000	//100 kW
	var/obj/machinery/shield_matrix/owned_matrix
	req_one_access = list(access_captain, access_security, access_engine)

/obj/machinery/shield_capacitor/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/shield_capacitor/LateInitialize()
	for(var/obj/machinery/shield_matrix/possible_matrix in range(1, src))
		possible_matrix.update_shield_parts()
	if(dir == NORTH)
		pixel_y = 7
	else
		pixel_y = 0

/obj/machinery/shield_capacitor/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()
	spark(src, 5, alldirs)

/obj/machinery/shield_capacitor/update_icon()
	if(active)
		icon_state = "capacitor_on"
	else
		icon_state = "capacitor"
	return ..()

/obj/machinery/shield_capacitor/rotate()
	. = ..()
	if(dir == NORTH)
		pixel_y = 7
	else
		pixel_y = 0

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
			for(var/obj/machinery/shield_matrix/matrix in range(1, src))
				matrix.update_shield_parts()
		else
			if(owned_matrix && owned_matrix.owned_capacitor == src)
				owned_matrix.owned_capacitor = null
			owned_matrix = null
	else
		..()

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	interact(user)

/obj/machinery/shield_capacitor/ui_data(mob/user)
	var/list/data = list()

	data["active"] = active
	data["time_since_fail"] = time_since_fail
	data["stored_charge"] = round(stored_charge/1000, 0.1)
	data["max_charge"] = round(max_charge/1000, 0.1)
	data["charge_rate"] = charge_rate
	data["max_charge_rate"] = max_charge_rate
	return data

/obj/machinery/shield_capacitor/interact(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("The device is locked. Swipe your ID to unlock it."))
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("The device needs to be bolted to the ground first."))
		return
	else
		if(owned_matrix)
			if(!(owned_matrix in range(1, src) && get_dir(owned_matrix, src) == owned_matrix.dir && owned_matrix.anchored))
				if(owned_matrix.owned_capacitor == src)
					owned_matrix.owned_capacitor = null
				owned_matrix = null
	if(!owned_matrix)
		for(var/obj/machinery/shield_matrix/matrix in range(1, src))
			if(matrix.owned_capacitor)
				continue
			if(get_dir(matrix, src) == matrix.dir && matrix.anchored)
				owned_matrix = matrix
				owned_matrix.owned_capacitor = src
				owned_matrix.updateDialog()
				break
	return ui_interact(user)

/obj/machinery/shield_capacitor/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldCapacitor", "Shield Capacitor", 480, 400)
		ui.open()

/obj/machinery/shield_capacitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("setChargeRate")
			charge_rate = between(0, params["charge_rate"], max_charge_rate)

		if("toggle")
			active = !active
			update_icon()

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

	stored_charge = max_charge //If this is still here when I PR this, someone scream profanities at me

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
