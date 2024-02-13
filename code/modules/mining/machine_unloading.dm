/**********************Unloading unit**************************/

/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	desc = "A machine capable of unloading an ore box or ore scattered on the floor within its input zone, to its output zone."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 15
	active_power_usage = 50
	var/turf/input
	var/turf/output

	component_types = list(
		/obj/item/circuitboard/unloading_machine,
		/obj/item/stock_parts/manipulator = 2
	)


/obj/machinery/mineral/unloading_machine/Initialize()
	. = ..()

	//Locate our output and input machinery.
	for(var/dir in GLOB.cardinal)
		var/input_spot = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input_spot)
			input = get_turf(input_spot) // thought of qdeling the spots here, but it's useful when rebuilding a destroyed machine
			break
	for(var/dir in GLOB.cardinal)
		var/output_spot = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			output = get_turf(output_spot)
			break

	if(!input)
		input = get_step(src, GLOB.reverse_dir[dir])
	if(!output)
		output = get_step(src, dir)

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
	if(src.output && src.input)
		if(locate(/obj/structure/ore_box, input))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input)
			var/i = 0
			for(var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.forceMove(output)
				i++
				if(i >= 10)
					return
		if(locate(/obj/item, input))
			var/obj/item/O
			var/i
			for(i = 0; i < 10; i++)
				O = locate(/obj/item, input)
				if(O)
					O.forceMove(output)
				else
					return
	return
