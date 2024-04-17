
// ---- map template/archetype

/datum/map_template/ruin/away_site/cult_base
	name = "Cult Base"
	description = "Cult Base."
	id = "cult_base"
	prefix = "away_site/cult_base/"
	suffixes = list("cult_base.dmm")
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // TODO: REMOVE THIS

/singleton/submap_archetype/cult_base
	map = "Cult Base"
	descriptor = "Cult Base."

// ---- sector

/obj/effect/overmap/visitable/sector/cult_base
	name = "Asteroid Station"
	desc = "\
		Scans reveal a small station built into a asteroid, registered in the official and public databases as a independent research outpost. \
		It appears to be pressurized, powered, with a functioning transponder, and has a hangar for a small shuttle. \
		Database query reveals that it was active and has seen traffic up until a few weeks ago, but no communications in or out since then. \
		Caution is advised.\
		"
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "asteroid_cluster"
	color = "#bd8159"

	designer = "Unknown"
	volume = "90 meters length, 90 meters beam/width, 42 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Asteroid Base"

	initial_generic_waypoints = list(
		// docks
		"nav_cult_base_dock_hangar",
		"nav_cult_base_dock_north_east",
		"nav_cult_base_dock_north_west",
		"nav_cult_base_dock_west",
		"nav_cult_base_dock_east_north",
		"nav_cult_base_dock_east_south",
		"nav_cult_base_dock_south_east",
		"nav_cult_base_dock_south_mid",
		"nav_cult_base_dock_south_west",
		// catwalks
		"nav_cult_base_catwalk_north",
		"nav_cult_base_catwalk_west",
		"nav_cult_base_catwalk_south_1",
		"nav_cult_base_catwalk_south_2",
		"nav_cult_base_catwalk_south_3",
		"nav_cult_base_catwalk_south_4",
		// space
		"nav_cult_base_space_south_west",
		"nav_cult_base_space_south_east",
		"nav_cult_base_space_north_west",
		"nav_cult_base_space_north_east",
	)

// ---- shuttle

/obj/effect/overmap/visitable/ship/landable/cult_base_shuttle
	name = "ICV Cult Base Shuttle"
	class = "ICV"
	desc = "\
		A standard-sized exploration shuttle manufactured by Hephaestus, \
		the Pioneer-class is commonly used by explorers, pioneers, surveyors, and the like. \
		Featuring well-rounded facilities and equipment, the Pioneer is a dependable platform, \
		although a bit dated by now, outclassed by newer designs like the Pathfinder-class.\
		"
	shuttle = "ICV Cult Base Shuttle"
	icon_state = "cetus"
	moving_state = "cetus_moving"
	colors = list("#d3d155", "#bea03b")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Hephaestus Industries"
	volume = "17 meters length, 24 meters beam/width, 6 meters vertical height"
	sizeclass = "Pioneer Exploration Shuttle"
	shiptype = "Field expeditions and private research uses"

/obj/effect/overmap/visitable/ship/landable/cult_base_shuttle/New()
	designation = pick(
		"Battle Against Evil", "Winds Over Aoyama", "Doll's Polyphony", "Shohmyoh",
		"Mutation", "Exodus From The Underground Fortress", "Illusion", "Requiem",
		)
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/cult_base_shuttle
	name = "shuttle control console"
	shuttle_tag = "ICV Cult Base Shuttle"

/datum/shuttle/autodock/overmap/cult_base_shuttle
	name = "ICV Cult Base Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/cult_base/crew, /area/shuttle/cult_base/cargo, /area/shuttle/cult_base/propulsion)
	dock_target = "airlock_cult_base_shuttle"
	current_location = "nav_cult_base_dock_hangar"
	landmark_transition = "nav_cult_base_shuttle_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_cult_base_dock_hangar"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/cult_base_shuttle
	name = "ICV Cult Base Shuttle"
	shuttle_tag = "ICV Cult Base Shuttle"
	master_tag = "airlock_cult_base_shuttle"

// ---------------------
