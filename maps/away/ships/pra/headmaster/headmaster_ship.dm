/datum/map_template/ruin/away_site/headmaster_ship
	name = "headmaster pra ship"
	id = "awaysite_headmaster_ship"
	description = "A People's Republic Orbital Fleet ship."
	suffix = "ships/pra/headmaster/headmaster_ship.dmm"
	spawn_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/obj/effect/overmap/visitable/ship/landable/headmaster_shuttle)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)

/obj/effect/overmap/visitable/ship/headmaster_ship
	name = "orbital fleet headmaster"
	desc = "The second heaviest ship created by the People's Republic of Adhomai. As of now, it's the lightest heavy ship ever designed, barely staying above the classification of a cruiser."
	class = "PRAMV" //People's Republic of Adhomai Vessel
	icon_state = "ship_grey"
	moving_state = "ship_grey_moving"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_headmaster_ship_1",
		"nav_headmaster_ship_2",
		"nav_headmaster_ship_3",
		"nav_headmaster_ship_4"
	)
	initial_restricted_waypoints = list(
		"Orbital Fleet Shuttle" = list("nav_hangar_headmaster_shuttle")
	)

/obj/effect/overmap/visitable/ship/headmaster_ship/New()
	if(50)
		designation = "Hadii"
	else
		designation = "[pick("Al'mari Hadii", "Adhomai's Shield", "Loyal Comrade", "People's Guardian", "Visionary", "Great Future", "Fearless Pioneer", "Adhomian Dream")]"
	..()

/obj/effect/shuttle_landmark/headmaster_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav1
	name = "Headmaster Ship Navpoint #1"
	landmark_tag = "nav_headmaster_ship_1"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav2
	name = "Headmaster Ship Navpoint #2"
	landmark_tag = "nav_headmaster_ship_2"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav3
	name = "Headmaster Ship Navpoint #3"
	landmark_tag = "nav_headmaster_ship_3"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav4
	name = "Headmaster Ship Navpoint #4"
	landmark_tag = "nav_headmaster_ship_4"

//shuttle
/obj/effect/overmap/visitable/ship/landable/headmaster_shuttle
	name = "Orbital Fleett Shuttle"
	icon_state = "shuttle_grey"
	moving_state = "shuttle_grey_moving"
	class = "PRAMV"
	designation = "Yve'kha"
	desc = "A simple and reliable shuttle design used by the Orbital Fleet."
	shuttle = "Orbital Fleett Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/headmaster_shuttle
	name = "shuttle control console"
	shuttle_tag = "Orbital Fleet Shuttle"


/datum/shuttle/autodock/overmap/headmaster_shuttle
	name = "Orbital Fleet Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/headmaster_shuttle)
	current_location = "nav_headmaster_shuttlee"
	landmark_transition = "nav_transit_headmaster_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_headmaster_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/headmaster_shuttle/hangar
	name = "Adhomian Freight Shuttle Hangar"
	landmark_tag = "nav_headmaster_shuttle"
	docking_controller = "headmaster_shuttle_dock"
	base_area = /area/headmaster_ship/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/headmaster_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_headmaster_shuttle"
	base_turf = /turf/space/transit/north