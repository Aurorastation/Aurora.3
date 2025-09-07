/obj/machinery/space_heater
	name = "portable temperature control unit"
	desc = "A portable temperature control unit. It can heat or cool a room to your liking."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	clicksound = /singleton/sound_category/switch_sound
	var/on = FALSE
	/// Currently heating or cooling the environment, if on.
	var/active = 0
	/// Force it to at least somewhat obey thermodynamics.
	var/heating_power = 40 KILO WATTS
	var/current_temperature
	var/set_temperature = T0C + 20
	var/set_temperature_max = T0C + 40
	var/set_temperature_min = T0C
	var/datum/gas_mixture/env
	var/obj/item/cell/apc/cell

/obj/machinery/space_heater/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The unit is <b>[on ? "on" : "off"]</b> and the hatch is <b>[panel_open ? "open" : "closed"]</b>."
	if(panel_open)
		. += "The power cell is <b>[cell ? "installed" : "missing"]</b>."
	else
		. += "The charge meter reads <b>[cell ? round(cell.percent(),1) : 0]%</b>."

/obj/machinery/space_heater/Initialize()
	. = ..()
	cell = new(src)
	/// Ensure env exists so TGUI doesn't attempt to round null for display.
	env = loc.return_air()
	update_icon()

/obj/machinery/space_heater/update_icon()
	ClearOverlays()
	if(!on)
		icon_state = "sheater-off"
		set_light(0)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light(0.7, 1, COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light(0.7, 1, COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light(0)
	if(panel_open)
		AddOverlays("sheater-open")

/obj/machinery/space_heater/powered()
	if(cell && cell.charge)
		return TRUE
	return FALSE

/obj/machinery/space_heater/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return

	if(cell)
		cell.emp_act(severity)

/obj/machinery/space_heater/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
			else
				// insert cell
				user.drop_from_inventory(attacking_item,src)
				cell = attacking_item
				attacking_item.add_fingerprint(user)

				visible_message(SPAN_NOTICE("[user] inserts a power cell into [src]."),
					SPAN_NOTICE("You insert the power cell into [src]."))
				power_change()
		else
			to_chat(user, SPAN_NOTICE("The hatch must be open to insert a power cell."))
		return TRUE
	else if(attacking_item.isscrewdriver())
		panel_open = !panel_open
		user.visible_message(SPAN_NOTICE("[user] [panel_open ? "opens" : "closes"] the hatch on the [src]."),
				SPAN_NOTICE("You [panel_open ? "open" : "close"] the hatch on the [src]."))
		update_icon()
		return TRUE
	return ..()

/obj/machinery/space_heater/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(panel_open)
		if(cell)
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [cell] from \the [src]."),
				SPAN_NOTICE("You remove \the [cell] from \the [src]."))
			cell.update_icon()
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell = null
			power_change()
		else
			to_chat(user,"There's no cell to remove!")
	else
		ui_interact(user)

// TGUI functions begin
/obj/machinery/space_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", src.name, 700, 300)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()

	current_temperature = round(env.temperature - T0C, 0.1)

	data["power_cell_inserted"] = cell
	data["power_cell_charge"] = cell?.percent()
	data["is_on"] = on
	data["is_active"] = active
	data["panel_open"] = panel_open
	data["heating_power"] = heating_power
	data["current_temperature"] = current_temperature
	data["set_temperature"] = set_temperature - T0C
	data["set_temperature_max"] = set_temperature_max - T0C
	data["set_temperature_min"] = set_temperature_min - T0C

	return data

/obj/machinery/space_heater/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("powerToggle")
			on = !on
			active = FALSE
			power_change()
			usr.visible_message(SPAN_NOTICE("[usr] toggles the power on \the [src]."),
			SPAN_NOTICE("You toggle the power on \the [src]."))
			update_icon()
			. = TRUE
		if ("tempSet")
			set_temperature = between(set_temperature_min, text2num(params["set_temperature"]) + T0C, set_temperature_max)
			. = TRUE
// TGUI functions end

/obj/machinery/space_heater/process()
	if(on && loc)
		if(cell && cell.charge)
			env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) <= 0.1)
				active = FALSE
			else
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					var/power_draw
					if(heat_transfer > 0) // Heating.
						heat_transfer = min(heat_transfer , heating_power) // Limit by the power rating of the heater.

						removed.add_thermal_energy(heat_transfer)
						power_draw = heat_transfer
					else // Cooling.
						heat_transfer = abs(heat_transfer)

						// Assume the heat is being pumped into the hull which is fixed at 20 C.
						var/cop = removed.temperature/T20C	// Co-efficient of performance from thermodynamics -> power used = heat_transfer/cop.
						heat_transfer = min(heat_transfer, cop * heating_power)	// Limit heat transfer by available power.

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	// Get the actual heat transfer.

						power_draw = abs(heat_transfer)/cop
					cell.use(power_draw * CELLRATE)
					active = heat_transfer

				env.merge(removed)
		else
			on = FALSE
			active = FALSE
			power_change()
		update_icon()

//For mounting on walls in planetary buildings and stuff.
/obj/machinery/space_heater/stationary
	name = "stationary temperature control unit"
	desc = "A stationary temperature control unit. It can heat or cool a room to your liking."
	anchored = TRUE
	can_be_unanchored = FALSE
	density = FALSE
