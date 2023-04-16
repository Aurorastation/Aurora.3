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

	// in the interest of these tests not taking a million years, we're only going to run tests that change based on what maps are loaded
	whitelisted_test_types = list(
		/datum/unit_test/map_test/ladder_test,
		/datum/unit_test/map_test/bad_doors,
		/datum/unit_test/map_test/bad_firedoors,
		/datum/unit_test/map_test/bad_piping,
		/datum/unit_test/map_test/mapped_products,
		/datum/unit_test/map_test/all_station_areas_shall_be_on_station_zlevels,
		/datum/unit_test/map_test/miscellaneous_map_checks,
		/datum/unit_test/machinery_global_test,
		/datum/unit_test/overmap_ships_shall_have_entrypoints,
		/datum/unit_test/overmap_ships_shall_have_class,
		/datum/unit_test/roundstart_cable_connectivity,
		/datum/unit_test/areas_apc_uniqueness,
		/datum/unit_test/area_power_tally_accuracy,
		/datum/unit_test/zas_active_edges
	)

/obj/effect/overmap/visitable/sector/away_sites_testing
	name = "Away Sites Testing Facility"
	desc = "You shouldn't be seeing this. But c'est la vie."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "runtime_penal_colony"
	color = COLOR_STEEL
	base = TRUE

/datum/map/away_sites_testing/build_away_sites()
	for (var/map in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/A = SSmapping.away_sites_templates[map]
		A.load_new_z()
		testing("[ascii_green]LOADING AWAY SITE:[ascii_reset] Spawning [A] on Z [english_list(GetConnectedZlevels(world.maxz))]")
