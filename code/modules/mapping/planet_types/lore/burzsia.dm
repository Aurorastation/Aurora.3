// --------------------------------- Burzsia I
/obj/effect/overmap/visitable/sector/exoplanet/burzsia
	name = "Burzsia I"
	desc = "An important Hephaestus Industries mining planet. Burzsia is inhospitable, toxic and dangerous to life."
	icon_state = "globe1"
	color = "#b7410e"
	planetary_area = /area/exoplanet/barren/burzsia
	scanimage = "adhomai.png"
	massvolume = "4.24/2.33"
	surfacegravity = "4.14"
	charted = "Charted 2199CE, Solarian Alliance"
	alignment = "Hephaestus Industries - Coalition of Colonies"
	geology = "Extreme volcanic activity with surface minerals in abundance"
	weather = "Tidally locked day/night split, extreme weather conditions with a toxic atmosphere and lightning storms"
	surfacewater = "No presence of water. Large bodies of liquid ammonia and molten metal"
	rock_colors = list(COLOR_DARK_BROWN)
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/barren)
	features_budget = 1
	surface_color = "#b7410e"
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/burzsia_mining, /datum/map_template/ruin/exoplanet/burzsia_dead_ipc)
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

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "burzsia")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/burzsia/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Burzsia II

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsia
	name = "Burzsia II"
	alignment = "Hephaestus Industries - Coalition of Colonies"
	generated_name = FALSE

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsia/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results
