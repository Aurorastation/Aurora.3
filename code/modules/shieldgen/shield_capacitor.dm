/obj/structure/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "Machine that charges a shield generator."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "capacitor"
	obj_flags = OBJ_FLAG_ROTATABLE
	density = TRUE
	/// Doesn't use APC power.
	use_power = POWER_USE_OFF
	req_one_access = list(ACCESS_CAPTAIN, ACCESS_SECURITY, ACCESS_ENGINE)

	var/active = FALSE
	/// Not to be confused with power cell charge, this is in Joules.
	var/stored_charge = 0
	var/last_stored_charge = 0
	var/time_since_fail = 100
	///How much energy the capacitor can store, value is in Joules, displayed in the UI as MJ. This value is calculated in RefreshParts() based on the components used, the value listed here is what base components provides, changing the value only here will not do anything.
	var/max_charge = 20 MEGA			//200 MJ
	///How much energy the capacitor can absorb per second, value is in Watts, displayed in the UI as MW. This value is calculated in RefreshParts() based on the components used, the value listed here is what base components provides, changing the value only here will not do anything.
	var/max_charge_rate = 9 MEGA WATTS	//9 MW
	var/locked = FALSE

	var/charge_rate = 100 KILO WATTS		//100 kW
	var/obj/structure/machinery/shield_gen/owned_gen

	component_types = list(
		/obj/item/circuitboard/shield_cap,
		/obj/item/stock_parts/capacitor = 4,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 1,
		/obj/item/stock_parts/subspace/analyzer = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
		)

/obj/structure/machinery/shield_capacitor/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>capacitors</b> will increase capacity."
	. += SPAN_NOTICE("	- The current capacity is <b>[max_charge / 1e6]</b> MJ")
	. += "Upgraded <b>microlasers</b> will increase the charging rate."
	. += SPAN_NOTICE("	- The current maximum charge rate is <b>[max_charge_rate / 1e6]</b> MW")

/obj/structure/machinery/shield_capacitor/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/shield_capacitor/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/shield_gen/possible_gen in range(1, src))
		if(get_dir(src, possible_gen) == dir)
			if(possible_gen.attach_capacitor(src))
				owned_gen = possible_gen
				break

/obj/structure/machinery/shield_capacitor/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()
	spark(src, 5, GLOB.alldirs)

/obj/structure/machinery/shield_capacitor/RefreshParts()
	..()
	max_charge = 0
	max_charge_rate = 6 MEGA WATTS	//9 MW after base components. 15 MW with full upgrades.

	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			max_charge += P.rating * 5 MEGA
		else if(ismicrolaser(P))
			max_charge_rate += P.rating * 3 MEGA WATTS

/obj/structure/machinery/shield_capacitor/attackby(obj/item/attacking_item, mob/user)

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
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by \the [user]."))

		if(anchored)
			for(var/obj/structure/machinery/shield_gen/gen in range(1, src))
				if(get_dir(src, gen) == src.dir)
					if(gen.attach_capacitor(src))
						owned_gen = gen
						break
		else
			if(owned_gen)
				owned_gen.detach_capacitor(src)
				owned_gen = null
	else
		..()

/obj/structure/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	ui_interact(user)

/obj/structure/machinery/shield_capacitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldCapacitor", "Shield Capacitor", 400, 300)
		ui.open()

/obj/structure/machinery/shield_capacitor/ui_data(mob/user)
	var/list/data = list()
	data["anchored"] = anchored
	data["locked"] = locked
	data["active"] = active
	data["time_since_fail"] = time_since_fail
	data["charge_rate"] = charge_rate / 1000 //UI expects kW
	data["stored_charge"] = round(stored_charge / 1e6, 0.1) //UI expects MJ
	data["max_charge"] = max_charge / 1e6 //UI expects MJ
	data["max_charge_rate"] = max_charge_rate / 1000 //UI expects kW
	return data

/obj/structure/machinery/shield_capacitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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
			// UI sends kW; convert to W and clamp.
			charge_rate = between(0 KILO WATTS, round(params["charge_rate"]) * 1000, max_charge_rate)
			. = TRUE

/obj/structure/machinery/shield_capacitor/process()
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
		power_draw = POWERNET_POWER_DRAW(PN, power_draw) //what we actually get
		DRAW_FROM_POWERNET(PN, power_draw)
		stored_charge += power_draw

	time_since_fail++
	if(stored_charge < last_stored_charge)
		time_since_fail = 0 //losing charge faster than we can draw from PN
	last_stored_charge = stored_charge

/obj/structure/machinery/shield_capacitor/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		..()

/// Horizon-specific non-variant, for now.
/obj/structure/machinery/shield_capacitor/multiz

