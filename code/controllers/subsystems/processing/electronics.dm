#define IC_SPAWN_DEFAULT  1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 2 // If the circuit design will be available in the IC printer after upgrading it.

/var/datum/controller/subsystem/processing/electronics/SSelectronics

/datum/controller/subsystem/processing/electronics
	name = "Electronics"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ELECTRONICS
	flags = SS_KEEP_TIMING
	init_order = SS_INIT_MISC_FIRST

	var/list/all_integrated_circuits = list()
	var/list/printer_recipe_list = list()

/datum/controller/subsystem/processing/electronics/New()
	NEW_SS_GLOBAL(SSelectronics)

/datum/controller/subsystem/processing/electronics/Initialize(timeofday)
	init_subtypes(/obj/item/integrated_circuit, all_integrated_circuits)

	// First loop is to seperate the actual circuits from base circuits.
	var/list/circuits_to_use = list()
	for(var/obj/item/integrated_circuit/IC in all_integrated_circuits)
		if((IC.spawn_flags & (IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH)))
			circuits_to_use += IC

	// Second loop is to find all categories.
	var/list/found_categories = list()
	for(var/obj/item/integrated_circuit/IC in circuits_to_use)
		if(!(IC.category_text in found_categories))
			found_categories += IC.category_text

	// Third loop is to initialize lists by category names, then put circuits matching the category inside.
	for(var/category in found_categories)
		printer_recipe_list[category] = list()
		var/list/current_list = printer_recipe_list[category]
		for(var/obj/item/integrated_circuit/IC in circuits_to_use)
			if(IC.category_text == category)
				current_list += IC

	// Now for non-circuit things.
	printer_recipe_list["Assemblies"] = list(
		new /obj/item/device/electronic_assembly,
		new /obj/item/device/electronic_assembly/medium,
		new /obj/item/device/electronic_assembly/large,
		new /obj/item/device/electronic_assembly/drone,
		new /obj/item/weapon/implant/integrated_circuit,
		new /obj/item/device/assembly/electronic_assembly
	)

	printer_recipe_list["Tools"] = list(
		new /obj/item/device/integrated_electronics/wirer,
		new /obj/item/device/integrated_electronics/debugger
	)

	..()

#undef IC_SPAWN_DEFAULT
#undef IC_SPAWN_RESEARCH
