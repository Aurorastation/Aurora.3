
/datum/shuttle/autodock/ferry/event_transport
	name = "SCCV Polish Punk"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/event_transport
	move_time = 20
	dock_target = "event_transport_shuttle"
	waypoint_station = "nav_event_transport_dock"
	landmark_transition = "nav_event_transport_interim"
	waypoint_offsite = "nav_event_transport_start"

/obj/effect/shuttle_landmark/event_transport/start
	name = "Point Verdant Spaceport"
	landmark_tag = "nav_event_transport_start"
	docking_controller = "event_transport_station"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/point_verdant/outdoors

/obj/effect/shuttle_landmark/event_transport/interim
	name = "In Transit"
	landmark_tag = "nav_event_transport_interim"
	base_turf = /turf/space/transit/bluespace/south

/obj/effect/shuttle_landmark/event_transport/dock
	name = "IAC Adam Bernard Mickiewicz"
	landmark_tag = "nav_event_transport_dock"
	docking_controller = "event_transport_shuttle_dock"
	base_turf = /turf/space
	base_area = /area/space

/area/shuttle/event_transport
	name = "SCCV Polish Punk Shuttle"
	base_turf = /turf/space
	sound_env = LARGE_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF

/obj/machinery/computer/shuttle_control/event_transport
	name = "SCCV Polish Punk control console"
	req_access = null
	shuttle_tag = "SCCV Polish Punk"
	ui_template = "ShuttleControlConsoleEventShuttle"
	var/auth_code = "tonkotsu ramen"

/obj/machinery/computer/shuttle_control/event_transport/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/shuttle, var/action, var/list/params)
	if(!istype(shuttle))
		return FALSE

	if(params["auth_code_input"] != auth_code)
		return FALSE

	. = ..()

/obj/machinery/computer/shuttle_control/event_transport/ui_data_more()
	. = list("auth_code" = auth_code)
