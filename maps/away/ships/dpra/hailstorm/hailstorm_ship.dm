/datum/map_template/ruin/away_site/hailstorm_ship
	name = "Hailstorm Ship"
	id = "hailstorm_ship"
	description = "A People's Volunteer Spacer Militia ship."
	suffixes = list("ships/dpra/hailstorm/hailstorm_ship.dmm")
	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/hailstorm_shuttle)
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_GAKAL)

/singleton/submap_archetype/hailstorm_ship
	map = "Hailstorm Ship"
	descriptor = "A skipjack armed with multiple mass-driver weapons designed for patrolling and brief engagements. When used for patrols, the Hailstorm is loaded with supplies to last weeks on its own; its crew is specifically trained to be as frugal as possible while aboard."

/obj/effect/overmap/visitable/ship/hailstorm_ship
	name = "Hailstorm Ship"
	desc = "A skipjack armed with multiple mass-driver weapons designed for patrolling and brief engagements. When used for patrols, the Hailstorm is loaded with supplies to last weeks on its own; its crew is specifically trained to be as frugal as possible while aboard."
	class = "DPRAMV" //Democratic People's Republic of Adhomai Vessel
	icon_state = "ship"
	moving_state = "ship_moving"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_hailstorm_ship_1",
		"nav_hailstorm_ship_2",
		"nav_hailstorm_ship_3",
		"nav_hailstorm_ship_4"
	)
	initial_restricted_waypoints = list(
		"Spacer Militia Shuttle" = list("nav_hailstorm_shuttle")
	)

/obj/effect/overmap/visitable/ship/hailstorm_ship/New()
	designation = "[pick("Al'mari", "Champion of the Tajara", "Nated's Revenge", "Mata'ke's Blade", "Star Guerilla", "Dreams of Freedom", "Al'mariist Comet", "Adhomai's Liberator")]"
	..()

/obj/effect/shuttle_landmark/hailstorm_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_hailstorm_ship/nav1
	name = "Hailstorm Ship Navpoint #1"
	landmark_tag = "nav_hailstorm_ship_1"

/obj/effect/shuttle_landmark/nav_hailstorm_ship/nav2
	name = "Hailstorm Ship Navpoint #2"
	landmark_tag = "nav_hailstorm_ship_2"

/obj/effect/shuttle_landmark/nav_hailstorm_ship/nav3
	name = "Hailstorm Ship Navpoint #3"
	landmark_tag = "nav_hailstorm_ship_3"

/obj/effect/shuttle_landmark/nav_hailstorm_ship/nav4
	name = "Hailstorm Ship Navpoint #4"
	landmark_tag = "nav_hailstorm_ship_4"


//shuttle
/obj/effect/overmap/visitable/ship/landable/hailstorm_shuttle
	name = "Spacer Militia Shuttle"
	desc = "A simple and reliable shuttle design used by the Spacer Militia Shuttle."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	class = "DPRAMV"
	designation = "Yve'kha"
	shuttle = "Spacer Militia Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/hailstorm_shuttle
	name = "shuttle control console"
	shuttle_tag = "Spacer Militia Shuttle"


/datum/shuttle/autodock/overmap/hailstorm_shuttle
	name = "Spacer Militia Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/hailstorm_shuttle)
	current_location = "nav_hailstorm_shuttle"
	landmark_transition = "nav_transit_hailstorm_shuttle"
	dock_target = "hailstorm_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hailstorm_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/hailstorm_shuttle/hangar
	name = "Spacer Militia Shuttle Hangar"
	landmark_tag = "nav_hailstorm_shuttle"
	docking_controller = "hailstorm_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/hailstorm_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_hailstorm_shuttle"
	base_turf = /turf/space/transit/north