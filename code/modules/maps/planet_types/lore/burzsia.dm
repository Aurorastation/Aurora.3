//burzsia
/obj/effect/overmap/visitable/sector/exoplanet/burzsia
	name = "Burzsia"
	desc = "The Tajaran homeworld. Adhomai is a cold and icy world, suffering from almost perpetual snowfall and extremely low temperatures."
	icon_state = "globe2"
	color = "#b5dfeb"
	planetary_area = /area/exoplanet/barren/burzsia
	scanimage = "adhomai.png"
	massvolume = "0.86/0.98"
	surfacegravity = "0.80"
	charted = "Tajaran homeworld, charted 2418CE, NanoTrasen Corporation"
	geology = "Minimal tectonic heat, miniscule geothermal signature overall"
	weather = "Global full-atmosphere hydrological weather system. Substantial meteorological activity, violent storms unpredictable"
	surfacewater = "Majority frozen, 78% surface water. Significant tidal forces from natural satellite"
	rock_colors = list(COLOR_DARK_BROWN)
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/barren)
	features_budget = 8
	surface_color = "#b7410e"
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
//	ruin_type_whitelist = list ()
	place_near_main = list(2, 2)
	var/bright_side = TRUE

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/pre_ruin_preparation()
	if(prob(50))
		bright_side = FALSE

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/get_surface_color()
	return "#b7410e"

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/generate_atmosphere()
	..()
	atmosphere.remove_ratio(1)
	atmosphere.adjust_gas(GAS_CO2, MOLES_N2STANDARD)
	atmosphere.adjust_gas(GAS_NO2, MOLES_O2STANDARD)
	if(bright_side)
		atmosphere.temperature = T0C + 546
	else
		atmosphere.temperature = T0C - 113
	atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/generate_map()
	if(bright_side)
		lightlevel = 10
	else
		lightlevel = 0
	..()
