/datum/map_template/ruin/away_site/peoples_station
	name = "People's Space Station"
	description = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."
	suffix = "away_site/tajara/peoples_station/peoples_station.dmm"
	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 1
	spawn_cost = 1
	id = "peoples_station"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/peoples_station_fang)

/decl/submap_archetype/peoples_station
	map = "People's Space Station"
	descriptor = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."

/obj/effect/overmap/visitable/sector/peoples_station
	name = "People's Space Station"
	desc = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."
	initial_generic_waypoints = list(
		"nav_peoples_station_ship_1",
		"nav_peoples_station_ship_1",
		"nav_peoples_station_ship_3"
	)
	initial_restricted_waypoints = list(
		"Orbital Fleet Fang" = list("nav_hangar_peoples_station_fang"),
		"Intrepid" = list("nav_peoples_station_dockintrepid")
	)
	light_power = 3
	light_range = 2

/obj/effect/shuttle_landmark/nav_peoples_station/dockintrepid
	name = "People's Space Station Intrepid Docking"
	landmark_tag = "nav_peoples_station_dockintrepid"
	base_area = /area/peoples_station/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_peoples_station/nav1
	name = "People's Space Station Navpoint #1"
	landmark_tag = "nav_peoples_station_ship_1"

/obj/effect/shuttle_landmark/nav_peoples_station/nav2
	name = "People's Space Station Navpoint #2"
	landmark_tag = "nav_peoples_station_ship_2"

/obj/effect/shuttle_landmark/nav_peoples_station/nav3
	name = "People's Space Station Navpoint #3"
	landmark_tag = "nav_peoples_station_ship_3"

//fang ship
/obj/effect/overmap/visitable/ship/landable/peoples_station_fang
	name = "Orbital Fleet Fang"
	class = "PRAMV" //People's Republic of Adhomai Vessel
	desc = "An interceptors used by Orbital Fleet in its carriers and stations."
	shuttle = "Orbital Fleet Fang"
	max_speed = 1/(1 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/peoples_station_fang/New()
	if (prob(50))
		designation = "Hadii"
	else
		designation = "[pick("Adhomai's Finest", "Party's Dagger", "Sunray", "Kazarrhaldiye", "Revolutionary Courage", "Hadiist Avenger")]"
	..()
/obj/machinery/computer/shuttle_control/explore/peoples_station_fang
	name = "shuttle control console"
	shuttle_tag = "Orbital Fleet Fang"

/datum/shuttle/autodock/overmap/peoples_station_fang
	name = "Orbital Fleet Fang"
	move_time = 20
	shuttle_area = list(/area/shuttle/fang/engine, /area/shuttle/fang/bridge)
	current_location = "nav_hangar_peoples_station_fang"
	landmark_transition = "nav_transit_peoples_station_fang"
	range = 1
	fuel_consumption = 2
	dock_target = "peoples_station_fang"
	logging_home_tag = "nav_hangar_peoples_station_fang"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/peoples_station_fang/hangar
	name = "People's Station Fang Hangar"
	landmark_tag = "nav_hangar_peoples_station_fang"
	docking_controller = "peoples_station_fang_dock"
	base_area = /area/peoples_station/fang
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/peoples_station_fang/transit
	name = "In transit"
	landmark_tag = "nav_transit_peoples_station_fang"
	base_turf = /turf/space/transit/north