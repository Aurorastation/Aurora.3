/datum/map/runtime
	name = "Runtime Ship"
	full_name = "Runtime Debugging Ship"
	path = "runtime"

	traits = list(
		//Z1
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	force_spawnpoint = TRUE

	lobby_icons = list('icons/misc/titlescreens/runtime/developers.dmi', 'icons/misc/titlescreens/runtime/away.dmi')
	lobby_transitions = FALSE

	admin_levels = list(9)
	contact_levels = list(1, 2)
	player_levels = list(1, 2)
	accessible_z_levels = list(1, 2)

	overmap_event_areas = 10

	station_name = "NSV Runtime"
	station_short = "Runtime"
	dock_name = "singulo"
	boss_name = "#code_dungeon"
	boss_short = "Coders"
	company_name = "BanoTarsen"
	company_short = "BT"
	station_type  = "dumpster"

	//If you're testing overmap stuff, remove the conditional definition
	//#if defined(UNIT_TEST)
	use_overmap = TRUE
	overmap_size = 35
	//#endif

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETA%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	overmap_visitable_type = /obj/effect/overmap/visitable/ship/runtime

	evac_controller_type = /datum/evacuation_controller/starship

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
	)

	num_exoplanets = 1
	planet_size = list(255, 255)

	away_site_budget = 2
	away_ship_budget = 2

	map_shuttles = list(/datum/shuttle/overmap/runtime)
	warehouse_basearea = /area/runtime/storage/primary

ABSTRACT_TYPE(/obj/item/paper/fluff/runtime)

/obj/item/paper/fluff/runtime/dontforgetuseovermap
	name = "Don't Forget use_overmap!"
	info = SPAN_BOLD("Don't forget to remove the conditional preprocessor definition for use_overmap = TRUE in maps\\runtime\\code\\runtime.dm if you want to test overmap things, it's off to load even faster!")
