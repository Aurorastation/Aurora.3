
/obj/machinery/mech_recharger
	name = "exosuit dock"
	desc = "A exosuit recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = FALSE
	layer = TURF_LAYER + 0.1
	anchored = TRUE
	idle_power_usage = 300	// Some electronics, passive drain.
	active_power_usage = 90 KILOWATTS // When charging

	var/mob/living/heavy_vehicle/charging
	var/base_charge_rate = 90 KILOWATTS
	var/repair_power_usage = 15 KILOWATTS		// Per 1 HP of health.
	var/repair = 0
	var/charge

	component_types = list(
		/obj/item/circuitboard/mech_recharger,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator = 2
	)

/obj/machinery/mech_recharger/Crossed(var/mob/living/heavy_vehicle/M)
	. = ..()
	if(istype(M) && charging != M)
		start_charging(M)

/obj/machinery/mech_recharger/Uncrossed(var/mob/living/heavy_vehicle/M)
	. = ..()
	if(M == charging)
		stop_charging()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	charge = 0
	repair = -5

	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			charge += P.rating * 20
		else if(isscanner(P))
			charge += P.rating * 5
			repair += P.rating
		else if(ismanipulator(P))
			repair += P.rating * 2

/obj/machinery/mech_recharger/machinery_process()
	if(!charging)
		update_use_power(1)
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

	var/remaining_energy = active_power_usage

	if(repair && !fully_repaired())
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

// An ugly proc, but apparently mechs don't have maxhealth var of any kind.
/obj/machinery/mech_recharger/proc/fully_repaired()
	return charging && (charging.health == charging.maxHealth)

/obj/machinery/mech_recharger/proc/start_charging(var/mob/living/heavy_vehicle/M)
	var/no_power = FALSE
	var/obj/item/cell/C = M.get_cell()
	if(stat & (NOPOWER | BROKEN))
		no_power = TRUE
	if(!no_power && C)
		charging = M
		update_use_power(2)
	for(var/pilot in M.pilots)
		if(no_power)
			to_chat(pilot, SPAN_WARNING("Power port not responding. Terminating."))
			return
		if(C)
			to_chat(pilot, SPAN_NOTICE("Now charging..."))

/obj/machinery/mech_recharger/proc/stop_charging()
	update_use_power(1)
	charging = null