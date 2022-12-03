/datum/map_template/ruin/away_site/diona_serz_ship
	name = "Serz Clan Ship"
	description = "A ship belonging to the Serz voidtamer clan, a group of Dioane who specalize in selling spacefauna."
	suffix = "ships/dionae/diona_serz_ship/diona_serz_ship.dmm"
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "diona_serz"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/diona_serz_ship_shuttle)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/decl/submap_archetype/diona_serz_ship
	map = "Serz Clan Ship"
	descriptor = "A ship belonging to the Serz voidtamer clan, a group of Dioane who specalize in selling spacefauna."

//areas
/area/ship/diona_serz_ship
	name = "Serz Clan Ship"

/area/shuttle/diona_serz_ship_shuttle
	name = "Serz Clan Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/diona_serz_ship
	name = "Serz Clan Ship"
	class = "SCS"
	desc = "A ship belonging to the Serz voidtamer clan, a group of Dioane who specalize in selling spacefauna."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Serz Clan Shuttle" = list("nav_diona_serz_ship_shuttle")
	)

	initial_generic_waypoints = list(
		"nav_diona_serz_ship_1",
		"nav_diona_serz_ship_2"
	)

/obj/effect/overmap/visitable/ship/diona_serz_ship/New()
    designation = "[pick("Trawler", "Floating Spear ", "Harpoon")]"
    ..()

/obj/effect/shuttle_landmark/diona_serz_ship/nav1
	name = "Serz Clan Ship - Port Side"
	landmark_tag = "nav_diona_serz_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/diona_serz_ship/nav2
	name = "Serz Clan Ship - Port Airlock"
	landmark_tag = "nav_serz_serz_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/diona_serz_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_diona_serz_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/diona_serz_ship_shuttle
	name = "Serz Clan Shuttle"
	class = "SCS"
	designation = "Serz Clan Shuttle"
	desc = "A shuttle belonging to the Serz clan of voidtamers."
	shuttle = "Serz Clan Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/diona_serz_ship
	name = "shuttle control console"
	shuttle_tag = "Serz Clan Shuttle"


/datum/shuttle/autodock/overmap/diona_serz_ship_shuttle
	name = "Serz Clan Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/diona_serz_ship_shuttle)
	current_location = "nav_diona_serz_ship_shuttle"
	landmark_transition = "nav_transit_diona_serz_ship_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_tdiona_serz_ship_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/diona_serz_ship_shuttle/hangar
	name = "Serz Clan Shuttle Hanger"
	landmark_tag = "nav_diona_serz_ship_shuttle"
	docking_controller = "diona_serz_ship_shuttle_dock"
	base_area = /area/ship/diona_serz_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/diona_serz_ship_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_diona_serz_ship_shuttle"
	base_turf = /turf/space/transit/north
