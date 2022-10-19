/datum/map_template/ruin/away_site/tirakqi_freighter
	name = "Ti'Rakqi Freighter"
	description = "A large skrellian freighter often seen skulking around space near the borders of the Traverse. This model has a large cargo hold, swift engines, and a deceptively large fuel reserve. Perfect for any smuggler on the go. This one's transponder identifies it as belonging to an independent freighter."
	suffix = "ships/tirakqi_freighter.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "tirakqi_freighter"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tirakqi_shuttle)

/decl/submap_archetype/tirakqi_freighter
	map = "Ti'Rakqi Freighter"
	descriptor = "A large skrellian freighter often seen skulking around space near the borders of the Traverse. This model has a large cargo hold, swift engines, and a deceptively large fuel reserve. Perfect for any smuggler on the go. This one's transponder identifies it as belonging to an independent freighter."

//areas
/area/ship/tirakqi_freighter
	name = "Ti'Rakqi Freighter"

/area/shuttle/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/tirakqi_freighter
	name = "Ti'Rakqi Freighter"
	desc = "A large skrellian freighter often seen skulking around space near the borders of the Traverse. This model has a large cargo hold, swift engines, and a deceptively large fuel reserve. Perfect for any smuggler on the go. This one's transponder identifies it as belonging to an independent freighter."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	class = "ISV"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Ti'Rakqi Shuttle" = list("nav_hangar_tirakqi_shuttle")
	)

	initial_generic_waypoints = list(
		"nav_tirakqi_freighter_1",
		"nav_tirakqi_freighter_2",
		"nav_tirakqi_freighter_3",
		"nav_tirakqi_freighter_4"
	)

/obj/effect/overmap/visitable/ship/tirakqi_freighter/New()
    designation = "[pick("Bigger Squib", "Frightful Whaler", "Star Spanner", "Lu'Kaax", "Star Scamp", "Ocean Ink", "Yippi")]"
    ..()

/obj/effect/shuttle_landmark/tirakqi_freighter/nav1
	name = "Ti'Rakqi Freighter - Starboard"
	landmark_tag = "nav_tirakqi_freighter_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_freighter/nav2
	name = "Ti'Rakqi Freighter - Port"
	landmark_tag = "nav_tirakqi_freighter_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_freighter/nav3
	name = "Ti'Rakqi Freighter - Fore"
	landmark_tag = "nav_tirakqi_freighter_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_freighter/nav4
	name = "Ti'Rakqi Freighter - Aft"
	landmark_tag = "nav_tirakqi_freighter_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_freighter/transit
	name = "In transit"
	landmark_tag = "nav_tirakqi_freighter_freighter"
	base_turf = /turf/space/transit/south

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	class = "ISV"
	designation = "Ku'ku"
	desc = "A simple and fast transport shuttle. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Ti'Rakqi Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tirakqi_shuttle
	name = "shuttle control console"
	shuttle_tag = "Ti'Rakqi Shuttle"
	req_access = list(access_skrell)

/datum/shuttle/autodock/overmap/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tirakqi_shuttle)
	current_location = "nav_hangar_tirakqi_shuttle"
	landmark_transition = "nav_transit_tirakqi_freighter"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tirakqi_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tirakqi_shuttle/hangar
	name = "Ti'Rakqi Shuttle Hangar"
	landmark_tag = "nav_hangar_tirakqi_shuttle"
	docking_controller = "tirakqi_tirakqi_shuttle_dock"
	base_area = /area/ship/tirakqi_freighter
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tirakqi_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tirakqi_freighter"
	base_turf = /turf/space/transit/south
