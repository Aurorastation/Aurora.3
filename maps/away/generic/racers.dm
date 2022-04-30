/datum/map_template/ruin/away_site/racers
	name = "racer club"
	description = "A station apparently home to an underground racing group."
	suffix = "generic/racers.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "racers"

/decl/submap_archetype/racers
	map = "racer club"
	descriptor = "A racer club."

/obj/effect/overmap/visitable/sector/racers
	name = "racer club"
	desc = "A station apparently home to an underground racing group."

/area/racers
	name = "Racer Club"
	icon_state = "bar"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE

/area/shuttle/redracer
	name = "Red Racer"
	icon_state = "shuttle2"

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/redracer
	name = "Red Racer"
	desc = "A class of ultra-small racing pinnace, the Comet-class is sleek and fast, but lacks any features beyond that. In fact, it is totally useless for anything except getting from point A to point B as quickly as possible. Extreme care must be placed in fuel management, to avoid stranding oneself in the void."
	shuttle = "Red Racer"
	max_speed = 1/(1 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 500 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/redracer
	name = "shuttle control console"
	shuttle_tag = "Red Racer"

/datum/shuttle/autodock/overmap/redracer
	name = "Red Racer"
	move_time = 20
	shuttle_area = list(/area/shuttle/redracer)
	current_location = "nav_hangar_racer"
	landmark_transition = "nav_transit_redracer"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_racer"
	defer_initialisation = TRUE
	mothershuttle = "Racer Club"

/obj/effect/shuttle_landmark/redracer/hangar
	name = "Red Racer Hangar"
	landmark_tag = "nav_hangar_racer"
	docking_controller = "redracer_dock"
	base_area = /area/shuttle/racer_club
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/redracer/transit
	name = "In transit"
	landmark_tag = "nav_transit_redracer"
	base_turf = /turf/space/transit/south