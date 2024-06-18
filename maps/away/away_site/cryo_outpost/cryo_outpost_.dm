
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/cryo_outpost
	name = "Cryo Outpost"
	description = "TODO."
	prefix = "away_site/cryo_outpost/"
	suffixes = list("cryo_outpost.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "cryo_outpost"
	// shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/cryo_outpost)
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/desert/cryo_outpost,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/desert/cryo_outpost/mountain,
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/grass/cryo_outpost
	)
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // TODO REMOVE THIS

/singleton/submap_archetype/cryo_outpost
	map = "Cryo Outpost"
	descriptor = "TODO."

/obj/abstract/weather_marker/cryo_outpost
	weather_type = /singleton/state/weather/ash/lava_planet

// --------------------------------------------------- mapmanip

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/crew_quarters_room
	name = "Crew Quarters Room"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/crew_quarters_room
	name = "Crew Quarters Room"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/warehouse
	name = "Warehouse"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/warehouse
	name = "Warehouse"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/river
	name = "River"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/river
	name = "River"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/landing_pads
	name = "Landing Pads"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/landing_pads
	name = "Landing Pads"

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/cryo_outpost
	name = "Cryo Outpost"
	desc = "TODO."
	icon_state = "globe3"
	color = "#d69200"
	initial_generic_waypoints = list(
		"nav_cryo_outpost_dock_outpost_1",
		"nav_cryo_outpost_dock_outpost_2",
		"nav_cryo_outpost_dock_outpost_3",
		"nav_cryo_outpost_dock_outpost_4",
		"nav_cryo_outpost_dock_outpost_5",
		"nav_cryo_outpost_surface_outpost_1",
		"nav_cryo_outpost_surface_outpost_2",
		"nav_cryo_outpost_surface_outpost_3",
		"nav_cryo_outpost_surface_outpost_4",
		"nav_cryo_outpost_surface_outpost_5",
		"nav_cryo_outpost_surface_far_1",
		"nav_cryo_outpost_surface_far_2",
		"nav_cryo_outpost_surface_far_3",
		"nav_cryo_outpost_surface_far_4",
	)

/obj/effect/overmap/visitable/sector/cryo_outpost/generate_ground_survey_result()
	..()
	// TODO

// --------------------------------------------------- misc

/obj/machinery/camera/network/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/machinery/computer/security/terminal/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/item/research_slip/cryo_outpost
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data."
	origin_tech = list(TECH_BIO = 8, TECH_MATERIAL = 7, TECH_MAGNET = 7, TECH_DATA = 7)

// ---------------------------------------------------
