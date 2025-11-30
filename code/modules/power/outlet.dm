// A simple power outlet that lets people charge modular computers

/obj/machinery/power/outlet
	name = "power outlet"
	desc = "A simple power outlet. You can charge your PDA or other modular computer device here."
	icon = 'icons/obj/power.dmi'
	icon_state = "outlet"
	density = FALSE
	anchored = TRUE
	use_power = POWER_USE_OFF // doesn't use power by default, only when drawing power

	active_power_usage = 200 // this variable serves to indicate the extra amount of juice this outlet will provide the tesla charger, since it's a dedicated machine

	component_types = list(
		/obj/item/stack/cable_coil{amount = 5},
		/obj/item/stock_parts/capacitor,
		/obj/item/circuitboard/outlet
	)

	parts_power_mgmt = FALSE

/obj/machinery/power/outlet/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>capacitors</b> will increase the rate at which connected devices charge."

/obj/machinery/power/outlet/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/outlet/update_icon()
	icon_state = panel_open ? "[initial(icon_state)]-open" : initial(icon_state)

/obj/machinery/power/outlet/RefreshParts()
	..()
	var/part_level = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		part_level += SP.rating
	active_power_usage = initial(active_power_usage) * part_level

/obj/machinery/power/outlet/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/modular_computer))
		var/obj/item/modular_computer/C = attacking_item
		if(istype(C.tesla_link, /obj/item/computer_hardware/tesla_link/charging_cable))
			var/obj/item/computer_hardware/tesla_link/charging_cable/CC = C.tesla_link
			CC.toggle(src, user)
			return
	else if(default_part_replacement(user, attacking_item))
		return
	else if(default_deconstruction_screwdriver(user, attacking_item))
		return
	else if(default_deconstruction_crowbar(user, attacking_item))
		return

	// since we'll mostly be on tables, don't block putting things on them if it's not a computer
	var/obj/structure/table/table_underneath = locate() in loc
	if(table_underneath)
		return table_underneath.attackby(attacking_item, user, params)

	return ..()

/obj/item/circuitboard/outlet
	name = T_BOARD("power outlet")
	build_path = /obj/machinery/power/outlet
	board_type = BOARD_MACHINE
	origin_tech = list(
		TECH_ENGINEERING = 1,
		TECH_POWER = 1
	)
	req_components = list(
		"/obj/item/stack/cable_coil" = 5,
		"/obj/item/stock_parts/capacitor" = 1
	)
