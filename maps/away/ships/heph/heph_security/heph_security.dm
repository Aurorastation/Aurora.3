/datum/map_template/ruin/away_site/heph_security
	name = "Hephaestus Security Vessel"
	description = "A vessel for protecting Hephaestus assets."
	suffixes = list("ships/heph/heph_security/heph_security.dmm")
	sectors = list(SECTOR_BURZSIA, SECTOR_UUEOAESA, SECTOR_TAU_CETI, SECTOR_CORP_ZONE) //Sectors with heavy Hephaestus presence specifically. These guys aren't going to be out patrolling the Badlands, they're going to be sticking close to valuable Heph installations.
	spawn_weight = 1
	ship_cost = 1
	id = "Hephaestus Security Vessel"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/hephsec_shuttle)

	unit_test_groups = list(2)

/singleton/submap_archetype/heph_security
	map = "Hephaestus Security Vessel"
	descriptor = "A vessel for protecting Hephaestus assets."

/obj/effect/overmap/visitable/ship/heph_security
	name = "Hephaestus Security Vessel"
	class = "HCV"
	desc = "The Eumenides-class security transport is a Hephaestus design, largely used by the corporation's own asset protection forces. Designed for rapid response and usually outfited with high-grade equipment, these vessels are rarely seen far from major Hephaestus investments."
	icon_state = "cetus"
	moving_state = "cetus_moving"
	colors = list("#BAB86C", "#8B4000")
	designer = "Hephaestus Industries"
	weapons = "Dual extruding fore-mounted medium caliber ballistic armament, aftobscured flight craft docking port"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	sizeclass = "Eumenides-class security transport"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Hephaestus Security Shuttle" = list("hephsec_shuttle")
	)
	initial_generic_waypoints = list(
		"hephsec_nav1",
		"hephsec_nav2",
		"hephsec_nav3",
		"hephsec_nav4",
		"hephsec_dock"
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/heph_security/New()
	designation = "[pick("Erebus", "Tisiphone", "Megaera", "Alecto", "Erinyes")]"
	..()

/obj/effect/shuttle_landmark/heph_security
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/heph_security/nav1
	name = "Fore"
	landmark_tag = "hephsec_nav1"

/obj/effect/shuttle_landmark/heph_security/nav2
	name = "Aft"
	landmark_tag = "hephsec_nav2"

/obj/effect/shuttle_landmark/heph_security/nav3
	name = "Port"
	landmark_tag = "hephsec_nav3"

/obj/effect/shuttle_landmark/heph_security/nav4
	name = "Starboard"
	landmark_tag = "hephsec_nav4"

/obj/effect/shuttle_landmark/heph_security/dock
	name = "Docking Port"
	landmark_tag = "hephsec_dock"
	docking_controller = "airlock_heph_sec_ship"

/obj/effect/overmap/visitable/ship/landable/hephsec_shuttle
	name = "Hephaestus Security Shuttle"
	class = "HCV"
	designation = "Lachesis"
	desc = "A short-range transport shuttle designed by Hephaestus, often seen in the hands of interstellar law enforcement.."
	shuttle = "Hephaestus Security Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#BAB86C", "#8B4000")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/hephsec_shuttle
	name = "shuttle control console"
	shuttle_tag = "Hephaestus Security Shuttle"

/datum/shuttle/autodock/overmap/hephsec_shuttle
	name = "Hephaestus Security Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/heph_security)
	current_location = "hephsec_shuttle"
	landmark_transition = "hephsec_shuttle_transit"
	dock_target = "airlock_heph_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "hephsec_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/hephsec_shuttle
	name = "Security Shuttle Dock"
	landmark_tag = "hephsec_shuttle"
	docking_controller = "heph_security_dock"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/hephsec_shuttle_transit
	name = "In transit"
	landmark_tag = "hephsec_shuttle_transit"
	base_turf = /turf/space/transit/north
	base_area = /area/space
