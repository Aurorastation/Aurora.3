
// Xanu Prime

/obj/effect/overmap/visitable/sector/exoplanet/xanu
	name = "Xanu Prime"
	desc = ""
	icon_state = "globe2"
	color = "#7c945c"
	planetary_area = /area/exoplanet/grass/xanu
	initial_weather_state = /singleton/state/weather/calm
	has_water_weather = TRUE
	massvolume = "~1.05"
	surfacegravity = "1.07"
	charted = "Charted 2156, Sol Alliance Department of Colonization."
	alignment = "Coalition of Colonies"
	geology = "4 major continents exhibiting typical tectonic activty. Abundance of cratering detected on surface"
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
	ruin_type_whitelist = null
	place_near_main = list(1,0)
	var/landing_region

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_map()
	lightlevel = 50
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
				if("Naya Khyber Wilderness")
					atmosphere.temperature = T0C + 28
				if("Himavatia Wounds")
					atmosphere.temperature = T0C - 4

		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/xanu/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/obj/effect/overmap/visitable/sector/exoplanet/xanu/pre_ruin_preparation()
	if(prob(1))
		landing_region = "Naya Khyber Wilderness"
	else
		landing_region = "Himavatia Wounds"
	switch(landing_region)
		if("Naya Khyber Wilderness")
			possible_themes = list(/datum/exoplanet_theme/grass)
			surface_color = "#7c945c"

			ruin_type_whitelist = null

		if("Himavatia Wounds")
			possible_themes = list(/datum/exoplanet_theme/snow/tundra)
			surface_color = "#d0fac5"
			set_weather(/singleton/state/weather/calm/arctic_planet)

			ruin_type_whitelist = null

	desc += " The landing sites are located in the [landing_region]."
