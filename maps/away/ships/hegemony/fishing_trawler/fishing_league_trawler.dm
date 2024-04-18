/datum/map_template/ruin/away_site/fishing_trawler
	name =  "Fishing League Trawler"
	description = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."

	prefix = "ships/hegemony/fishing_trawler/"
	suffixes = list("fishing_league_trawler.dmm")

	sectors = list(SECTOR_BADLANDS)
	spawn_weight_sector_dependent = list(SECTOR_UUEOAESA = 3)
	spawn_weight = 1
	ship_cost = 1
	id = "fishing_trawler"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(2)
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fishing_trawler)

/singleton/submap_archetype/fishing_trawler
	map = "Fishing League Trawler"
	descriptor = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."

//Ship
/obj/effect/overmap/visitable/ship/fishing_trawler
	name = "Fishing League Trawler"
	class = "IHGV"
	desc = "Replace this Description with something more original after checking with the lore team."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#F06553")
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "65 meters length, 35 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent, fore of ship shows extensive catwalk and lattice network designed for piercing carp"
	sizeclass = "Azkrazal-class cargo freighter"
	shiptype = "Long-term shipping utilities"
	scanimage = "unathi_freighter2.png"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH

	invisible_until_ghostrole_spawn = TRUE

	initial_restricted_waypoints = list(
		"Trawler Shuttle" = list("fishing_trawler_shuttle_dock")
	)
	initial_generic_waypoints = list(
		"fishing_trawler_fore",
		"fishing_trawler_aft",
		"fishing_trawler_port",
		"fishing_trawler_starboard"
	)

/obj/effect/overmap/visitable/ship/fishing_trawler/New()
	designation = "[pick("Hegemon's Bounty", "Fisher's Reach")]"
	..()

/obj/effect/overmap/visitable/ship/fishing_trawler/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "fishing_trawler")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

//Shuttle

/obj/effect/overmap/visitable/ship/landable/fishing_trawler_shuttle
	name = "Fishing League Shuttle"
	class = "IHGV"
	desc = "A Seeker-class transportation shuttle, manufactured in the Izweski Hegemony. The design is small and somewhat cramped, but it is cheap to manufacture and maintain."
	shuttle = "Fishing League Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#F06553")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "10 meters length, 9 meters width, 6 meters vertical height"
	weapons = "No Apparent Weapons"
	sizeclass = "Merchant Transport Shuttlecraft"

/obj/effect/overmap/visitable/ship/landable/fishing_trawler_shuttle/New()
	designation = "[pick("Fisher's Net")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/fishing_trawler
	name = "shuttle control console"
	shuttle_tag = "Fishing League Shuttle"
	req_access = list(ACCESS_FISHING_LEAGUE)

/datum/shuttle/autodock/overmap/fishing_trawler
	name = "Fishing League Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/fishing_trawler)
	dock_target = "fishing_trawler_shuttle"
	current_location = "fishing_trawler_shuttle_dock"
	landmark_transition = "fishing_trawler_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "fishing_trawler_shuttle"
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
	landmark_tag = "nav_transit_fishing_trawler_shuttle"
	base_turf = /turf/space/transit/north

