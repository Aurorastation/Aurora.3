
// ---- map template/archetype

/datum/map_template/ruin/away_site/enviro_testing_facility
	name = "Environmental Testing Facility"
	description = "Environmental Testing Facility."
	id = "enviro_testing_facility"

	prefix = "scenarios/enviro_testing_facility/"
	suffix = "enviro_testing_facility.dmm"

	// exoplanet_theme_base = /datum/exoplanet_theme/crystal
	// exoplanet_themes = list(
	// 	/turf/unsimulated/marker/green = /datum/exoplanet_theme/crystal,
	// 	/turf/unsimulated/marker/teal  = /datum/exoplanet_theme/crystal/mountain
	// )
	// exoplanet_atmosphere = list(/datum/gas_mixture/earth_cold)
	// exoplanet_lightlevel = list(1, 2)
	// exoplanet_lightcolor = list("#dad8c1", "#dad8c1") // light-yellowish colors

	spawn_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)

	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/enviro_testing_facility
	map = "IPC RnD Facility"
	descriptor = "IPC RnD Facility."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/enviro_testing_facility
	name = "Anastasia-Archippos, Env-Test Facility Zoya"
	desc = "\
		Barren planet, covered in loose rocks, mountains, craters, with a expansive cave system deep underground. \
		The planet, amusingly, holds a standard breathable atmosphere. \
		Landing site is in a valley, near some facility.\
		"
	icon_state = "globe2"
	color = "#f1c86f"
	comms_support = TRUE
	initial_generic_waypoints = list(
		"nav_enviro_testing_facility_1a",
		"nav_enviro_testing_facility_1b",
		"nav_enviro_testing_facility_1c",
		"nav_enviro_testing_facility_1d",

		"nav_enviro_testing_facility_2a",
		"nav_enviro_testing_facility_2b",
		"nav_enviro_testing_facility_2c",
		"nav_enviro_testing_facility_2d",

		"nav_enviro_testing_facility_3a",
		"nav_enviro_testing_facility_3b",
		"nav_enviro_testing_facility_3c",
		"nav_enviro_testing_facility_3d",

		"nav_enviro_testing_facility_4a",
		"nav_enviro_testing_facility_4b",
		"nav_enviro_testing_facility_4c",
		"nav_enviro_testing_facility_4d",

		"nav_enviro_testing_facility_5a",
		"nav_enviro_testing_facility_5b",
		"nav_enviro_testing_facility_5c",
		"nav_enviro_testing_facility_5d",
	)

/obj/effect/overmap/visitable/sector/enviro_testing_facility/generate_ground_survey_result()
	..()
	if(prob(80))
		ground_survey_result += "<br>Analysis indicates sands rich in silica"
	// if(prob(40))
	// 	ground_survey_result += "<br>High nitrogen and phosphorus contents of the soil"
	// if(prob(40))
	// 	ground_survey_result += "<br>Chemical extraction indicates soil is rich in major and secondary nutrients for agriculture"
	// if(prob(40))
	// 	ground_survey_result += "<br>Analysis indicates low contaminants of the soil"
	// if(prob(40))
	// 	ground_survey_result += "<br>Soft clays detected, composed of quartz and calcites"
	// if(prob(40))
	// 	ground_survey_result += "<br>Muddy dirt rich in organic material"
	// if(prob(40))
	// 	ground_survey_result += "<br>Stratigraphy indicates low risk of tectonic activity in this region"
	// if(prob(60))
	// 	ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	// if(prob(10))
	// 	ground_survey_result += "<br>Traces of fissile material"

// --------------------------------------------------- misc

#define NETWORK_ENVIRO_TESTING_FACILITY "Env-Test Facility Zoya"

/obj/machinery/camera/network/enviro_testing_facility
	network = list(NETWORK_ENVIRO_TESTING_FACILITY)

/obj/machinery/computer/security/terminal/enviro_testing_facility
	network = list(NETWORK_ENVIRO_TESTING_FACILITY)

/obj/item/research_slip/enviro_testing_facility
	icon_state = "slip_generic"
	origin_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 4, TECH_DATA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 6)
