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
		new /obj/item/device/electronic_assembly/default,
		new /obj/item/device/electronic_assembly/calc,
		new /obj/item/device/electronic_assembly/clam,
		new /obj/item/device/electronic_assembly/simple,
		new /obj/item/device/electronic_assembly/hook,
		new /obj/item/device/electronic_assembly/pda,
		new /obj/item/device/electronic_assembly/tiny/default,
		new /obj/item/device/electronic_assembly/tiny/cylinder,
		new /obj/item/device/electronic_assembly/tiny/scanner,
		new /obj/item/device/electronic_assembly/tiny/hook,
		new /obj/item/device/electronic_assembly/tiny/box,
		new /obj/item/device/electronic_assembly/medium/default,
		new /obj/item/device/electronic_assembly/medium/box,
		new /obj/item/device/electronic_assembly/medium/clam,
		new /obj/item/device/electronic_assembly/medium/medical,
		new /obj/item/device/electronic_assembly/medium/gun,
		new /obj/item/device/electronic_assembly/medium/radio,
		new /obj/item/device/electronic_assembly/large/default,
		new /obj/item/device/electronic_assembly/large/scope,
		new /obj/item/device/electronic_assembly/large/terminal,
		new /obj/item/device/electronic_assembly/large/arm,
		new /obj/item/device/electronic_assembly/large/tall,
		new /obj/item/device/electronic_assembly/large/industrial,
		new /obj/item/device/electronic_assembly/drone/default,
		new /obj/item/device/electronic_assembly/drone/arms,
		new /obj/item/device/electronic_assembly/drone/secbot,
		new /obj/item/device/electronic_assembly/drone/medbot,
		new /obj/item/device/electronic_assembly/drone/genbot,
		new /obj/item/device/electronic_assembly/drone/android,
		new /obj/item/device/electronic_assembly/wallmount/tiny,
		new /obj/item/device/electronic_assembly/wallmount/light,
		new /obj/item/device/electronic_assembly/wallmount,
		new /obj/item/device/electronic_assembly/wallmount/heavy,
		new /obj/item/implant/integrated_circuit,
		new /obj/item/clothing/under/circuitry,
		new /obj/item/clothing/gloves/circuitry,
		new /obj/item/clothing/glasses/circuitry,
		new /obj/item/clothing/shoes/circuitry,
		new /obj/item/clothing/head/circuitry,
		new /obj/item/clothing/ears/circuitry,
		new /obj/item/clothing/suit/circuitry
	)

	printer_recipe_list["Tools"] = list(
		new /obj/item/device/integrated_electronics/wirer,
		new /obj/item/device/integrated_electronics/debugger,
		new /obj/item/device/integrated_electronics/detailer
	)

	..()

#undef IC_SPAWN_DEFAULT
#undef IC_SPAWN_RESEARCH
