
// --------------------------------- Konyang

/obj/effect/overmap/visitable/sector/exoplanet/konyang
	name = "Konyang"
	desc = "A Coalition world which was recently Solarian territory, now resting on the fringes of the northern Frontier. It possesses very humid weather and highly developed infrastructure, boasting a population in some billions."
	icon_state = "globe2"
	color = "#68e968"
	planetary_area = /area/exoplanet/grass/konyang
	initial_weather_state = /singleton/state/weather/rain/storm/jungle_planet
	scanimage = "konyang.png"
	massvolume = "0.89/0.99"
	surfacegravity = "0.93"
	charted = "Charted 2305, Sol Alliance Department of Colonization."
	geology = "Low-energy tectonic heat signature, minimal surface disruption"
	weather = "Global full-atmosphere hydrological weather system. Substantial meteorological activity, violent storms unpredictable"
	surfacewater = "Majority potable, 88% surface water. Significant tidal forces from natural satellite"
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	flora_diversity = 0
	has_trees = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list(
		/datum/map_template/ruin/exoplanet/konyang_landing_zone,
		/datum/map_template/ruin/exoplanet/konyang_jeweler_nest,
		/datum/map_template/ruin/exoplanet/konyang_village,
		/datum/map_template/ruin/exoplanet/konyang_telecomms_outpost,
		/datum/map_template/ruin/exoplanet/pirate_outpost,
		/datum/map_template/ruin/exoplanet/pirate_moonshine,
		/datum/map_template/ruin/exoplanet/hivebot_burrows_1,
		/datum/map_template/ruin/exoplanet/hivebot_burrows_2,
		/datum/map_template/ruin/exoplanet/konyang_fireoutpost,
		/datum/map_template/ruin/exoplanet/konyang_homestead,
		/datum/map_template/ruin/exoplanet/konyang_tribute,
		/datum/map_template/ruin/exoplanet/konyang_swamp_1,
		/datum/map_template/ruin/exoplanet/konyang_swamp_2,
		/datum/map_template/ruin/exoplanet/konyang_swamp_3,
		/datum/map_template/ruin/exoplanet/konyang_swamp_4,
		/datum/map_template/ruin/exoplanet/konyang_abandoned_outpost,
		/datum/map_template/ruin/exoplanet/konyang_abandoned_village,
		/datum/map_template/ruin/exoplanet/konyang_lostcop,
		/datum/map_template/ruin/exoplanet/rural_clinic
	)
	possible_themes = list(/datum/exoplanet_theme/konyang)
	place_near_main = list(1,0)
	var/landing_area

/obj/effect/overmap/visitable/sector/exoplanet/konyang/Initialize()
	. = ..()
	var/area/overmap/map = global.map_overmap
	for(var/obj/effect/overmap/visitable/sector/point_verdant/P in map)
		P.x = x
		P.y = y

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_map()
	lightlevel = 50
	..()

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "konyang")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/konyang/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		atmosphere.temperature = T20C
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/obj/effect/overmap/visitable/sector/exoplanet/konyang/pre_ruin_preparation()
	landing_area = pick("overgrown wilderness within the Yakusoku Jungle.", "abandoned infrastructure in Han'ei Industrial Park, discontinued.")
	switch(landing_area)
		if("overgrown wilderness within the Yakusoku Jungle.")
			possible_themes = list(/datum/exoplanet_theme/konyang)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_landing_zone, /datum/map_template/ruin/exoplanet/konyang_jeweler_nest, /datum/map_template/ruin/exoplanet/konyang_village, /datum/map_template/ruin/exoplanet/konyang_telecomms_outpost, /datum/map_template/ruin/exoplanet/pirate_outpost, /datum/map_template/ruin/exoplanet/pirate_moonshine, /datum/map_template/ruin/exoplanet/hivebot_burrows_1, /datum/map_template/ruin/exoplanet/hivebot_burrows_2, /datum/map_template/ruin/exoplanet/konyang_fireoutpost, /datum/map_template/ruin/exoplanet/konyang_homestead, /datum/map_template/ruin/exoplanet/konyang_tribute, /datum/map_template/ruin/exoplanet/konyang_swamp_1, /datum/map_template/ruin/exoplanet/konyang_swamp_2, /datum/map_template/ruin/exoplanet/konyang_swamp_3, /datum/map_template/ruin/exoplanet/konyang_swamp_4, /datum/map_template/ruin/exoplanet/konyang_abandoned_outpost, /datum/map_template/ruin/exoplanet/konyang_abandoned_village)

		if("abandoned infrastructure in Han'ei Industrial Park, discontinued.")
			possible_themes = list(/datum/exoplanet_theme/konyang/abandoned)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_abandoned_landing_zone, /datum/map_template/ruin/exoplanet/konyang_office, /datum/map_template/ruin/exoplanet/konyang_house_small, /datum/map_template/ruin/exoplanet/konyang_factory_robotics, /datum/map_template/ruin/exoplanet/konyang_factory_refinery, /datum/map_template/ruin/exoplanet/konyang_factory_arms, /datum/map_template/ruin/exoplanet/konyang_garage)

	desc += " Landing beacon details of [landing_area]"

// --------------------------------- Qixi

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi
	name = "Qixi"
	desc = "The small, lifeless, and largely insignificant moon of Konyang."
	icon_state = "globe1"
	color = "#a2b3ad"
	rock_colors = list("#807f7f")
	massvolume = "0.27/0.39"
	surfacegravity = "0.19"
	geology = "No tectonic activity detected."
	charted = "Natural satellite of Konyang. Charted 2305, Sol Alliance Department of Colonization."
	features_budget = 1
	surface_color = "#807f7f"
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	place_near_main = list(1, 1)
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/haneunim_mystery, /datum/map_template/ruin/exoplanet/haneunim_flag, /datum/map_template/ruin/exoplanet/haneunim_mining, /datum/map_template/ruin/exoplanet/haneunim_crash)

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/get_surface_color()
	return "#807f7f"

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- ice asteroid

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/haneunim
	desc = "An ice-covered rock from the outlying asteroid belt of Haneunim. Largely unexplored and uninhabited."
	ruin_planet_type = PLANET_LORE
	place_near_main = null
	generated_name = FALSE
	features_budget = 1
	ring_chance = 0
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/haneunim_crash, /datum/map_template/ruin/exoplanet/haneunim_refugees, /datum/map_template/ruin/exoplanet/haneunim_mystery, /datum/map_template/ruin/exoplanet/haneunim_mining)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/haneunim/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Huozhu

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu
	name = "Huozhu"
	desc = "A scorching dwarf planet close to Haneunim's star. Largely unexplored."
	icon_state = "globe1"
	massvolume = "0.39/0.56"
	surfacegravity = "0.32"
	charted = "Charted 2305, Sol Alliance Department of Colonization."
	ruin_planet_type = PLANET_LORE
	generated_name = FALSE
	features_budget = 1
	ring_chance = 0
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/haneunim_crash, /datum/map_template/ruin/exoplanet/haneunim_mystery)

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu/generate_atmosphere()
	..()
	atmosphere.remove_ratio(1)
	atmosphere.adjust_gas(GAS_SULFUR, MOLES_N2STANDARD)
	atmosphere.temperature = T20C + rand(600, 1000)
	atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Hwanung

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung
	name = "Hwanung"
	generated_name = FALSE
	desc = "A dwarf planet in the Haneunim system, largely considered insignificant."
	icon_state = "globe1"
	massvolume = "0.31/0.42"
	surfacegravity = "0.18"
	charted = "Charted 2305, Sol Alliance Department of Colonization."
	features_budget = 1
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	rock_colors = list(COLOR_GRAY80)
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/haneunim_crash, /datum/map_template/ruin/exoplanet/haneunim_refugees, /datum/map_template/ruin/exoplanet/haneunim_mystery, /datum/map_template/ruin/exoplanet/haneunim_flag, /datum/map_template/ruin/exoplanet/haneunim_mining)

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results
