/obj/machinery/mech_recharger
	name = "exosuit dock"
	desc = "A exosuit recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = FALSE
	layer = ABOVE_TILE_LAYER
	anchored = TRUE
	idle_power_usage = 300	// Some electronics, passive drain.
	active_power_usage = 90 KILO WATTS // When charging

	var/mob/living/heavy_vehicle/charging
	var/base_charge_rate = 90 KILO WATTS
	var/repair_power_usage = 15 KILO WATTS		// Per 1 HP of health.
	var/repair
	var/charge

	var/charge_per_capacitor_rating = 0.5
	var/charge_per_scanner_rating = 0.25
	var/repair_per_scanner_rating = 0.25
	var/repair_per_manipulator_rating = 0.5

	component_types = list(
		/obj/item/circuitboard/mech_recharger,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator = 2
	)

/obj/machinery/mech_recharger/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>capacitors</b> will increase charging rate."
	. += "Upgraded <b>scanning modules</b> will increase both charging rate and repair speed."
	. += SPAN_NOTICE("	- The current charge speed is <b>[active_power_usage / 1000]</b> kW")
	. += "Upgraded <b>manipulators</b> will increase repair speed."
	if(repair > 0)
		. += SPAN_NOTICE("	- The current repair speed is <b>[repair]</b> HP per second</b>")
		. += SPAN_NOTICE("	- The current repair power usage is <b>[(repair_power_usage * repair) / 1000]</b> kW")

/obj/machinery/mech_recharger/Initialize(mapload)
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/mech_recharger/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(istype(arrived, /mob/living/heavy_vehicle) && charging != arrived)
		start_charging(arrived)

/obj/machinery/mech_recharger/proc/on_exit(atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(gone == charging)
		stop_charging()

/obj/machinery/mech_recharger/attackby(obj/item/attacking_item, mob/user)
	if(default_part_replacement(user, attacking_item))
		return TRUE
	else if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	else if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	return ..()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	charge = -0.25
	repair = -1.75

	for(var/obj/item/stock_parts/P in component_parts) //Charges at 315 kW and repairs at 2 HP/s fully upgraded.
		if(iscapacitor(P))
			charge += P.rating * charge_per_capacitor_rating
		else if(isscanner(P))
			charge += P.rating * charge_per_scanner_rating
			repair += P.rating * repair_per_scanner_rating
		else if(ismanipulator(P))
			repair += P.rating * repair_per_manipulator_rating

	change_power_consumption(initial(base_charge_rate) * charge, POWER_USE_ACTIVE)

/obj/machinery/mech_recharger/process()
	if(!charging)
		update_use_power(POWER_USE_IDLE)
		return
	if(charging.loc != loc)
		stop_charging()
		return

	if(stat & (BROKEN|NOPOWER))
		stop_charging()
		return

	// Cell could have been removed.
	if(!charging.get_cell())
		stop_charging()
		return

	var/remaining_energy = active_power_usage * charge

	if(repair > 0 && !fully_repaired())
		for(var/obj/item/mech_component/MC in charging)
			if(MC)
				MC.repair_brute_damage(repair)
				MC.repair_burn_damage(repair)
				remaining_energy -= repair * repair_power_usage
			if(remaining_energy <= 0)
				break
		charging.updatehealth()
		if(fully_repaired())
			for(var/mob/pilot in charging.pilots)
				to_chat(pilot, SPAN_NOTICE("Exosuit integrity has been fully restored."))

	var/obj/item/cell/cell = charging.get_cell()
	if(cell && remaining_energy > 0)
		cell.give(remaining_energy * CELLRATE)

/obj/machinery/mech_recharger/power_change()
	..()
	if(!(stat & NOPOWER) && !(stat & BROKEN) && !charging)
		var/mob/living/heavy_vehicle/HV = locate() in get_turf(src)
		if(HV)
			start_charging(HV)

// An ugly proc, but apparently mechs don't have maxhealth var of any kind.
/obj/machinery/mech_recharger/proc/fully_repaired()
	return charging && (charging.health == charging.maxhealth)

/obj/machinery/mech_recharger/proc/start_charging(var/mob/living/heavy_vehicle/M)
	var/no_power = FALSE
	var/obj/item/cell/C = M.get_cell()
	if(stat & (NOPOWER | BROKEN))
		no_power = TRUE
	if(!no_power && C)
		charging = M
		update_use_power(POWER_USE_ACTIVE)
	for(var/pilot in M.pilots)
		if(no_power)
			to_chat(pilot, SPAN_WARNING("Power port not responding. Terminating."))
			return
		if(C)
			to_chat(pilot, SPAN_NOTICE("Now charging..."))

/obj/machinery/mech_recharger/proc/stop_charging()
	update_use_power(POWER_USE_IDLE)
	charging = null


/obj/machinery/mech_recharger/hephaestus
	name = "hephaestus exosuit dock"
	desc = "A massive vehicle dock elevated slightly above the ground, constructed for equally massive charging speeds."
	icon_state = "supermechcharger"
	idle_power_usage = 400
	active_power_usage = 120 KILO WATTS

	base_charge_rate = 120 KILO WATTS
	repair = 1

	component_types = list(
		/obj/item/circuitboard/mech_recharger/hephaestus,
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 3
	)

/obj/machinery/mech_recharger/automobile
	name = "vehicle charging port"
	desc = "A vehicle battery recharger, built into the ground."
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "chargeport"
