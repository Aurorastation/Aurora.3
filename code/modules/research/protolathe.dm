/obj/structure/machinery/r_n_d/fabricator/protolathe
	name = "protolathe"
	desc = "An upgraded variant of a common Autolathe, this can only be operated via a nearby RnD console, but can manufacture cutting edge technology, provided it has the design and the correct materials."
	icon_state = "protolathe"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	idle_power_usage = 30 WATTS
	active_power_usage = 25 KILO WATTS
	build_type = PROTOLATHE
	uses_reagents = TRUE
	fabrication_loop_type = /datum/looping_sound/synth_fab
	component_types = list(
		/obj/item/circuitboard/protolathe,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2
	)

/obj/structure/machinery/r_n_d/fabricator/protolathe/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "- Materials are drawn from the research material silo linked to the same R&D console."
	. += "- Upgraded <b>manipulators</b> will improve material use efficiency and increase fabrication speed."
	. += SPAN_NOTICE("	- The current speed increase is <b>[round((1 - (1 / production_speed)) * 100)]%</b>")
	. += SPAN_NOTICE("	- The current cost reduction is <b>[round((1 - mat_efficiency) * 100)]%</b>")

/obj/structure/machinery/r_n_d/fabricator/protolathe/RefreshParts()
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
	mat_efficiency = 1 - (manipulator_rating - 2) / 8
	production_speed = manipulator_rating / 2
	update_icon()

/obj/structure/machinery/r_n_d/fabricator/protolathe/dismantle()
	for(var/obj/item/reagent_containers/glass/beaker in component_parts)
		reagents.trans_to_obj(beaker, reagents.total_volume)
	..()

/obj/structure/machinery/r_n_d/fabricator/protolathe/power_change()
	. = ..()
	update_icon()

/obj/structure/machinery/r_n_d/fabricator/protolathe/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(!(stat & (NOPOWER | BROKEN)))
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(build_callback_timer)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/structure/machinery/r_n_d/fabricator/protolathe/is_open_container()
	. = ..()
	linked_console?.dispatch_fabrication_jobs()
