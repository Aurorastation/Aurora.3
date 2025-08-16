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

	lobby_icon_image_paths = list(list('icons/misc/titlescreens/runtime/test.png'))
	lobby_transitions = 10 SECONDS

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

	map_shuttles = list(/datum/shuttle/autodock/overmap/runtime)
	warehouse_basearea = /area/storage/primary

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

/// CIVILIAN_AREAS
// Hallways
/area/hallway
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	allow_nightmode = TRUE
	station_area = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/central_one
	name = "Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "Central Primary Hallway"
	icon_state = "hallC2"

/// COMMAND_AREAS
/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_blurb = "The sound here seems to carry more than others, every click of a shoe or clearing of a throat amplified. The smell of ink, written and printed, wafts notably through the air."
	area_blurb_category = "command"

/// ENGINEERING_AREAS
/area/engineering
	name = "Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/atmos
	name = "Engineering - Atmospherics"
	icon_state = "atmos"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "Many volume tanks filled with gas reside here, some providing vital gases for the vessel's life support systems."
	area_blurb_category = "atmos"

/area/engineering/gravity_gen
	name = "Engineering - Gravity Generator"
	icon_state = "engine"

/// MAINTENANCE_AREAS
/area/maintenance
	station_area = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."
	area_blurb_category = "maint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/// MEDICAL_AREAS
/// OPERATIONS_AREAS

// Smalls
/area/outpost
	ambience = AMBIENCE_EXPOUTPOST

// Main mining
/area/outpost/mining_main
	icon_state = "outpost_mine_main"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/outpost/mining_main/eva
	name = "Mining EVA storage"

/// SCIENCE_AREAS
/// SECURITY_AREAS
/area/security
	no_light_control = 1
	station_area = FALSE
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/// SERVICE_AREAS
/// STORAGE_AREAS
//Storage
/area/storage
	station_area = TRUE

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	allow_nightmode = 1

/// TCOMMS_AREAS
/area/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/tcommsat/chamber
	name = "Telecoms Central Compartment"
	icon_state = "tcomsatcham"
	area_blurb = "Countless machines sit here, an unfathomably complicated network that runs every radio and computer connection. The air lacks any notable scent, having been filtered of dust and pollutants before being allowed into the room and all the sensitive machinery."

/area/tcommsat/computer
	name = "Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/turbolift/main_station
	name = "Civilian Lift - Main"
	lift_announce_str = "Arriving at the Main Level. Facilities on this floor include: Engineering, Medical, Security, Science, Command departments, Cargo Office, Chapel, Bar, Kitchen."

	lift_floor_label = "Main Lvl."
	lift_floor_name = "Main Lvl."

	base_turf = /turf/simulated/floor/plating

/area/turbolift/main_mid
	name = "Civilian Lift - Mid Level"
	lift_announce_str = "Arriving at (Unknown). Facilities on this floor include: (Unknown)."

	lift_floor_label = "Under construction"
	lift_floor_name = "Under construction"

ABSTRACT_TYPE(/obj/item/paper/fluff/runtime)

/obj/item/paper/fluff/runtime/dontforgetuseovermap
	name = "Don't Forget use_overmap!"
	info = SPAN_BOLD("Don't forget to remove the conditional preprocessor definition for use_overmap = TRUE in maps\\runtime\\code\\runtime.dm if you want to test overmap things, it's off to load even faster!")
