/datum/map_template/ruin/away_site/diona_rokz_ship
	name = "Rokz Clan Ship"
	description = "A ship belonging to the Rokz voidtamer clan, a group of dionae who specialize in selling space fauna."
	suffix = "ships/dionae/diona_rokz_ship/diona_rokz_ship.dmm"
	sectors = list(SECTOR_BADLANDS, SECTOR_GAKAL, SECTOR_UUEOAESA)
	spawn_weight = 1
	spawn_cost = 1
	id = "diona_rokz"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/diona_rokz_ship_shuttle)

/decl/submap_archetype/diona_rokz_ship
	map = "Rokz Clan Ship"
	descriptor = "A ship belonging to the Rokz voidtamer clan, a group of dionae who specialize in selling space fauna."

//areas
/area/ship/diona_rokz_ship
	name = "Rokz Clan Ship"

/area/shuttle/diona_rokz_ship_shuttle
	name = "Rokz Clan Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/diona_rokz_ship
	name = "Rokz Clan Ship"
	class = "RCS"
	desc = "A ship belonging to the Rokz voidtamer clan, a group of dionae who specialize in selling space fauna."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Rokz Clan Shuttle" = list("nav_diona_rokz_ship_shuttle")
	)

	initial_generic_waypoints = list(
		"nav_diona_rokz_ship_1",
		"nav_diona_rokz_ship_2"
	)

/obj/effect/overmap/visitable/ship/diona_rokz_ship/New()
    designation = "[pick("Boulder", "Stonecarp", "Gibber")]"
    ..()

/obj/effect/shuttle_landmark/diona_rokz_ship/nav1
	name = "Rokz Clan Ship - Port Side"
	landmark_tag = "nav_diona_rokz_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/diona_rokz_ship/nav2
	name = "Rokz Clan Ship - Port Airlock"
	landmark_tag = "nav_diona_rokz_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/diona_rokz_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_diona_rokz_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/diona_rokz_ship_shuttle
	name = "Rokz Clan Shuttle"
	class = "RCS"
	designation = "Rokz Clan Shuttle"
	desc = "A shuttle belonging to the Rokz clan of voidtamers."
	shuttle = "Rokz Clan Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/diona_rokz_ship
	name = "shuttle control console"
	shuttle_tag = "Rokz Clan Shuttle"


/datum/shuttle/autodock/overmap/diona_rokz_ship_shuttle
	name = "Rokz Clan Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/diona_rokz_ship_shuttle)
	current_location = "nav_diona_rokz_ship_shuttle"
	landmark_transition = "nav_transit_diona_rokz_ship_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_diona_rokz_ship_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/diona_rokz_ship_shuttle/hangar
	name = "Rokz Clan Shuttle Hangar"
	landmark_tag = "nav_diona_rokz_ship_shuttle"
	docking_controller = "diona_rokz_ship_shuttle_dock"
	base_area = /area/ship/diona_rokz_ship
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/diona_rokz_ship_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_diona_rokz_ship_shuttle"
	base_turf = /turf/space/transit/north
