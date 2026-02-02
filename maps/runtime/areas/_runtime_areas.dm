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

/area/runtime
	name = "Runtime (PARENT AREA - DON'T USE)"
	icon_state = "unknown"
	station_area = TRUE
	ambience = AMBIENCE_GENERIC
	// Remember to set this for new areas!!
	// horizon_deck = 1, 2, or 3
	// Remember to set this for new areas!!
	// department = constant in '\_DEFINES\departments.dm'
	// Remember to set this for new areas!!
	// subdepartment = constant in '\_DEFINES\departments.dm'
	area_blurb = "One of the compartments of the NSS Runtime."

/area/runtime/exterior
	name = "Runtime - Exterior"
	icon_state = "exterior"
	requires_power = FALSE
	// This area will place starlight on any turf it's put on!
	needs_starlight = TRUE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PREVENT_PERSISTENT_TRASH | AREA_FLAG_NO_GRAVITY | AREA_FLAG_SHIP_EXTERIOR
	area_blurb = "The sheer scale of the NSS Runtime is never more apparent than when tearing apart bugs at 3 AM."

/// CIVILIAN_AREAS
// Hallways
/area/runtime/hallway
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	allow_nightmode = TRUE
	station_area = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE

/area/runtime/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/runtime/hallway/primary/central_one
	name = "Central Primary Hallway"
	icon_state = "hallC1"

/area/runtime/hallway/primary/central_two
	name = "Central Primary Hallway"
	icon_state = "hallC2"

/// COMMAND_AREAS
/area/runtime/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_blurb = "The sound here seems to carry more than others, every click of a shoe or clearing of a throat amplified. The smell of ink, written and printed, wafts notably through the air."
	area_blurb_category = "command"

/// ENGINEERING_AREAS
/area/runtime/engineering
	name = "Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/runtime/engineering/atmos
	name = "Engineering - Atmospherics"
	icon_state = "atmos"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "Many volume tanks filled with gas reside here, some providing vital gases for the vessel's life support systems."
	area_blurb_category = "atmos"

/area/runtime/engineering/gravity_gen
	name = "Engineering - Gravity Generator"
	icon_state = "engine"

/area/runtime/construction
	name = "Engineering Construction Area"
	icon_state = "yellow"
	no_light_control = 1
	station_area = TRUE

/// MAINTENANCE_AREAS
/area/runtime/maintenance
	station_area = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."
	area_blurb_category = "maint"

/area/runtime/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/// MEDICAL_AREAS
/// OPERATIONS_AREAS

// Smalls
/area/runtime/outpost
	ambience = AMBIENCE_EXPOUTPOST

// Main mining
/area/runtime/outpost/mining_main
	icon_state = "outpost_mine_main"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/runtime/outpost/mining_main/eva
	name = "Mining EVA storage"

/// SCIENCE_AREAS
/// SECURITY_AREAS
/// SERVICE_AREAS
/// STORAGE_AREAS
//Storage
/area/runtime/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	allow_nightmode = 1

/// TCOMMS_AREAS
/area/runtime/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/runtime/tcommsat/chamber
	name = "Telecoms Central Compartment"
	icon_state = "tcomsatcham"
	area_blurb = "Countless machines sit here, an unfathomably complicated network that runs every radio and computer connection. The air lacks any notable scent, having been filtered of dust and pollutants before being allowed into the room and all the sensitive machinery."

/area/runtime/tcommsat/computer
	name = "Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/turbolift/main_station
	name = "Civilian Lift - Main"
	lift_announce_str = "Arriving at the Main Level. Facilities on this floor include: Engineering, Medical, Security, Science, Command departments, Cargo Office, Chapel, Bar, Kitchen."

	lift_floor_label = "Main Lvl."
	lift_floor_name = "Main Lvl."

/area/turbolift/main_mid
	name = "Civilian Lift - Mid Level"
	lift_announce_str = "Arriving at (Unknown). Facilities on this floor include: (Unknown)."

	lift_floor_label = "Under construction"
	lift_floor_name = "Under construction"
