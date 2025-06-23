#if defined(UNIT_TEST)

/datum/map/exoplanet_testing
	name = "Exoplanet Testing"
	full_name = "Exoplanet Testing Map"
	path = "exoplanet_testing"

	traits = list(
		//Z1
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = FALSE),
	)

	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)
	lobby_icon_image_paths = list('icons/misc/titlescreens/runtime/test.png')
	lobby_transitions = 10 SECONDS
	allowed_spawns = list()

	use_overmap = TRUE
	planet_size = list(255, 255)

	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)

/obj/effect/overmap/visitable/sector/exoplanet_testing
	name = "Exoplanet Testing Facility"
	desc = "You shouldn't be seeing this. But c'est la vie."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "runtime_penal_colony"
	color = COLOR_STEEL
	base = TRUE

/datum/map/exoplanet_testing/build_exoplanets()
	var/list/all_ruins = list()
	for(var/T in subtypesof(/datum/map_template/ruin/exoplanet))
		var/datum/map_template/ruin/exoplanet/ruin = T
		if((initial(ruin.template_flags) & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
			continue
		all_ruins += new ruin

	all_ruins = build_exoplanets_for_testing(all_ruins)


	var/sanity_count = 0
	while(all_ruins.len)
		sanity_count++
		var/types_needed = 0
		var/planets_to_spawn = list()

		for(var/datum/map_template/ruin/exoplanet/R in all_ruins)
			if(!R.planet_types)
				continue
			types_needed |= R.planet_types

		for(var/EP in subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
			var/obj/effect/overmap/visitable/sector/exoplanet/E = EP
			if(initial(E.ruin_planet_type) & types_needed)
				planets_to_spawn += EP
				var/PT = initial(E.ruin_planet_type)
				types_needed &= ~PT

		all_ruins = build_exoplanets_for_testing(all_ruins, planets_to_spawn)

		if(!planets_to_spawn || (sanity_count > 5))
			//Build a list of types
			var/list/types_fail_list = list()
			for(var/datum/map_template/ruin/exoplanet/ruin as anything in all_ruins)
				types_fail_list += ruin.type

			SSunit_tests_config.UT.fail(TEST_OUTPUT_RED("**** FAILED SPAWNING RUINS: [sanity_count > 5 ? "EXCEEDED SANITY COUNT" : "NO VALID PLANETS"] \
										for ruins [english_list(types_fail_list)] ****"), __FILE__, __LINE__)
			break

/datum/map/exoplanet_testing/proc/build_exoplanets_for_testing(list/ruins_to_test = list(), list/exoplanet_types = subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
	for(var/exoplanet_type in exoplanet_types)

		var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = exoplanet_type

		var/list/ruins_to_spawn = list()
		if(!initial(new_planet.ruin_planet_type) || initial(new_planet.ruin_planet_type) == PLANET_LORE)
			continue

		new_planet = new new_planet(null, planet_size[1], planet_size[2], being_generated_for_unit_test = TRUE)

		//Check if the planet decided to delete itself, that should mean (in this test) that the unit test group does not match,
		//if so, leave it alone and continue with the rest
		if(QDELETED(new_planet))
			SSunit_tests_config.UT.debug("**** The exoplanet type [exoplanet_type] was not generated, as it does not belong to this test group ****", __FILE__, __LINE__)

			for(var/datum/map_template/ruin/exoplanet/R in ruins_to_test)

				if(new_planet.ruin_planet_type & R.planet_types)
					SSunit_tests_config.UT.debug("**** Ruin [R.name] - [R.type] got the exoplanet type of [new_planet.type] removed,\
													as this exoplanet does not load in this unit test pod****", __FILE__, __LINE__)
					R.planet_types &= ~new_planet.ruin_planet_type

					if(!(R.planet_types))
						SSunit_tests_config.UT.debug("**** Ruin [R.name] - [R.type] got removed from the list of valid ruins to test in this pod,\
													as it had no suitable planets left that can run in this pod****", __FILE__, __LINE__)
						ruins_to_test -= R

			continue //Proceed to check the next exoplanet type

		for(var/datum/map_template/ruin/exoplanet/R in ruins_to_test)
			if(new_planet.ruin_planet_type & R.planet_types)
				ruins_to_spawn |= R

		testing(TEST_OUTPUT_GREEN("LOADING EXOPLANET: Spawning [new_planet.name] on Z [english_list(GetConnectedZlevels(world.maxz))]"))
		testing("With ruins: [english_list(ruins_to_spawn)]")

		new_planet.build_level_for_testing(ruins_to_spawn)

		for(var/datum/map_template/ruin/exoplanet/R in new_planet.spawned_features)
			ruins_to_test -= R

	return ruins_to_test

/obj/effect/overmap/visitable/sector/exoplanet/proc/build_level_for_testing(list/ruins_to_spawn)
	generate_habitability()
	generate_atmosphere()
	generate_map()
	spawned_features = seedRuins(map_z, features_budget, ruins_to_spawn, /area/exoplanet, maxx, maxy, ignore_sector = TRUE)
	generate_landing(2)
	update_biome()
	generate_planet_image()
	START_PROCESSING(SSprocessing, src)

/datum/map/exoplanet_testing/build_away_sites()
	return

#endif //UNIT_TEST
