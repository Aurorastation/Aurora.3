/datum/map_template/ruin/away_site/orion_express_ship
	name = "Orion Express Mobile Station"
	description = "The Traveler-class mobile station is a relatively old design, but nonetheless venerable and one of the building blocks of interstellar commerce. While relatively small, is a treasured asset in the Orion Express corporation's fleet, and has been referred to as “the gas station of the stars”, offering food, supplies, and fuel to anyone who may need it."

	prefix = "ships/orion/"
	suffix = "orion_express_ship.dmm"

	sectors = list(ALL_CORPORATE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "orion_express_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/orion_express_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/orion_express_ship
	map = "Orion Express Mobile Station"
	descriptor = "The Traveler-class mobile station is a relatively old design, but nonetheless venerable and one of the building blocks of interstellar commerce. While relatively small, is a treasured asset in the Orion Express corporation's fleet, and has been referred to as “the gas station of the stars”, offering food, supplies, and fuel to anyone who may need it."
//areas
/area/ship/orion
	name = "Orion Express Courier Ship (parent type, do not use!)"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/orion/engie
	name = "Engineering"
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "engineering"

/area/ship/orion/atmos
	name = "Atmospherics"
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "atmos"

/area/ship/orion/cargo
	name = "Cargo Bay"
	ambience = AMBIENCE_GENERIC
	icon_state = "quartloading"

/area/ship/orion/mainhall
	name = "Main Hallway"
	ambience = AMBIENCE_GENERIC
	icon_state = "hallC"

/area/ship/orion/crew
	name = "Crew Quarters"
	ambience = AMBIENCE_GENERIC
	icon_state = "crew_quarters"

/area/ship/orion/captain
	name = "Captain's Office"
	ambience = AMBIENCE_GENERIC
	icon_state = "captain"

/area/ship/orion/bridge
	name = "Platform Command Center"
	ambience = AMBIENCE_GENERIC
	icon_state = "bridge"

/area/ship/orion/comms
	name = "Telecommunications"
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "tcomsatcham"

/area/ship/orion/forehall
	name = "Cafeteria"
	ambience = AMBIENCE_GENERIC
	icon_state = "lounge"

/area/ship/orion/shop
	name = "Commissary"
	ambience = AMBIENCE_GENERIC
	icon_state = "blue"

/area/ship/orion/thruster1
	name = "Thruster Pod 1"
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "engine"

/area/ship/orion/thruster2
	name = "Thruster Pod 2"
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "engine"

/area/ship/orion/docking1
	name = "Primary Docking Arm"
	ambience = AMBIENCE_GENERIC
	icon_state = "exit"

/area/ship/orion/docking2
	name = "Secondary Docking Arm"
	ambience = AMBIENCE_GENERIC
	icon_state = "exit"

// Shuttle
/area/shuttle/orion_shuttle/
	requires_power = TRUE
	name = "Orion Courier Shuttle"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/orion_shuttle/storage
	name = "Storage Compartment"
	ambience = AMBIENCE_GENERIC

/area/shuttle/orion_shuttle/cockpit
	name = "Cockpit"
	ambience = AMBIENCE_GENERIC

/area/shuttle/orion_shuttle/portthrust
	name = "Port Nacelle"
	ambience = AMBIENCE_MAINTENANCE

/area/shuttle/orion_shuttle/starboardthrust
	name = "Starboard Nacelle"
	ambience = AMBIENCE_MAINTENANCE

//ship stuff

/obj/effect/overmap/visitable/ship/orion_express_ship
	name = "Orion Express Mobile Station"
	class = "OEV"
	desc = "The Traveler-class mobile station is a relatively old design, but nonetheless venerable and one of the building blocks of interstellar commerce. While relatively small, is a treasured asset in the Orion Express corporation's fleet, and has been referred to as “the gas station of the stars”, offering food, supplies, and fuel to anyone who may need it."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "waystation"
	moving_state = "waystation"
	colors = list("#a1a8e2", "#818be0")
	scanimage = "oe_platform.png"
	designer = "Orion Express, Refurbished Design"
	volume = "51 meters length, 55 meters beam/width, 29 meters vertical height"
	sizeclass = "Traveler-class Mobile Waystation"
	shiptype = "Refuel, resupply and commercial logistics services"
	drive = "Medium-Speed Warp Acceleration FTL Drive"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	initial_restricted_waypoints = list(
		"Orion Express Shuttle" = list("nav_hangar_orion_express")
	)

	initial_generic_waypoints = list(
		"nav_orion_express_ship_1",
		"nav_orion_express_ship_2",
		"nav_orion_express_ship_3",
		"nav_orion_express_ship_4",
		"nav_orion_express_ship_dock_aft",
		"nav_orion_express_ship_dock_fore",
		"nav_orion_express_ship_dock_port",
		"nav_orion_express_ship_dock_starboard"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/orion_express_ship/New()
	designation = "[pick("Messenger", "Traveler", "Highspeed", "Punctual", "Unstoppable", "Pony Express", "Courier", "Telegram", "Carrier Pigeon", "Fuel Stop", "Convenience")]"
	..()

/obj/effect/overmap/visitable/ship/orion_express_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "oe_platform")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/orion_express_ship/nav1
	name = "Orion Express Mobile Station - Port Side"
	landmark_tag = "nav_orion_express_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/orion_express_ship/nav2
	name = "Orion Express Mobile Station - Starboard Side"
	landmark_tag = "nav_orion_express_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/orion_express_ship/nav3
	name = "Orion Express Mobile Station - Fore Side"
	landmark_tag = "nav_orion_express_ship_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/orion_express_ship/nav4
	name = "Orion Express Mobile Station - Aft Side"
	landmark_tag = "nav_orion_express_ship_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/orion_express_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_orion_express_ship"
	base_turf = /turf/space/transit/north

// Docks

/obj/effect/map_effect/marker/airlock/docking/orion_express_ship/shuttle
	name = "Orion Express Mobile Station - Shuttle Dock"
	landmark_tag = "nav_orion_express_ship_dock_shuttle"
	master_tag = "orion_traveler_shuttle"

/obj/effect/shuttle_landmark/orion_express_ship/aft
	name = "Orion Express Mobile Station - Aft Dock"
	landmark_tag = "nav_orion_express_ship_dock_aft"
	docking_controller = "orion_traveler_port_aft"
	base_area = /area/space
	base_turf = /turf/space/dynamic

/obj/effect/map_effect/marker/airlock/docking/orion_express_ship/aft
	name = "Orion Express Mobile Station - Aft Dock"
	landmark_tag = "nav_orion_express_ship_dock_aft"
	master_tag = "orion_traveler_port_aft"

/obj/effect/shuttle_landmark/orion_express_ship/fore
	name = "Orion Express Mobile Station - Fore Dock"
	landmark_tag = "nav_orion_express_ship_dock_fore"
	docking_controller = "orion_traveler_port_fore"
	base_area = /area/space
	base_turf = /turf/space/dynamic

/obj/effect/map_effect/marker/airlock/docking/orion_express_ship/fore
	name = "Orion Express Mobile Station - Fore Dock"
	landmark_tag = "nav_orion_express_ship_dock_fore"
	master_tag = "orion_traveler_port_fore"

/obj/effect/shuttle_landmark/orion_express_ship/starboard
	name = "Orion Express Mobile Station - Starboard Dock"
	landmark_tag = "nav_orion_express_ship_dock_starboard"
	docking_controller = "orion_traveler_port_starboard"
	base_area = /area/space
	base_turf = /turf/space/dynamic

/obj/effect/map_effect/marker/airlock/docking/orion_express_ship/starboard
	name = "Orion Express Mobile Station - Starboard Dock"
	landmark_tag = "nav_orion_express_ship_dock_starboard"
	master_tag = "orion_traveler_port_starboard"

/obj/effect/shuttle_landmark/orion_express_ship/port
	name = "Orion Express Mobile Station - Port Dock"
	landmark_tag = "nav_orion_express_ship_dock_port"
	docking_controller = "orion_traveler_port_port"
	base_area = /area/space
	base_turf = /turf/space/dynamic

/obj/effect/map_effect/marker/airlock/docking/orion_express_ship/port
	name = "Orion Express Mobile Station - Port Dock"
	landmark_tag = "nav_orion_express_ship_dock_port"
	master_tag = "orion_traveler_port_port"

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/orion_express_shuttle
	name = "Orion Express Shuttle"
	class = "OEV"
	designation = "Packmaster"
	desc = "The Troubadour-class skiff is not quite an independent design, and is instead essentially a component of the larger Traveler-class station as a whole, seamlessly attaching and detaching for operations as is necessary. This one's transponder identifies it as part of an Orion Express refueling station."
	shuttle = "Orion Express Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#a1a8e2", "#818be0")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/orion_express_shuttle
	name = "shuttle control console"
	shuttle_tag = "Orion Express Shuttle"
	req_access = list(ACCESS_ORION_EXPRESS_SHIP)

/datum/shuttle/autodock/overmap/orion_express_shuttle
	name = "Orion Express Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/orion_shuttle/cockpit, /area/shuttle/orion_shuttle/portthrust, /area/shuttle/orion_shuttle/storage, /area/shuttle/orion_shuttle/starboardthrust)
	current_location = "nav_hangar_orion_express"
	landmark_transition = "nav_transit_orion_express"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_orion_express"
	dock_target = "orion_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/orion_express_shuttle/hangar
	name = "Orion Express Shuttle Hangar"
	landmark_tag = "nav_hangar_orion_express"
	docking_controller = "orion_traveler_shuttle"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/orion_express_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_orion_express"
	base_turf = /turf/space/transit/north
