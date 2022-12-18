/obj/machinery/recharger
	name = "charger"
	desc = "A charger. Useful for recharging electronic devices."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger_off"
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 1 KILOWATT
	pass_flags = PASSTABLE
	var/charge_rate = 50000
	var/obj/item/charging

	var/list/allowed_devices = list(
		/obj/item/gun/energy,
		/obj/item/melee/baton,
		/obj/item/cell,
		/obj/item/modular_computer,
		/obj/item/computer_hardware/battery_module,
		/obj/item/device/flashlight/survival,
		/obj/item/clothing/mask/smokable/ecig,
		/obj/item/inductive_charger/handheld,
		/obj/item/auto_cpr,
		/obj/item/device/personal_shield
	)
	var/icon_state_charged = "recharger100"
	var/icon_state_charging = "recharger"
	var/icon_state_idle = "recharger_off" //also when unpowered
	var/portable = 1
	var/list/chargebars

/obj/machinery/recharger/examine(mob/user)
	. = ..(user, 3)
	to_chat(user, "There is [charging ? "\a [charging]" : "nothing"] in [src].")
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

/obj/machinery/recharger/attackby(obj/item/G, mob/user)
	if(portable && G.iswrench())
		if(charging)
			to_chat(user, SPAN_WARNING("You can't modify \the [src] while it has something charging inside."))
			return TRUE
		anchored = !anchored
		user.visible_message("<b>[user]</b> [anchored ? "attaches" : "detaches"] \the [src].", SPAN_NOTICE("You [anchored ? "attach" : "detach"] \the [src]."))
		playsound(loc, G.usesound, 75, 1)
		return TRUE

	if (istype(G, /obj/item/gripper))//Code for allowing cyborgs to use rechargers
		var/obj/item/gripper/Gri = G
		if (charging)//If there's something in the charger
			if (Gri.grip_item(charging, user))//we attempt to grab it
				charging = null
				update_icon()
			else
				to_chat(user, "<span class='danger'>Your gripper cannot hold \the [charging].</span>")
		return TRUE

	if(!G.dropsafety())
		return TRUE

	if(is_type_in_list(G, allowed_devices))
		if (G.get_cell() == DEVICE_NO_CELL)
			if (G.charge_failure_message)
				to_chat(user, "<span class='warning'>\The [G][G.charge_failure_message]</span>")
			return TRUE
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return TRUE
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>\The [name] blinks red as you try to insert the item!</span>")
			return TRUE

		user.drop_from_inventory(G,src)
		charging = G
		update_icon()
		return TRUE

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

/obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(POWER_USE_OFF)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(POWER_USE_IDLE)
		icon_state = icon_state_idle
	else
		var/obj/item/cell/cell = charging.get_cell()
		if(istype(cell))
			var/obj/item/cell/C = cell
			if(!C.fully_charged())
				if(cell.charge / cell.maxcharge * 100 < 20)
					icon_state = icon_state_charging + "0"
				else if(cell.charge / cell.maxcharge * 100 < 40)
					icon_state = icon_state_charging + "20"
				else if(cell.charge / cell.maxcharge * 100 < 60)
					icon_state = icon_state_charging + "40"
				else if(cell.charge / cell.maxcharge * 100 < 80)
					icon_state = icon_state_charging + "60"
				else
					icon_state = icon_state_charging + "80"
				C.give(charge_rate * CELLRATE)

				update_use_power(POWER_USE_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(POWER_USE_IDLE)

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
		icon_state = icon_state_charging + "0"
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/wallcharger
	name = "wall-mounted weapon quick charger"
	desc = "A wall-mounted quick charger, specialized for electrical weaponry."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger_off"
	active_power_usage = 2 KILOWATTS
	charge_rate = 100000
	allowed_devices = list(
		/obj/item/gun/energy,
		/obj/item/melee/baton
	)
	icon_state_charged = "wrecharger100"
	icon_state_charging = "wrecharger"
	icon_state_idle = "wrecharger_off"
	appearance_flags = TILE_BOUND // prevents people from viewing us through a wall
	portable = FALSE