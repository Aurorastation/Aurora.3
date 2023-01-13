/datum/map_template/ruin/away_site/dominian_corvette
	name = "Dominian Corvette"
	description = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Hegemony, and Republic of dominia."
	suffixes = list("ships/dominia/dominian_corvette.dmm")
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_shuttle)

/singleton/submap_archetype/dominian_corvette
	map = "Dominian Corvette"
	descriptor = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Hegemony, and Republic of dominia."

//areas
/area/ship/dominian_corvette
	name = "Dominian Corvette"

/area/ship/dominian_corvette/hangar
	name = "Dominian Corvette Hangar"

/area/ship/dominian_corvette/infirmary
	name = "Dominian Corvette Infirmary"

/area/ship/dominian_corvette/quarters
	name = "Dominian Corvette Crew Quarters"

/area/ship/dominian_corvette/brig
	name = "Dominian Corvette Brig"

/area/ship/dominian_corvette/cic
	name = "Dominian Corvette CIC"

/area/ship/dominian_corvette/bridge
	name = "Dominian Corvette Bridge"

/area/ship/dominian_corvette/franny
	name = "Dominian Corvette Francisca Compartment"

/area/ship/dominian_corvette/officer
	name = "Dominian Corvette Officer Compartment"

/area/ship/dominian_corvette/armory
	name = "Dominian Corvette Armory"

/area/ship/dominian_corvette/temple
	name = "Dominian Corvette Temple"

/area/ship/dominian_corvette/cryo
	name = "Dominian Corvette Cryogenics"

/area/ship/dominian_corvette/engineering
	name = "Dominian Corvette Engineering"

/area/ship/dominian_corvette/cannon
	name = "Dominian Corvette Cannon Compartment"

/area/ship/dominian_corvette/exterior
	name = "Dominian Corvette Exterior"

/area/shuttle/dominian_shuttle
	name = "Dominian Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/dominian_corvette
	name = "Dominian Corvette"
	class = "HIMS"
	desc = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Hegemony, and Republic of dominia."
	icon_state = "ship_red"
	moving_state = "ship_red_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Dominian Shuttle" = list("nav_hangar_dominia")
	)

	initial_generic_waypoints = list(
		"nav_dominian_corvette_1",
		"nav_dominian_corvette_2"
	)

/obj/effect/overmap/visitable/ship/dominian_corvette/New()
	designation = "[pick("Lammergeier", "Eagle", "Hawk", "Owl", "Vulture", "Sparrowhawk", "Falcon", "Peregrine", "Condor", "Harrier", "Kestrel", "Osprey", "Yastr", "Merlin", "Kite", "Seriema", "Caracaras")]"
	..()

/obj/effect/shuttle_landmark/dominian_corvette/nav1
	name = "Dominian Corvette - Fore"
	landmark_tag = "nav_dominian_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_corvette/nav2
	name = "Dominian Corvette - Aft"
	landmark_tag = "nav_dominian_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_corvette/nav3
	name = "Dominian Corvette - Starboard"
	landmark_tag = "nav_dominian_corvette_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_corvette/nav4
	name = "Dominian Corvette - Port"
	landmark_tag = "nav_dominian_corvette_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_corvette"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/dominian_shuttle
	name = "Dominian Shuttle"
	class = "HIMS"
	designation = "Chariot"
	desc = "A light shuttle used by the Imperial Fleet to move small amounts of cargo or personnel between vessels, the Yupmi-class shuttle is a dependable utility craft. Like most Dominian vessels it is relatively well armored for its size but is not a combat vessel by any means. A short operational range means a Yupmi should never stray too far from its vessel of origin as it will soon run out of fuel."
	shuttle = "Dominian Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/dominian_shuttle
	name = "shuttle control console"
	shuttle_tag = "Dominian Shuttle"
	req_access = list(access_imperial_fleet_voidsman_ship)

/datum/shuttle/autodock/overmap/dominian_shuttle
	name = "Dominian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/dominian_shuttle)
	current_location = "nav_hangar_dominia"
	landmark_transition = "nav_transit_dominian_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_dominia"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/dominian_shuttle/hangar
	name = "Dominian Shuttle Hangar"
	landmark_tag = "nav_hangar_dominia"
	docking_controller = "dominian_shuttle_dock"
	base_area = /area/ship/dominian_corvette
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/dominian_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_shuttle"
	base_turf = /turf/space/transit/north
