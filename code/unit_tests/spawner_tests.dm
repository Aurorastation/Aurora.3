/*
 *
 *  Unit Test Template
 *  This file is not used.
 *
 */

datum/unit_test/template
	name = "Ghost Spawner Tests"		// If it's a template leave the word "template" in it's name so it's not ran.
	

datum/unit_test/template/start_test()
	var/list/ignore_spawners = list(
		/datum/ghostspawner/human,
		/datum/ghostspawner/human/admin,
		/datum/ghostspawner/human/admin/corporate,
		/datum/ghostspawner/simplemob,
		/datum/ghostspawner/human/ert
		)
	var/failed_checks = 0
	var/checks = 0

	for(var/spawner in subtypesof(/datum/ghostspawner))
		checks++
		var/datum/ghostspawner/G = new spawner
		if(instances_of_type_in_list(G,ignore_spawners, strict = TRUE))
			continue
		//Check if we hae name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			log_unit_test("[ascii_red]--------------- Invalid Spawner: Type:[G.type], Short-Name:[G.short_name], Name:[G.name]")
			failed_checks++

	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Ghost Spawners are invalid")
	else
		pass("All Ghost Spawners are valid.")


	return 1
// ============================================================================
