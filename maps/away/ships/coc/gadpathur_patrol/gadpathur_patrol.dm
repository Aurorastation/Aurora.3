/datum/map_template/ruin/away_site/gadpathur_patrol
	name = "Gadpathurian Patrol Corvette"
	description = "Gadpathur navy patrol ship."
	suffixes = list("ships/coc/gadpathur_patrol/gadpathur_patrol.dmm")
	sectors = list(ALL_COALITION_SECTORS) //NOTE: Gadpathur patrols all of the Coalition, however, they are intentionally -not- present in Haneunim. Konyang and Gadpathur are not friendly as of the Amor Patriae arc.
	sectors_blacklist = list(SECTOR_HANEUNIM, SECTOR_BURZSIA)
	spawn_weight = 1
	ship_cost = 1
	id = "gadpathur_patroller"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/gadpathur_shuttle)

	unit_test_groups = list(1)

/singleton/submap_archetype/gadpathur_patrol
	map = "Gadpathurian Patrol Corvette"
	descriptor = "Gadpathur navy patrol ship."

/obj/effect/overmap/visitable/ship/gadpathur_patrol
	name = "Gadpathurian Patrol Corvette"
	class = "GNV"
	desc = "The Gadpathurian Skanda-class patrol corvette is very much designed with function over form in mind. These vessels are built by Gadpathur's industrial cadres, to serve as patrol and reconnaissance craft for Gadpathur's navy. While not built as a dedicated combat vessel, it has the armanent to fend off minor hostile incursions and pirates alone."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	designation = "264"
	colors = list("#474800", "#7f6300")
	designer = "Gadpathur"
	volume = "80 meters length, 58 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard fore-mounted light caliber armament, starboard midship-mounted large caliber armanent, aft flight craft bay"
	sizeclass = "Skanda-class Patrol"
	shiptype = "Military patrol and combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 6000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	initial_generic_waypoints = list(
		"nav_gadpathur_corvette1",
		"nav_gadpathur_corvette2",
		"nav_gadpathur_corvette3",
		"nav_gadpathur_corvette4"
	)
	initial_restricted_waypoints = list(
		"Gadpathurian Corvette Shuttle" = list("nav_gadpathur_corvette_shuttle")
	)

/obj/effect/overmap/visitable/ship/gadpathur_patrol/New()
	designation = "[rand(100, 500)]"
	..()

/obj/effect/shuttle_landmark/gadpathur_patrol
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/gadpathur_patrol/nav1
	name = "Gadpathurian Patrol Corvette - Fore"
	landmark_tag = "nav_gadpathur_corvette1"

/obj/effect/shuttle_landmark/gadpathur_patrol/nav2
	name = "Gadpathurian Patrol Corvette - Aft"
	landmark_tag = "nav_gadpathur_corvette2"

/obj/effect/shuttle_landmark/gadpathur_patrol/nav3
	name = "Gadpathurian Patrol Corvette - Port"
	landmark_tag = "nav_gadpathur_corvette3"

/obj/effect/shuttle_landmark/gadpathur_patrol/nav4
	name = "Gadpathurian Patrol Corvette - Starboard"
	landmark_tag = "nav_gadpathur_corvette4"

/obj/effect/shuttle_landmark/gadpathur_patrol/dock
	name = "Gadpathurian Patrol Corvette - Dock"
	landmark_tag = "nav_gadpathur_dock"

//Shuttle Stuff

/obj/effect/overmap/visitable/ship/landable/gadpathur_shuttle
	name = "Gadpathurian Corvette Shuttle"
	class = "GNS"
	desc = "The Gadpathurian Tigra-class combat shuttle is a lightly armed transport, designed to serve multiple roles including fire support, and transportation."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designation = "1364"
	colors = list("#474800")
	shuttle = "Gadpathurian Corvette Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/gadpathur_shuttle/New()
	designation = "[rand(1000, 1500)]"
	..()

/obj/machinery/computer/shuttle_control/explore/gadpathur_shuttle
	name = "shuttle control console"
	shuttle_tag = "Gadpathurian Corvette Shuttle"
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

/datum/shuttle/autodock/overmap/gadpathur_shuttle
	name = "Gadpathurian Corvette Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/gadpathur_shuttle)
	current_location = "nav_gadpathur_corvette_shuttle"
	landmark_transition = "nav_transit_gadpathur_corvette"
	dock_target = "gadpathur_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_gadpathur_corvette_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/gadpathur_shuttle/dock
	name = "Gadpathurian Patrol Corvette - Shuttle Dock"
	landmark_tag = "nav_gadpathur_corvette_shuttle"
	docking_controller = "gadpathur_hangar_dock"
	base_area = /area/ship/gadpathur_patrol/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/gadpathur_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_gadpathur_corvette"
	base_turf = /turf/space/transit/north

/obj/structure/closet/secure_closet/guncabinet/gadpathur
	req_access = list(ACCESS_GADPATHUR_NAVY_OFFICER)

/obj/structure/closet/secure_closet/guncabinet/gadpathur/sidearm
	name = "sidearm cabinet"

/obj/structure/closet/secure_closet/guncabinet/gadpathur/rifle
	name = "assault rifle cabinet"

/obj/structure/closet/secure_closet/guncabinet/gadpathur/shotgun
	name = "shotgun cabinet"
