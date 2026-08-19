
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/modular_freelancer_ship
	name = "Modular Freelancer Ship"
	description = "Modular Freelancer Ship."
	id = "modular_freelancer_ship"

	prefix = "scenarios/modular_freelancer_ship/"
	suffix = "modular_freelancer_ship.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	ship_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/modular_freelancer_ship/fighter,
		/datum/shuttle/autodock/overmap/modular_freelancer_ship/ferry,
	)

/singleton/submap_archetype/modular_freelancer_ship
	map = /datum/map_template/ruin/away_site/modular_freelancer_ship::id
	descriptor = /datum/map_template/ruin/away_site/modular_freelancer_ship::description

// --------------------------------------------------- ship

/obj/effect/overmap/visitable/ship/modular_freelancer_ship
	name = /datum/map_template/ruin/away_site/modular_freelancer_ship::id
	class = "ICV"
	desc = /datum/map_template/ruin/away_site/modular_freelancer_ship::description

	// visual:
	icon_state = "freighter_large"
	moving_state = "freighter_large_moving"
	colors = list("#c3c7eb", "#a0a8ec", "#a0eccf", "#ecdea0", "#eca0a0", "#eca0d5", "#ecb8a0")

	// functional:
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH

	// fluff:
	designer = "Unknown"
	volume = "42 meters length, 48 meters beam/width, 23 meters vertical height"
	drive = "First-Gen Warp Capable, Hybrid Phoron Bluespace Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Present, cannot read in detail"
	sizeclass = "Modular Freighter"
	shiptype = "Freighter"

	// defines:
	var/list/designation_options = list(
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

/obj/effect/overmap/visitable/ship/modular_freelancer_ship/New()
	class = pick(
		"ICV", // Independent Civilian Vessel
		"IFR", // Independent Freighter
		"CCV", // Coalition Civilian Vessel
	)
	designation = pick(/obj/effect/overmap/visitable/ship/modular_freelancer_ship::designation_options)
	..()

// --------------------------------------------------- shuttles

// ----------- fighter

/obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter
	name = "Modular Freelancer Ship, Fighter Shuttle"
	class = "ICV"
	desc = "A standard-sized shuttle manufactured by Hephaestus. It is a low-end model, fairly uninteresting, found all over the spur. It has a small-caliber gun mounted on the side."
	shuttle = "Modular Freelancer Ship, Fighter Shuttle"

	// visual:
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = /obj/effect/overmap/visitable/ship/modular_freelancer_ship::colors

	// functional:
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

	// fluff:
	designer = "Hephaestus Industries"
	volume = "17 meters length, 24 meters beam/width, 6 meters vertical height"
	sizeclass = "Dual-purpose Fighter Shuttle"
	shiptype = "Light exploration and defensive uses"

/obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter/New()
	designation = pick(/obj/effect/overmap/visitable/ship/modular_freelancer_ship::designation_options)
	..()

/obj/structure/machinery/computer/shuttle_control/explore/terminal/modular_freelancer_shuttle_fighter
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter::shuttle

/datum/shuttle/autodock/overmap/modular_freelancer_shuttle_fighter
	name = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter::shuttle
	move_time = 20
	shuttle_area = list(/area/shuttle/modular_freelancer_shuttle/fighter)
	dock_target = "airlock_modular_freelancer_shuttle_fighter"
	current_location = "nav_modular_freelancer_shuttle_fighter_dock"
	landmark_transition = "nav_modular_freelancer_shuttle_fighter_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_modular_freelancer_shuttle_fighter_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/scc_scout_ship
	name = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter::shuttle
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_fighter::shuttle
	master_tag = /datum/shuttle/autodock/overmap/modular_freelancer_shuttle_fighter::dock_target

// ----------- ferry

/obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry
	name = "Modular Freelancer Ship, Ferry Shuttle"
	class = "ICV"
	desc = "A standard-sized shuttle manufactured by Hephaestus. It is a low-end model, fairly uninteresting, found all over the spur. It has a small-caliber gun mounted on the side."
	shuttle = "Modular Freelancer Ship, Ferry Shuttle"

	// visual:
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = /obj/effect/overmap/visitable/ship/modular_freelancer_ship::colors

	// functional:
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

	// fluff:
	designer = "Hephaestus Industries"
	volume = "17 meters length, 24 meters beam/width, 6 meters vertical height"
	sizeclass = "Dual-purpose Ferry Shuttle"
	shiptype = "Light exploration and defensive uses"

/obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry/New()
	designation = pick(/obj/effect/overmap/visitable/ship/modular_freelancer_ship::designation_options)
	..()

/obj/structure/machinery/computer/shuttle_control/explore/terminal/modular_freelancer_shuttle_ferry
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry::shuttle

/datum/shuttle/autodock/overmap/modular_freelancer_shuttle_ferry
	name = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry::shuttle
	move_time = 20
	shuttle_area = list(/area/shuttle/modular_freelancer_shuttle/ferry)
	dock_target = "airlock_modular_freelancer_shuttle_ferry"
	current_location = "nav_modular_freelancer_shuttle_ferry_dock"
	landmark_transition = "nav_modular_freelancer_shuttle_ferry_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_modular_freelancer_shuttle_ferry_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/scc_scout_ship
	name = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry::shuttle
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/modular_freelancer_shuttle_ferry::shuttle
	master_tag = /datum/shuttle/autodock/overmap/modular_freelancer_shuttle_ferry::dock_target

// ------------------------- misc

// ------------------------- fin
