/datum/map_template/ruin/away_site/peoples_station
	name = "People's Space Station"
	description = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."
	suffix = "away_site/tajara/scrapper/peoples_station.dmm"
	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 1
	spawn_cost = 1
	id = "peoples_station"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/peoples_station_fang)

/decl/submap_archetype/peoples_station
	map = "People's Space Station"
	descriptor = "A derelict space outpost."

/obj/effect/overmap/visitable/sector/peoples_station
	name = "abandoned outpost"
	desc = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."
	initial_restricted_waypoints = list(
		"People's Station Fang" = list("nav_transit_peoples_station_fang"),
		"Intrepid" = list("nav_peoples_station_dockintrepid")
	)

/obj/effect/overmap/visitable/sector/peoples_station/dockintrepid // restricted for the intrepid only or else other ships will be able to use this point, and not properly dock
	name = "People's Space Station Intrepid Docking"
	landmark_tag = "nav_peoples_station_dockintrepid"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav1
	name = "Kataphract Ship Navpoint #1"
	landmark_tag = "nav_kataphract_ship_1"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav2
	name = "Kataphract Ship Navpoint #2"
	landmark_tag = "nav_kataphract_ship_2"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav3
	name = "Kataphract Ship Navpoint #3"
	landmark_tag = "nav_kataphract_ship_3"

//fang ship
/obj/effect/overmap/visitable/ship/landable/peoples_station_fang
	name = "Orbital Fleet Fang"
	class = "PRAMV" //People's Republic of Adhomai Vessel
	desc = "An interceptors used by Orbital Fleet in its carriers and stations."
	shuttle = "Unmarked Civilian Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
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
	name = "People's Station Fang"
	move_time = 20
	shuttle_area = list(/area/shuttle/tajara_safehouse_shuttle)
	current_location = "peoples_station_fang_dock"
	landmark_transition = "nav_transit_peoples_station_fang"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "peoples_station_fang_dock"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/peoples_station_fang/hangar
	name = "People's Station Fang Hangar"
	landmark_tag = "nav_hangar_peoples_station_fang"
	docking_controller = "peoples_station_fang_dock"
	base_area = /area/tajara_safehouse/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/peoples_station_fang/transit
	name = "In transit"
	landmark_tag = "nav_transit_peoples_station_fang"
	base_turf = /turf/space/transit/north