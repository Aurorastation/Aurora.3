/obj/effect/overmap/visitable/ship/sccv_horizon
	name = "SCCV Horizon"
	desc = "A Stellar Conglomerate Vessel general purpose ship."
	fore_dir = SOUTH
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	base = TRUE

	initial_restricted_waypoints = list(
		"Mining Shuttle" = list("nav_hangar_mining"), 	//can't have random shuttles popping inside the ship
		"Intrepid" = list("nav_hangar_intrepid")
	)

	initial_generic_waypoints = list(
	"nav_hangar_horizon_1",
	"nav_hangar_horizon_2"
	)


/obj/machinery/computer/shuttle_control/explore/intrepid
	name = "Intrepid control console"
	shuttle_tag = "Intrepid"
	req_access = list(access_intrepid)

/obj/effect/overmap/visitable/ship/landable/intrepid
	name = "Intrepid"
	desc = "An exploration shuttle used by SCC general purpose ships"
	shuttle = "Intrepid"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/mining_shuttle
	name = "Mining Shuttle"
	desc = "A mining shuttle used by SCC general purpose ships to gather resources in asteroid fields."
	shuttle = "Mining Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/mining_shuttle
	name = "mining shuttle control console"
	shuttle_tag = "Mining Shuttle"
	req_access = list(access_mining)

/obj/effect/shuttle_landmark/horizon/nav1
	name = "SCCV Horizon Navpoint #1"
	landmark_tag = "nav_hangar_horizon_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/nav2
	name = "SCCV Horizon Navpoint #2"
	landmark_tag = "nav_hangar_horizon_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary