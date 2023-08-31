/datum/map_template/ruin/away_site/dominian_unathi
	name = "Kazhkz Privateer Ship"
	description = "Dominian Unathi pirates"
	suffixes = list("ships/dominia/dominian_unathi_privateer/dominian_unathi_privateer.dmm")
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_unathi"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_unathi_shuttle)

/singleton/submap_archetype/dominian_unathi
	map = "Kazhkz Privateer Ship"
	descriptor = "Dominian Unathi pirates"

/obj/effect/overmap/visitable/ship/dominian_unathi
	name = "Kazhkz Privateer Ship"
	class = "ICV"
	desc = "A Dragoon-class corvette - the predecessor to the Empire of Dominia's modern Lammergier-class. Though these once served a similar role in the early days of the Imperial Fleet, they have since been entirely decomissioned in favor of the Lammergier. This one's IFF marks it as a civilian vessel, of no specific affiliation."
	icon_state = "dragoon"
	moving_state = "dragoon_moving"
	colors = list("#e67f09", "#fcf9f5")
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	volume = "54 meters length, 25 meters beam/width, 17 meters vertical height"
	sizeclass = "Dragoon-class corvette"
	shiptype = "Long-distance patrol and scouting action"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Port wingtip-mounted extruding medium-caliber ballistic armament, starboard obscured flight craft bay"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	initial_restricted_waypoints = list(
		"Kazhkz Fighter" = list("nav_hangar_kazhkz")
	)
	initial_generic_waypoints = list(
		"nav_dominian_unathi_1",
		"nav_dominian_unathi_2",
		"nav_dominian_unathi_3",
		"nav_dominian_unathi_4"
	)

/obj/effect/overmap/visitable/ship/dominian_unathi/New()
	designation = "[pick("Old Grudges", "Redhorn", "Seryo's Revenge", "Spiritbound", "Hammer of the Goddess", "Come Try Me", "Beating Wardrum", "Grudgetaker", "Our Lady's Talon", "Hunter", "Bloodied Claws", "Steelscale")]"
	..()

/obj/effect/shuttle_landmark/dominian_unathi/nav1
	name = "Kazhkz Privateer Ship - Fore"
	landmark_tag = "nav_dominian_unathi_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_unathi/nav2
	name = "Kazhkz Privateer Ship - Starboard"
	landmark_tag = "nav_dominian_unathi_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_unathi/nav3
	name = "Kazhkz Privateer Ship - Port"
	landmark_tag = "nav_dominian_unathi_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_unathi/nav4
	name = "Kazhkz Privateer Ship - Aft"
	landmark_tag = "nav_dominian_unathi_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

//Shuttle
/obj/effect/overmap/visitable/ship/landable/dominian_unathi_shuttle
	name = "Kazhkz Fighter"
	class = "ICV"
	designation = "Dagger"
	desc = "The Lanying-class fighter is often seen in the ranks of the Imperial Fleet - a larger-than-normal fighter craft, capable of carrying a boarding party of up to five soldiers, and equipped with a rotary cannon. This one's transponder does not mark it as an Imperial vessel, however."
	shuttle = "Kazhkz Fighter"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#e67f09", "#fcf9f5")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/dominian_unathi_shuttle
	name = "shuttle control console"
	shuttle_tag = "Kazhkz Fighter"
	req_access = list(access_imperial_fleet_voidsman_ship)

/datum/shuttle/autodock/overmap/dominian_unathi_shuttle
	name = "Kazhkz Fighter"
	move_time = 20
	shuttle_area = list(/area/shuttle/dominian_unathi)
	current_location = "nav_hangar_kazhkz"
	landmark_transition = "nav_transit_kazhkz_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_kazhkz"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/dominian_unathi_shuttle/hangar
	name = "Kazhkz Privateer Ship - Fighter Bay"
	landmark_tag = "nav_hangar_kazhkz"
	base_area = /area/ship/dominian_unathi/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/dominian_unathi_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_kazhkz_shuttle"
	base_turf = /turf/space/transit/north
