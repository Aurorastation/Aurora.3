/datum/map_template/ruin/away_site/orion_miner
	name = "Orion Express Mining Skiff"
	description = "The Argon-class mining skiff is a workhorse of Orion Express's mining division. It is a small but dependable atmospheric-capable skiff designed to land on or dock near asteroids, planets and other places and conduct all \
	manner of mining, salvage, or extraction operations."

	prefix = "ships/orion_miner/"
	suffix = "orion_miner.dmm"

	sectors = list(ALL_CORPORATE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "orion_miner"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/orion_miner)

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/ship/landable/orion_miner
	name = "Orion Express Mining Skiff"
	class = "OEV"
	shuttle = "Orion Express Mining Skiff"
	desc = "The Argon-class mining skiff is a workhorse of Orion Express's mining division. It is a small but dependable atmospheric-capable skiff designed to land on or dock near asteroids, planets and other places and conduct all \
	manner of mining, salvage, or extraction operations."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	color = COLOR_BROWN
	colors = list(COLOR_BROWN)
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	use_mapped_z_levels = TRUE
	invisible_until_ghostrole_spawn = TRUE
	designer = "Orion Express"
	volume = "40 meters length, 20 meters beam/width, 7 meters vertical height"
	drive = "Medium-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard Grauwolf-type flak cannon"
	sizeclass = "Argon-class Miner"
	shiptype = "Multipurpose mining and salvage"

/obj/effect/overmap/visitable/ship/landable/orion_miner/New()
	designation = "[pick("Charming", "Endearing", "Rusted", "Lucky", "Unlucky", "Unrelenting", "Unfortunate", "Definitive", "Difficult", "Fiery", "Willful", "Broke", "Aerial", "Starborn", "Unreal", "Orion", "Stellar", "Astral", "Flying", "Nautical ", "Miner's", "Wayward", "Duct-Taped", "Sort-of", "Barely", "Negative")] \
	[pick("Reality", "Dreamer", "Regrets", "Boltbucket", "Wayfarer", "Trailblazer", "Overtime", "Gizmo", "Express", "Deity", "Diamond", "Miner", "Skiff of Skiffs", "Wallop", "Express", "Courier", "Coal", "Pitchblende", "Ore", "Activated Charcoal", "Plywood", "Luck", "Profit", "Write-off")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/orion_miner
	name = "shuttle control console"
	shuttle_tag = "Orion Express Mining Skiff"

// This controls how docking behaves
/datum/shuttle/autodock/overmap/orion_miner
	name = "Orion Express Mining Skiff"
	move_time = 20
	range = 2
	fuel_consumption = 2
	shuttle_area = list(
		/area/shuttle/orion_miner/exterior,
		/area/shuttle/orion_miner/bridge,
		/area/shuttle/orion_miner/mining_prep,
		/area/shuttle/orion_miner/grauwolf,
		/area/shuttle/orion_miner/ammo_storage,
		/area/shuttle/orion_miner/mess_hall,
		/area/shuttle/orion_miner/corridor,
		/area/shuttle/orion_miner/corridor/central,
		/area/shuttle/orion_miner/corridor/vestibule,
		/area/shuttle/orion_miner/corridor/aft,
		/area/shuttle/orion_miner/cargo_bay,
		/area/shuttle/orion_miner/medbay,
		/area/shuttle/orion_miner/eva,
		/area/shuttle/orion_miner/dorm,
		/area/shuttle/orion_miner/bathroom,
		/area/shuttle/orion_miner/hydro,
		/area/shuttle/orion_miner/main_engineering_port,
		/area/shuttle/orion_miner/main_engineering_stbd,
		/area/shuttle/orion_miner/tech_storage,
		/area/shuttle/orion_miner/reactor,
	)
	current_location = "nav_orion_miner_space"
	dock_target = "orion_miner"
	landmark_transition = "nav_orion_miner_transit"
	logging_home_tag = "nav_orion_miner_space"
	defer_initialisation = TRUE

// Main shuttle landmark
/obj/effect/shuttle_landmark/ship/orion_miner
	name = "Open Space"
	shuttle_name = "Orion Express Mining Skiff"
	landmark_tag = "nav_orion_miner_space"

// Transit landmark
/obj/effect/shuttle_landmark/orion_miner
	name = "In transit"
	landmark_tag = "nav_orion_miner_transit"
	base_turf = /turf/space

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/orion_miner
	name = "Aft Docking Airlock"
	master_tag = "orion_miner"
	shuttle_tag = "Independent Skiff"
	cycle_to_external_air = TRUE

// Forward airlocks
/obj/effect/map_effect/marker/airlock/orion_miner_port
	name = "Port Fore Airlock"
	master_tag = "port_orion_miner"
	cycle_to_external_air = TRUE

/obj/effect/map_effect/marker/airlock/orion_miner_starboard
	name = "Starboard Fore Airlock"
	master_tag = "stbd_orion_miner"
	cycle_to_external_air = TRUE

// Aft airlock
/obj/effect/map_effect/marker/airlock/orion_miner_aft
	name = "Aft Airlock"
	master_tag = "rear_orion_miner"
	cycle_to_external_air = TRUE
