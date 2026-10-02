/obj/structure/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specifically designed to charge power cells."
	icon = 'icons/obj/machinery/cell_charger.dmi'
	icon_state = "ccharger"
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 90 KILO WATTS
	power_channel = AREA_USAGE_EQUIP
	update_icon_on_init = TRUE
	component_types = list(
		/obj/item/circuitboard/cell_charger,
		/obj/item/stock_parts/capacitor = 2
	)

	var/obj/item/cell/charging = null
	var/charge_level = -1
	var/charging_efficiency = 2
	var/charging_efficiency_per_capacitor = 0.1
	var/charging_speed_per_capacitor = 25 KILO WATTS

/obj/structure/machinery/cell_charger/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It [anchored ? "is" : "could be"] anchored in place with a couple of <b>bolts</b>."

/obj/structure/machinery/cell_charger/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance > 5)
		return

	if(charging)
		. += "There's \a [charging.name] in the charger. Current charge: [charging.percent()]%."
	else
		. += SPAN_WARNING("The charger is empty.")

/obj/structure/machinery/cell_charger/RefreshParts()
	..()

	var/cap_rating = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		cap_rating += capacitor.rating

	charging_efficiency = initial(charging_efficiency) * (1 + (cap_rating * charging_efficiency_per_capacitor))
	active_power_usage = cap_rating * charging_speed_per_capacitor

/obj/structure/machinery/cell_charger/proc/update_charge_level()
	if(!charging)
		charge_level = -1
		return

	var/new_level = round(charging.percent() / 25)
	if(new_level != charge_level)
		charge_level = new_level

/obj/structure/machinery/cell_charger/update_icon()
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

/obj/structure/machinery/cell_charger/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN)
		return TRUE

	if(istype(attacking_item, /obj/item/cell))
		if(!anchored)
			to_chat(user, SPAN_WARNING("You need to secure \the [src] first."))
			return TRUE

		if(charging)
			to_chat(user, SPAN_WARNING("There is already a cell in \the [src]."))
			return TRUE

		if(panel_open)
			to_chat(user, SPAN_WARNING("You need to close the maintenance panel on \the [src] first."))
			return TRUE

		user.drop_from_inventory(attacking_item, src)
		charging = attacking_item
		user.visible_message("[user] inserts \the [charging.name] into \the [src].", "You insert \the [charging.name] into \the [src].")

		update_icon()
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return TRUE

	if(charging)
		to_chat(user, SPAN_WARNING("Remove the cell first!"))
		return TRUE

	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		anchored = !anchored
		to_chat(user, "You [anchored ? "" : "un"]secure \the [src].")
		attacking_item.play_tool_sound(src, 50)
		return TRUE

	if(default_deconstruction_screwdriver(user, attacking_item))
		update_icon()
		return TRUE
	else if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	else if(default_part_replacement(user, attacking_item))
		return TRUE

/obj/structure/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		user.put_in_hands(charging, TRUE)
		charging.add_fingerprint(user)
		charging.update_icon()
		user.visible_message("[user] removes \the [charging.name] from \the [src].", "You remove \the [charging.name] from \the [src].")

		charging = null
		update_icon()

	return TRUE

/obj/structure/machinery/cell_charger/attack_ai(mob/user)
	if(isrobot(user) && charging) // Borgs can remove the cell if they are near enough
		user.put_in_hands(charging, TRUE)
		charging.update_icon()
		user.visible_message("[user] removes \the [charging.name] from \the [src].", "You remove \the [charging.name] from \the [src].")

		charging = null
		charge_level = -1
		update_icon()

/obj/structure/machinery/cell_charger/emp_act(severity)
	. = ..()

	if(INOPERABLE(src))
		return
	if(charging)
		charging.emp_act(severity)

/obj/structure/machinery/cell_charger/power_change()
	if(..() && charging && anchored)
		if(INOPERABLE(src))
			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		else
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/structure/machinery/cell_charger/process()
	if(INOPERABLE(src) || !anchored)
		update_use_power(POWER_USE_OFF)
		update_icon()
		return PROCESS_KILL

	if (charging && !charging.fully_charged())
		if(use_power < POWER_USE_ACTIVE)
			update_use_power(POWER_USE_ACTIVE)
		charging.give(active_power_usage * CELLRATE * charging_efficiency)
		update_icon()
	else
		update_use_power(POWER_USE_IDLE)
		update_icon()
		if(charging)
			ping()
		return PROCESS_KILL

/obj/structure/machinery/cell_charger/rack
	name = "cell charger rack"
	desc = "A large rack capable of storing and sequentially charging power cells, mech power cores, and computer batteries."
	icon = 'icons/obj/power.dmi'
	icon_state = "gsmes"
	density = TRUE
	component_types = list(
		/obj/item/circuitboard/cell_charger/rack,
		/obj/item/stock_parts/capacitor = 2
	)

	/// Maximum number of cells which can be stored in the rack.
	var/max_cells = 10

/obj/structure/machinery/cell_charger/rack/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	if(distance > 3)
		return

	var/cell_count = 0
	for(var/obj/item/battery_item in contents)
		if(get_stored_cell(battery_item))
			cell_count++
	. += "It contains [cell_count] of a maximum of [max_cells] batteries."
	if(charging && !INOPERABLE(src) && anchored)
		. += "It is currently charging \the [charging]. Current charge: [charging.percent()]%."

/obj/structure/machinery/cell_charger/rack/proc/get_stored_cell(obj/item/battery_item)
	if(istype(battery_item, /obj/item/cell) || istype(battery_item, /obj/item/computer_hardware/battery_module))
		return battery_item.get_cell()

/obj/structure/machinery/cell_charger/rack/proc/is_cell_stored(obj/item/cell/cell)
	for(var/obj/item/battery_item in contents)
		if(get_stored_cell(battery_item) == cell)
			return TRUE
	return FALSE

/obj/structure/machinery/cell_charger/rack/proc/select_charging_cell()
	if(charging && is_cell_stored(charging) && !charging.fully_charged())
		return charging

	charging = null
	for(var/obj/item/battery_item in contents)
		var/obj/item/cell/cell = get_stored_cell(battery_item)
		if(!cell)
			continue
		if(!cell.fully_charged())
			charging = cell
			break
	return charging

/obj/structure/machinery/cell_charger/rack/proc/cell_count()
	var/count = 0
	for(var/obj/item/battery_item in contents)
		if(get_stored_cell(battery_item))
			count++
	return count

/obj/structure/machinery/cell_charger/rack/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN)
		return TRUE

	var/obj/item/cell/battery_cell = get_stored_cell(attacking_item)
	if(battery_cell)
		if(!anchored)
			to_chat(user, SPAN_WARNING("You need to secure \the [src] first."))
			return TRUE
		if(panel_open)
			to_chat(user, SPAN_WARNING("You need to close the maintenance panel on \the [src] first."))
			return TRUE
		if(cell_count() >= max_cells)
			to_chat(user, SPAN_WARNING("There is no room for another battery in \the [src]."))
			return TRUE

		user.drop_from_inventory(attacking_item, src)
		user.visible_message("[user] inserts \the [attacking_item] into \the [src].", "You insert \the [attacking_item] into \the [src].")
		select_charging_cell()
		update_icon()
		if(charging)
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return TRUE

	if(cell_count())
		to_chat(user, SPAN_WARNING("Remove the stored batteries first!"))
		return TRUE

	return ..()

/obj/structure/machinery/cell_charger/rack/attack_hand(mob/user)
	ui_interact(user)
	return TRUE

/obj/structure/machinery/cell_charger/rack/attack_ai(mob/user)
	if(ai_can_interact(user))
		ui_interact(user)

/obj/structure/machinery/cell_charger/rack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CellChargerRack", name, 460, 500)
		ui.open()

/obj/structure/machinery/cell_charger/rack/ui_data(mob/user)
	var/list/data = list()
	var/list/cells = list()
	var/operational = !INOPERABLE(src) && anchored
	var/charge_per_tick = active_power_usage * CELLRATE * charging_efficiency
	var/current_cell_eta = 0
	var/all_cells_eta = 0
	for(var/obj/item/battery_item in contents)
		var/obj/item/cell/cell = get_stored_cell(battery_item)
		if(!cell)
			continue
		var/cell_eta = 0
		if(!cell.fully_charged() && charge_per_tick > 0)
			var/charging_ticks = CEILING((cell.maxcharge - cell.charge) / charge_per_tick, 1)
			cell_eta = charging_ticks * (SSmachinery.wait / 10)
			all_cells_eta += cell_eta
			if(cell == charging)
				current_cell_eta = cell_eta

		cells.Add(list(list(
			"name" = battery_item.name,
			"charge" = round(cell.percent(), 0.1),
			"charging" = cell == charging && operational,
			"ref" = REF(battery_item)
		)))

	data["cells"] = cells
	data["max_cells"] = max_cells
	data["operational"] = operational
	data["current_cell_eta"] = current_cell_eta
	data["all_cells_eta"] = all_cells_eta
	return data

/obj/structure/machinery/cell_charger/rack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "eject")
		var/obj/item/battery_item = locate(params["ref"]) in contents
		var/obj/item/cell/cell = get_stored_cell(battery_item)
		if(!cell)
			return

		if(cell == charging)
			charging = null
		cell.update_icon()
		ui.user.put_in_hands(battery_item, TRUE)
		battery_item.add_fingerprint(ui.user)
		select_charging_cell()
		update_icon()
		if(charging && !INOPERABLE(src) && anchored)
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return TRUE

/obj/structure/machinery/cell_charger/rack/emp_act(severity)
	. = ..()
	for(var/obj/item/battery_item in contents)
		var/obj/item/cell/cell = get_stored_cell(battery_item)
		if(!cell)
			continue
		if(cell != charging)
			cell.emp_act(severity)

/obj/structure/machinery/cell_charger/rack/power_change()
	. = ..()
	select_charging_cell()
	if(charging && anchored && !INOPERABLE(src))
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/structure/machinery/cell_charger/rack/process()
	if(INOPERABLE(src) || !anchored)
		update_use_power(POWER_USE_OFF)
		update_icon()
		return PROCESS_KILL

	select_charging_cell()
	if(!charging)
		update_use_power(POWER_USE_IDLE)
		update_icon()
		return PROCESS_KILL

	update_use_power(POWER_USE_ACTIVE)
	charging.give(active_power_usage * CELLRATE * charging_efficiency)
	if(charging.fully_charged())
		charging = null
		select_charging_cell()
		if(!charging)
			update_use_power(POWER_USE_IDLE)
			ping()
			update_icon()
			return PROCESS_KILL
	update_icon()
