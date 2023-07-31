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

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/get_surface_color()
	return "#6ba7f7"
