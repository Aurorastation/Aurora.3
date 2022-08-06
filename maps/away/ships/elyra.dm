/datum/map_template/ruin/away_site/elyran_strike_craft
	name = "Elyran Naval Strike Craft"
	description = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."
	suffix = "ships/elyran_strike_craft.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "elyran_strike_craft"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/elyran_shuttle)

/decl/submap_archetype/elyran_strike_craft
	map = "Elyran Naval Strike Craft"
	descriptor = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."

//areas
/area/ship/elyran_strike_craft
	name = "Elyran Naval Strike Craft"

/area/shuttle/elyran_shuttle
	name = "Elyran Naval Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/elyran_strike_craft
	name = "Elyran Naval Strike Craft"
	desc = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Elyran Naval Shuttle" = list("nav_hangar_elyra")
	)

	initial_generic_waypoints = list(
		"nav_elyran_strike_craft_1",
		"nav_elyran_strike_craft_2"
	)

/obj/effect/overmap/visitable/ship/elyran_strike_craft/New()
	name = "ENV [pick("Persepolis", "Damascus", "Medina", "Aemaq", "New Suez", "Bursa", "Republican", "Falcon", "Gelin", "Sphinx", "Takam", "Dandan", "Anqa", "Falak", "Uthra", "Djinn", "Roc", "Shadhavar", "Karkadann")]"
	..()

/obj/effect/shuttle_landmark/elyran_strike_craft/nav1
	name = "Elyran Naval Strike Craft - Port Side"
	landmark_tag = "nav_elyran_strike_craft_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_strike_craft/nav2
	name = "Elyran Naval Strike Craft - Port Airlock"
	landmark_tag = "nav_elyran_strike_craft_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_strike_craft/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_strike_craft"
	base_turf = /turf/space/transit/south

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/elyran_shuttle
	name = "Elyran Naval Shuttle"
	desc = "A large and unusually-shaped shuttle, the Hydrus-class is deceptively fast and is designed to operate out of a Cetus-class corvette's rear hangar bay, interdicting targets that its mothership intercepts. This one's transponder identifies it as a Tau Ceti Foreign Legion shuttle, and as a Velite-class Interceptor - the TCFL designation for this design."
	shuttle = "Elyran Naval Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/elyran_shuttle
	name = "shuttle control console"
	shuttle_tag = "Elyran Naval Shuttle"
	req_access = list(access_elyran_naval_infantry_ship)

/datum/shuttle/autodock/overmap/elyran_shuttle
	name = "Elyran Naval Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/elyran_shuttle)
	current_location = "nav_hangar_elyra"
	landmark_transition = "nav_transit_elyran_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_elyra"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/elyran_shuttle/hangar
	name = "Elyran Naval Shuttle Hangar"
	landmark_tag = "nav_hangar_elyra"
	docking_controller = "elyran_shuttle_dock"
	base_area = /area/ship/elyran_strike_craft
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/elyran_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_shuttle"
	base_turf = /turf/space/transit/south
