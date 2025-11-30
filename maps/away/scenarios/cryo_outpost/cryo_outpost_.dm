
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/cryo_outpost
	name = "Desert Oasis Planet"
	description = "Desert Oasis Planet."
	id = "cryo_outpost"

	prefix = "scenarios/cryo_outpost/"
	suffix = "cryo_outpost.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/desert/cryo_outpost
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/desert/cryo_outpost,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/desert/cryo_outpost/mountain,
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/grass/cryo_outpost
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_hot)
	exoplanet_lightlevel = list(1, 2, 5)
	exoplanet_lightcolor = list("#ffffd4") // light white-yellowish

	spawn_weight = 0 // so it does not spawn as ordinary away site
	spawn_cost = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(3)

/singleton/submap_archetype/cryo_outpost
	map = "Desert Oasis Planet"
	descriptor = "Desert Oasis Planet."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/cryo_outpost
	name = "Juliett-Enderly, Desert Oasis Planet"
	desc = "\
		Temperate planet, mostly dry and covered in sand dunes, but with river and lake oases scattered around the equator. \
		Scans show a somewhat rich biosphere with flora and fauna, and the planet holds a standard breathable atmosphere. \
		Landing site is in a small valley with a small river running through it.\
		"
	icon_state = "globe1"
	color = "#f1c86f"
	comms_support = TRUE
	initial_generic_waypoints = list(
		"nav_cryo_outpost_surface_close_1a",
		"nav_cryo_outpost_surface_close_1b",
		"nav_cryo_outpost_surface_close_1c",
		"nav_cryo_outpost_surface_close_1d",
		"nav_cryo_outpost_surface_close_2a",
		"nav_cryo_outpost_surface_close_2b",
		"nav_cryo_outpost_surface_close_2c",
		"nav_cryo_outpost_surface_close_2d",
		"nav_cryo_outpost_surface_far_1a",
		"nav_cryo_outpost_surface_far_1b",
		"nav_cryo_outpost_surface_far_1c",
		"nav_cryo_outpost_surface_far_1d",
		"nav_cryo_outpost_surface_far_2a",
		"nav_cryo_outpost_surface_far_2b",
		"nav_cryo_outpost_surface_far_2c",
		"nav_cryo_outpost_surface_far_2d",
		"nav_cryo_outpost_surface_far_3a",
		"nav_cryo_outpost_surface_far_3b",
		"nav_cryo_outpost_surface_far_3c",
		"nav_cryo_outpost_surface_far_3d",
	)

/obj/effect/overmap/visitable/sector/cryo_outpost/generate_ground_survey_result()
	..()
	if(prob(60))
		ground_survey_result += "<br>Analysis indicates sands rich in silica and oxygen"
	if(prob(40))
		ground_survey_result += "<br>High nitrogen and phosphorus contents of the soil"
	if(prob(40))
		ground_survey_result += "<br>Chemical extraction indicates soil is rich in major and secondary nutrients for agriculture"
	if(prob(40))
		ground_survey_result += "<br>Analysis indicates low contaminants of the soil"
	if(prob(40))
		ground_survey_result += "<br>Soft clays detected, composed of quartz and calcites"
	if(prob(40))
		ground_survey_result += "<br>Muddy dirt rich in organic material"
	if(prob(40))
		ground_survey_result += "<br>Stratigraphy indicates low risk of tectonic activity in this region"
	if(prob(60))
		ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	if(prob(10))
		ground_survey_result += "<br>Traces of fissile material"

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

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/outside_building_river
	name = "Outside Building, River"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/outside_building_river
	name = "Outside Building, River"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/outside_building_landing_pads
	name = "Outside Building, Landing Pads"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/outside_building_landing_pads
	name = "Outside Building, Landing Pads"

// --------------------------------------------------- misc

/obj/machinery/camera/network/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/machinery/computer/security/terminal/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/item/research_slip/cryo_outpost
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data. This one is covered in Zeng-Hu Pharmaceuticals logos."
	icon_state = "slip_zeng"
	origin_tech = list(TECH_BIO = 8, TECH_MATERIAL = 7, TECH_MAGNET = 7, TECH_DATA = 7)
