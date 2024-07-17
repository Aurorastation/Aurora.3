// This should be everything you need to make the thing work. Make the tweaks you need to, and just copy/paste everything into your main event dm or however you wanna break it up.

/obj/effect/overmap/visitable/ship/landable/scc_passanger_shuttle
	name = "SCC Passanger Shuttle"
	class = "SCCV"
	desc = "A prototype passenger shuttle designed by Orion Express, with the sole goal of moving a new kind of cargo: people. Design of the pattern started at the beginning of the Konyang Hivebot Crisis of 2466, heavily influenced by data received from local aid workers, the IAC, and the SCC's own mission to Konyang. Comfortable sits 80 passangers, plus 12 handrails and 7 seats for crew."
	shuttle = "SCCV Opossum"
	icon_state = "intrepid"
	moving_state = "intrepid_moving"
	colors = list("#cfd4ff", "#78adf8")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Orion Express, Hephaestus Industries"
	volume = "30 meters length, 18 meters beam/width, 6 meters vertical height"
	sizeclass = "Prototype Civilian Shuttle"
	shiptype = "Field expeditions and passanger travel."

/datum/shuttle/autodock/overmap/scc_passanger_shuttle
	name = "SCCV Opossum"
	move_time = 20
	shuttle_area = list(/area/shuttle/sccv_opossum)
	dock_target = "airlock_scc_passanger_shuttle"
	current_location = "nav_scc_passanger_shuttle"
	landmark_transition = "nav_transit_scc_passanger_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scc_passanger_shuttle"
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/explore/terminal/scc_passanger_shuttle
	name = "shuttle control console"
	shuttle_tag = "SCC Passanger Shuttle"

/obj/effect/map_effect/marker/airlock/shuttle/scc_passanger_shuttle
	name = "SCC Passanger Shuttle"
	shuttle_tag = "SCC Passanger Shuttle"
	master_tag = "airlock_scc_passanger_shuttle"
	cycle_to_external_air = FALSE


// ---------------------  area
/area/shuttle/sccv_opossum
	name = "SCCV Opossum"
	icon_state = "shuttle"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_outside = FALSE


// --------------------- shuttle landmark base

/obj/effect/shuttle_landmark/scc_passanger_shuttle
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle landmarks -- Set the base area accordingly, left blank in document.

/obj/effect/shuttle_landmark/scc_passanger_shuttle/hangar
	name = "Opossum Hanger Spot"
	landmark_tag = "nav_scc_passanger_shuttle"
	docking_controller = "scc_passanger_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/scc_passanger_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_scc_passanger_shuttle"
	base_turf = /turf/space/transit/north
