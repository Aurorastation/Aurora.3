/obj/effect/overmap/visitable/sector/exoplanet/crystal
	name = "crystalline exoplanet"
	desc = "A near-airless world whose surface is encrusted with various crystalline minerals."
	color = "#6ba7f7"
	scanimage = "barren.png"
	geology = "Exceptional silica content compared to baseline; minimal tectonic activity present"
	planetary_area = /area/exoplanet/crystal
	rock_colors = list(COLOR_BLUE_GRAY, COLOR_PALE_BLUE_GRAY)
	possible_themes = list(/datum/exoplanet_theme/crystal)
	features_budget = 6
	surface_color = null
	water_color = null
	ruin_planet_type = PLANET_CRYSTAL
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/sector/exoplanet/crystal/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/crystal/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/crystal/get_surface_color()
	return "#6ba7f7"

/obj/effect/overmap/visitable/sector/exoplanet/crystal/generate_ground_survey_result()
	..()
	if(prob(50))
		ground_survey_result += "<br>Crystal mush detected in deep crust"
	if(prob(50))
		ground_survey_result += "<br>Natural silica aerogels predicted to be found in subterranean pockets"
	if(prob(50))
		ground_survey_result += "<br>Planetary core contains volatiles, maintaining stability due to high pressure"
	if(prob(50))
		ground_survey_result += "<br>Micro-textural analysis indicates porous crystals in shallow crust"
	if(prob(50))
		ground_survey_result += "<br>Superconductors in crystalline form present in the crust"
	if(prob(50))
		ground_survey_result += "<br>Silicon carbides found deep in the crust"
	if(prob(50))
		ground_survey_result += "<br>High content of refractory materials"
	if(prob(10))
		ground_survey_result += "<br>Traces of fusile material"
