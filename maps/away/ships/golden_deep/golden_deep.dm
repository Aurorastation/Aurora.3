/datum/map_template/ruin/away_site/golden_deep
	name = "Golden Deep Merchantile Vessel"
	id = "golden_deep"
	description = "A mercantile transport vessel, registered to the Golden Deep."

	prefix = "ships/golden_deep/"
	suffix = "golden_deep.dmm"

	traits = list(
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	ship_cost = 1
	spawn_weight = 1

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/golden_deep, /datum/shuttle/autodock/multi/lift/gd)
	sectors = list(ALL_TAU_CETI_SECTORS, ALL_COALITION_SECTORS, SECTOR_VALLEY_HALE)

	unit_test_groups = list(1)

/singleton/submap_archetype/golden_deep
	map = "Golden Deep Merchantile Vessel"
	descriptor = "A mercantile transport vessel, registered to the Golden Deep."

/obj/effect/overmap/visitable/ship/golden_deep
	name = "Golden Deep Merchantile Vessel"
	desc = "The Anchurus-class mercantile vessel is a common sight in the possession of Golden Deep traders - a high-speed vessel, designed in the shipyards of Midaion by the brightest minds of the Grand Camarilla Estriconian. They are frequently plated in gold and other rare metals, in order to easily distinguish them as Golden Deep property."
	class = "GDMV" //Golden Deep Mercantile Vessel
	icon_state = "tramp"
	moving_state = "tramp_moving"
	color = "#efd10fe4"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	designer = "Grand Camarilla Estriconian, Midaion Anchorage"
	volume = "55 meters length, 43 meters beam/width, 22 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Small starboard ballistic mount, obscured flight craft hangar aft underside"
	sizeclass = "Anchurus-class mercantile freighter"
	shiptype = "Long-term shipping utilities"
	initial_restricted_waypoints = list(
		"Golden Deep Shuttle" = list("gd_nav_hangar")
	)
	initial_generic_waypoints = list(
		"gd_nav1",
		"gd_nav2",
		"gd_nav3",
		"gd_nav4",
		"gd_dock1",
		"gd_dock2",
		"gd_dock3",
		"gd_dock4",
		"gd_dock5"
	)

/obj/effect/overmap/visitable/ship/golden_deep/New()
	designation = "[pick("Pessinus", "Phyrgia", "Gordia", "Bermion", "Ancyra", "Silenus", "Alyattes", "Orpheus")]"
	..()

//Shuttle
/obj/effect/overmap/visitable/ship/landable/golden_deep_shuttle
	name = "Golden Deep Shuttle"
	desc = "The Lityerses-class transport shuttle is a design only seen in the possession of the synthetic merchants of the Golden Deep - designed in the shipyards of Midaion, and frequently used by the Deep's members for matters of interstellar shipping and sales."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#efd10fe4"
	class = "GDMV"
	designation = "Cybele"
	shuttle = "Golden Deep Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/golden_deep
	name = "shuttle control console"
	shuttle_tag = "Golden Deep Shuttle"
	req_one_access = list(ACCESS_GOLDEN_DEEP, ACCESS_GOLDEN_DEEP_OWNED)

/datum/shuttle/autodock/overmap/golden_deep
	name = "Golden Deep Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/golden_deep/cargo, /area/shuttle/golden_deep/cockpit, /area/shuttle/golden_deep/passenger)
	current_location = "gd_nav_hangar"
	landmark_transition = "gd_nav_transit"
	dock_target = "airlock_golden_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "gd_nav_hangar"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/golden_deep
	name = "Golden Deep Shuttle"
	shuttle_tag = "Golden Deep Shuttle"
	master_tag = "airlock_golden_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/map_effect/marker/airlock/docking/golden_deep/shuttle_hangar
	name = "Shuttle Dock"
	landmark_tag = "gd_nav_hangar"
	master_tag = "golden_deep_hangar"

/obj/effect/shuttle_landmark/golden_deep_shuttle/hangar
	name = "Golden Deep Mercantile Vessel - Hangar"
	landmark_tag = "gd_nav_hangar"
	docking_controller = "golden_deep_hangar"
	base_turf = /turf/space
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/golden_deep_shuttle/transit
	name = "In transit"
	landmark_tag = "gd_nav_transit"
	base_turf = /turf/space/transit/east

//Fluff items
/obj/item/storage/secure/safe/golden_deep // Placed in merchant's quarters.
	starts_with = list(
	/obj/item/clothing/accessory/badge/passport = 1,
	/obj/item/clothing/accessory/badge/passport/coc = 1,
	/obj/item/spacecash/c1000 = 2,
	/obj/item/spacecash/c200 = 1,
	/obj/item/spacecash/c20 = 1
	)
