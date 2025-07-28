/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specifically designed to charge power cells."
	icon = 'icons/obj/machinery/cell_charger.dmi'
	icon_state = "ccharger"
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 90 KILO WATTS
	power_channel = AREA_USAGE_EQUIP
	update_icon_on_init = TRUE

	var/obj/item/cell/charging = null
	var/charge_level = -1
	var/const/CHARGE_EFFICIENCY = 1.38

/obj/machinery/cell_charger/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It [anchored ? "is" : "could be"] anchored in place with a couple of <b>bolts</b>."

/obj/machinery/cell_charger/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance > 5)
		return

	if(charging)
		. += "There's \a [charging.name] in the charger. Current charge: [charging.percent()]%."
	else
		. += SPAN_WARNING("The charger is empty.")

/obj/machinery/cell_charger/proc/update_charge_level()
	if(!charging)
		charge_level = -1
		return

	var/new_level = round(charging.percent() / 25)
	if(new_level != charge_level)
		charge_level = new_level

/obj/machinery/cell_charger/update_icon()
	ClearOverlays()
	if(charging)
		charging.update_icon()
		AddOverlays(charging.icon_state)
		AddOverlays("ccharger-on")
		if(stat & (NOPOWER|BROKEN))
			AddOverlays(charging.overlays)

	if(INOPERABLE(src) || !charging)
		return

	update_charge_level()
	AddOverlays("cell-o2")
	AddOverlays("[icon_state]-o[charge_level]")

/obj/machinery/cell_charger/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN)
		return TRUE

	if(attacking_item.iswrench())
		if(charging)
			to_chat(user, SPAN_WARNING("Remove the cell first!"))
			return TRUE

		anchored = !anchored
		to_chat(user, "You [anchored ? "" : "un"]secure \the [src].")
		attacking_item.play_tool_sound(src, 50)
		return TRUE

	if(istype(attacking_item, /obj/item/cell))
		if(!anchored)
			to_chat(user, SPAN_WARNING("You need to secure \the [src] first."))
			return TRUE

		if(charging)
			to_chat(user, SPAN_WARNING("There is already a cell in \the [src]."))
			return TRUE

		user.drop_from_inventory(attacking_item, src)
		charging = attacking_item
		user.visible_message("[user] inserts \the [charging.name] into \the [src].", "You insert \the [charging.name] into \the [src].")

		update_icon()
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return TRUE

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		user.put_in_hands(charging, TRUE)
		charging.add_fingerprint(user)
		charging.update_icon()
		user.visible_message("[user] removes \the [charging.name] from \the [src].", "You remove \the [charging.name] from \the [src].")

		charging = null
		update_icon()

	return TRUE

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(isrobot(user) && charging) // Borgs can remove the cell if they are near enough
		user.put_in_hands(charging, TRUE)
		charging.update_icon()
		user.visible_message("[user] removes \the [charging.name] from \the [src].", "You remove \the [charging.name] from \the [src].")

		charging = null
		charge_level = -1
		update_icon()

/obj/machinery/cell_charger/emp_act(severity)
	. = ..()

	if(INOPERABLE(src))
		return
	if(charging)
		charging.emp_act(severity)

/obj/machinery/cell_charger/power_change()
	if(..() && charging && anchored)
		if(INOPERABLE(src))
			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		else
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/cell_charger/process()
	if(INOPERABLE(src) || !anchored)
		update_use_power(POWER_USE_OFF)
		update_icon()
		return PROCESS_KILL

	if (charging && !charging.fully_charged())
		if(use_power < POWER_USE_ACTIVE)
			update_use_power(POWER_USE_ACTIVE)
		charging.give(active_power_usage * CELLRATE * CHARGE_EFFICIENCY)
		update_icon()
	else
		update_use_power(POWER_USE_IDLE)
		update_icon()
		if(charging)
			ping()
		return PROCESS_KILL
