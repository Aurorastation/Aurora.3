// --------------------------------------------------- template

/datum/map_template/ruin/away_site/nuclear_silo
	name = "Arctic Valley"
	description = "A small wooden village within a valley in an arctic environment."
	prefix = "scenarios/nuclear_silo/"
	suffix = "nuclear_silo.dmm"

	traits = list(
		// Bunker Level
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Surface Level
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	spawn_weight = 0
	spawn_cost = 1
	id = "nuclear_silo"
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/lift/nuclear_silo)
	exoplanet_theme_base = /datum/exoplanet_theme/snow/nuclear_silo
	exoplanet_themes = list(
		/turf/unsimulated/marker = /datum/exoplanet_theme/snow/nuclear_silo,
		/turf/unsimulated/marker/gray   = /datum/exoplanet_theme/snow/nuclear_silo/mountain,
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/snow/foothills/nuclear_silo
	)
	unit_test_groups = list(1)

/singleton/submap_archetype/nuclear_silo
	map = "Arctic Valley"
	descriptor = "A small wooden village within a valley in an arctic environment."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/nuclear_silo
	name = "Unlabelled Arctic Exoplanet"
	desc = "\
		An arctic exoplanet not currently listed on available starcharts. \
		Scans of the landing area indicate a small valley within the wider craggy mountains, with a frozen river running through it. \
		Higher resolution scans show a small town within the valley, with biological signatures indicating a standard breathable atmosphere. \
		"
	icon_state = "globe2"
	color = "#f7e3e3"
	comms_support = TRUE
	initial_generic_waypoints = list(
		"nav_nuclear_silo_surface_south_1a",
		"nav_nuclear_silo_surface_south_1b",
		"nav_nuclear_silo_surface_south_1c",
		"nav_nuclear_silo_surface_south_1d",
		"nav_nuclear_silo_surface_south_2a",
		"nav_nuclear_silo_surface_south_2b",
		"nav_nuclear_silo_surface_south_2c",
		"nav_nuclear_silo_surface_south_2d",
		"nav_nuclear_silo_surface_north_1a",
		"nav_nuclear_silo_surface_north_1b",
		"nav_nuclear_silo_surface_north_1c",
		"nav_nuclear_silo_surface_north_1d",
		"nav_nuclear_silo_surface_north_2a",
		"nav_nuclear_silo_surface_north_2b",
		"nav_nuclear_silo_surface_north_2c",
		"nav_nuclear_silo_surface_north_2d",
		"nav_nuclear_silo_surface_north_3a",
		"nav_nuclear_silo_surface_north_3c",
		"nav_nuclear_silo_surface_north_3b",
		"nav_nuclear_silo_surface_north_3d",
	)
// --------------------------------------------------- mapmanip

/obj/effect/map_effect/marker/mapmanip/submap/insert/nuclear_silo/crew_quarters_room
	name = "Crew Quarters Room South"

/obj/effect/map_effect/marker/mapmanip/submap/extract/nuclear_silo/crew_quarters_room
	name = "Crew Quarters Room South"

/obj/effect/map_effect/marker/mapmanip/submap/insert/nuclear_silo/crew_quarters_room_north
	name = "Crew Quarters Room North"

/obj/effect/map_effect/marker/mapmanip/submap/extract/nuclear_silo/crew_quarters_room_north
	name = "Crew Quarters Room North"

/obj/effect/map_effect/marker/mapmanip/submap/insert/nuclear_silo/armoury
	name = "Armoury"

/obj/effect/map_effect/marker/mapmanip/submap/extract/nuclear_silo/armoury
	name = "Armoury"
