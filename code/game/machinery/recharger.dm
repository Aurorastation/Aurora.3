//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	desc = "Useful for recharging electronic devices."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 30 KILOWATTS
	var/charging_efficiency = 0.85
	//Entropy. The charge put into the cell is multiplied by this
	var/obj/item/charging

	var/list/allowed_devices = list(
		/obj/item/gun/energy,
		/obj/item/melee/baton,
		/obj/item/cell,
		/obj/item/modular_computer,
		/obj/item/computer_hardware/battery_module
	)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1
	var/list/chargebars

/obj/machinery/recharger/examine(mob/user)
	. = ..(user, 3)
	to_chat(user, "There is [charging ? "[charging]" : "nothing"] in [src].")
	if (charging && .)
		var/obj/item/cell/C = charging.get_cell()
		if (istype(C) && user.client && (!user.progressbars || !user.progressbars[src]))
			var/datum/progressbar/progbar = new(user, C.maxcharge, src)
			progbar.update(C.charge)
			LAZYADD(chargebars, progbar)
			chargebars[progbar] = addtimer(CALLBACK(src, .proc/remove_bar, progbar, null), 3 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/obj/machinery/recharger/proc/remove_bar(datum/progressbar/bar, timerid)
	if (!timerid || deltimer(timerid))
		LAZYREMOVE(chargebars, bar)
		qdel(bar)

/obj/machinery/recharger/attackby(obj/item/G as obj, mob/user as mob)
	if(portable && G.iswrench())
		if(charging)
			to_chat(user, "<span class='alert'>Remove [charging] first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You have [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, G.usesound, 75, 1)
		return

	if (istype(G, /obj/item/gripper))//Code for allowing cyborgs to use rechargers
		var/obj/item/gripper/Gri = G
		if (charging)//If there's something in the charger
			if (Gri.grip_item(charging, user))//we attempt to grab it
				charging = null
				update_icon()
			else
				to_chat(user, "<span class='danger'>Your gripper cannot hold \the [charging].</span>")

	if(!dropsafety(G))
		return

	if(is_type_in_list(G, allowed_devices))
		if (G.get_cell() == DEVICE_NO_CELL)
			if (G.charge_failure_message)
				to_chat(user, "<span class='warning'>\The [G][G.charge_failure_message]</span>")
			return
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>\The [name] blinks red as you try to insert the item!</span>")
			return

		user.drop_from_inventory(G,src)
		charging = G
		update_icon()

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		if (chargebars)
			for (var/thing in chargebars)
				remove_bar(thing, chargebars[thing])
		update_icon()

/obj/machinery/recharger/machinery_process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(1)
		icon_state = icon_state_idle
	else
		var/obj/item/cell/cell = charging.get_cell()
		if(istype(cell))
			var/obj/item/cell/C = cell
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(active_power_usage*CELLRATE*charging_efficiency)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)

			if (chargebars)
				for (var/thing in chargebars)
					var/datum/progressbar/bar = thing
					if (QDELETED(bar))
						LAZYREMOVE(chargebars, bar)
					else
						bar.update(C.charge)

		else if (cell == DEVICE_NO_CELL)
			log_debug("recharger: Item [DEBUG_REF(charging)] was in charger, but claims to have no internal cell slot; booting item.")
			charging.forceMove(loc)
			charging.visible_message("\The [charging] falls out of [src].")
			charging = null

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging,  /obj/item/gun/energy))
		var/obj/item/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = charging
		if(B.bcell)
			B.bcell.charge = 0
	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A heavy duty wall recharger specialized for energy weaponry."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 50 KILOWATTS	//50 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(
		/obj/item/gun/energy,
		/obj/item/melee/baton
	)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	charging_efficiency = 0.8
