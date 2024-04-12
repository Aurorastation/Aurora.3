/datum/map_template/ruin/away_site/racers
	name = "unregistered station"
	description = "A station that doesn't appear to have been legally registered. It has four large hangar bays and a small habitation module - and the signals emittered by its dying equipment seem to identify it as belonging to an underground racing group."
	suffixes = list("away_site/racers/racers.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 2
	id = "racers"

	unit_test_groups = list(1)
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/racers_red,
		/datum/shuttle/autodock/overmap/racers_blue
	)

/singleton/submap_archetype/racers
	map = "unregistered station"
	descriptor = "A unregistered station."

/obj/effect/overmap/visitable/sector/racers
	name = "unregistered station"
	desc = "A station that doesn't appear to have been legally registered. It has four large hangar bays and a small habitation module - and the signals emittered by its dying equipment seem to identify it as belonging to an underground racing group."
	comms_support = TRUE
	comms_name = "station"

/area/racers
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	name = "unregistered station"
	icon_state = "bar"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE

/area/shuttle/racers_blue
	name = "Racing Shuttle - Blue"

/area/shuttle/racers_red
	name = "Racing Shuttle - Red"

//Shuttles
/obj/effect/overmap/visitable/ship/landable/racers_red
	name = "Racing Shuttle - Red"
	desc = "A one-person transport shuttle produced by Einstein Engines. This one looks to have undergone extensive modifications"
	class = "ISV" //Independent Sporting Vessel
	designation = "Burning Sunset"
	sizeclass = "Modified civilian transport"
	shuttle = "Red Racer"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#d21410"
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 500 //Tiny shuttle designed to be VERY fast and maneuverable
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/racers_red
	name = "Red Racer"
	move_time = 20
	shuttle_area = /area/shuttle/racers_red
	current_location = "nav_red_racer_hangar"
	landmark_transition = "nav_red_racer_transit"
	fuel_consumption = 2
	logging_home_tag = "nav_red_racer_hangar"
	range = 1
	defer_initialisation = TRUE

/obj/effect/overmap/visitable/ship/landable/racers_blue
	name = "Racing Shuttle - Blue"
	desc = "A one-person transport shuttle produced by Einstein Engines. This one looks to have undergone extensive modifications"
	class = "ISV" //Independent Sporting Vessel
	designation = "Cerulean Wind"
	sizeclass = "Modified civilian transport"
	shuttle = "Blue Racer"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#0fc4f1"
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 500 //Tiny shuttle designed to be VERY fast and maneuverable
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/racers_blue
	name = "Blue Racer"
	move_time = 20
	shuttle_area = /area/shuttle/racers_blue
	current_location = "nav_blue_racer_hangar"
	landmark_transition = "nav_blue_racer_transit"
	fuel_consumption = 2
	logging_home_tag = "nav_blue_racer_hangar"
	range = 1
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/explore/red_racer
	name = "shuttle control console"
	shuttle_tag = "Red Racer"

/obj/machinery/computer/shuttle_control/explore/blue_racer
	name = "shuttle control console"
	shuttle_tag = "Blue Racer"

/obj/effect/shuttle_landmark/red_racer_hangar
	name = "Unregistered Station Hangar"
	landmark_tag = "nav_red_racer_hangar"
	base_area = /area/racers
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/red_racer_transit
	name = "In transit"
	landmark_tag = "nav_red_racer_transit"
	base_turf = /turf/space/transit

/obj/effect/shuttle_landmark/blue_racer_hangar
	name = "Unregistered Station Hangar"
	landmark_tag = "nav_blue_racer_hangar"
	base_area = /area/racers
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/blue_racer_transit
	name = "In transit"
	landmark_tag = "nav_blue_racer_transit"
	base_turf = /turf/space/transit
