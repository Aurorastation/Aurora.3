/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules.
*/

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter
	name = "circuit imprinter"
	desc = "An advanced device that can only be operated via a nearby RnD console, it can print any circuitboard the user requests, provided it has the correct materials to do so."
	icon_state = "circuit_imprinter"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	idle_power_usage = 30
	active_power_usage = 2500
	build_type = IMPRINTER
	uses_reagents = TRUE
	fabrication_loop_type = /datum/looping_sound/synth_fab
	component_types = list(
		/obj/item/circuitboard/circuit_imprinter,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_containers/glass/beaker = 2
	)

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "- Materials are drawn from the research material silo linked to the same R&D console."
	. += "- Upgraded <b>manipulators</b> will improve material use efficiency and increase fabrication speed."
	. += SPAN_NOTICE("	- The current speed increase is <b>[round((1 - (1 / production_speed)) * 100)]%</b>")
	. += SPAN_NOTICE("	- The current cost reduction is <b>[round((1 - mat_efficiency) * 100)]%</b>")

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter/RefreshParts()
	..()
	var/total_volume = 0
	for(var/obj/item/reagent_containers/glass/beaker in component_parts)
		total_volume += beaker.reagents.maximum_volume
	create_reagents(total_volume)
	for(var/obj/item/reagent_containers/glass/beaker in component_parts)
		beaker.reagents.trans_to_obj(src, beaker.reagents.total_volume)

	var/manipulator_rating = 0
	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		manipulator_rating += manipulator.rating
	mat_efficiency = 1 - (manipulator_rating - 1) / 8
	production_speed = manipulator_rating
	update_icon()

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(build_callback_timer)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter/dismantle()
	for(var/obj/item/reagent_containers/glass/beaker in component_parts)
		reagents.trans_to_obj(beaker, reagents.total_volume)
	..()

/obj/structure/machinery/r_n_d/fabricator/circuit_imprinter/is_open_container()
	. = ..()
	linked_console?.dispatch_fabrication_jobs()
