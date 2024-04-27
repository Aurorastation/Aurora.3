/obj/effect/overmap/visitable/sector/exoplanet/snow
	name = "snow exoplanet"
	desc = "A frigid exoplanet with limited plant life."
	color = "#dcdcdc"
	scanimage = "snow.png"
	geology = "Non-existent tectonic activity, minimal geothermal signature"
	weather = "Global full-atmosphere hydrological weather system. Barely-habitable ambient low temperatures. Frequently dangerous, unpredictable meteorological upsets"
	surfacewater = "Majority frozen, 70% surface water"
	initial_weather_state = /singleton/state/weather/calm/snow_planet
	planetary_area = /area/exoplanet/snow
	flora_diversity = 4
	has_trees = TRUE
	rock_colors = list(COLOR_DARK_BLUE_GRAY, COLOR_GUNMETAL, COLOR_GRAY80, COLOR_DARK_GRAY)
	plant_colors = list("#d0fef5","#93e1d8","#93e1d8", "#b2abbf", "#3590f3", "#4b4e6d")
	possible_themes = list(/datum/exoplanet_theme/snow)
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	ruin_planet_type = PLANET_SNOW
	ruin_allowed_tags = RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	unit_test_groups = list(2)

/obj/effect/overmap/visitable/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 0
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.cold_level_1) + rand(1,10)
		atmosphere.temperature = max(T0C - rand(10, 100), limit)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/snow/generate_ground_survey_result()
	..()
	if(prob(40))
		ground_survey_result += "<br>High quality natural fertilizer found in subterranean pockets"
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
	if(prob(40))
		ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	if(prob(10))
		ground_survey_result += "<br>Traces of fissile material"
	if(prob(50))
		ground_survey_result += "<br>Atmosphere micro-analysis detects high contents of aerogens stable in low temperature"

