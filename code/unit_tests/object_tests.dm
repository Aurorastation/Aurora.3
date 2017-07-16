/**
 * Tests whether or not all mapped in machinery appear in the SSmachinery.all_machines
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
		if (!SSmachinery.all_machines[M] && !QDELETED(M))
			if (!unfound_types[M.type])
				unfound_types[M.type] = 1
			else
				unfound_types[M.type]++

		if (!all_types[M.type])
			all_types[M.type] = 1

	if (unfound_types.len)
		for (var/t in unfound_types)
			log_unit_test("[ascii_red]--------------- [unfound_types[t]] instances of [t] not found in SSmachinery.all_machines.")

		fail("\[[unfound_types.len] / [all_types.len]\] mapped in machinery types were not found in SSmachinery.all_machines.")
	else
		pass("All \[[all_types.len]\] mapped in machinery types were found in SSmachinery.all_machines.")

	return 1
