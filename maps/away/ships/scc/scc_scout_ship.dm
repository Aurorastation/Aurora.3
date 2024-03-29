/datum/map_template/ruin/away_site/scc_scout_ship
	name = "SCC Scout Ship"
	description = "A small ship commonly fielded by the Stellar Corporate Conglomerate, the Serendipity-class, Hephaestus-designed and produced. It is supposed to be a small platform, entirely self-sufficient general-purpose scouting and surveying ship, the Serendipity is equipped with both a bluespace and a warp drive and two different engines."
	suffixes = list("ships/scc/scc_scout_ship.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "scc_scout_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scc_scout_shuttle)
	unit_test_groups = list(3)

/singleton/submap_archetype/scc_scout_ship
	map = "SCC Scout Ship"
	descriptor = "A small ship commonly fielded by the Stellar Corporate Conglomerate, the Serendipity-class, Hephaestus-designed and produced. It is supposed to be a small platform, entirely self-sufficient general-purpose scouting and surveying ship, the Serendipity is equipped with both a bluespace and a warp drive and two different engines."

// ship

/obj/effect/overmap/visitable/ship/scc_scout_ship
	name = "SCC Scout Ship"
	class = "SCCV"
	desc = "A small ship commonly fielded by the Stellar Corporate Conglomerate, the Serendipity-class, Hephaestus-designed and produced. It is supposed to be a small platform, entirely self-sufficient general-purpose scouting and surveying ship, the Serendipity is equipped with both a bluespace and a warp drive and two different engines."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#cfd4ff", "#78adf8")
	designer = "Hephaestus Industries"
	volume = "42 meters length, 48 meters beam/width, 23 meters vertical height"
	drive = "First-Gen Warp Capable, Hybrid Phoron Bluespace Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Flak battery"
	sizeclass = "Serendipity-class Scout Ship"
	shiptype = "Multi-purpose scout"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = TRUE
	initial_restricted_waypoints = list(
		"SCC Scout Shuttle" = list("nav_scc_scout_shuttle_dock")
	)
	initial_generic_waypoints = list(
		"nav_scc_scout_dock_starboard",
		"nav_scc_scout_dock_port",
		"nav_scc_scout_dock_aft",
		"nav_scc_scout_catwalk_aft",
		"nav_scc_scout_catwalk_fore_starboard",
		"nav_scc_scout_catwalk_fore_port",
		"nav_scc_scout_space_fore_starboard",
		"nav_scc_scout_space_fore_port",
		"nav_scc_scout_space_aft_starboard",
		"nav_scc_scout_space_aft_port",
		"nav_scc_scout_space_port_far",
		"nav_scc_scout_space_starboard_far",
	)

/obj/effect/overmap/visitable/ship/scc_scout_ship/New()
	designation = "[pick("Dew Point", "Monsoon", "Cyclogenesis", "Warm Fronts", "Moisture Deficit", "Borealis", "Surface Tension", "Precipitation", "Oscillation", "Coalescence", "Double Rainbow", "Through a Cloud, Darkly", "Relative Humidity", "Evapotranspiration", "Alluvial Plain", "Dehydration", "Hydrophobia", "The Rain Formerly Known as Purple", "Lacrimosum", "Island of Ignorance", "Intertropical", "Once in a Lullaby", "A Boat Made from a Sheet of Newspaper", "Flood Control")]"
	..()

// shuttle

/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle
	name = "SCC Scout Shuttle"
	class = "SCCV"
	desc = "A standard-sized exploration shuttle manufactured by Hephaestus, the Pathfinder-class is commonly used by the corporations of the SCC. Featuring well-rounded facilities and equipment, the Pathfinder is excellent, albeit pricey, platform. This one appears to be a bit of an older model, perhaps a prototype."
	shuttle = "SCC Scout Shuttle"
	icon_state = "intrepid"
	moving_state = "intrepid_moving"
	colors = list("#cfd4ff", "#78adf8")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Hephaestus Industries"
	volume = "17 meters length, 24 meters beam/width, 6 meters vertical height"
	sizeclass = "Pathfinder Exploration Shuttle"
	shiptype = "Field expeditions and private research uses"

/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "intrepid")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle/New()
	designation = "[pick("Dew Point", "Monsoon", "Cyclogenesis", "Warm Fronts", "Moisture Deficit", "Borealis", "Surface Tension", "Precipitation", "Oscillation", "Coalescence", "Double Rainbow", "Through a Cloud, Darkly", "Relative Humidity", "Evapotranspiration", "Alluvial Plain", "Dehydration", "Hydrophobia", "The Rain Formerly Known as Purple", "Lacrimosum", "Island of Ignorance", "Intertropical", "Once in a Lullaby", "A Boat Made from a Sheet of Newspaper", "Flood Control")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/scc_scout_shuttle
	name = "shuttle control console"
	shuttle_tag = "SCC Scout Shuttle"

/datum/shuttle/autodock/overmap/scc_scout_shuttle
	name = "SCC Scout Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/scc_scout_ship_shuttle/cockpit, /area/shuttle/scc_scout_ship_shuttle/eva, /area/shuttle/scc_scout_ship_shuttle/cargo, /area/shuttle/scc_scout_ship_shuttle/medbay, /area/shuttle/scc_scout_ship_shuttle/propulsion_starboard, /area/shuttle/scc_scout_ship_shuttle/propulsion_port)
	dock_target = "airlock_scc_scout_shuttle"
	current_location = "nav_scc_scout_shuttle_dock"
	landmark_transition = "nav_scc_scout_shuttle_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scc_scout_shuttle_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/scc_scout_ship
	name = "SCC Scout Shuttle"
	shuttle_tag = "SCC Scout Shuttle"
	master_tag = "airlock_scc_scout_shuttle"
