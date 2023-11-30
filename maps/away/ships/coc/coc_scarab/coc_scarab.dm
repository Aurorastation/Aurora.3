/datum/map_template/ruin/away_site/coc_scarab
	name = "Scarab Salvage Ship"
	description = "Scarab salvage ship."
	suffixes = list("ships/coc/coc_scarab/coc_scarab.dmm")
	//sectors = list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_ARUSHA, SECTOR_LIBERTYS_CRADLE)
	//spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	ship_cost = 1
	id = "coc_scarab"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scarab_gas_harvester, /datum/shuttle/autodock/overmap/scarab_shuttle)

	unit_test_groups = list(1)

/singleton/submap_archetype/coc_scarab
	map = "Scarab Salvage Ship"
	descriptor = "Scarab salvage ship."

/obj/effect/overmap/visitable/ship/coc_scarab
	name = "Scarab Salvage Ship"
	class = "SFV" //Scarab Fleet Vessel
	desc = "An ancient Burrow-class transport vessel, bearing signs of extensive modification. These vessels are rarely seen in service outside of the Scarab Fleet in the modern day."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#a400c1", "#4d61fc")
	designer = "Coalition of Colonies, Scarab Fleet"
	volume = "57 meters length, 48 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard fore ballistic armament, dual port flight craft."
	sizeclass = "Modified Burrow-class transport."
	shiptype = "Salvage, fuel extraction and mineral exploration."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	initial_generic_waypoints = list(
		"scarab_nav1",
		"scarab_nav2",
		"scarab_nav3",
		"scarab_nav4"
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("scarab_intrepid"),
		"Scarab Shuttle" = list("nav_scarab_start"),
		"Scarab Gas Harvester" = list("nav_scarab_harvester_start")
	)

/obj/effect/overmap/visitable/ship/coc_scarab/New()
	designation = "[pick("Umphangi", "Umfuni", "Zibal", "Albahith", "Sikeo", "Chaj-a Hemaeda", "Khog Tseverlegch", "Khaigch")]"
	..()

/obj/effect/shuttle_landmark/coc_scarab
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/coc_scarab/nav1
	name = "Scarab Salvage Vessel - Fore"
	landmark_tag = "scarab_nav1"

/obj/effect/shuttle_landmark/coc_scarab/nav2
	name = "Scarab Salvage Vessel - Aft"
	landmark_tag = "scarab_nav2"

/obj/effect/shuttle_landmark/coc_scarab/nav3
	name = "Scarab Salvage Vessel - Port"
	landmark_tag = "scarab_nav3"

/obj/effect/shuttle_landmark/coc_scarab/nav4
	name = "Scarab Salvage Vessel - Starboard"
	landmark_tag = "scarab_nav4"

/obj/effect/shuttle_landmark/coc_scarab/intrepid
	name = "Scarab Salvage Vessel - Intrepid Dock"
	landmark_tag = "scarab_intrepid"

//Shuttles
/obj/effect/overmap/visitable/ship/landable/scarab_gas_harvester
	name = "Scarab Gas Harvester"
	desc = "An old Hephaestus-designed shuttle, intended for atmospheric mining of gas giants. This one appears to have been extensively modified."
	class = "SFV"
	designation = "Vacuum"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Scarab Gas Harvester"
	colors = list("#a400c1", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/scarab_gas_harvester
	name = "shuttle control terminal"
	shuttle_tag = "Scarab Gas Harvester"

/datum/shuttle/autodock/overmap/scarab_gas_harvester
	name = "Scarab Gas Harvester"
	move_time = 20
	shuttle_area = list(/area/shuttle/scarab_harvester)
	current_location = "nav_scarab_harvester_start"
	landmark_transition = "nav_scarab_harvester_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scarab_harvester_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_scarab/harvester_start
	name = "Scarab Salvage Vessel - Harvester Dock"
	landmark_tag = "nav_scarab_harvester_start"

/obj/effect/shuttle_landmark/coc_scarab/harvester_transit
	name = "In transit"
	landmark_tag = "nav_scarab_harvester_transit"
	base_turf = /turf/space/transit/north

/obj/effect/overmap/visitable/ship/landable/scarab_shuttle
	name = "Scarab Shuttle"
	desc = "An early predecessor to the modern Pickaxe-class, this ancient mining shutle appears to have been extensively repurposed."
	class = "SFV"
	designation = "Breaker"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Scarab Shuttle"
	colors = list("#a400c1", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/scarab_shuttle
	name = "shuttle control terminal"
	shuttle_tag = "Scarab Shuttle"

/datum/shuttle/autodock/overmap/scarab_shuttle
	name = "Scarab Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/coc_scarab)
	current_location = "nav_scarab_start"
	landmark_transition = "nav_scarab_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scarab_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_scarab/shuttle_start
	name = "Scarab Salvage Vessel - Shuttle Dock"
	landmark_tag = "nav_scarab_start"

/obj/effect/shuttle_landmark/coc_scarab/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_scarab_transit"
	base_turf = /turf/space/transit/north
