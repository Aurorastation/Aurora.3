/datum/map_template/ruin/away_site/iac_rescue_ship
	name = "IAC Rescue Ship"
	description = "The Sanctuary-class rescue ship is a fast response medical vessel, based in large part off of the Asclepius-class medical transport, a much older and more widespread clinic ship, designed to operate mainly between planets rather than in open space. Most Sanctuary-class hulls are heavily refitted to accomodate for the new conditions in the Wildlands, sporting additional thrusters and a hangar bay, created from what was originally a waiting room. However, it is still limited by its origins, having only the bare minimum of crew and atmospherics facilities, as well as being rather obviously unarmed, often needing to return to port for repairs or supplies."
	suffixes = list("ships/iac/iac_rescue_ship.dmm")
	sectors = list(SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)
	spawn_weight = 1
	spawn_cost = 1
	id = "iac_rescue_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/iac_shuttle)


/decl/submap_archetype/iac_rescue_ship
	map = "IAC Rescue Ship"
	descriptor = "The Sanctuary-class rescue ship is a fast response medical vessel, based in large part off of the Asclepius-class medical transport, a much older and more widespread clinic ship, designed to operate mainly between planets rather than in open space. Most Sanctuary-class hulls are heavily refitted to accomodate for the new conditions in the Wildlands, sporting additional thrusters and a hangar bay, created from what was originally a waiting room. However, it is still limited by its origins, having only the bare minimum of crew and atmospherics facilities, as well as being rather obviously unarmed, often needing to return to port for repairs or supplies."

//areas
/area/ship/iac_rescue_ship
	name = "IAC Rescue Ship"
	requires_power = TRUE
	
/area/ship/iac_rescue_ship/bridge
	name = "IAC Rescue Ship Bridge"
	
/area/ship/iac_rescue_ship/hangar
	name = "IAC Rescue Ship Hangar"
	
/area/ship/iac_rescue_ship/starboardengine
	name = "IAC Rescue Ship Starboard Engine"
	
/area/ship/iac_rescue_ship/portengine
	name = "IAC Rescue Ship Port Engine"
	
/area/ship/iac_rescue_ship/bathroom
	name = "IAC Rescue Ship Bathroom"
	
/area/ship/iac_rescue_ship/mainstorage
	name = "IAC Rescue Ship Main Storage"
	
/area/ship/iac_rescue_ship/medical
	name = "IAC Rescue Ship Medical"
	
/area/ship/iac_rescue_ship/surgery
	name = "IAC Rescue Ship Surgery Room"

/area/ship/iac_rescue_ship/pharmacy
	name = "IAC Rescue Ship Pharmacy"
	
/area/ship/iac_rescue_ship/dorms
	name = "IAC Rescue Ship Dorms"
	
/area/ship/iac_rescue_ship/coord
	name = "IAC Rescue Ship Coordinator's Office"
	
/area/ship/iac_rescue_ship/hallway
	name = "IAC Rescue Ship Hallway"
	
/area/shuttle/iac_shuttle
	name = "IAC Ambulance Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/iac_rescue_ship
	name = "IAC Rescue Ship"
	class = "IAV"
	desc = "The Sanctuary-class rescue ship is a fast response medical vessel, based in large part off of the Asclepius-class medical transport, a widespread clinic ship, designed to operate mainly between planets rather than in open space. Most Sanctuary-class hulls are heavily refitted to accomodate for the new conditions in the Wildlands, sporting additional thrusters and a hangar bay, created from what was originally a waiting room. However, it is still limited by its origins, having only the bare minimum of crew and atmospherics facilities, as well as being rather obviously unarmed, often needing to return to port for repairs or supplies."
	icon_state = "ship"
	moving_state = "ship_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"IAC Ambulance Shuttle" = list("nav_hangar_iac")
	)

	initial_generic_waypoints = list(
		"nav_iac_rescue_ship_1",
		"nav_iac_rescue_ship_2",
		"nav_iac_rescue_ship_3",
		"nav_iac_rescue_ship_4",
		"nav_iac_rescue_ship_5"
	)

/obj/effect/overmap/visitable/ship/iac_rescue_ship/New()
	designation = "[pick("Angitia", "Eir", "Vejovis", "Dharti", "Serket", "He Xiangu", "Sirona", "Ixtlilton", "Boris Yegorov", "Simi", "Aleksandra Hro'makar", "Assistance", "Helping Hand", "Free Aid", "Safe Haven", "Grace", "Compassion", "Relief")]"
	..()

/obj/effect/shuttle_landmark/iac_rescue_ship/nav1
	name = "IAC Rescue Ship - Port Side"
	landmark_tag = "nav_iac_rescue_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/iac_rescue_ship/nav2
	name = "IAC Rescue Ship - Port Airlock"
	landmark_tag = "nav_iac_rescue_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space
	
/obj/effect/shuttle_landmark/iac_rescue_ship/nav3
	name = "IAC Rescue Ship - Starboard Side"
	landmark_tag = "nav_iac_rescue_ship_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space
	
/obj/effect/shuttle_landmark/iac_rescue_ship/nav4
	name = "IAC Rescue Ship - Aft Side"
	landmark_tag = "nav_iac_rescue_ship_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space
	
/obj/effect/shuttle_landmark/iac_rescue_ship/nav5
	name = "IAC Rescue Ship - Fore Side"
	landmark_tag = "nav_iac_rescue_ship_5"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/iac_rescue_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_iac_rescue_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/iac_shuttle
	name = "IAC Ambulance Shuttle"
	class = "IAV"
	designation = "Heka"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one's transponder identifies it as belonging to a Interstellar Aid Corps vessel."
	shuttle = "IAC Ambulance Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/iac_shuttle
	name = "shuttle control console"
	shuttle_tag = "IAC Ambulance Shuttle"
	req_access = list(access_iac_rescue_ship)

/datum/shuttle/autodock/overmap/iac_shuttle
	name = "IAC Ambulance Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/iac_shuttle)
	current_location = "nav_hangar_iac"

	landmark_transition = "nav_transit_iac_shuttle"

	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_iac"

	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/iac_shuttle/hangar
	name = "IAC Ambulance Shuttle Hangar"
	landmark_tag = "nav_hangar_iac"

	docking_controller = "iac_shuttle_dock"

	base_area = /area/ship/iac_rescue_ship/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/iac_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_iac_shuttle"

	base_turf = /turf/space/transit/north
