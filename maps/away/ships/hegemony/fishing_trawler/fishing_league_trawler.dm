/datum/map_template/ruin/away_site/fishing_trawler
	name =  "Fishing League Trawler"
	description = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."

	prefix = "ships/hegemony/fishing_trawler/"
	suffix = "fishing_league_trawler.dmm"

	sectors = list(SECTOR_BADLANDS, SECTOR_UUEOAESA)
	spawn_weight_sector_dependent = list(SECTOR_UUEOAESA = 3)
	spawn_weight = 1
	ship_cost = 1
	id = "fishing_trawler"

	unit_test_groups = list(2)
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fishing_trawler)

/singleton/submap_archetype/fishing_trawler
	map = "Fishing League Trawler"
	descriptor = "A freighter sponsored by the Fishing league has been augmented with sharpened pylons designed to harvest carp shoals."

//Ship
/obj/effect/overmap/visitable/ship/fishing_trawler
	name = "Fishing League Trawler"
	class = "IHGV"
	desc = "The Azkrazal-class freighter is a common civilian design from the Izweski Hegemony's shipbuilding guilds, designed in collaberation with Hephaestus Industries. They are mostly found in the possession of Unathi guilds, as well as the occasional smuggler or pirate fleet."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#F06553")
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "54 meters length, 54 meters beam/width, 18 meters vertical height"
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
		"Fishing League Shuttle" = list("fishing_trawler_shuttle")
	)
	initial_generic_waypoints = list(
		"fishing_trawler_fore",
		"fishing_trawler_aft",
		"fishing_trawler_port",
		"fishing_trawler_starboard",
		"fishing_trawler_port_dock",
		"fishing_trawler_starboard_dock",
		"fishing_trawler_aux_dock"
	)

/obj/effect/overmap/visitable/ship/fishing_trawler/New()
	designation = "[pick("Hegemon's Bounty", "Fisher's Reach", "Fisher's Net", "Kasavakh Rising" , "Violet Scale" , "Feast Bringer")]"
	..()


//Shuttle

/obj/effect/overmap/visitable/ship/landable/fishing_trawler_shuttle
	name = "Fishing League Shuttle"
	class = "IHGV"
	desc = "An Otzek class transportation shuttle, manufactured in the Izweski Hegemony. This simply designed transport shuttle is designed to reliably haul goods and is cheap and easy to maintain."
	shuttle = "Fishing League Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#F06553")
	designation = "Shrieker"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "10 meters length, 9 meters width, 6 meters vertical height"
	weapons = "No Apparent Weapons"
	sizeclass = "Merchant Transport Shuttlecraft"

/obj/machinery/computer/shuttle_control/explore/terminal/fishing_trawler
	name = "shuttle control console"
	shuttle_tag = "Fishing League Shuttle"
	req_access = list(ACCESS_FISHING_LEAGUE)

/datum/shuttle/autodock/overmap/fishing_trawler
	name = "Fishing League Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/fishing_trawler)
	dock_target = "trawler_shuttle_airlock"
	current_location = "fishing_trawler_shuttle"
	landmark_transition = "fishing_trawler_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "fishing_trawler_shuttle"
	defer_initialisation = TRUE
