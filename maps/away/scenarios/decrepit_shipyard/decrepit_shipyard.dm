/datum/map_template/ruin/away_site/decrepit_shipyard
	name = "Decrepit Shipyard"
	description = "Decrepit Shipyard."
	id = "decrepit_shipyard"

	prefix = "scenarios/decrepit_shipyard/"
	suffix = "decrepit_shipyard.dmm"

	traits = list(
		// Deck 1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck 2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	spawn_cost = 1
	spawn_weight = 0
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/decrepit_shipyard_shuttle)
	unit_test_groups = list(3)

/singleton/submap_archetype/decrepit_shipyard
	map = "Decrepit Shipyard"
	descriptor = "Decrepit Shipyard."

/obj/effect/overmap/visitable/sector/decrepit_shipyard
	name = "Deep-space Shipyard Outpost #117-B"
	desc = "\
		Industrial shipyard outpost, owned by a group of independent businesses. Scanners detect it to be pressurized. \
		Records indicate it to be a shipyard, able to build small vessels but mostly providing repair/maintenance services for the spacefarers who can afford the fee. \
		"
	static_vessel = TRUE
	generic_object = FALSE
	comms_support = TRUE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "depot"
	color = "#afa181"
	designer = "Unknown"
	volume = "74 meters length, 125 meters beam/width, 52 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Outpost"

	initial_generic_waypoints = list(
		// shuttle dock
		"nav_decrepit_shipyard_drydock",
		// south-east docking arm
		"nav_decrepit_shipyard_dock_1a",
		"nav_decrepit_shipyard_dock_1b",
		"nav_decrepit_shipyard_dock_1c",
		"nav_decrepit_shipyard_dock_1d",
		// visitors docking
		"nav_decrepit_shipyard_dock_2a",
		"nav_decrepit_shipyard_dock_2b",
		"nav_decrepit_shipyard_dock_2c",
		"nav_decrepit_shipyard_dock_2d",
		// dry dock (space docking)
		"nav_decrepit_shipyard_dock_3a",
		"nav_decrepit_shipyard_dock_3b",
		"nav_decrepit_shipyard_dock_3c",
		"nav_decrepit_shipyard_dock_3d",
		// space
		"nav_decrepit_shipyard_space_4a",
		"nav_decrepit_shipyard_space_4b",
		"nav_decrepit_shipyard_space_4c",
		"nav_decrepit_shipyard_space_4d"
	)

// ---- Shuttle
/obj/effect/overmap/visitable/ship/landable/decrepit_shipyard_shuttle
	name = "Decrepit Shuttle"
	desc = "A shuttle of dubious origin."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#776145"
	class = "ICV"
	designation = "Your Trash, My Treasure"
	shuttle = "Decrepit Shuttle"
	burn_delay = 2 SECONDS
	vessel_mass = 4000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/decrepit_shipyard_shuttle
	name = "shuttle control console"
	shuttle_tag = "Decrepit Shuttle"

/datum/shuttle/autodock/overmap/decrepit_shipyard_shuttle
	name = "Decrepit Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/decrepit_shipyard_shuttle)
	current_location = "nav_decrepit_shipyard_drydock"
	landmark_transition = "nav_decrepit_shipyard_transit"
	dock_target = "airlock_decrepit_shipyard_shuttle_docking"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_decrepit_shipyard_drydock"
	defer_initialisation = TRUE

// Shuttle starting landmark
/obj/effect/shuttle_landmark/decrepit_shipyard/drydock
	name = "Dry Dock #07-F"
	landmark_tag = "nav_decrepit_shipyard_drydock"
	// there ain't no docking controller, chief
	base_area = /area/space
	base_turf = /turf/space/dynamic
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// Shuttle docking airlock
/obj/effect/map_effect/marker/airlock/shuttle/decrepit_shipyard_shuttle
	name = "Aft Docking Airlock"
	shuttle_tag = "Decrepit Shipyard Shuttle"
	master_tag = "airlock_decrepit_shipyard_shuttle_docking"
	cycle_to_external_air = TRUE

// Shuttle non-docking airlocks

// Port
/obj/effect/map_effect/marker/airlock/decrepit_shipyard_shuttle/port
	name = "Port Airlock"
	master_tag = "airlock_decrepit_shipyard_shuttle_port"
	cycle_to_external_air = TRUE

// Starboard
/obj/effect/map_effect/marker/airlock/decrepit_shipyard_shuttle/starboard
	name = "Starboard Airlock"
	master_tag = "airlock_decrepit_shipyard_shuttle_starboard"
	cycle_to_external_air = TRUE

// Transit landmark
/obj/effect/shuttle_landmark/decrepit_shipyard_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_decrepit_shipyard_transit"
	base_turf = /turf/space/transit/north

// ---- Mapmanip markers

/obj/effect/map_effect/marker/mapmanip/submap/extract/decrepit_shipyard/functional_shuttle
	name = "functional_shuttle"

/obj/effect/map_effect/marker/mapmanip/submap/insert/decrepit_shipyard/functional_shuttle
	name = "functional_shuttle"


