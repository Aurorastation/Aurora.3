/datum/map_template/ruin/away_site/yacht_civ
	name = "Civilian Yacht"
	description = "???"
	suffixes = list("ships/yacht_civ/yacht_civ.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "yacht_civ"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scc_scout_shuttle)
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/yacht_civ
	map = "Civilian Yacht"
	descriptor = "???"

// ship

/obj/effect/overmap/visitable/ship/yacht_civ
	name = "Civilian Yacht"
	class = "ICV"
	desc = "???"
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	designer = "Einstein Engines"
	volume = "63 meters length, 24 meters beam/width, 20 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "None"
	sizeclass = "Diamond-class Yacht"
	shiptype = "??? yacht"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = TRUE
	// initial_restricted_waypoints = list(
	// 	"SCC Scout Shuttle" = list("nav_scc_scout_shuttle_dock")
	// )
	// initial_generic_waypoints = list(
	// 	"nav_scc_scout_dock_starboard",
	// 	"nav_scc_scout_dock_port",
	// 	"nav_scc_scout_dock_aft",
	// 	"nav_scc_scout_catwalk_aft",
	// 	"nav_scc_scout_catwalk_fore_starboard",
	// 	"nav_scc_scout_catwalk_fore_port",
	// 	"nav_scc_scout_space_fore_starboard",
	// 	"nav_scc_scout_space_fore_port",
	// 	"nav_scc_scout_space_aft_starboard",
	// 	"nav_scc_scout_space_aft_port",
	// 	"nav_scc_scout_space_port_far",
	// 	"nav_scc_scout_space_starboard_far",
	// )

/obj/effect/overmap/visitable/ship/yacht_civ/New()
	designation = pick("Makemake")
	..()

// shuttle

/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle
	name = "Civilian Yacht Shuttle"
	class = "ICV"
	desc = "???"
	shuttle = "Civilian Yacht Shuttle"
	icon_state = "intrepid"
	moving_state = "intrepid_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Einstein Engines"
	volume = "10 meters length, 7 meters beam/width, 6 meters vertical height"
	sizeclass = "Glass-class Shuttle"
	shiptype = "???"

/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle/New()
	designation = pick("Iapetus")
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/scc_scout_shuttle
	name = "shuttle control console"
	shuttle_tag = "Civilian Yacht Shuttle"

/datum/shuttle/autodock/overmap/scc_scout_shuttle
	name = "Civilian Yacht Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/yacht_civ_shuttle/cockpit, /area/shuttle/yacht_civ_shuttle/eva, /area/shuttle/yacht_civ_shuttle/cargo, /area/shuttle/yacht_civ_shuttle/medbay, /area/shuttle/yacht_civ_shuttle/propulsion_starboard, /area/shuttle/yacht_civ_shuttle/propulsion_port)
	dock_target = "airlock_scc_scout_shuttle"
	current_location = "nav_scc_scout_shuttle_dock"
	landmark_transition = "nav_scc_scout_shuttle_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scc_scout_shuttle_dock"
	defer_initialisation = TRUE
