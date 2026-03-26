
// --------------------------------- Assunzione

/obj/effect/overmap/visitable/sector/exoplanet/assunzione
	name = "Assunzione"
	desc = "space italy w star that got mysteriously offed CHANGEME"
	icon_state = "globe2"
	color = "#990099"
	planetary_area = /area/exoplanet/assunzione
	initial_weather_state = /singleton/state/weather/calm
	scanimage = "assunzione.png"
	massvolume = "0.96-1.01"
	surfacegravity = "0.97"
	charted = "Charted 2203CE, Sol Alliance Department of Colonization."
	alignment = "Coalition of Colonies"
	geology = "Low-energy tectonic heat signature, minimal surface disruption"
	weather = "Negligible. Lack of solar convective heating, collapse of the water cycle, and ~200 years of thermal equalization has reduced atmospheric activity to effective total stillness, disrupted only by marginal wind drift imparted by Coriolis force."
	surfacewater = "All surface water is frozen; majority exists in the former oceans, while the remainder is ice deposition over landmass following the 2274 stellar collapse."
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	flora_diversity = 0
	has_trees = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list()
	possible_themes = list(/datum/exoplanet_theme/snow/assunzione)
	place_near_main = list(1,0)
	var/landing_area

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/Initialize()
	. = ..()
	var/area/overmap/map = GLOB.map_overmap
	for(var/obj/effect/overmap/visitable/sector/port_volturno/P in map)
		P.x = x
		P.y = y

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_map()
	lightlevel = 0
	..()

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "assunzione")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		// hey at least 97% of the the atmosphere hasn't condensed to a liquid yet!
		atmosphere.temperature = 103
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/*
// Maaaaaaybe
/obj/effect/overmap/visitable/sector/exoplanet/assunzione/pre_ruin_preparation()
	landing_area = pick("overgrown wilderness within the Yakusoku Jungle.", "abandoned infrastructure in Han'ei Industrial Park, discontinued.")
	switch(landing_area)
		if("overgrown wilderness within the Yakusoku Jungle.")
			possible_themes = list(/datum/exoplanet_theme/assunzione)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_landing_zone, /datum/map_template/ruin/exoplanet/konyang_jeweler_nest, /datum/map_template/ruin/exoplanet/konyang_village, /datum/map_template/ruin/exoplanet/konyang_telecomms_outpost, /datum/map_template/ruin/exoplanet/pirate_outpost, /datum/map_template/ruin/exoplanet/pirate_moonshine, /datum/map_template/ruin/exoplanet/hivebot_burrows_1, /datum/map_template/ruin/exoplanet/hivebot_burrows_2, /datum/map_template/ruin/exoplanet/konyang_fireoutpost, /datum/map_template/ruin/exoplanet/konyang_homestead, /datum/map_template/ruin/exoplanet/konyang_tribute, /datum/map_template/ruin/exoplanet/konyang_swamp_1, /datum/map_template/ruin/exoplanet/konyang_swamp_2, /datum/map_template/ruin/exoplanet/konyang_swamp_3, /datum/map_template/ruin/exoplanet/konyang_swamp_4, /datum/map_template/ruin/exoplanet/konyang_abandoned_outpost, /datum/map_template/ruin/exoplanet/konyang_abandoned_village)

		if("abandoned infrastructure in Han'ei Industrial Park, discontinued.")
			possible_themes = list(/datum/exoplanet_theme/konyang/abandoned)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_abandoned_landing_zone, /datum/map_template/ruin/exoplanet/konyang_office, /datum/map_template/ruin/exoplanet/konyang_house_small, /datum/map_template/ruin/exoplanet/konyang_factory_robotics, /datum/map_template/ruin/exoplanet/konyang_factory_refinery, /datum/map_template/ruin/exoplanet/konyang_factory_arms, /datum/map_template/ruin/exoplanet/konyang_garage)

	desc += " Landing beacon details of [landing_area]"
*/
