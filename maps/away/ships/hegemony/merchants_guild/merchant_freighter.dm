/datum/map_template/ruin/away_site/merchants_guild
	name = "Merchants' Guild Freighter"
	id = "merchants_guild"
	description = "A freighter flying under the banner of the Izweski Hegemony Merchants' Guild."
	suffixes = list("ships/hegemony/merchants_guild/merchant_freighter.dmm")
	ship_cost = 1
	spawn_weight = 1

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/merchants_guild)
	sectors = list(SECTOR_BADLANDS, SECTOR_UUEOAESA, SECTOR_VALLEY_HALE, SECTOR_CORP_ZONE, SECTOR_TAU_CETI)

/singleton/submap_archetype/merchants_guild
	map = "Merchants' Guild Freighter"
	descriptor = "A freighter flying under the banner of the Izweski Hegemony Merchants' Guild."

/obj/effect/overmap/visitable/ship/merchants_guild
	name = "Merchants' Guild Freighter"
	desc = "The Azkrazal-class freighter is a common civilian design from the Izweski Hegemony's shipbuilding guilds, designed in collaberation with Hephaestus Industries. They are mostly found in the possession of Unathi guilds, as well as the occasional smuggler or pirate fleet."
	class = "IHGV" //Izweski Hegemony Guild Vessel
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("5a189a")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tramp_freighter.png"
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "65 meters length, 35 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent, starboard obscured flight craft bay"
	sizeclass = "Azkrazal-class cargo freighter"
	shiptype = "Long-term shipping utilities"
	initial_restricted_waypoints = list(
		"Merchants' Guild Shuttle" = list("merchantsguild_nav_hangar")
	)
	initial_generic_waypoints = list(
		"merchantsguild_nav1",
		"merchantsguild_nav2",
		"merchantsguild_nav3",
		"merchantsguild_nav4"
	)

/obj/effect/overmap/visitable/ship/merchants_guild/New()
	designation = "[pick("Fisher's Bounty", "Scales of Silver", "Gharr's Greed", "Pride of Skalamar", "Horns of Diamond", "Memory of Dukhul", "Glory through Profit", "Razi's Pride")]"
	..()

/obj/effect/shuttle_landmark/merchants_guild
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/merchants_guild/nav1
	name = "Merchants' Guild Freighter, Fore"
	landmark_tag = "merchantsguild_nav1"

/obj/effect/shuttle_landmark/merchants_guild/nav2
	name = "Merchants' Guild Freighter, Port"
	landmark_tag = "merchantsguild_nav2"

/obj/effect/shuttle_landmark/merchants_guild/nav3
	name = "Merchants' Guild Freighter, Starboard"
	landmark_tag = "merchantsguild_nav3"

/obj/effect/shuttle_landmark/merchants_guild/nav4
	name = "Merchants' Guild Freighter, Aft"
	landmark_tag = "merchantsguild_nav4"

//Shuttle stuff

/obj/effect/overmap/visitable/ship/landable/merchants_guild_shuttle
	name = "Merchants' Guild Shuttle"
	desc = "A Seeker-class transportation shuttle, manufactured in the Izweski Hegemony. The design is small and somewhat cramped, but it is cheap to manufacture and maintain."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#5a189a")
	class = "IHGV"
	designation = "Gilded Claw"
	shuttle = "Merchants' Guild Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/merchants_guild
	name = "shuttle control console"
	shuttle_tag = "Merchants' Guild Shuttle"
	req_access = list(access_merchants_guild)

/datum/shuttle/autodock/overmap/merchants_guild
	name = "Merchants' Guild Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/merchants_guild)
	current_location = "merchantsguild_nav_hangar"
	landmark_transition = "merchantsguild_nav_transit"
	dock_target = "merchant_guild_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "merchantsguild_nav_hangar"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/merchants_guild_shuttle/hangar
	name = "Merchants' Guild Freighter - Shuttle Hangar"
	landmark_tag = "merchantsguild_nav_hangar"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/merchants_guild/hangar
	docking_controller = "merchant_guild_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/merchants_guild_shuttle/transit
	name = "In transit"
	landmark_tag = "merchantsguild_nav_transit"
	base_turf = /turf/space/transit/north
