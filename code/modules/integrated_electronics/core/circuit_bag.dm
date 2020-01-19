/obj/item/storage/bag/circuits
	name = "circuit kit"
	desc = "This kit is essential for any circuitry projects."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_kit"
	w_class = 3
	display_contents_with_number = 0
	can_hold = list(
		/obj/item/integrated_circuit,
		/obj/item/storage/bag/circuits/mini,
		/obj/item/device/electronic_assembly,
		/obj/item/device/integrated_electronics,
		/obj/item/screwdriver,
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger
	)

/obj/item/storage/bag/circuits/basic/fill()
	new /obj/item/storage/bag/circuits/mini/arithmetic(src)
	new /obj/item/storage/bag/circuits/mini/trig(src)
	new /obj/item/storage/bag/circuits/mini/input(src)
	new /obj/item/storage/bag/circuits/mini/output(src)
	new /obj/item/storage/bag/circuits/mini/memory(src)
	new /obj/item/storage/bag/circuits/mini/manipulation(src)
	new /obj/item/storage/bag/circuits/mini/logic(src)
	new /obj/item/storage/bag/circuits/mini/time(src)
	new /obj/item/storage/bag/circuits/mini/reagents(src)
	new /obj/item/storage/bag/circuits/mini/transfer(src)
	new /obj/item/storage/bag/circuits/mini/converter(src)
	new /obj/item/storage/bag/circuits/mini/power(src)
	new /obj/item/storage/bag/circuits/mini/filter(src)
	new /obj/item/storage/bag/circuits/mini/lists(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/assembly/electronic_assembly(src)
	new /obj/item/device/assembly/electronic_assembly(src)
	new /obj/item/screwdriver(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	make_exact_fit()

/obj/item/storage/bag/circuits/all/fill()
	..()
	new /obj/item/storage/bag/circuits/mini/arithmetic/all(src)
	new /obj/item/storage/bag/circuits/mini/trig/all(src)
	new /obj/item/storage/bag/circuits/mini/input/all(src)
	new /obj/item/storage/bag/circuits/mini/output/all(src)
	new /obj/item/storage/bag/circuits/mini/memory/all(src)
	new /obj/item/storage/bag/circuits/mini/logic/all(src)
	new /obj/item/storage/bag/circuits/mini/smart/all(src)
	new /obj/item/storage/bag/circuits/mini/manipulation/all(src)
	new /obj/item/storage/bag/circuits/mini/time/all(src)
	new /obj/item/storage/bag/circuits/mini/reagents/all(src)
	new /obj/item/storage/bag/circuits/mini/transfer/all(src)
	new /obj/item/storage/bag/circuits/mini/converter/all(src)
	new /obj/item/storage/bag/circuits/mini/power/all(src)
	new /obj/item/storage/bag/circuits/mini/filter/all(src)
	new /obj/item/storage/bag/circuits/mini/lists/all(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/electronic_assembly/medium(src)
	new /obj/item/device/electronic_assembly/large(src)
	new /obj/item/device/electronic_assembly/drone(src)
	new /obj/item/screwdriver(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	make_exact_fit()

/obj/item/storage/bag/circuits/mini
	name = "circuit box"
	desc = "Used to partition categories of circuits, for a neater workspace."
	w_class = 2
	display_contents_with_number = 1
	can_hold = list(/obj/item/integrated_circuit)
	var/spawn_flags_to_use = IC_SPAWN_DEFAULT
	var/list/spawn_types = list()

/obj/item/storage/bag/circuits/mini/fill()
	spawn_types = typecacheof(spawn_types)
	for (var/thing in typecache_filter_list(SSelectronics.flat_circuit_list, spawn_types))
		var/obj/item/integrated_circuit/IC = thing
		if (IC.spawn_flags & spawn_flags_to_use)
			for (var/i in 1 to 4)
				new IC.type(src)

	make_exact_fit()

/obj/item/storage/bag/circuits/mini/arithmetic
	name = "arithmetic circuit box"
	desc = "Warning: Contains math."
	icon_state = "box_arithmetic"
	spawn_types = list(
		/obj/item/integrated_circuit/arithmetic
	)

/obj/item/storage/bag/circuits/mini/arithmetic/all // Don't believe this will ever be needed.
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/trig
	name = "trig circuit box"
	desc = "Danger: Contains more math."
	icon_state = "box_trig"
	spawn_types = list(
		/obj/item/integrated_circuit/trig
	)

/obj/item/storage/bag/circuits/mini/trig/all // Ditto
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/input
	name = "input circuit box"
	desc = "Tell these circuits everything you know."
	icon_state = "box_input"
	spawn_types = list(
		/obj/item/integrated_circuit/input
	)

/obj/item/storage/bag/circuits/mini/input/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/output
	name = "output circuit box"
	desc = "Circuits to interface with the world beyond itself."
	icon_state = "box_output"
	spawn_types = list(
		/obj/item/integrated_circuit/output
	)

/obj/item/storage/bag/circuits/mini/output/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/memory
	name = "memory circuit box"
	desc = "Machines can be quite forgetful without these."
	icon_state = "box_memory"
	spawn_types = list(
		/obj/item/integrated_circuit/memory
	)

/obj/item/storage/bag/circuits/mini/memory/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/logic
	name = "logic circuit box"
	desc = "May or may not be Turing complete."
	icon_state = "box_logic"
	spawn_types = list(
		/obj/item/integrated_circuit/logic
	)

/obj/item/storage/bag/circuits/mini/logic/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/time
	name = "time circuit box"
	desc = "No time machine parts, sadly."
	icon_state = "box_time"
	spawn_types = list(
		/obj/item/integrated_circuit/time
	)

/obj/item/storage/bag/circuits/mini/time/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/reagents
	name = "reagent circuit box"
	desc = "Unlike most electronics, these circuits are supposed to come in contact with liquids."
	icon_state = "box_reagents"
	spawn_types = list(
		/obj/item/integrated_circuit/reagent
	)

/obj/item/storage/bag/circuits/mini/reagents/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/transfer
	name = "transfer circuit box"
	desc = "Useful for moving data representing something arbitrary to another arbitrary virtual place."
	icon_state = "box_transfer"
	spawn_types = list(
		/obj/item/integrated_circuit/transfer
	)

/obj/item/storage/bag/circuits/mini/transfer/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/converter
	name = "converter circuit box"
	desc = "Transform one piece of data to another type of data with these."
	icon_state = "box_converter"
	spawn_types = list(
		/obj/item/integrated_circuit/converter
	)

/obj/item/storage/bag/circuits/mini/converter/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/smart
	name = "smart box"
	desc = "Sentience not included."
	icon_state = "box_ai"
	spawn_types = list(
		/obj/item/integrated_circuit/smart
	)

/obj/item/storage/bag/circuits/mini/smart/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/manipulation
	name = "manipulation box"
	desc = "Make your machines actually useful with these."
	icon_state = "box_manipulation"
	spawn_types = list(
		/obj/item/integrated_circuit/manipulation
	)

/obj/item/storage/bag/circuits/mini/manipulation/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/power
	name = "power circuit box"
	desc = "Electronics generally require electricity."
	icon_state = "box_power"
	spawn_types = list(
		/obj/item/integrated_circuit/passive/power,
		/obj/item/integrated_circuit/power
	)

/obj/item/storage/bag/circuits/mini/power/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/filter
	name = "filter circuit box"
	desc = "Allows to filter input types."
	icon_state = "box_filter"
	spawn_types = list(
		/obj/item/integrated_circuit/filter/ref
	)

/obj/item/storage/bag/circuits/mini/filter/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/lists
	name = "list circuit box"
	desc = "Add some order to your circuits."
	icon_state = "box_lists"
	spawn_types = list(
		/obj/item/integrated_circuit/lists
	)

/obj/item/storage/bag/circuits/mini/lists/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
