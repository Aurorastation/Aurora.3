/obj/effect/overmap/visitable/sector/exoplanet/lava
	name = "lava exoplanet"
	desc = "An exoplanet with an excess of volcanic activity."
	color = "#575d5e"
	scanimage = "lava.png"
	geology = "Extreme, surface-apparent tectonic activity. Unreadable high-energy geothermal readings. Surface traversal demands caution"
	weather = "Global sub-atmospheric volcanic ambient weather system. Exercise extreme caution with unpredictable volcanic eruption"
	surfacewater = "Majority superheated methane, silicon and metallic substances, 7% liquid surface area."
	planetary_area = /area/exoplanet/lava
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/volcanic)
	features_budget = 4
	surface_color = "#cf1020"
	water_color = null
	ruin_planet_type = PLANET_LAVA
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_atmosphere()
	..()
	atmosphere.temperature = T20C + rand(220, 800)
	atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/lava/get_surface_color()
	return "#575d5e"
