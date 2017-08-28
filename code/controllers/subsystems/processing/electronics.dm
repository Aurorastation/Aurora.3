#define IC_SPAWN_DEFAULT			1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 			2 // If the circuit design will be available in the IC printer after upgrading it.

/var/datum/controller/subsystem/processing/electronics/SSelectronics

/datum/controller/subsystem/processing/electronics
	name = "Electronics"
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING
	init_order = SS_INIT_MISC_FIRST

	var/list/all_integrated_circuits = list()
	var/list/printer_recipe_list = list()

/datum/controller/subsystem/processing/electronics/New()
	NEW_SS_GLOBAL(SSelectronics)

/datum/controller/subsystem/processing/electronics/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(!QDELETED(thing))
			thing.process()
		else
			processing -= thing

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/processing/electronics/Initialize(timeofday)
	for(var/thing in subtypesof(/obj/item/integrated_circuit))
		all_integrated_circuits += new thing()
		CHECK_TICK

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
	var/list/assembly_list = list(
		new /obj/item/device/electronic_assembly,
		new /obj/item/device/electronic_assembly/medium,
		new /obj/item/device/electronic_assembly/large,
		new /obj/item/device/electronic_assembly/drone,
		new /obj/item/device/assembly/electronic_assembly
	)
	printer_recipe_list["Assemblies"] = assembly_list

	var/list/tools_list = list(
		new /obj/item/device/integrated_electronics/wirer,
		new /obj/item/device/integrated_electronics/debugger
	)
	printer_recipe_list["Tools"] = tools_list

	..()

#undef IC_SPAWN_DEFAULT
#undef IC_SPAWN_RESEARCH 
