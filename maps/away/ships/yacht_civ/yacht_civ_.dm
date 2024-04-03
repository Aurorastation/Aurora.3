/datum/map_template/ruin/away_site/yacht_civ
	name = "Civilian Yacht"
	description = "Civilian Yacht"
	suffixes = list("ships/yacht_civ/yacht_civ.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_DANGEROUS_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "yacht_civ"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/yacht_civ_shuttle)
	unit_test_groups = list(3)

/singleton/submap_archetype/yacht_civ
	map = "Civilian Yacht"
	descriptor = "Civilian Yacht"

// ship

/obj/effect/overmap/visitable/ship/yacht_civ
	name = "Civilian Yacht"
	class = "ICV"
	desc = "\
		Diamond-class Yacht, commonly seen in Sol and usually used for short-range flights between Solarian planets, moons, and other nearby sectors, \
		shuttling the rich between work, home, and recreation. Certainly not a cheap platform, sparing no expenses in its internal systems, \
		it is a quick and capable ship, being designed by Einstein Engines and produced by Hephaestus Industries.\
		"
	icon_state = "canary"
	moving_state = "canary_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	designer = "Einstein Engines"
	volume = "63 meters length, 24 meters beam/width, 20 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "None"
	sizeclass = "Diamond-class Yacht"
	shiptype = "Leisure yacht"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = TRUE
	initial_restricted_waypoints = list(
		"Civilian Yacht Shuttle" = list("nav_yacht_civ_shuttle_dock")
	)
	initial_generic_waypoints = list(
		"nav_yacht_civ_dock_starboard",
		"nav_yacht_civ_dock_port",
		"nav_yacht_civ_dock_aft",
		"nav_yacht_civ_dock_fore",
		"nav_yacht_civ_space_fore_starboard",
		"nav_yacht_civ_space_fore_port",
		"nav_yacht_civ_space_aft_starboard",
		"nav_yacht_civ_space_aft_port",
		"nav_yacht_civ_space_port_far",
		"nav_yacht_civ_space_starboard_far",
	)

/obj/effect/overmap/visitable/ship/yacht_civ/New()
	var/planetary_body = pick(
		"Jupiter", "Saturn", "Uranus", "Neptune", "Venus", "Mars", "Ganymede", "Titan",
		"Mercury", "Callisto", "Io", "Europa", "Triton", "Pluto", "Eris", "Haumea",
		"Titania", "Rhea", "Oberon", "Iapetus", "Makemake", "Charon", "Umbriel", "Ariel",
		"Dione", "Quaoar", "Tethys", "Sedna", "Ceres", "Orcus", "Salacia", "Vesta",
		"Pallas", "Enceladus", "Mimas", "Nereid", "Europa", "Hyperion", "Juno", "Mnemosyne",
	)
	var/prefix  = pick("", "", "", pick("Wondrous ", "Little ", "Tiny ", "Dreamy ", "Fine ", "Orbiter of ", "Greetings from "))
	var/postfix = pick("", "", "", pick(", the Adventurer", " among Stars", ", Explorer", " of Sol", " from Sol", " and Moons"))
	designation = "[prefix][planetary_body][postfix]"
	..()

// shuttle

/obj/effect/overmap/visitable/ship/landable/yacht_civ_shuttle
	name = "Civilian Yacht Shuttle"
	class = "ICV"
	desc = "\
		A small short-range shuttle, primarily designed to move people between smaller docks or moons, and bigger yachts, too big to actually dock. \
		It has lots of automation and internal systems to help with piloting, so even if it appears unimpressive, it is quite an expensive platform. \
		"
	shuttle = "Civilian Yacht Shuttle"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 1000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Einstein Engines"
	volume = "10 meters length, 7 meters beam/width, 6 meters vertical height"
	sizeclass = "Glass-class Shuttle"
	shiptype = "Short-range transport"

/obj/effect/overmap/visitable/ship/landable/yacht_civ_shuttle/New()
	var/planetary_body = pick(
		"Jupiter", "Saturn", "Uranus", "Neptune", "Venus", "Mars", "Ganymede", "Titan",
		"Mercury", "Callisto", "Io", "Europa", "Triton", "Pluto", "Eris", "Haumea",
		"Titania", "Rhea", "Oberon", "Iapetus", "Makemake", "Charon", "Umbriel", "Ariel",
		"Dione", "Quaoar", "Tethys", "Sedna", "Ceres", "Orcus", "Salacia", "Vesta",
		"Pallas", "Enceladus", "Mimas", "Nereid", "Europa", "Hyperion", "Juno", "Mnemosyne",
	)
	var/prefix  = pick("", "", "", pick("Wondrous ", "Little ", "Tiny ", "Dreamy ", "Fine ", "Orbiter of ", "Greetings from "))
	var/postfix = pick("", "", "", pick(", the Adventurer", " among Stars", ", Explorer", " of Sol", " from Sol", " and Moons"))
	designation = "[prefix][planetary_body][postfix]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/yacht_civ_shuttle
	name = "shuttle control console"
	shuttle_tag = "Civilian Yacht Shuttle"

/datum/shuttle/autodock/overmap/yacht_civ_shuttle
	name = "Civilian Yacht Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/yacht_civ_shuttle)
	dock_target = "airlock_yacht_civ_shuttle"
	current_location = "nav_yacht_civ_shuttle_dock"
	landmark_transition = "nav_yacht_civ_shuttle_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_yacht_civ_shuttle_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/yacht_civ_shuttle
	name = "Civilian Yacht Shuttle"
	shuttle_tag = "Civilian Yacht Shuttle"
	master_tag = "airlock_yacht_civ_shuttle"
