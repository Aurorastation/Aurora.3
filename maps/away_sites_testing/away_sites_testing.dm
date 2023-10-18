/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Map"
	path = "away_sites_testing"

	station_levels = list(1)
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)
	lobby_icons = list('icons/misc/titlescreens/runtime/away.dmi')
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

		//Check if the group is in the configuration of this pod, if so, add it to the list of away sites to spawn
		for(var/unit_test_group in A.unit_test_groups)
			if((unit_test_group in SSunit_tests_config.config["map_template_unit_test_groups"]) || (SSunit_tests_config.config["map_template_unit_test_groups"][1] == "*"))
				away_sites_to_spawn += A
				break

	//Spawn the away sites selected in the previous step
	for(var/datum/map_template/ruin/away_site/away_site in away_sites_to_spawn)
		away_site.load_new_z()
		testing("[ascii_green]LOADING AWAY SITE:[ascii_reset] Spawning [away_site] on Z [english_list(GetConnectedZlevels(world.maxz))]")

#else

	for (var/map in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/A = SSmapping.away_sites_templates[map]
		A.load_new_z()
		testing("[ascii_green]LOADING AWAY SITE:[ascii_reset] Spawning [A] on Z [english_list(GetConnectedZlevels(world.maxz))]")
#endif
