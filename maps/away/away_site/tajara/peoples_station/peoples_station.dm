/datum/map_template/ruin/away_site/peoples_station
	name = "People's Space Station"
	description = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."

	prefix = "away_site/tajara/peoples_station/"
	suffix = "peoples_station.dmm"

	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 2.5
	spawn_cost = 1
	id = "peoples_station"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/peoples_station_fang, /datum/shuttle/autodock/overmap/peoples_station_transport)

	unit_test_groups = list(2)

/singleton/submap_archetype/peoples_station
	map = "People's Space Station"
	descriptor = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."

/obj/effect/overmap/visitable/ship/stationary/peoples_station
	name = "People's Space Station"
	class = "PRASS"
	designation = "People's Space Station"
	desc = "Built in the interwar period, the People's Space Station bears the prestige of being the first space installation designed, constructed, and manned by Tajara."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "battlestation"
	color = "#8C8A81"
	static_vessel = TRUE
	generic_object = FALSE
	scanimage = "pss.png"
	designer = "People's Republic of Adhomai"
	volume = "101 meters length, 115 meters beam/width, 32 meters vertical height"
	weapons = "Dual extruding starboard-mounted medium and small caliber ballistic armament, two port obscured flight craft bays"
	sizeclass = "Armed military surveillance and waypoint station"
	place_near_main = list(2, 2)

	initial_generic_waypoints = list(
		"nav_peoples_station_ship_1",
		"nav_peoples_station_ship_1",
		"nav_peoples_station_ship_3",
		"nav_peoples_station_ship_4",
		"nav_peoples_station_fore_dock",
		"nav_peoples_station_aft_dock",
		"nav_peoples_station_port_dock",
		"nav_peoples_station_starboard_dock"
	)
	initial_restricted_waypoints = list(
		"Orbital Fleet Fang" = list("nav_hangar_peoples_station_fang"),
		"People's Station Transport Shuttle" = list("nav_hangar_peoples_station_transport")
	)
	comms_support = TRUE
	comms_name = "people's station"

/obj/effect/overmap/visitable/ship/stationary/peoples_station/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "pss")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

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
	desc = "An interceptor used by the Orbital Fleet in its carriers and stations."
	shuttle = "Orbital Fleet Fang"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8C8A81")
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
/obj/machinery/computer/shuttle_control/explore/terminal/peoples_station_fang
	name = "shuttle control console"
	shuttle_tag = "Orbital Fleet Fang"

/datum/shuttle/autodock/overmap/peoples_station_fang
	name = "Orbital Fleet Fang"
	move_time = 20
	shuttle_area = list(/area/shuttle/fang)
	current_location = "nav_hangar_peoples_station_fang"
	landmark_transition = "nav_transit_peoples_station_fang"
	range = 1
	fuel_consumption = 2
	dock_target = "peoples_station_fang"
	logging_home_tag = "nav_hangar_peoples_station_fang"
	defer_initialisation = TRUE

//transport shuttle

/obj/effect/overmap/visitable/ship/landable/peoples_station_transport
	name = "People's Station Transport Shuttle"
	class = "PRAMV"
	designation = "Yve'kha"
	desc = "A simple and reliable shuttle design used by the Orbital Fleet."
	shuttle = "People's Station Transport Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8C8A81")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/peoples_station_transport
	name = "shuttle control console"
	shuttle_tag = "People's Station Transport Shuttle"

/datum/shuttle/autodock/overmap/peoples_station_transport
	name = "People's Station Transport Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/peoples_station_transport)
	current_location = "nav_peoples_station_transport"
	landmark_transition = "nav_transit_peoples_station_transport"
	dock_target = "peoples_station_transport"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_peoples_station_transport"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/peoples_station_transport/hangar
	name = "People's Station Transport Shuttle"
	landmark_tag = "nav_peoples_station_transport"
	docking_controller = "peoples_station_transport_dock"
	base_area = /area/peoples_station/transport_hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/peoples_station_transport/transit
	name = "In transit"
	landmark_tag = "nav_transit_peoples_station_transport"
	base_turf = /turf/space/transit/north
