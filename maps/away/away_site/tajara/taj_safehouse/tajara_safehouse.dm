/datum/map_template/ruin/away_site/tajara_safehouse
	name = "abandoned outpost"
	description = "A derelict space outpost."
	suffix = "away_site/tajara/taj_safehouse/tajara_safehouse.dmm"
	sectors = list(SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 2
	id = "tajara_safehouse"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajara_safehouse_shuttle)

/decl/submap_archetype/tajara_safehouse
	map = "abandoned outpost"
	descriptor = "A derelict space outpost."

/obj/effect/overmap/visitable/sector/tajara_safehouse
	name = "abandoned outpost"
	desc = "A derelict space outpost."
	initial_restricted_waypoints = list(
		"Unmarked Civilian Shuttle" = list("nav_hangar_tajara_safehouse")
	)
	comms_support = TRUE

/area/tajara_safehouse
	name = "Abandoned Outpost"
	icon_state = "bar"
	flags = RAD_SHIELDED | HIDE_FROM_HOLOMAP
	requires_power = FALSE
	base_turf = /turf/simulated/floor/plating
	no_light_control = TRUE

/area/tajara_safehouse/hangar
	name = "Abandoned Outpost Hangar"
	icon_state = "exit"

/area/shuttle/tajara_safehouse_shuttle
	name = "Unmarked Civilian Shuttle"
	icon_state = "shuttle2"

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tajara_safehouse_shuttle
	name = "Unmarked Civilian Shuttle"
	class = "Unmarked"
	designation = "Civilian Shuttle"
	desc = "A civilian shuttle without any kind of identification."
	shuttle = "Unmarked Civilian Shuttle"
	icon_state = "shuttle_grey"
	moving_state = "shuttle_grey_moving"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tajara_safehouse_shuttle
	name = "shuttle control console"
	shuttle_tag = "Unmarked Civilian Shuttle"


/datum/shuttle/autodock/overmap/tajara_safehouse_shuttle
	name = "Unmarked Civilian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tajara_safehouse_shuttle)
	current_location = "nav_hangar_tajara_safehouse"
	landmark_transition = "nav_transit_tajara_safehouse"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tajara_safehouse"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tajara_safehouse_shuttle/hangar
	name = "Unmarked Civilian Hangar"
	landmark_tag = "nav_hangar_tajara_safehouse"
	docking_controller = "tajara_safehouse_shuttle_dock"
	base_area = /area/tajara_safehouse/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tajara_safehouse_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajara_safehouse"
	base_turf = /turf/space/transit/north
