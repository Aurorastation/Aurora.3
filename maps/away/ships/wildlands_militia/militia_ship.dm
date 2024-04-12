/datum/map_template/ruin/away_site/militia_ship
	name = "Militia Ship"
	description = "An unarmed and extremely prolific design of large, self-sufficient shuttle, prized for its modularity. Found all throughout the spur, the Yak-class shuttle can be configured to conceivably serve in any role, though it is only rarely armed with ship-to-ship weapons. Manufactured by Hephaestus."
	suffixes = list("ships/wildlands_milita/militia_ship.dmm")
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "militia_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/militia_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/militia_ship
	map = "Militia Ship"
	descriptor = "An unarmed and extremely prolific design of large, self-sufficient shuttle, prized for its modularity. Found all throughout the spur, the Yak-class shuttle can be configured to conceivably serve in any role, though it is only rarely armed with ship-to-ship weapons. Manufactured by Hephaestus."

//areas
/area/ship/militia_ship
	name = "Militia Ship"

/area/shuttle/militia_shuttle
	name = "Militia Ship"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/militia_ship
	name = "Militia Ship"
	class = "IPV"
	desc = "An unarmed and extremely prolific design of large, self-sufficient shuttle, prized for its modularity. Found all throughout the spur, the Yak-class shuttle can be configured to conceivably serve in any role, though it is only rarely armed with ship-to-ship weapons. Manufactured by Hephaestus."
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Militia Ship" = list("nav_hangar_militia")
	)

	initial_generic_waypoints = list(
		"nav_militia_ship_1",
		"nav_militia_ship_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/militia_ship/New()
	designation = "[pick("Volunteer", "Part-Timer", "Last Line", "Fearless", "Protector", "Minuteman", "Watchdog", "Family Man", "Guardian", "Hoplite", "Home Guard", "Defender")]"
	..()

/obj/effect/shuttle_landmark/militia_ship/nav1
	name = "Militia Ship - Port Side"
	landmark_tag = "nav_militia_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/militia_ship/nav2
	name = "Militia Ship - Port Airlock"
	landmark_tag = "nav_militia_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/militia_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_militia_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/militia_shuttle
	name = "Militia Ship"
	class = "IPV"
	designation = "Boulevard"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one's transponder identifies it as belonging to an independent militia."
	shuttle = "Militia Ship"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/militia_shuttle
	name = "shuttle control console"
	shuttle_tag = "Militia Ship"


/datum/shuttle/autodock/overmap/militia_shuttle
	name = "Militia Ship"
	move_time = 20
	shuttle_area = list(/area/shuttle/militia_shuttle)
	current_location = "nav_hangar_militia"
	landmark_transition = "nav_transit_militia_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_militia"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/militia_shuttle/hangar
	name = "Militia Ship Hangar"
	landmark_tag = "nav_hangar_militia"
	docking_controller = "militia_shuttle_dock"
	base_area = /area/ship/militia_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/militia_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_militia_shuttle"
	base_turf = /turf/space/transit/north
