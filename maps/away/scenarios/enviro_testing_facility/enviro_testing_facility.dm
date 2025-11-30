
// ---- map template/archetype

/datum/map_template/ruin/away_site/enviro_testing_facility
	name = "Environmental Testing Facility"
	description = "Environmental Testing Facility."
	id = "enviro_testing_facility"

	prefix = "scenarios/enviro_testing_facility/"
	suffix = "enviro_testing_facility.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/barren
	exoplanet_themes = list(
		/turf/unsimulated/marker/blue = /datum/exoplanet_theme/barren,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/barren/mountain,
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_standard)
	exoplanet_lightlevel = list(1, 2, 5, 7)
	exoplanet_lightcolor = list("#ffffd4", "#ffe397", "#b38653")

	spawn_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	unit_test_groups = list(1)

/singleton/submap_archetype/enviro_testing_facility
	map = "Environmental Testing Facility"
	descriptor = "Environmental Testing Facility."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/enviro_testing_facility
	name = "Anastasia-Archippos, Barren Planet"
	desc = "\
		Barren planet, covered in loose rocks, mountains, craters, with a expansive cave system deep underground. \
		The planet, however, holds a standard breathable atmosphere, and there are some traces of carbon-based life. \
		Landing site is in a valley, near some facility carved into the mountain.\
	"
	icon_state = "globe2"
	color = "#e6a66a"
	comms_support = TRUE
	initial_generic_waypoints = list(
		"nav_enviro_testing_facility_surface_1a",
		"nav_enviro_testing_facility_surface_1b",
		"nav_enviro_testing_facility_surface_1c",
		"nav_enviro_testing_facility_surface_1d",

		"nav_enviro_testing_facility_surface_2a",
		"nav_enviro_testing_facility_surface_2b",
		"nav_enviro_testing_facility_surface_2c",
		"nav_enviro_testing_facility_surface_2d",

		"nav_enviro_testing_facility_surface_3a",
		"nav_enviro_testing_facility_surface_3b",
		"nav_enviro_testing_facility_surface_3c",
		"nav_enviro_testing_facility_surface_3d",

		"nav_enviro_testing_facility_surface_4a",
		"nav_enviro_testing_facility_surface_4b",
		"nav_enviro_testing_facility_surface_4c",
		"nav_enviro_testing_facility_surface_4d",

		"nav_enviro_testing_facility_surface_5a",
		"nav_enviro_testing_facility_surface_5b",
		"nav_enviro_testing_facility_surface_5c",
		"nav_enviro_testing_facility_surface_5d",
	)

/obj/effect/overmap/visitable/sector/enviro_testing_facility/generate_ground_survey_result()
	..()
	if(prob(50))
		ground_survey_result += "<br>Evidence of lava tubes being present in the subsurface"
	if(prob(50))
		ground_survey_result += "<br>Water ice pockets detected deep underground"
	if(prob(50))
		ground_survey_result += "<br>No geothermal activity observed in the planetary core"
	if(prob(50))
		ground_survey_result += "<br>Micro-textural analysis indicates availability of fissile material"
	if(prob(50))
		ground_survey_result += "<br>Surface soil may provide adequate radiation shielding"
	if(prob(50))
		ground_survey_result += "<br>Silicon carbides found deep in the crust"
	if(prob(50))
		ground_survey_result += "<br>Oxygen found in locally stable metal oxides"
	if(prob(40))
		ground_survey_result += "<br>Regolith rich in heavy silicate alloys"
	if(prob(30))
		ground_survey_result += "<br>Relatively high abundance of fusile material, accumulated on the surface by the solar wind"
	if(prob(10))
		ground_survey_result += "<br>Traces of fusile material"
	if(prob(10))
		ground_survey_result += "<br>Carbon nanotubes naturally found in the regolith"

// --------------------------------------------------- misc

/obj/machinery/computer/security/terminal/enviro_testing_facility
	network = list("Env-Test Facility Zoya")

/obj/machinery/camera/network/enviro_testing_facility
	network = list("Env-Test Facility Zoya")

/obj/item/research_slip/enviro_testing_facility
	icon_state = "slip_generic"
	origin_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 4, TECH_DATA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 6)

/obj/effect/map_effect/door_helper/access_req/enviro_testing_facility/control
	req_access = /datum/access/enviro_testing_facility_access_control::id

/obj/effect/map_effect/door_helper/access_req/enviro_testing_facility/medres
	req_access = /datum/access/enviro_testing_facility_access_medres::id

/obj/effect/map_effect/door_helper/access_req/enviro_testing_facility/engops
	req_access = /datum/access/enviro_testing_facility_access_engops::id

/obj/effect/map_effect/door_helper/access_req/enviro_testing_facility/sec
	req_access = /datum/access/enviro_testing_facility_access_sec::id
