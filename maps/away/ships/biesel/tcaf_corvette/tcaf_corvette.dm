/datum/map_template/ruin/away_site/tcaf_corvette
	name = "Republican Fleet Corvette"
	description = "A patrol vessel of Biesel's Republican Fleet."
	suffixes = list("ships/biesel/tcaf_corvette/tcaf_corvette.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_BADLANDS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "tcaf_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tcaf_shuttle)
	ban_ruins = list(/datum/map_template/ruin/away_site/tcfl_peacekeeper_ship)

	unit_test_groups = list(3)

/singleton/submap_archetype/tcaf_corvette
	map = "Republican Fleet Corvette"
	descriptor = "A patrol vessel of Biesel's Republican Fleet."

/obj/effect/overmap/visitable/ship/tcaf_corvette
	name = "Republican Fleet Corvette"
	class = "BLV"
	desc = "The Auriga-class corvette is a recent design, from the brightest minds of Hephaestus Industries. An evolution of their earlier Uhlan-class design often used by the Solarian Navy, the Auriga is designed for long-term scouting operations and combat utility. The Auriga has rapidly become one of the standard vessels used by the Republican Fleet for patrols of the Corporate Reconstruction Zone and surrounding areas."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#263aeb", "#3d8cfa")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	designer = "Tau Ceti Republican Fleet, Hephaestus Industries"
	volume = "41 meters length, 43 meters beam/width, 19 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore caliber ballistic armament, aft obscured flight craft bay"
	sizeclass = "Auriga-class corvette"
	shiptype = "Military reconnaissance and extended-duration combat utility"
	initial_restricted_waypoints = list(
		"TCAF Gunship" = list("nav_hangar_tcaf")
	)

	initial_generic_waypoints = list(
		"tcaf_corvette_nav1",
		"tcaf_corvette_nav2",
		"tcaf_corvette_nav3",
		"tcaf_corvette_nav4",
		"tcaf_corvette_dock"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tcaf_corvette/New()
	designation = "[pick("Shining Liberty", "Zoleth's Lance", "Live Free or Die", "Watchman", "Velazco", "Valkyrie", "Astraeus", "Caxamalca", "Vezdukh", "Independence", "Light of Liberty", "Bright Tomorrow", "Chandras", "Retribution", "Myrmidon")]"
	..()

/obj/effect/shuttle_landmark/tcaf_corvette
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tcaf_corvette/nav1
	name = "Fore"
	landmark_tag = "tcaf_corvette_nav1"

/obj/effect/shuttle_landmark/tcaf_corvette/nav2
	name = "Aft"
	landmark_tag = "tcaf_corvette_nav2"

/obj/effect/shuttle_landmark/tcaf_corvette/nav3
	name = "Port"
	landmark_tag = "tcaf_corvette_nav3"

/obj/effect/shuttle_landmark/tcaf_corvette/nav4
	name = "Starboard"
	landmark_tag = "tcaf_corvette_nav4"

/obj/effect/shuttle_landmark/tcaf_corvette/dock
	name = "Port Docking Port"
	docking_controller = "airlock_tcaf_dock"
	landmark_tag = "tcaf_corvette_dock"

/obj/effect/shuttle_landmark/tcaf_corvette/dock1
	name = "Starboard Docking Port"
	docking_controller = "airlock_tcaf_dock1"
	landmark_tag = "tcaf_corvette_dock1"

/obj/effect/shuttle_landmark/tcaf_corvette/dock2
	name = "Aft Docking Port"
	docking_controller = "airlock_tcaf_dock2"
	landmark_tag = "tcaf_corvette_dock2"

/obj/effect/overmap/visitable/ship/landable/tcaf_shuttle
	name = "TCAF Gunship"
	class = "BLV"
	designation = "Dumas"
	desc = "Designed by Hephaestus and named for the astrofauna of the Romanovich Cloud, Reaver-class gunships have been a staple of TCAF strategy since their inception, providing air support in the jungles of Mictlan during the conflict against the Samaritans. Since the end of the Mictlan conflict, Reavers are frequently seen accompanying Minutemen detachments in the outer CRZ or used as transports by smaller Republican Fleet vessels."
	shuttle = "TCAF Gunship"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Tau Ceti Republican Fleet, Hephaestus Industries"
	weapons = "Fore ballistic weapon mount."
	sizeclass = "Reaver-class gunship"
	colors = list("#263aeb", "#3d8cfa")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tcaf_shuttle
	name = "shuttle control console"
	shuttle_tag = "TCAF Gunship"
	req_access = list(ACCESS_TCAF_SHIPS)

/datum/shuttle/autodock/overmap/tcaf_shuttle
	name = "TCAF Gunship"
	move_time = 40
	shuttle_area = list(/area/shuttle/tcaf)
	current_location = "nav_hangar_tcaf"
	landmark_transition = "nav_transit_tcaf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tcaf"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tcaf_shuttle/hangar
	name = "Gunship Hangar"
	landmark_tag = "nav_hangar_tcaf"
	docking_controller = "tcaf_dock"
	base_area = /area/tcaf_corvette/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tcaf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcaf_shuttle"
	base_turf = /turf/space/transit/north
