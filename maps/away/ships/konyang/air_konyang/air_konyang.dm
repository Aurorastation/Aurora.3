/datum/map_template/ruin/away_site/air_konyang
	name = "Air Konyang"
	description = "Air Konyang civilian transport."
	suffixes = list("ships/konyang/air_konyang/air_konyang.dmm")
	sectors = list(SECTOR_HANEUNIM)
	spawn_weight = 1
	ship_cost = 1
	id = "air_konyang"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/air_konyang)
	unit_test_groups = list(3)

/singleton/submap_archetype/air_konyang
	map = "Air Konyang"
	descriptor = "Air Konyang civilian transport."

/obj/effect/overmap/visitable/sector/air_konyang_spawn
	name = "empty sector"
	desc = "An empty sector."
	icon_state = null //this away site only exists so the shuttle can spawn and doesn't need to be seen. Invisible var causes issues when used for this purpose.
	initial_restricted_waypoints = list(
		"Air Konyang Transport" = list("nav_air_konyang_start")
	)

/obj/effect/overmap/visitable/ship/landable/air_konyang
	name = "Air Konyang Transport"
	class = "AKPV" //Air Konyang Passenger Vessel
	desc = "The Peregrine-class civilian transport, manufactured by Einstein Engines, is a frequent favorite for interstellar travel. The design is most commonly seen owned by Solarian spacelines, as well as the Konyang-based Air Konyang."
	icon_state = "generic"
	moving_state = "generic_moving"
	designer = "Einstein Engines"
	volume = "75 meters length, 35 meters beam/width, 21 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "No weapons detected"
	sizeclass = "Peregrine-class civilian transport"
	shiptype = "Civilian passenger transport."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Air Konyang Transport"

/obj/effect/overmap/visitable/ship/landable/air_konyang/New()
	designation = "[pick("Qianlima", "Senrima", "Cheollima", "Chollima")]"
	..()

/obj/machinery/computer/shuttle_control/explore/air_konyang
	name = "shuttle control console"
	shuttle_tag = "Air Konyang Transport"

/datum/shuttle/autodock/overmap/air_konyang
	name = "Air Konyang Transport"
	move_time = 35
	range = 2
	fuel_consumption = 6
	shuttle_area = list(/area/shuttle/air_konyang/atmos, /area/shuttle/air_konyang/engineering, /area/shuttle/air_konyang/storage, /area/shuttle/air_konyang/starbwing, /area/shuttle/air_konyang/crew, /area/shuttle/air_konyang/mainroom, /area/shuttle/air_konyang/bridge, /area/shuttle/air_konyang/rear_hall)
	current_location = "nav_air_konyang_start"
	dock_target = "airlock_air_konyang"
	landmark_transition = "nav_air_konyang_transit"
	logging_home_tag = "nav_air_konyang_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/air_konyang/start
	name = "Empty Space"
	landmark_tag = "nav_air_konyang_start"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/air_konyang/transit
	name = "In transit"
	landmark_tag = "nav_air_konyang_transit"
	base_turf = /turf/space/transit
