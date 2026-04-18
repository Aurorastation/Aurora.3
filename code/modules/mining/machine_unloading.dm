/**********************Unloading unit**************************/

/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	desc = "A machine capable of unloading an ore box or ore scattered on the floor within its input zone, to its output zone."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	is_processing_machine = TRUE
	idle_power_usage = 15
	active_power_usage = 50

	component_types = list(
		/obj/item/circuitboard/unloading_machine,
		/obj/item/stock_parts/manipulator = 2
	)


/obj/machinery/mineral/unloading_machine/Initialize()
	. = ..()
	setup_io()

/obj/machinery/mineral/unloading_machine/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()

/obj/machinery/mineral/unloading_machine/process()
	..()
	if(src.output_turf && src.input_turf)
		if(locate(/obj/structure/ore_box, input_turf))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input_turf)
			var/i = 0
			for(var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.forceMove(output_turf)
				i++
				if(i >= 10)
					return
		if(locate(/obj/item, input_turf))
			var/obj/item/O
			var/i
			for(i = 0; i < 10; i++)
				O = locate(/obj/item, input_turf)
				if(O)
					O.forceMove(output_turf)
				else
					return
	return
