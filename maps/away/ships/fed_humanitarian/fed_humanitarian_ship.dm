/datum/map_template/ruin/away_site/fed_humanitarian_ship
	name = "Nralakk Humanitarian Ship"
	description = "Ship with skrell, here to help :)."
	suffixes = list("ships/nralakk/fed_humanitarian/fed_humanitarian_ship.dmm")
	sectors = list(SECTOR_UUEOAESA)
	spawn_weight = 1
	ship_cost = 1
	id = "skrell_humanitarian"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fed_humanitarian_shuttle)
	unit_test_groups = list(3)


/singleton/submap_archetype/fed_humanitarian_ship
	map = "Nralakk Humanitarian Ship"
	descriptor = "Luxupi-class freighters are one of the most common civilian vessels of the Nralakk Federation. Usually outfitted with midsized warp drives, they transport all manner of goods and cargo across the Nralakk Federation - sometimes even to other nations within the Orion Spur. These ships are capable of atmospheric operations depending on size, with the smaller vessels being used as intermediaries between larger freighters and planets. Freighters that do not travel outside of the inner systems do not normally have weapons, but will be outfitted with basic weaponry if travelling into known Marauder hotspots within the Traverse."

/obj/effect/overmap/visitable/ship/fed_humanitarian_ship
	name = "Nralakk Humanitarian Ship"
	class = "NFV" //Nralakk Federal Vessel
	desc = "Luxupi-class freighters are one of the most common civilian vessels of the Nralakk Federation. Usually outfitted with midsized warp drives, they transport all manner of goods and cargo across the Nralakk Federation - sometimes even to other nations within the Orion Spur. These ships are capable of atmospheric operations depending on size, with the smaller vessels being used as intermediaries between larger freighters and planets. Freighters that do not travel outside of the inner systems do not normally have weapons, but will be outfitted with basic weaponry if travelling into known Marauder hotspots within the Traverse."
	icon_state = "sanctuary"
	moving_state = "sanctuary-moving"
	colors = list("#b227ee", "#85c8ff")
	designer = "Qerr'Zovlq Industries"
	volume = "62 meters length, 45 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "No weapons systems detected. Starboard transport shuttle hangar."
	sizeclass = "Luxupi-class freighter"
	shiptype = "Long-range resupply and support operations."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Nralakk Humanitarian Shuttle" = list("fed_humanitarian_hangar")
	)
	initial_generic_waypoints = list(
		"fed_humanitarian_nav1",
		"fed_humanitarian_nav2",
		"fed_humanitarian_nav3",
		"fed_humanitarian_nav4",
		"fed_humanitarian_dock1",
		"fed_humanitarian_dock2"
	)

/obj/effect/overmap/visitable/ship/fed_humanitarian_ship/New()
	designation = "[pick("Aweijiin Bounty", "Indomitable Progress", "Vitality", "Stellar Wanderer", "Hand of Friendship", "Interstellar Harmony", "Burning Quasar")]"
	..()

/obj/effect/shuttle_landmark/fed_humanitarian
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/fed_humanitarian/nav1
	name = "Nralakk Humanitarian Ship - Fore"
	landmark_tag = "fed_humanitarian_nav1"

/obj/effect/shuttle_landmark/fed_humanitarian/nav2
	name = "Nralakk Humanitarian Ship - Aft"
	landmark_tag = "fed_humanitarian_nav2"

/obj/effect/shuttle_landmark/fed_humanitarian/nav3
	name = "Nralakk Humanitarian Ship - Port"
	landmark_tag = "fed_humanitarian_nav3"

/obj/effect/shuttle_landmark/fed_humanitarian/nav4
	name = "Nralakk Humanitarian Ship - Starboard"
	landmark_tag = "fed_humanitarian_nav4"

/obj/effect/shuttle_landmark/fed_humanitarian/portdock
	name = "Nralakk Humanitarian Ship - Port Dock"
	landmark_tag = "fed_humanitarian_dock1"
	docking_controller = "airlock_fed_humanitarian_port"

/obj/effect/shuttle_landmark/fed_humanitarian/starbdock
	name = "Nralakk Humanitarian Ship - Starboard Dock"
	landmark_tag = "fed_humanitarian_dock2"
	docking_controller = "airlock_fed_humanitarian_stbd"

//Shuttle
/obj/effect/overmap/visitable/ship/landable/fed_humanitarian_shuttle
	name = "Nralakk Humanitarian Shuttle"
	class = "NFV"
	designation = "Xuqo"
	desc = "The Quloq-class transport shuttle is a common civilian model in the Nralakk Federation, often used for short-range or in-atmosphere transport of personnel or goods."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Nralakk Humanitarian Shuttle"
	colors = list("#b227ee", "#85c8ff")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/fed_humanitarian_shuttle
	name = "shuttle control console"
	shuttle_tag = "Nralakk Humanitarian Shuttle"

/datum/shuttle/autodock/overmap/fed_humanitarian_shuttle
	name = "Nralakk Humanitarian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/fed_humanitarian_shuttle, /area/shuttle/fed_humanitarian_shuttle/engine)
	current_location = "fed_humanitarian_hangar"
	landmark_transition = "fed_humanitarian_transit"
	dock_target = "fed_humanitarian_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "fed_humanitarian_hangar"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/fed_humanitarian_shuttle/transit
	name = "In transit"
	landmark_tag = "fed_humanitarian_transit"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/fed_humanitarian_shuttle/dock
	name = "Nralakk Humanitarian Ship - Hangar"
	landmark_tag = "fed_humanitarian_hangar"
	docking_controller = "fed_humanitarian_shuttle_dock"
	base_area = /area/fed_humanitarian_ship/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
