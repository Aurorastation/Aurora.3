/obj/effect/overmap/visitable/ship/sccv_horizon
	name = "SCCV Horizon"
	desc = "A line without compare, the Venator-series consists of one vessel so far: the SCCV Horizon, the lead ship of its class. Designed to be an entirely self-sufficient general-purpose surveying ship and to carry multiple replacement crews simultaneously, the Venator is equipped with both a bluespace and a warp drive and two different engines. Defying typical cruiser dimensions, the Venator is home to a sizable residential deck below the operations deck of the ship, where the crew is housed. It also features weapon hardpoints in its prominent wing nacelles. This one’s transponder identifies it, obviously, as the SCCV Horizon."
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
	"nav_hangar_horizon_2",
	"nav_hangar_horizon_3"
	)


/obj/machinery/computer/shuttle_control/explore/intrepid
	name = "Intrepid control console"
	shuttle_tag = "Intrepid"
	req_access = list(access_intrepid)

/obj/effect/overmap/visitable/ship/landable/intrepid
	name = "Intrepid"
	desc = "A standard-sized unarmed exploration shuttle manufactured by Hephaestus, the Pathfinder-class is commonly used by the corporations of the SCC. Featuring well-rounded facilities and equipment, the Pathfinder is excellent, albeit pricey, platform. This one’s transponder identifies it as the SCCV Intrepid."
	shuttle = "Intrepid"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/mining_shuttle
	name = "Mining Shuttle"
	desc = "A common, modestly-sized short-range shuttle manufactured by Hephaestus. Most frequently used as a mining platform, the Pickaxe-class is entirely reliant on a reasonably-sized mothership for anything but short-term functionality. This one’s transponder identifies it as belonging to the Stellar Corporate Conglomerate."
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
	name = "Port Hangar Bay 1"
	landmark_tag = "nav_hangar_horizon_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/nav2
	name = "Port Hangar Bay 2"
	landmark_tag = "nav_hangar_horizon_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/nav3
	name = "Starboard Primary Docking Arm"
	landmark_tag = "nav_hangar_horizon_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space