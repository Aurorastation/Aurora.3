/obj/machinery/space_heater
	name = "portable temperature control unit"
	desc = "A portable temperature control unit. It can heat or cool a compartment to your liking."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	clicksound = SFX_SWITCH
	light_system = MOVABLE_LIGHT
	var/on = FALSE
	/// Currently heating or cooling the environment, if on, and by how much (in terms of heat transfer).
	var/active = 0
	/// This value gets overwritten on activation. heating_power scales with cell maxcharge (to a point).
	var/heating_power = 40 KILO WATTS
	var/current_temperature
	/// Current target temperature for the unit.
	var/set_temperature = T0C + 20
	/// Maximum allowed target temperature.
	var/set_temperature_max = T0C + 40
	/// Minimum allowed target temperature.
	var/set_temperature_min = T0C
	var/datum/gas_mixture/env
	/// The cell we spawn with.
	var/obj/item/cell/apc/cell
	/// Is our cell high-powered? (>= 50 kW, so 'super' or better).
	var/high_power_cell = FALSE

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

/obj/machinery/space_heater/Destroy()
	env = null
	QDEL_NULL(cell)
	return ..()

/obj/machinery/space_heater/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("sheater-open")
	if(!on)
		icon_state = "sheater-off"
		set_light_on(FALSE)
	else if(active > 0)
		icon_state = "sheater-heat"
		AddOverlays(emissive_appearance(icon, "sheater-heat-emissive", src, alpha = src.alpha))
		set_light_range_power_color(0.7, 1, COLOR_SEDONA)
		set_light_on(TRUE)
	else if(active < 0)
		icon_state = "sheater-cool"
		AddOverlays(emissive_appearance(icon, "sheater-cool-emissive", src, alpha = src.alpha))
		set_light_range_power_color(0.7, 1, COLOR_DEEP_SKY_BLUE)
		set_light_on(TRUE)
	else
		icon_state = "sheater-standby"
		AddOverlays(emissive_appearance(icon, "sheater-standby-emissive", src, alpha = src.alpha))
		set_light_on(FALSE)

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
				to_chat(user, "There is already \a [cell] inside.")
			else
				// insert cell
				user.drop_from_inventory(attacking_item,src)
				cell = attacking_item
				attacking_item.add_fingerprint(user)
				visible_message(SPAN_NOTICE("[user] inserts a power cell into [src]."),
				SPAN_NOTICE("You insert \the [cell] into [src]."))
				power_change()
		else
			balloon_alert("hatch still closed!")
		return TRUE
	else if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		panel_open = !panel_open
		attacking_item.play_tool_sound(get_turf(src), 50)
		balloon_alert_to_viewers("[panel_open ? "opened" : "closed"]")
		update_icon()
		return TRUE
	return ..()

/obj/machinery/space_heater/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(panel_open)
		if(cell)
			user.visible_message(SPAN_NOTICE("\The [user] removes a power cell from \the [src]."),
				SPAN_NOTICE("You remove \the [cell] from \the [src]."))
			cell.update_icon()
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell = null
			power_change()
			/// If a cell's power rating is above a certain threshold (>= super), expand temperature minmax range by 10 in both directions.
			if(cell.maxcharge >= 50000)
				high_power_cell = TRUE
			else
				high_power_cell = FALSE
		else
			to_chat(user, SPAN_WARNING("There's no cell to remove!"))
	else
		ui_interact(user)

// TGUI functions begin
/obj/machinery/space_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", src.name, 415, 280)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()

	current_temperature = round(env.temperature - T0C, 0.1)

	var/bonus_temp_range = 0
	if(high_power_cell)
		bonus_temp_range = 10

	data["power_cell_inserted"] = cell != null
	data["power_cell_charge"] = cell?.percent()
	data["is_on"] = on
	data["is_active"] = active
	data["panel_open"] = panel_open
	data["current_temperature"] = current_temperature
	data["set_temperature"] = set_temperature - T0C
	data["set_temperature_max"] = set_temperature_max - T0C + bonus_temp_range
	data["set_temperature_min"] = set_temperature_min - T0C - bonus_temp_range

	return data

/obj/machinery/space_heater/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return
	switch(action)
		if("powerToggle")
			balloon_alert_to_viewers("turned [on ? "off" : "on"]")
			on = !on
			active = 0
			power_change()
			update_icon()
			heating_power = clamp(0 WATTS, (cell?.maxcharge), 500 KILO WATTS)
			playsound(src, clicksound, clickvol)
			. = TRUE
		if ("tempSet")
			var/bonus_temp_range = 0
			if(high_power_cell)
				bonus_temp_range = 10
			set_temperature = clamp(set_temperature_min - bonus_temp_range, text2num(params["set_temperature"]) + T0C, set_temperature_max + bonus_temp_range)
			playsound(src, 'sound/machines/terminal/terminal_select.ogg', 10, TRUE)
			. = TRUE
// TGUI functions end

/obj/machinery/space_heater/process()
	if(on && loc)
		if(cell && cell.charge)
			env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) <= 0.1)
				active = 0
			else
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					var/power_draw
					if(heat_transfer > 0) // Heating.
						// Limit by the power rating of the cell (messy but workable, while we still don't have joules)
						heat_transfer = min(heat_transfer, heating_power)

						removed.add_thermal_energy(heat_transfer)
						power_draw = heat_transfer * 1.2 // Lets at least pretend we respect entropy.
					else // Cooling.
						heat_transfer = abs(heat_transfer)

						// Assume the heat is being pumped into the hull which is fixed at 20 C.
						var/cop = removed.temperature/T20C	// Co-efficient of performance from thermodynamics -> power used = heat_transfer/cop.
						// Limit by the power rating of the cell (messy but workable, while we still don't have joules)
						heat_transfer = min(heat_transfer, cop * heating_power)

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	// Get the actual heat transfer.

						power_draw = (abs(heat_transfer)/cop) * 1.2 // Lets at least pretend we respect entropy.
					cell.use(power_draw * CELLRATE)
					active = heat_transfer

				env.merge(removed)
		else
			on = FALSE
			active = 0
			power_change()
		update_icon()

//For mounting on walls in planetary buildings and stuff.
/obj/machinery/space_heater/stationary
	name = "stationary temperature control unit"
	desc = "A stationary temperature control unit. It can heat or cool a compartment to your liking."
	anchored = TRUE
	can_be_unanchored = FALSE
	density = FALSE
