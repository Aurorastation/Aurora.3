/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/structure/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	desc = "A specialized research analysis unit that evaluates custom prototype weaponry and botanical seed strains for corporate R&D contracts, as well as planetary survey data disks."
	icon_state = "d_analyzer"
	var/obj/loaded_item = null
	var/decon_mod = 0

	idle_power_usage = 30
	active_power_usage = 2500

	component_types = list(
		/obj/item/circuitboard/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser
	)

/obj/structure/machinery/r_n_d/destructive_analyzer/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>micro-lasers</b> will increase data gathered from destructive analysis."
	. += "Upgraded <b>scanning modules</b> will increase data gathered from destructive analysis."
	. += "Upgraded <b>manipulators</b> will increase data gathered from destructive analysis."

/obj/structure/machinery/r_n_d/destructive_analyzer/RefreshParts()
	..()
	var/T = 0

	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	decon_mod = T * 0.1

/obj/structure/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/structure/machinery/r_n_d/destructive_analyzer/attackby(obj/item/attacking_item, mob/user)
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
		if(!istype(attacking_item, /obj/item/gun/energy/laser/prototype) && !istype(attacking_item, /obj/item/seeds) && !istype(attacking_item, /obj/item/slime_extract) && !istype(attacking_item, /obj/item/electronic_assembly) && !istype(attacking_item, /obj/item/disk/survey_data))
			to_chat(user, SPAN_WARNING("\The [src] only accepts custom prototype energy weapons, plant seed packets, slime extracts, custom electronic assemblies, planetary survey data disks, or drag-and-dropped alien artifacts."))
			return
		return load_object(attacking_item, user)
	return

/obj/structure/machinery/r_n_d/destructive_analyzer/proc/load_object(obj/O, mob/user)
	if(!O || !user)
		return FALSE
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy right now."))
		return FALSE
	if(loaded_item)
		to_chat(user, SPAN_NOTICE("There is something already loaded into \the [src]."))
		return FALSE
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return FALSE
	if(!linked_console)
		to_chat(user, SPAN_NOTICE("\The [src] must be linked to an R&D console first."))
		return FALSE

	busy = 1
	loaded_item = O
	if(istype(O, /obj/item))
		user.drop_from_inventory(O, src)
	else
		O.forceMove(src)
	to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]."))
	flick("d_analyzer_la", src)
	spawn(10)
		update_icon()
		busy = 0
	if(linked_console.screen == 2.1)
		linked_console.screen = 2.2
		linked_console.updateUsrDialog()
	return TRUE
