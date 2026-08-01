
// ------------------------- template

/datum/map_template/ruin/away_site/modular_freelancer_ship
	name = "Modular Freelancer Ship"
	description = "Modular Freelancer Ship."
	id = "modular_freelancer_ship"

	prefix = "scenarios/modular_freelancer_ship/"
	suffix = "modular_freelancer_ship.dmm"

	spawn_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	sectors = list(ALL_POSSIBLE_SECTORS)
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/modular_freelancer_ship/fighter,
		/datum/shuttle/autodock/overmap/modular_freelancer_ship/ferry,
	)

	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/modular_freelancer_ship
	map = "Modular Freelancer Ship"
	descriptor = "Modular Freelancer Ship."

// ------------------------- ship

/obj/effect/overmap/visitable/ship/modular_freelancer_ship
	name = "Modular Freelancer Ship"
	class = "ICV"
	desc = "........"
	icon_state = "freighter_large"
	moving_state = "freighter_large_moving"
	colors = list("#c3c7eb", "#a0a8ec", "#a0eccf", "#ecdea0", "#eca0a0", "#eca0d5", "#ecb8a0")

	designer = "Unknown"
	volume = "42 meters length, 48 meters beam/width, 23 meters vertical height"
	drive = "First-Gen Warp Capable, Hybrid Phoron Bluespace Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Present, cannot read in detail"
	sizeclass = "Modular Freighter"
	shiptype = "Freighter"

	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH

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

/obj/effect/overmap/visitable/ship/modular_freelancer_ship/New()
	class = pick(
		"ICV", // Independent Civilian Vessel
		"IFR", // Independent Freighter
		"CCV", // Coalition Civilian Vessel
	)
	designation = pick(
		"This Old Tune",
		"June",
		"Thou Shalt Not Kill",
		"5 for You and 5 for Me",
		"No Jazz",
		"I don't Want to Be an Emperor",
		"Nocturne",
		"Secret Society",
		"Leave Me Alone",
		"In the Woods",
		"Little Tale",
		"No Need To Be Frightened",
		"Black Moon",
		"Point of No Return",
		"Entering the Black Hole",
		"No Meeting",
		"Low Gravity",
		"Out of Time",
		"In Time",
		"This Is Just the Beginning",
		"Melancholia",
		"Before Midnight Tonight",
		"Second Sun",
		"Sure the Sun Will Rise",
		"One More Step",
		"2001 Light Years From Home",
		"Far From Home",
		"Unknown Jungle",
		"Come With Me",
	)
	..()

// ------------------------- shuttles

// ----------- fighter

// ----------- ferry
