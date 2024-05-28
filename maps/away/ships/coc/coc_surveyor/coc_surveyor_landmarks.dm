// --------------------- shuttle

/obj/effect/shuttle_landmark/coc_survey_shuttle/shuttle_dock
	name = "CoC Surveyor Shuttle Dock"
	landmark_tag = "coc_surveyor_shuttle"
	docking_controller = "coc_surveyor_shuttle"
	base_area = /area/shuttle/coc_survey_shuttle
	base_turf = /turf/space/dynamic
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/map_effect/marker/airlock/shuttle/coc_survey_ship/shuttle_dock
	name = "Shuttle Dock"
	landmark_tag = "coc_surveyor_shuttle"
	master_tag = "airlock_coc_survey_shuttle_dock"

/obj/effect/shuttle_landmark/coc_survey_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_survey_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks + things I don't wanna redo so I'm just moving them from the main dm to here so its cleaner. Don't worry about it <3

/obj/effect/shuttle_landmark/coc_survey_ship
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/coc_survey_ship/nav1
	name = "Port"
	landmark_tag = "nav_surveyor_1"

/obj/effect/shuttle_landmark/coc_survey_ship/nav2
	name = "Starboard"
	landmark_tag = "nav_surveyor_2"

/obj/effect/shuttle_landmark/coc_survey_ship/nav3
	name = "Aft"
	landmark_tag = "nav_surveyor_3"

/obj/effect/shuttle_landmark/coc_survey_ship/nav4
	name = "Fore"
	landmark_tag = "nav_surveyor_4"

/obj/effect/shuttle_landmark/coc_survey_ship/port_dock
	name = "Port Docking Bay"
	landmark_tag = "nav_surveyor_portdock"
	docking_controller = "airlock_coc_surveyor_port"

/obj/effect/map_effect/marker/airlock/docking/coc_survey_ship/dock/port
	name = "Dock, port"
	landmark_tag = "nav_coc_surveyor_dock_port"
	master_tag = "airlock_coc_survey_ship_port"

/obj/effect/shuttle_landmark/coc_survey_ship/starboard_dock
	name = "Starboard Docking Bay"
	landmark_tag = "nav_surveyor_starboarddock"
	docking_controller = "airlock_coc_surveyor_starboard"

/obj/effect/map_effect/marker/airlock/docking/coc_survey_ship/dock/starboard
	name = "Dock, Aft"
	landmark_tag = "nav_coc_survey_ship_dock_starboard"
	master_tag = "airlock_coc_survey_ship_starboard"

/obj/effect/map_effect/marker/airlock/docking/coc_survey_ship/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_coc_survey_ship_dock_aft"
	master_tag = "airlock_coc_survey_ship_aft"
