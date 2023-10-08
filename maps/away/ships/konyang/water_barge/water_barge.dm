/datum/map_template/ruin/away_site/water_barge
	name = "Water Barge"
	description = "A PACHROM transport barge, exporting water."
	suffixes = list("ships/konyang/air_konyang/air_konyang.dmm")
	sectors = list(SECTOR_HANEUNIM)
	spawn_weight = 1
	ship_cost = 1
	id = "water_barge"
	shuttles_to_initialise = list()

/singleton/submap_archetype/water_barge
	map = "Water Barge"
	descriptor = "A PACHROM transport barge, exporting water."

/obj/effect/overmap/visitable/ship/water_barge
	name = "Water Barge"
	class = "PCV" //PACHROM cargo vessel
	desc = "The Shelfer-class cargo transport is a common sight in the shipyards of Konyang - designed by Einstein Engines and frequently used by Konyang corporations for long-distance cargo hauling throughout the Orion Spur."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	designer = "Einstein Engines"
	volume = "75 meters length, 55 meters beam/width, 21 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "No weapons detected"
	sizeclass = "Shelfer-class cargo transport"
	shiptype = "Long-distance cargo hauling"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 8000 //big boy
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list()
	initial_generic_waypoints = list(
		"water_barge_nav1",
		"water_barge_nav2",
		"water_barge_nav3",
		"water_barge_nav4",
		"water_barge_dock",
		"water_barge_dock_s"
	)

/obj/effect/overmap/visitable/ship/water_barge/New()
	designation = "[pick("Shelfer", "Sapsalgae", "Harmony", "Reciprocity", "Qixi")]"
	..()

/obj/effect/shuttle_landmark/water_barge
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/water_barge/nav1
	name = "PACHROM Water Barge - Fore"
	landmark_tag = "water_barge_nav1"

/obj/effect/shuttle_landmark/water_barge/nav2
	name = "PACHROM Water Barge - Aft"
	landmark_tag = "water_barge_nav2"

/obj/effect/shuttle_landmark/water_barge/nav3
	name = "PACHROM Water Barge - Port"
	landmark_tag = "water_barge_nav3"

/obj/effect/shuttle_landmark/water_barge/nav4
	name = "PACHROM Water Barge - Starboard"
	landmark_tag = "water_barge_nav4"

/obj/effect/shuttle_landmark/water_barge/dock
	name = "PACHROM Water Barge - Port Dock"
	landmark_tag = "water_barge_dock"

/obj/effect/shuttle_landmark/water_barge/starboarddock
	name = "PACHROM Water Barge - Starboard Dock"
	landmark_tag = "water_barge_dock_s"

//Shuttle Stuff

/obj/effect/overmap/visitable/ship/landable/water_barge_shuttle
	name = "Water Barge Shuttle"
	class = "PCV"
	shuttle = "Water Barge Shuttle"
	designation = "Aoyama"
	desc = "A small civilian transport shuttle."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/water_barge_shuttle
	name = "Water Barge Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/water_barge)
	current_location = "nav_water_barge_hangar"
	landmark_transition = "nav_water_barge_transit"
	dock_target = "water_barge_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_water_barge_hangar"
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/explore/water_barge_shuttle
	name = "shuttle control console"
	shuttle_tag = "Water Barge Shuttle"

/obj/effect/shuttle_landmark/water_barge_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_water_barge_transit"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/water_barge_shuttle/hangar
	name = "PACHROM Water Barge - Hangar"
	landmark_tag = "nav_water_barge_hangar"
	docking_controller = "water_barge_hangar"
	base_area = /area/water_barge/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
