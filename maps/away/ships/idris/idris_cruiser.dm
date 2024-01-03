/datum/map_template/ruin/away_site/idris_cruiser
	name = "Idris Cruiser"
	description = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."
	suffixes = list("ships/idris/idris_cruiser.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "idris_cruiser"

	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/idris_cruiser
	map = "Idris Cruiser"
	descriptor = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."

// ship

/obj/effect/overmap/visitable/ship/idris_cruiser
	name = "Idris Cruiser"
	class = "IDRV"
	desc = "A small luxury cruiser run by Idris Incorporated's subsidiary, Celestial Cruises. The Argentum-class is more of a yacht than a proper cruise ship, and is easily dwarfed by the fleet's larger vessels. However, it makes up for its diminuitive size by its speed, flexibility, and low maintenance cost. It adopts a unique wandering business model, where it roams the Spur and caters to tired traveling vessel crews seeking a getaway among the stars. It comes with a bar and restaurant, a pool, a spa, and a viewing lounge, as well as four suites for overnight stayers."
	icon_state = "sanctuary"
	moving_state = "sanctuary_moving"
	colors = list("#a7fff3", "#5acfc0")
	designer = "Idris Incorporated - Celestial Cruises"
	volume = "82 meters length, 60 meters beam/width, 28 meters vertical height"
	drive = "Warp Capable, Hybrid Phoron Bluespace Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "None"
	sizeclass = "Argentum-class Cruise Yacht"
	shiptype = "Luxury cruise yacht"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = FALSE
	initial_restricted_waypoints = list(
		"Idris Cruiser" = list("nav_idris_cruiser_stbd_aft")
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

/obj/machinery/computer/shuttle_control/explore/terminal/idris_cruiser_shuttle
	name = "shuttle control console"
	shuttle_tag = "Idris Runabout"


