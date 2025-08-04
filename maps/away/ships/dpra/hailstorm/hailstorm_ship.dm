/datum/map_template/ruin/away_site/hailstorm_ship
	name = "Hailstorm Ship"
	id = "hailstorm_ship"
	description = "A People's Volunteer Spacer Militia ship."

	prefix = "ships/dpra/hailstorm/"
	suffix = "hailstorm_ship.dmm"

	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/hailstorm_shuttle)
	spawn_weight_sector_dependent = list(SECTOR_SRANDMARR = 2, SECTOR_GAKAL = 2, SECTOR_BADLANDS = 0.5)
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_GAKAL)
	unit_test_groups = list(1)

/singleton/submap_archetype/hailstorm_ship
	map = "Hailstorm Ship"
	descriptor = "A skipjack armed with multiple weapons designed for patrolling and brief engagements. When used for patrols, the Hailstorm is loaded with supplies to last weeks on its own; its crew is specifically trained to be as frugal as possible while aboard."

/obj/effect/overmap/visitable/ship/hailstorm_ship
	name = "Hailstorm Ship"
	class = "DPRAMV" //Democratic People's Republic of Adhomai Vessel
	desc = "A skipjack armed with multiple weapons designed for patrolling and brief engagements. When used for patrols, the Hailstorm is loaded with supplies to last weeks on its own; its crew is specifically trained to be as frugal as possible while aboard."
	icon_state = "hailstorm"
	moving_state = "hailstorm_moving"
	colors = list("#B9BDC4")
	scanimage = "hailstorm.png"
	designer = "Obfuscated, hull origin uncertain"
	volume = "37 meters length, 24 meters beam/width, 11 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual bow-mounted extruding low-caliber rotary ballistic armament, dual port and starboard torpedo bays"
	sizeclass = "Hailstorm-type Retrofitted Skipjack"
	shiptype = "Short-distance military tasking, low-level naval interdiction"
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL

	initial_restricted_waypoints = list(
		"Spacer Militia Shuttle" = list("nav_hangar_hailstorm")
	)

	initial_generic_waypoints = list(
		"hailstorm_ship_nav1",
		"hailstorm_ship_nav2",
		"hailstorm_ship_nav3",
		"hailstorm_ship_nav4",
		"hailstorm_ship_starboard_dock",
		"hailstorm_ship_port_dock",
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/hailstorm_ship/New()
	designation = "[pick("Al'mari", "Champion of the Tajara", "Nated's Revenge", "Mata'ke's Blade", "Star Guerilla", "Dreams of Freedom", "Al'mariist Comet", "Adhomai's Liberator")]"
	..()

/obj/effect/overmap/visitable/ship/hailstorm_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "hailstorm")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
