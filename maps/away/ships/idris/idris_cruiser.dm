/datum/map_template/ruin/away_site/idris_cruiser
	name = "Idris Cruiser"
	description = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."
	suffixes = list("ships/idris/idris_cruiser.dmm")
	sectors = list(ALL_CORPORATE_SECTORS)
	sectors_blacklist = list(ALL_DANGEROUS_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "idris_cruiser"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/idris_cruiser_shuttle)
	unit_test_groups = list(3)

/singleton/submap_archetype/idris_cruiser
	map = "Idris Cruiser"
	descriptor = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."

// ship

/obj/effect/overmap/visitable/ship/idris_cruiser
	name = "Idris Cruiser"
	class = "IIV"
	desc = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."
	icon_state = "sanctuary"
	moving_state = "sanctuary_moving"
	colors = "#5acfc0"
	designer = "Idris Incorporated - Celestial Cruises"
	volume = "82 meters length, 60 meters beam/width, 28 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "None"
	sizeclass = "Argentum-class Cruise Yacht"
	shiptype = "Luxury cruise yacht"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	place_near_main = 4
	invisible_until_ghostrole_spawn = TRUE
	initial_restricted_waypoints = list(
		"Idris Runabout" = list("nav_idris_cruiser_stbd_aft")
	)
	initial_generic_waypoints = list(
		"nav_idris_cruiser_stbd_fore",
		"nav_idris_cruiser_stbd_berth",
		"nav_idris_cruiser_port_aft",
		"nav_idris_cruiser_port_fore",
		"nav_idris_cruiser_port_berth",
		"nav_idris_cruiser_space_fore_starboard",
		"nav_idris_cruiser_space_fore_port",
		"nav_idris_cruiser_space_aft_starboard",
		"nav_idris_cruiser_space_aft_port",
		"nav_idris_cruiser_space_port_far",
		"nav_idris_cruiser_space_starboard_far",
	)

/obj/effect/overmap/visitable/ship/idris_cruiser/New()
	designation = "[pick("Celestial Spirit", "Celestial Crown", "Celestial Splendor", "Celestial Dreamer", "Celestial Fantasy", "Celestial Odyssey", "Celestial Serenade", "Celestial Starlight", "Celestial Paradise", "Celestial Enchantress", "Celestial Luminance")]"
	..()

/obj/effect/overmap/visitable/ship/landable/idris_cruiser_shuttle
	name = "Runabout"
	class = "I-2"
	desc = "The I-2 Runabout is one of a few shuttlecraft types in service with Idris Incorporated's civilian liners, all designed to transport civilians between their ship and a port of call or a planet's surface. It is the middle child of the Idris runabout family, larger than the I-1 but smaller than the I-3 and I-4."
	shuttle = "Idris Runabout"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = "#5acfc0"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 1000
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY
	designer = "Idris Incorporated - Celestial Cruises"
	volume = "18 meters length, 7 meters beam/width, 6 meters vertical height"
	sizeclass = "Cruise liner tender"
	shiptype = "Short-distance passenger transport between ships or between ship and planet"

/obj/effect/overmap/visitable/ship/landable/idris_cruiser_shuttle/New()
	designation = "Idris Runabout"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/idris_cruiser_shuttle
	name = "shuttle control console"
	shuttle_tag = "Idris Runabout"

/datum/shuttle/autodock/overmap/idris_cruiser_shuttle
	name = "Idris Runabout"
	move_time = 15
	shuttle_area = list(/area/shuttle/idris_cruiser_shuttle/main, /area/shuttle/idris_cruiser_shuttle/bridge, /area/shuttle/idris_cruiser_shuttle/engineering,)
	dock_target = "airlock_idris_cruiser_shuttle"
	current_location = "nav_idris_cruiser_stbd_aft"
	landmark_transition = "nav_idris_cruiser_transit"
	range = 1
	fuel_consumption = 1
	logging_home_tag = "nav_idris_cruiser_stbd_aft"
	defer_initialisation = TRUE

