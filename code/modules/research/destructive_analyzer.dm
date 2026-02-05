/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	desc = "A cutting-edge research device that allows scientists to discover and further knowledge in fields that were used in the manufacture of certain objects."
	icon_state = "d_analyzer"
	var/obj/item/loaded_item = null
	var/decon_mod = 0

	idle_power_usage = 30
	active_power_usage = 2500

	component_types = list(
		/obj/item/circuitboard/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser
	)

/obj/machinery/r_n_d/destructive_analyzer/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>micro-lasers</b> will increase data gathered from destructive analysis."
	. += "Upgraded <b>scanning modules</b> will increase data gathered from destructive analysis."
	. += "Upgraded <b>manipulators</b> will increase data gathered from destructive analysis."

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	..()
	var/T = 0

	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	decon_mod = T * 0.1

/obj/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/attackby(obj/item/attacking_item, mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy right now."))
		return
	if(loaded_item)
		to_chat(user, SPAN_NOTICE("There is something already loaded into \the [src]."))
		return 1
	if(default_deconstruction_screwdriver(user, attacking_item))
		if(linked_console)
			linked_console.linked_destroy = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return 1
	if(!linked_console)
		to_chat(user, SPAN_NOTICE("\The [src] must be linked to an R&D console first."))
		return
	if(istype(attacking_item, /obj/item) && !loaded_item)
		if(!attacking_item.dropsafety()) //Don't put your module items in there!
			return
		if(!attacking_item.origin_tech)
			to_chat(user, SPAN_NOTICE("This doesn't seem to have a tech origin."))
			return
		if(attacking_item.origin_tech.len == 0)
			to_chat(user, SPAN_NOTICE("You cannot deconstruct this item."))
			return
		busy = 1
		loaded_item = attacking_item
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, SPAN_NOTICE("You add \the [attacking_item] to \the [src]."))
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0
		if(linked_console.screen == 2.1)
			linked_console.screen = 2.2
			linked_console.updateUsrDialog()
		return 1
	return
