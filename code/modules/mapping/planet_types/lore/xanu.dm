
// Xanu Prime

/obj/effect/overmap/visitable/sector/exoplanet/xanu
	name = "Xanu Prime"
	desc = "The capital of the Coalition of Colonies. Xanu Prime is a geographically diverse, Earth-like world with varied biomes, ranging from equatorial rainforests and tropical deserts to boreal forests and polar continents. Sieged during the Interstellar War, the planet is scarred by battles and orbital bombardments of the past."
	icon_state = "globe2"
	scanimage = "xanu_prime.png"
	color = "#7c945c"
	planetary_area = /area/exoplanet/grass/xanu
	initial_weather_state = /singleton/state/weather/calm
	has_water_weather = TRUE
	massvolume = "~1.05"
	surfacegravity = "1.07"
	charted = "Charted 2156, Sol Alliance Department of Colonization."
	alignment = "Coalition of Colonies"
	geology = "4 major continents exhibiting typical seismic activty. Abundance of cratering detected on surface; flooded to form lakes."
	weather = "Global full-atmosphere hydrological weather system."
	surfacewater = "67% surface salt water"
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	flora_diversity = 0
	has_trees = FALSE
	ruin_planet_type = PLANET_LORE
	place_near_main = list(1,0)

	// Defaults, later set under pre_ruin_preparation
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/delivery_site, /datum/map_template/ruin/exoplanet/crashed_coc_skipjack)
	possible_themes = list(/datum/exoplanet_theme/grass/xanu_nayakhyber)
	surface_color = "#7c945c"
	var/landing_region = "grasslands and mountains of Naya Khyber"

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_map()
	lightlevel = rand(1,10)
	..()

/obj/effect/overmap/visitable/sector/exoplanet/xanu/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)

		if(landing_region)
			switch(landing_region)
				if("grasslands and mountains of Naya Khyber")
					atmosphere.temperature = T0C + rand(25,30)
				if("valleys and cliffs of Himavatia")
					atmosphere.temperature = T0C - rand(1,5)

		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_ground_survey_result()
	ground_survey_result = "<br><b>Notable Features:</b>"

	switch(landing_region)
		if("grasslands and mountains of Naya Khyber")
			ground_survey_result += "<br>Clay-loam soil with a dense, sticky texture; excellent retention of nutrients and water for agricultural purposes."
			ground_survey_result += "<br>Trace materials and signatures consistent with historical orbital bombardment: lead, uranium. Carbon-dated: ~220 years old."
			switch(rand(1,3))
				if(1)
					ground_survey_result += "<br>(!) Large mineral deposit of lithium in the form of spodumene. Inform local authority for reward."
				if(2)
					ground_survey_result += "<br>(!) Region displays above average retention of nutrients and water for agricultural purposes. Inform local authority for reward."
				if(3)
					ground_survey_result += "<br>(!) Region otherwise typical of Naya Khyber."
		if("valleys and cliffs of Himavatia")
			ground_survey_result += "<br>Permafrost with massive ice layer. Unable to sustain deep-rooted flora."
			ground_survey_result += "<br>Ground form consistent with high, historical glacial activity."
			switch(rand(1,2))
				if(1)
					ground_survey_result += "<br>(!) Large oil trap detected, containing significant crude oil deposit. Inform local authority for reward."
				if(2)
					ground_survey_result += "<br>(!) Region otherwise typical of Himavatia."

/obj/effect/overmap/visitable/sector/exoplanet/xanu/pre_ruin_preparation()
	if(prob(66))
		landing_region = "grasslands and mountains of Naya Khyber"
	else
		landing_region = "valleys and cliffs of Himavatia"

	desc += " The landing sites are located in the [landing_region]."

	switch(landing_region)
		if("grasslands and mountains of Naya Khyber")
			possible_themes = list(/datum/exoplanet_theme/grass/xanu_nayakhyber)
			surface_color = "#7c945c"

			ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/delivery_site, /datum/map_template/ruin/exoplanet/crashed_coc_skipjack)

			desc += " The local government only permits Scientific Sampling operations in this area; other operations are not permitted."

		if("valleys and cliffs of Himavatia")
			possible_themes = list(/datum/exoplanet_theme/snow/tundra/xanu_himavatia)
			surface_color = "#d0fac5"
			initial_weather_state = /singleton/state/weather/calm/arctic_planet

			ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/delivery_site, /datum/map_template/ruin/exoplanet/crashed_coc_skipjack)

			desc += " The local government only permits Scientific Sampling operations in this area; other operations are not permitted."
