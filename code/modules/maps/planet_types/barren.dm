/obj/effect/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#ad9c9c"
	scanimage = "barren.png"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/barren)
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null
	ruin_planet_type = PLANET_BARREN
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/get_surface_color()
	return "#6C6251"
