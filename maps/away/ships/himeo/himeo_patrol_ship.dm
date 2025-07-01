/datum/map_template/ruin/away_site/himeo_patrol_ship
	name = "Himean Planetary Guard Vessel"
	description = "A patrol vessel fielded by the Himean Planetary Guard."

	traits = list(
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "ships/himeo/"
	suffix = "himeo_patrol_ship.dmm"

	sectors = list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_ARUSHA, SECTOR_LIBERTYS_CRADLE, SECTOR_HANEUNIM)
	spawn_weight = 1
	ship_cost = 1
	id = "Himean Planetary Guard Vessel"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/himeo_patrol_shuttle, /datum/shuttle/autodock/multi/lift/himeo_patrol_ship)
	unit_test_groups = list(1)

/singleton/submap_archetype/himeo_patrol_ship
	map = "Himean Planetary Guard Vessel"
	descriptor = "A patrol vessel fielded by the Himean Planetary Guard."

/obj/effect/overmap/visitable/ship/himeo_patrol_ship
	name = "Himean Planetary Guard Vessel"
	class = "USPGV" // United Syndicates Planetary Guard Vessel
	desc = "A typical Himean design, the Collier-class is designed to patrol major trade routes and discourage pirate attacks. It is not intended for fleet engagements, as it lacks heavier armament such as missiles."
	icon_state = "himeo_patrol"
	moving_state = "himeo_patrol_moving"
	colors = list("#817f7f", "#be0f0f")
	designer = "Free Consortium of Defense and Aerospace Manufacturers"
	weapons = "Rear-mounted low-calibre autocannon, rear-mounted blaster weapon"
	drive = "Forsberg Mk. XII Warp Drive: A Himean design from the 2440s, the Forsberg is a decently cheap — and relatively fast — drive produced by FCDAM for the Himean Planetary Guard."
	sizeclass = "Collier-class patrol corvette"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 9000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Himean Patrol Shuttle" = list("himeo_patrol_nav_dock")
	)
	initial_generic_waypoints = list(
		"himeo_patrol_nav1",
		"himeo_patrol_nav2",
		"himeo_patrol_nav3",
		"himeo_patrol_nav4",
		"himeo_patrol_dock1",
		"himeo_patrol_dock2",
		"himeo_patrol_dock3",
		"himeo_patrol_dock4"
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/himeo_patrol_ship/New()
	designation = "[pick("Ilmarinen", "Vetehinen", "Vesikko", "Saukko", "Jaakarhu", "Sampo", "Lieska", "Riilahti", "Griffwn", "Llew Du", "Rhyfelog", "Hydd Gwyn", "Roisin", "Niamh", "Aoibhinn", "Gobnait" )]"
	..()

//Shuttle
/obj/effect/overmap/visitable/ship/landable/himeo_patrol_shuttle
	name = "Himean Patrol Shuttle"
	desc = "Placeholder."
	class = "USPGV"
	designation = "Kotka"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Himean Patrol Shuttle"
	colors = list("#525151", "#800a0a")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Free Consortium of Defense and Auerospace Manufacturers"
	volume = "15 meters length, 20 meters beam/width, 6 meters vertical height"
	sizeclass = "Hiirihaukka-class Fighter Shuttle"
	shiptype = "Troop transport and anti-ship combat operations"

/obj/machinery/computer/shuttle_control/explore/terminal/himeo_patrol_shuttle
	name = "shuttle control terminal"
	shuttle_tag = "Himean Patrol Shuttle"

/datum/shuttle/autodock/overmap/himeo_patrol_shuttle
	name = "Himean Patrol Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/himeo_patrol, /area/shuttle/himeo_patrol/central)
	dock_target = "airlock_himeo_patrol_shuttle"
	current_location = "himeo_patrol_nav_dock"
	landmark_transition = "himeo_patrol_nav_transit"
	dock_target = "airlock_himeo_patrol_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "himeo_patrol_nav_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/himeo_patrol_ship
	name = "Himean Patrol Shuttle"
	shuttle_tag = "Himean Patrol Shuttle"
	master_tag = "airlock_himeo_patrol_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/map_effect/marker/airlock/docking/himeo_patrol_ship/shuttle_dock
	name = "Shuttle Dock"
	landmark_tag = "himeo_patrol_nav_dock"
	master_tag = "himean_patrol_dock"

/obj/effect/shuttle_landmark/himeo_patrol_shuttle/dock
	name = "Himean Patrol Ship - Kotka Dock"
	landmark_tag = "himeo_patrol_nav_dock"
	docking_controller = "himean_patrol_dock"
	base_turf = /turf/space
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/himeo_patrol_shuttle/transit
	name = "In transit"
	landmark_tag = "himeo_patrol_nav_transit"
	base_turf = /turf/space/transit/north

// Lift
/datum/shuttle/autodock/multi/lift/himeo_patrol_ship
	name = "Himean Patrol Ship Lift"
	current_location = "nav_himeo_patrol_ship_lift_first_deck"
	shuttle_area = /area/turbolift/himeo_patrol/himeo_patrol_lift
	destination_tags = list(
		"nav_himeo_patrol_ship_lift_first_deck",
		"nav_himeo_patrol_ship_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/nav_himeo_patrol_ship_lift_first_deck
	name = "Himean Patrol Ship Lift - First Deck"
	landmark_tag = "nav_himeo_patrol_ship_lift_first_deck"
	base_area = /area/himeo_patrol_ship
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/nav_himeo_patrol_ship_lift_second_deck
	name = "Himean Patrol Ship Lift - Second Deck"
	landmark_tag = "nav_himeo_patrol_ship_lift_second_deck"
	base_area = /area/himeo_patrol_ship/deck_2_interstitial
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/himeo_patrol_ship
	shuttle_tag = "Himean Patrol Ship Lift"

// TEG manual. Largely just repurposed and reflavoured from the TCAF corvette, thank you Ben.
/obj/item/paper/fluff/himeo_patrol_engine_guide
	name = "Collier-class engine manual"
	desc = "This is a printed list of steps to operating the Thermoelectric Generator of a Collier-class patrol corvette."
	info = "<font face=\"Verdana\"><flag_coc>\
	<br><b>Failure to adhere to these instructions may lead to catastrophic destruction of the ship. Don't let that happen.</b><BR>\
	<BR>STEP 1: Enable the 'connectors to cold loop' pump and the 'cooling arrays to generator' pump. This will cool the cold-loop.<BR>\
	<BR>STEP 2: Configure the gas mixer to output west, and inject the contents of as many hydrogen and oxygen tanks into the combustion chamber as you wish, \
	at the pre-set ratio of 60% oxygen to 40% hydrogen. If you include more than one tank of each, the tank walls may require repairs.<BR>\
	<BR>STEP 3: Disable injection. Do not leave injection on.<BR>\
	<BR>STEP 4: Press the ignition button, and wait for it to fully burn out. Strain on the glas is expected, do not be concerned.<BR>\
	<BR>STEP 5: Once the fire has stopped and the contents of the tank are 100% CO2, \
	enable circulation: The recommended base rate is 700L/s input and 1000kpa output. The higher the output, the quicker it loses temperature. \
	You may need to bump it up to 2000kpa to fully recharge the SMES.<BR>\
	<BR>WARNING: If catastrophic containment failure is imminent, lower the blast doors and vent the chamber immediately! \
	There is a portable generator in the aft thruster-pod, and another in tool storage. Use one of them if the reactor melts down.</b></font>"
	language = LANGUAGE_SOL_COMMON
