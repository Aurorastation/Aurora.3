/datum/map_template/ruin/away_site/fishing_trawler
	name =  "Fishing League Trawler"
	id = "fishing_trawler"
	description = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."
	prefix = "ships/hegemony/fishing_trawler"
	suffixes = list("fishing_league_trawler.dmm")
	ship_cost = 1
	spawn_weight = 1

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fishing_trawler)
	sectors = list(SECTOR_BADLANDS, SECTOR_UUEOAESA, SECTOR_VALLEY_HALE, SECTOR_CORP_ZONE, SECTOR_TAU_CETI)

	unit_test_groups = list(2)

/singleton/submap_archetype/fishing_trawler
	map = "Fishing League Trawler"
	descriptor = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."

/obj/effect/overmap/visitable/ship/fishing_trawler
	name = "Fishing League Trawler"
	desc = "Replace this Description with something more original after checking with the lore team."
	class = "IHGV"
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#F06553")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Trawler Shuttle" = list("nav_fishing_trawler_shuttle")
	)
	initial_generic_waypoints = list(
		"nav_fishing_trawler1",
		"nav_fishing_trawler2",
		"nav_fishing_trawler3",
		"nav_fishing_trawler4"
	)

/obj/effect/overmap/visitable/ship/fishing_trawler/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "fishing_trawler")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/fishing_trawler
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/fishing_trawler/nav1
	name = "Fishing Trawler - Fore"
	landmark_tag = "nav_fishing_trawler1"

/obj/effect/shuttle_landmark/fishing_trawler/nav2
	name = "Fishing Trawler - Aft"
	landmark_tag = "nav_fishing_trawler2"

/obj/effect/shuttle_landmark/fishing_trawler/nav3
	name = "Fishing Trawler - Port"
	landmark_tag = "nav_fishing_trawler3"

/obj/effect/shuttle_landmark/fishing_trawler/nav4
	name = "Fishing Trawler - Starboard"
	landmark_tag = "nav_fishing_trawler4"

/obj/effect/shuttle_landmark/fishing_trawler/nav1
	name = "Fishing Trawler - Fore"
	landmark_tag = "nav_fishing_trawler1"

/obj/effect/shuttle_landmark/fishing_trawler/dock2
	name = "Fishing Trawler - Auxiliary Dock"
	landmark_tag = "nav_fishing_trawler_generic"

/obj/effect/overmap/visitable/ship/landable/fishing_trawler_shuttle
	name = "Fishing League Shuttle"
	desc = "A Seeker-class transportation shuttle, manufactured in the Izweski Hegemony. The design is small and somewhat cramped, but it is cheap to manufacture and maintain."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#F06553")
	class = "IHGV"
	designation = "Fisher's Net"
	shuttle = "Fishing League Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/fishing_trawler
	name = "shuttle control console"
	shuttle_tag = "Fishing League Shuttle"
	req_access = list(ACCESS_FISHING_LEAGUE)

/datum/shuttle/autodock/overmap/fishing_trawler
	name = "Fishing League Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/fishing_trawler)
	current_location = "nav_fishing_trawler_shuttle"
	landmark_transition = "fishing_trawler_nav_transit"
	dock_target = "fishing_trawler_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_fishing_trawler_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/fishing_trawler_shuttle/dock
	name = "Fishing League Trawler = Shuttle Dock"
	landmark_tag = "nav_fishing_trawler_shuttle"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/fishing_trawler/dock
	docking_controller = "fishing_trawler_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/fishing_trawler_shuttle/transit
	name = "In transit"
	landmark_tag = "fishing_trawler_nav_transit"
	base_turf = /turf/space/transit/north

