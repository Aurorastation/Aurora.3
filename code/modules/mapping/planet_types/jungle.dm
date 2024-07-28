/obj/effect/overmap/visitable/sector/exoplanet/grass/grove
	name = "grove exoplanet"
	desc = "A temperate planet with abundant, peaceful flora and fauna."
	color = "#346934"
	scanimage = "grove.png"
	planetary_area = /area/exoplanet/grass/grove
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	grass_color = null
	plant_colors = null
	flora_diversity = 7
	has_trees = TRUE
	possible_themes = list(/datum/exoplanet_theme/jungle)
	initial_weather_state = /singleton/state/weather/rain/storm/jungle_planet
	ruin_planet_type = PLANET_GROVE
	ruin_allowed_tags = RUIN_LOWPOP|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/get_surface_color()
	return "#5C7F34"
