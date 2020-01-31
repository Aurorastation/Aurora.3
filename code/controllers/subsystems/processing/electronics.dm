#define IC_SPAWN_DEFAULT  1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 2 // If the circuit design will be available in the IC printer after upgrading it.

/var/datum/controller/subsystem/processing/electronics/SSelectronics

/datum/controller/subsystem/processing/electronics
	name = "Electronics"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ELECTRONICS
	flags = SS_KEEP_TIMING
	init_order = SS_INIT_MISC_FIRST

	// List of all types related to circuits
	var/list/all_integrated_circuits = list()
	var/list/all_assemblies = list()

	// Special types, needed for clothing circuits
	var/list/special_paths = list()

	// A list with circuits and assemblies to check their parameters
	var/list/cached_circuits = list()
	var/list/cached_assemblies = list()

	// Array of cached circuits, needed for circuit bags to work
	var/list/flat_circuit_list = list()

	var/list/printer_recipe_list = list()

	var/cipherkey

	var/cost_multiplier = SHEET_MATERIAL_AMOUNT / 10

/datum/controller/subsystem/processing/electronics/New()
	NEW_SS_GLOBAL(SSelectronics)

/datum/controller/subsystem/processing/electronics/Initialize(timeofday)
	cipherkey = generateRandomString(2000+rand(0,10))
	circuits_init()
	..()

/datum/controller/subsystem/processing/electronics/proc/circuits_init()
	var/list/special = list(
		/obj/item/clothing/under/circuitry,
		/obj/item/clothing/gloves/circuitry,
		/obj/item/clothing/glasses/circuitry,
		/obj/item/clothing/shoes/circuitry,
		/obj/item/clothing/head/circuitry,
		/obj/item/clothing/ears/circuitry,
		/obj/item/clothing/suit/circuitry,
		/obj/item/implant/integrated_circuit
	)

	//Cached lists for free performance
	var/atom/def = /obj/item/integrated_circuit
	var/default_name = initial(def.name)
	for(var/path in typesof(/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = path
		var/name = initial(IC.name)
		if(name == default_name)
			continue
		all_integrated_circuits[name] = path // Populating the component lists
		cached_circuits[IC] = new path()
		flat_circuit_list += cached_circuits[IC]

		if(!(initial(IC.spawn_flags) & (IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH)))
			continue

		var/category = initial(IC.category_text)
		if(!printer_recipe_list[category])
			printer_recipe_list[category] = list()
		var/list/category_list = printer_recipe_list[category]
		category_list += IC // Populating the fabricator categories

	for(var/path in typesof(/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/A = path
		var/name = initial(A.name)
		all_assemblies[name] = path
		cached_assemblies[A] = new path()

	// Saving special cases
	for(var/path in special)
		var/obj/A = path
		var/name = initial(A.name)
		special_paths[name] = path


	// Specific Recipe Lists
	printer_recipe_list["Assemblies"] = subtypesof(/obj/item/device/electronic_assembly) -\
		typesof(/obj/item/device/electronic_assembly/clothing) - /obj/item/device/electronic_assembly/implant +\
		special

	printer_recipe_list["Tools"] = list(
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger,
		/obj/item/device/integrated_electronics/analyzer,
		/obj/item/device/integrated_electronics/detailer,
		/obj/item/card/data,
		//obj/item/card/data/full_color,
		//obj/item/card/data/disk
	)
	
#undef IC_SPAWN_DEFAULT
#undef IC_SPAWN_RESEARCH
