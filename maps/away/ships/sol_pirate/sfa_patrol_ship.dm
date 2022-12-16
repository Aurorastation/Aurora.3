/datum/map_template/ruin/away_site/sfa_patrol_ship
	name = "SFA Corvette"
	description = "A small ship that appears to be, at its core, a Montevideo-class corvette, a Solarian anti-piracy and patrol corvette designed with ample automation and streamlined equipment which allows for it to be manned by a small crew. This one, however, seems to have been host to a myriad of haphazard and radical modifications, and is scarcely identifiable as the original craft. Beyond the changes made to the ship itself, it also appears to have suffered extensive damage and wear, and seems to be near-derelict"
	suffix = "ships/sol_pirate/sfa_patrol_ship.dmm"
	sectors = list(SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "sfa_patrol_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/sfa_shuttle)

/decl/submap_archetype/sfa_patrol_ship
	map = "SFA Corvette"
	descriptor = "A small ship that appears to be, at its core, a Montevideo-class corvette, a Solarian anti-piracy and patrol corvette designed with ample automation and streamlined equipment which allows for it to be manned by a small crew. This one, however, seems to have been host to a myriad of haphazard and radical modifications, and is scarcely identifiable as the original craft. Beyond the changes made to the ship itself, it also appears to have suffered extensive damage and wear, and seems to be near-derelict"

//areas
/area/ship/sfa_patrol_ship
	name = "SFA Corvette"

/area/ship/sfa_patrol_ship/medbay
	name = "SFA Medbay"

/area/ship/sfa_patrol_ship/SFA_Armory
	name = "SFA Armory"

/area/ship/sfa_patrol_ship/Engineering
	name = "SFA Engineering"

/area/ship/sfa_patrol_ship/Telecoms
	name = "SFA Telecoms"

/area/ship/sfa_patrol_ship/TreasureRoom
	name = "SFA Treasure Room"

/area/ship/sfa_patrol_ship/Bridge
	name = "SFA Corvette Bridge"

/area/ship/sfa_patrol_ship/Ammo_Closet
	name = "SFA Ammo Closet"

/area/ship/sfa_patrol_ship/Quarters
	name = "SFA Crew Quarters"

/area/ship/sfa_patrol_ship/Officer
	name = "SFA Officer Quarters"

/area/ship/sfa_patrol_ship/Brig
	name = "SFA Brig"

/area/ship/sfa_patrol_ship/Engine1
	name = "SFA Engine One"

/area/ship/sfa_patrol_ship/Engine2
	name = "SFA Engine Two"

/area/ship/sfa_patrol_ship/Suit_Storage
	name = "SFA Suit Storage"

/area/shuttle/sfa_shuttle
	name = "SFA Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/sfa_patrol_ship
	name = "SFA Corvette"
	class = "SFAV"
	desc = "A small ship that appears to be, at its core, a Montevideo-class corvette, a Solarian anti-piracy and patrol corvette designed with ample automation and streamlined equipment which allows for it to be manned by a small crew. This one, however, seems to have been host to a myriad of haphazard and radical modifications, and is scarcely identifiable as the original craft. Beyond the changes made to the ship itself, it also appears to have suffered extensive damage and wear, and seems to be near-derelict"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"SFA Shuttle" = list("nav_hangar_sfa")
	)

	initial_generic_waypoints = list(
		"nav_sfa_patrol_ship_1",
		"nav_sfa_patrol_ship_2"
	)

/obj/effect/overmap/visitable/ship/sfa_patrol_ship/New()
	designation = "[pick("Brigand", "Zheng Yi Sao", "Corruption", "Edward Teach", "Beauchamp's Revenge", "Blackguard", "Viking", "Despoiler", "Wayward Son", "Black Sheep", "Gluttony", "Pride", "Avarice", "Greed", "Envy", "Sloth", "Wrath", "We're The Good Ones", "Reformed", "Repentant", "Recidivist", "Just Following Orders", "Habitual Offender", "Felon", "Misdemeanor", "Conscientious Objector")]"
	..()

/obj/effect/shuttle_landmark/sfa_patrol_ship/nav1
	name = "SFA Corvette - Port Side"
	landmark_tag = "nav_sfa_patrol_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_patrol_ship/nav2
	name = "SFA Corvette - Port Airlock"
	landmark_tag = "nav_sfa_patrol_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_patrol_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_sfa_patrol_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/sfa_shuttle
	name = "SFA Shuttle"
	class = "SFAV"
	designation = "Pickford"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus."
	shuttle = "SFA Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/sfa_shuttle
	name = "shuttle control console"
	shuttle_tag = "SFA Shuttle"
	req_access = list(access_sol_ships)

/datum/shuttle/autodock/overmap/sfa_shuttle
	name = "SFA Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/sfa_shuttle)
	current_location = "nav_hangar_sfa"
	landmark_transition = "nav_transit_sfa_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_sfa"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/sfa_shuttle/hangar
	name = "SFA Shuttle Hangar"
	landmark_tag = "nav_hangar_sfa"
	docking_controller = "sfa_shuttle_dock"
	base_area = /area/ship/sfa_patrol_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/sfa_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_sfa_shuttle"
	base_turf = /turf/space/transit/north