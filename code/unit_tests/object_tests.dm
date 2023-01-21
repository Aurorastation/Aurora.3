/**
 * Tests whether or not all mapped in machinery appear in the SSmachinery.machinery
 * list after round start.
 *
 * It's not exactly the most robust, but it'll catch basic faults in new machinery
 * design.
 */
/datum/unit_test/machinery_global_test
	name = "OBJECTS: Machinery Global List Test"

/datum/unit_test/machinery_global_test/start_test()
	var/list/all_types = list()
	var/list/unfound_types = list()

	for (var/obj/machinery/M in world)
		if (!LAZYISIN(SSmachinery.machinery, M) && !QDELETED(M))
			if (!unfound_types[M.type])
				unfound_types[M.type] = 1
			else
				unfound_types[M.type]++

		if (!all_types[M.type])
			all_types[M.type] = 1

	if (unfound_types.len)
		for (var/t in unfound_types)
			log_unit_test("[ascii_red]--------------- [unfound_types[t]] instances of [t] not found in SSmachinery.machinery.")

		fail("\[[unfound_types.len] / [all_types.len]\] mapped in machinery types were not found in SSmachinery.machinery.")
	else
		pass("All \[[all_types.len]\] mapped in machinery types were found in SSmachinery.machinery.")

	return 1

/**
 * Tests whether all floor tiles have a unique or null build type. Else constructing them may result in the wrong turf.
 */
/datum/unit_test/flooring_build_type_conflicts
	name = "OBJECTS: All flooring shall have a unique build type"

/datum/unit_test/flooring_build_type_conflicts/start_test()
	var/list/known_types = list()
	var/list/decls = GET_SINGLETON_SUBTYPE_MAP(/singleton/flooring)
	for(var/flooring_type in decls)
		var/singleton/flooring/F = decls[flooring_type]
		if(!isnull(F.build_type))
			known_types += F.build_type

	if(known_types.len == length(uniquelist(known_types)))
		pass("All flooring types had a unique or null build type.")
	else
		for(var/type in known_types)
			var/i = 0
			for(var/flooring_type in known_types)
				if(flooring_type == type)
					i++
			if(i != 1)
				log_unit_test("[ascii_red]--------------- Flooring build_type [type] is non-unique; exists [i] times.")
		fail("Found non-unique build_types in flooring decl.")

	return TRUE

/datum/unit_test/check_vending_products
	name = "OBJECTS: All vending products shall be /obj subtypes"

/datum/unit_test/check_vending_products/start_test()
	var/list/vending_products = list()
	var/list/valid_keys = list()
	for(var/v_type in typesof(/obj/machinery/vending))
		var/obj/machinery/vending/V = new v_type
		for(var/list/p in list(V.products, V.contraband, V.premium))
			for(var/k in p)
				vending_products += k
				if(!ispath(k, /obj))
					log_unit_test("Vending product [k] in vending machine [V] is not a subtype of /obj")
				else
					valid_keys += k

	if(length(valid_keys) == length(vending_products))
		pass("All vending products are /obj subtypes")
	else
		fail("Some vending products are not /obj subtypes")

	return TRUE
