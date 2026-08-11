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
	#if defined(UNIT_TEST)
	use_overmap = TRUE
	overmap_size = 35
	#endif

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

	map_shuttles = list(
		/datum/shuttle/autodock/overmap/runtime,
		/datum/shuttle/autodock/ferry/supply/horizon,
	)

	warehouse_basearea = /area/runtime/floor_one/warehouse
	warehouse_packagearea = /area/runtime/floor_one/warehouse/package

/**
 * This file is the only location in which runtime map areas should be defined.
 * Each department (or other appropriate grouping) will have its own section that you can jump to with ctrl-f.
 * For convenience, these groupings are:
 * * CREW_AREAS
 * * COMMAND_AREAS
 * * ENGINEERING_AREAS
 * * MAINTENANCE_AREAS
 * * MEDICAL_AREAS
 * * OPERATIONS_AREAS
 * * SCIENCE_AREAS
 * * SECURITY_AREAS
 * * SERVICE_AREAS
 * * TCOMMS_AREAS
 *
 * GUIDELINES:
 * * The Horizon should not have any areas mapped to it which are defined outside this file.
 * * Any PR that removes all areas of a given definition should also remove that definition from this file.
 * * No area should exist across multiple decks. Ex., an elevator vestibule on all three decks should have three child definitions, one for each deck. This is both for organization and for managing area objects like APCs etc.
 * * Update the groupings list if anything is added/removed.
 */

// ---- Base type
/area/runtime
	allow_nightmode = TRUE
	station_area = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE
	area_lighting = LIGHT_COLOR_HALOGEN

// ---- Floor one
/area/runtime/floor_one/main
	name = "Runtime - Main Area"
	icon_state = "hallC1"

/area/runtime/floor_one/construction
	name = "Runtime - Construction Area"
	icon_state = "yellow"

/area/runtime/floor_one/atmospherics
	name = "Runtime - Atmoshperics"
	icon_state = "yellow"

/area/runtime/floor_one/warehouse
	name = "Runtime - Warehouse"
	icon_state = "dark128"

/area/runtime/floor_one/warehouse/package
	name = "Runtime - Package Area"
	icon_state = "dark160"
	requires_power = FALSE

// ---- Floor two
/area/runtime/floor_two/main
	name = "Runtime - Second Floor"
	icon_state = "hallC2"

/area/runtime/floor_two/comms
	name = "Runtime - Telecommunications"
	icon_state = "ai_chamber"

/area/runtime/floor_two/bridge
	name = "Runtime - Bridge"
	icon_state = "bridge"

// ---- Exterior
/area/runtime/exterior
	name = "Exterior"
	icon_state = "exterior"
	needs_starlight = TRUE
	has_gravity = FALSE
	station_area = TRUE
	requires_power = FALSE
	ambience = AMBIENCE_SPACE

// ---- Papers
ABSTRACT_TYPE(/obj/item/paper/fluff/runtime)

/obj/item/paper/fluff/runtime/dontforgetuseovermap
	name = "Don't Forget use_overmap!"
	info = SPAN_BOLD("Don't forget to remove the conditional preprocessor definition for use_overmap = TRUE in maps\\runtime\\code\\runtime.dm if you want to test overmap things, it's off to load even faster!")
