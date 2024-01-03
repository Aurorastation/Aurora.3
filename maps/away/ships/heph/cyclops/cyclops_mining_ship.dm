/datum/map_template/ruin/away_site/cyclops_mining_vessel
	name = "Cyclops Mining Vessel"
	description = "This bulky vessel is designed and operated by Hephaestus Industries. From asteroid cracking to planetary operations, this ship can do it all. "
	suffixes = list("ships/heph/cyclops/cyclops.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_WEEPING_STARS, SECTOR_UUEOAESA, SECTOR_BURZSIA)
	spawn_weight = 1
	ship_cost = 1
	id = "Cyclops Mining Vessel"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/cyclops_shuttle)

	unit_test_groups = list(2)

/singleton/submap_archetype/cyclops_mining
	map = "Cyclops Mining Vessel"
	descriptor = "This bulky vessel is designed and operated by Hephaestus Industries. From asteroid cracking to planetary operations, this ship can do it all. "

// Ship Stuff
/obj/effect/overmap/visitable/ship/cyclops_mining
	name = "Cyclops Mining Vessel"
	class = "HCV"
	desc = "This bulky vessel is designed and operated by Hephaestus Industries. From asteroid cracking to planetary operations, this ship can do it all. "
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#BAB86C", "#8B4000")
	designer = "Hephaestus Industries"
	weapons = "Not apparent"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	sizeclass = "Cyclops Mining Freighter"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Cyclops Shuttle" = list("nav_hangar_cyclops")
	)
	initial_generic_waypoints = list(
		"nav_cyclops_1",
		"nav_cyclops_2",
		"nav_cyclops_3",
		"nav_cyclops_4",
		"nav_cyclops_5",
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/cyclops_mining/New()
	designation = "[pick("Archemedes", "Pallas", "Crius", "Pothos", "Nyx")]"
	..()

/obj/effect/shuttle_landmark/cyclops
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/cyclops/nav1
	name = "Cyclops Mining Vessel - Port Side"
	landmark_tag = "nav_cyclops_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/cyclops/nav2
	name = "Cyclops Mining Vessel - Port Airlock"
	landmark_tag = "nav_cyclops_2"
	docking_controller = "airlock_cyclops_dock"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/cyclops/nav3
	name = "Cyclops Mining Vessel - Starboard Side"
	landmark_tag = "nav_cyclops_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/cyclops/nav4
	name = "Cyclops Mining Vessel - Aft"
	landmark_tag = "nav_cyclops_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/cyclops/nav5
	name = "Cyclops Mining Vessel - Fore"
	landmark_tag = "nav_cyclops_5"
	base_turf = /turf/space/dynamic
	base_area = /area/space

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/cyclops_shuttle
	name = "Cyclops Shuttle"
	class = "HCS"
	designation = "Cyclops Shuttle"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Cyclops Shuttle"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/cyclops_shuttle
	name = "shuttle control console"
	shuttle_tag = "Cyclops Shuttle"

/datum/shuttle/autodock/overmap/cyclops_shuttle
	name = "Cyclops Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/cyclops_shuttle)
	current_location = "nav_hangar_cyclops"
	landmark_transition = "nav_transit_cyclops_shuttle"
	dock_target = "airlock_shuttle_cyclops"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_cyclops"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/cyclops_shuttle/hangar
	name = "Cyclops Shuttle Hangar"
	landmark_tag = "nav_hangar_cyclops"
	docking_controller = "airlock_shuttle_cyclops"
	base_area = /area/hephmining_ship/cyclops
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/cyclops_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_cyclops_shuttle"
	base_turf = /turf/space/transit/north
