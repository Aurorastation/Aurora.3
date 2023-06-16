/obj/effect/overmap/visitable/sector/exoplanet/ocean
	name = "ocean exoplanet"
	desc = "An exoplanet almost entirely covered by liquid water."
	color = "#53a4ca"
	scanimage = "ocean.png"
	geology = "High-energy geothermal signature, tectonic activity non-obstructive to surface environment. Volatile global tidal readings"
	weather = "Global full-atmosphere hydrological weather system. Dangerous meteorological activity present across equatorial regions"
	surfacewater = "99-100% surface water, majority readings not visibly potable. Expected mineral toxicity or salt presence in water bodies"
	planetary_area = /area/exoplanet/ocean
	rock_colors = list(COLOR_ASTEROID_ROCK, COLOR_BROWN)
	plant_colors = null//looks satanic otherwise
	possible_themes = list(/datum/exoplanet_theme/ocean)
	ruin_planet_type = PLANET_OCEAN

/obj/effect/overmap/visitable/sector/exoplanet/ocean/generate_map()
	lightlevel = 100
	..()

/obj/effect/overmap/visitable/sector/exoplanet/ocean/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.adjust_gas(MOLES_O2STANDARD)
		atmosphere.temperature = T20C + rand(10, 30)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/ocean/get_surface_color()
	return water_color

