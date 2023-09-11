/datum/map_template/ruin/away_site/coc_surveyor
	name = "COC Survey Ship"
	description = "Coalition science ship."
	suffixes = list("ships/coc/coc_surveyor/coc_surveyor.dmm")
	sectors = list(ALL_COALITION_SECTORS, ALL_VOID_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "coc_surveyor"
	shuttles_to_initialise = list()

/singleton/submap_archetype/coc_surveyor
	map = "COC Survey Ship"
	descriptor = "Coalition science ship."

/obj/effect/overmap/visitable/ship/coc_surveyor
	name = "COC Survey Ship"
	class = ""
	desc = ""
	icon_state = "xansan"
	moving_state = "xansan_moving"
	colors = list("#8492fd", "#4d61fc")
	designer = "Coalition of Colonies, Xanu Prime"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/coc_surveyor/New()
	designation = "[pick("SHIP")]"
	..()

/obj/effect/shuttle_landmark/coc_survey_ship
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/coc_survey_ship/nav1
	name = "Coalition Survey Ship - Port"
	landmark_tag = "nav_surveyor_1"

/obj/effect/shuttle_landmark/coc_survey_ship/nav2
	name = "Coalition Survey Ship - Starboard"
	landmark_tag = "nav_surveyor_2"

/obj/effect/shuttle_landmark/coc_survey_ship/nav3
	name = "Coalition Survey Ship - Aft"
	landmark_tag = "nav_surveyor_3"

/obj/effect/shuttle_landmark/coc_survey_ship/nav4
	name = "Coalition Survey Ship - Fore"
	landmark_tag = "nav_surveyor_4"

/obj/effect/overmap/visitable/ship/landable/coc_survey_shuttle
	name = "COC Survey Shuttle"
	desc = ""
	class = ""
	designation = ""
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "COC Survey Shuttle"
	colors = list("#8492fd", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/coc_survey_shuttle
	name = "shuttle control console"
	shuttle_tag = "COC Survey Shuttle"

/datum/shuttle/autodock/overmap/coc_survey_shuttle
	name = "COC Survey Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/coc_survey_shuttle)
	current_location = "nav_hangar_survey"
	landmark_transition = "nav_transit_survey_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_survey"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_survey_shuttle/hangar
	name = "COC Survey Ship - Hangar"
	landmark_tag = "nav_hangar_survey"
	base_area = /area/ship/coc_survey_ship/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/coc_survey_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_survey_shuttle"
	base_turf = /turf/space/transit/north
