/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null


/obj/machinery/mineral/unloading_machine/Initialize()
	. = ..()
	for (var/dir in cardinal)
		src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(src.input) break
	for (var/dir in cardinal)
		src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(src.output) break

/obj/machinery/mineral/unloading_machine/machinery_process()
	..()
	if (src.output && src.input)
		if (locate(/obj/structure/ore_box, input.loc))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
			var/i = 0
			for (var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.forceMove(output.loc)
				i++
				if (i>=10)
					return
		if (locate(/obj/item, input.loc))
			var/obj/item/O
			var/i
			for (i = 0; i<10; i++)
				O = locate(/obj/item, input.loc)
				if (O)
					O.forceMove(src.output.loc)
				else
					return
	return
