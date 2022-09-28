/datum/map_template/ruin/away_site/adhomian_circus
	name = "Adhomian Traveling Circus"
	description = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."
	suffix = "ships/circus/adhomian_circus.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	spawn_cost = 1
	id = "adhomian_circus_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/adhomian_circus_shuttle)

/decl/submap_archetype/adhomian_circus
	map = "Adhomian Traveling Circus"
	descriptor = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."

//areas
/area/ship/adhomian_circus
	name = "Adhomian Traveling Circus"

/area/shuttle/adhomian_circus_shuttle
	name = "Adhomian Traveling Circus Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/adhomian_circus
	name = "Adhomian Traveling Circus"
	class = "ACV"
	desc = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Adhomian Circus Shuttle" = list("nav_hangar_adhomian_circus")
	)

/obj/effect/overmap/visitable/ship/adhomian_circus/New()
	designation = "[pick("Kalmykova", "Flying Rafama", "Harazhimir Brothers")]"
	..()

/obj/effect/shuttle_landmark/adhomian_circus/transit
	name = "In transit"
	landmark_tag = "nav_transit_adhomian_circus"
	base_turf = /turf/space/transit/south

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/adhomian_circus_shuttle
	name = "Adhomian Circus Shuttle"
	desc = "An inefficient and rustic looking shuttle. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Adhomian Circus Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/adhomian_circus_shuttle
	name = "shuttle control console"
	shuttle_tag = "Adhomian Circus Shuttle"

/datum/shuttle/autodock/overmap/adhomian_circus_shuttle
	name = "Adhomian Circus Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tcfl_shuttle)
	current_location = "nav_hangar_adhomian_circus_shuttle"
	landmark_transition = "nav_transit_adhomian_circus_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_adhomian_circus_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/adhomian_circus_shuttle/hangar
	name = "Adhomian Circus Shuttle"
	landmark_tag = "nav_hangar_tcfl"
	docking_controller = "adhomian_circus_shuttle_shuttle_dock"
	base_area = /area/ship/tcfl_peacekeeper_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/adhomian_circus_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_adhomian_circus_shuttle"
	base_turf = /turf/space/transit/south
