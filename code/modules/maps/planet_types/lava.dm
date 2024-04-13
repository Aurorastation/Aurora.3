/obj/effect/overmap/visitable/sector/exoplanet/lava
	name = "lava exoplanet"
	desc = "An exoplanet with an excess of volcanic activity."
	color = "#575d5e"
	scanimage = "lava.png"
	geology = "Extreme, surface-apparent tectonic activity. Unreadable high-energy geothermal readings. Surface traversal demands caution"
	weather = "Global sub-atmospheric volcanic ambient weather system. Exercise extreme caution with unpredictable volcanic eruption"
	surfacewater = "Majority superheated methane, silicon and metallic substances, 7% liquid surface area."
	planetary_area = /area/exoplanet/lava
	initial_weather_state = /singleton/state/weather/calm/lava_planet
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/volcanic)
	features_budget = 4
	surface_color = "#cf1020"
	water_color = null
	ruin_planet_type = PLANET_LAVA
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	unit_test_groups = list(1)

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_atmosphere()
	..()
	atmosphere.temperature = T20C + rand(220, 800)
	atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/lava/get_surface_color()
	return "#575d5e"

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_ground_survey_result()
	..()
	if(prob(50))
		ground_survey_result += "<br>High sulfide content of the shallow rock bed"
	if(prob(50))
		ground_survey_result += "<br>Pockets of saturated hydrocarbons in deep crust"
	if(prob(50))
		ground_survey_result += "<br>Planetary core contains volatiles, maintaining stability due to high pressure"
	if(prob(50))
		ground_survey_result += "<br>Silica alloy superconductors found in stability in the lava"
	if(prob(50))
		ground_survey_result += "<br>Analysis indicates heavy metals of low impurity, high possibility of easy extraction"
	if(prob(50))
		ground_survey_result += "<br>Traces of precious metals scattered in the crust"
	if(prob(20))
		ground_survey_result += "<br>High entropy alloys detected in deep crust"
	if(prob(30))
		ground_survey_result += "<br>Traces of fusile material"
	if(prob(40))
		ground_survey_result += "<br>High content of fissile material in the rock"
