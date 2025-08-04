/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Map"
	path = "away_sites_testing"

	traits = list(
		//Z1
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = FALSE),
	)

	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)
	lobby_icon_image_paths = list(list('icons/misc/titlescreens/runtime/test.png'))
	lobby_transitions = 10 SECONDS
	allowed_spawns = list()

	use_overmap = TRUE

	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)

/obj/effect/overmap/visitable/sector/away_sites_testing
	name = "Away Sites Testing Facility"
	desc = "You shouldn't be seeing this. But c'est la vie."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "runtime_penal_colony"
	color = COLOR_STEEL
	base = TRUE

/datum/map/away_sites_testing/build_away_sites()
#ifdef UNIT_TEST
	//Build a list of away sites to spawn, based on the group
	var/list/away_sites_to_spawn = list()

	for (var/map in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/A = SSmapping.away_sites_templates[map]

		if(!length(A.unit_test_groups))
			SSunit_tests_config.UT.fail("**** The away site --> [A.name] - [A.type] <-- does not have any unit test group set! ****", __FILE__, __LINE__)

		//Check if the group is in the configuration of this pod, if so, add it to the list of away sites to spawn
		for(var/unit_test_group in A.unit_test_groups)
			if((unit_test_group in SSunit_tests_config.config["map_template_unit_test_groups"]) || (SSunit_tests_config.config["map_template_unit_test_groups"][1] == "*"))
				away_sites_to_spawn += A
				break

	//Spawn the away sites selected in the previous step
	for(var/datum/map_template/ruin/away_site/away_site in away_sites_to_spawn)
		// load the site
		var/bounds = away_site.load_new_z()

		// do away site exoplanet generation, if needed
		if(away_site.exoplanet_themes)
			for(var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
				for(var/marker_turf_type in away_site.exoplanet_themes)
					var/datum/exoplanet_theme/exoplanet_theme_type = away_site.exoplanet_themes[marker_turf_type]
					var/datum/exoplanet_theme/exoplanet_theme = new exoplanet_theme_type()
					exoplanet_theme.generate_map(z_index, 1, 1, 254, 254, marker_turf_type)


		// fin
		testing("LOADING AWAY SITE: Spawning [away_site] on Z [english_list(GetConnectedZlevels(world.maxz))]")

#else

	for (var/map in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/away_site = SSmapping.away_sites_templates[map]

		// load the site
		var/bounds = away_site.load_new_z()

		// do away site exoplanet generation, if needed
		if(away_site.exoplanet_themes)
			for(var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
				for(var/marker_turf_type in away_site.exoplanet_themes)
					var/datum/exoplanet_theme/exoplanet_theme_type = away_site.exoplanet_themes[marker_turf_type]
					var/datum/exoplanet_theme/exoplanet_theme = new exoplanet_theme_type()
					exoplanet_theme.generate_map(z_index, 1, 1, 254, 254, marker_turf_type)

		// fin
		testing("LOADING AWAY SITE: Spawning [away_site] on Z [english_list(GetConnectedZlevels(world.maxz))]")
#endif
