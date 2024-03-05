/datum/map/event/point_verdant
	name = "Point Verdant"
	full_name = "Point Verdant"
	path = "event/raccoon_city"
	lobby_icons = list('icons/misc/titlescreens/raccoon_city/raccoon_city.dmi')
	lobby_transitions = 0

	allowed_jobs = list(/datum/job/visitor, /datum/job/passenger)

	station_levels = list(1,2,3)
	//admin_levels = list(4)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3)
	accessible_z_levels = list(1,2,3)
	restricted_levels = list()

	station_name = "Point Verdant"
	station_short = "Point Verdant"
	dock_name = "SCCV Horizon"
	dock_short = "Horizon"
	boss_name = "Stellar Corporate Conglomerate"
	boss_short = "SCC"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	use_overmap = FALSE
	force_spawnpoint = TRUE
	map_shuttles = list(/datum/shuttle/autodock/ferry/scc_transport)

/area/shuttle/scc
	name = "SCC Transport Shuttle"

/datum/shuttle/autodock/ferry/scc_transport
	name = "SCC Transport Shuttle"
	location = 0
	warmup_time = 10
	shuttle_area = /area/shuttle/scc
	move_time = 90
	dock_target = "scc_transport"
	waypoint_station = "nav_scc_transport_start"
	landmark_transition = "nav_scc_transport_interim"
	waypoint_offsite = "nav_scc_transport_dock"
	knockdown = FALSE

/obj/effect/shuttle_landmark/scc_transport/start
	name = "SCC Transport Shuttle Dock"
	landmark_tag = "nav_scc_transport_start"
	docking_controller = "scc_transport_station"

/obj/effect/shuttle_landmark/scc_transport/interim
	name = "In Transit"
	landmark_tag = "nav_scc_transport_interim"
	base_turf = /turf/space/transit/bluespace/west

/obj/effect/shuttle_landmark/scc_transport/dock
	name = "Point Verdant Spaceport"
	landmark_tag = "nav_scc_transport_dock"
	docking_controller = "scc_transport_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/point_verdant/outdoors

/obj/machinery/computer/shuttle_control/scc_transport
	name = "transport shuttle control console"
	shuttle_tag = "SCC Transport Shuttle"
