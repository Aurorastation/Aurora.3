/datum/map_template/ruin/away_site/tajara_mining_jack
	name = "adhomian mining outpost"
	description = "An outpost used by the crew of mining jacks."
	suffixes = list("away_site/tajara/mining_jack/mining_jack.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	ship_cost = 1
	id = "tajara_mining_jack"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajara_mining_jack)

	unit_test_groups = list(2)

/singleton/submap_archetype/tajara_mining_jack
	map = "adhomian mining outpost"
	descriptor = "An outpost used by the crew of mining jacks."

/obj/effect/overmap/visitable/sector/tajara_mining_jack
	name = "adhomian mining outpost"
	desc = "An outpost used by the crew of adhomian mining jacks."

	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#DAA06D"

	initial_generic_waypoints = list(
		"nav_tajara_mining_jack_1",
		"nav_tajara_mining_jack_2",
		"nav_tajara_mining_jack_3"
	)
	initial_restricted_waypoints = list(
		"Mining Jack" = list("nav_hangar_tajara_mining_jack")
	)
	comms_support = TRUE
	comms_name = "adhomian mining"

/obj/effect/shuttle_landmark/tajara_mining_jack
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/tajara_mining_jack/nav1
	name = "Adhomian Mining Outpost Navpoint #1"
	landmark_tag = "nav_tajara_mining_jack_1"

/obj/effect/shuttle_landmark/tajara_mining_jack/nav2
	name = "Adhomian Mining Outpost Navpoint #2"
	landmark_tag = "nav_tajara_mining_jack_2"

/obj/effect/shuttle_landmark/tajara_mining_jack/nav3
	name = "Adhomian Mining Outpost Navpoint #3"
	landmark_tag = "nav_tajara_mining_jack_3"


//ship stuff
/obj/effect/overmap/visitable/ship/landable/tajara_mining_jack
	name = "Mining Jack"
	class = "ACV"
	desc = "A modified skipjack used by Tajaran miners. These models have been modified to mine as much as possible with a small crew. Due to its limited fuel supply, it usually does not go too far from its home base."
	shuttle = "Mining Jack"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#DAA06D")
	designer = "Independent/no designation"
	volume = "18 meters length, 15 meters beam/width, 7 meters vertical height"
	sizeclass = "Multi-purpose Civilian Skipjack"
	shiptype = "Short-term industrial prospecting, raw goods transport"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/tajara_mining_jack/New()
	designation = "[pick("Rock Breaker", "Mining Zhan", "Flying Pickaxe", "Asteroid's Worst Nightmare", "Twin Suns Drills", "Minharrzka's Blessing", "Driller", "Stardust", "Dhrarmela's Smelter")]"
	..()

/obj/machinery/computer/shuttle_control/explore/tajara_mining_jack
	name = "shuttle control console"
	shuttle_tag = "Mining Jack"

/datum/shuttle/autodock/overmap/tajara_mining_jack
	name = "Mining Jack"
	move_time = 20
	shuttle_area = list(/area/shuttle/mining_jack/bridge, /area/shuttle/mining_jack/engines)
	dock_target = "tajara_mining_jack"
	current_location = "nav_hangar_tajara_mining_jack"
	landmark_transition = "nav_transit_tajara_mining_jack"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tajara_mining_jack"
	defer_initialisation = TRUE
