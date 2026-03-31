
// --------------------------------- Assunzione

/obj/effect/overmap/visitable/sector/exoplanet/assunzione
	name = "Assunzione"
	desc = "A dark, frozen world blighted by the mysterious extinguishing of its star in 2274. Surface uninhabitable; significant (500+ mil) population resides in planetary network of biodomes. Both legal injunction and mass ice deposition makes mining here effectively impossible."
	icon_state = "globe1"
	color = "#b375ca"
	planetary_area = /area/exoplanet/assunzione
	initial_weather_state = /singleton/state/weather/calm
	scanimage = "assunzione.png"
	massvolume = "0.97-1.01"
	surfacegravity = "0.98"
	charted = "Charted 2243CE, Sol Alliance Department of Colonization."
	alignment = "Coalition of Colonies"
	geology = "Low tectonic heat signature, minimal surface disruption."
	weather = "Negligible. All atmospheric and hydrological activity collapsed; marginal wind drift imparted by Coriolis force present."
	surfacewater = "All surface water is frozen; majority exists in former oceans, while remainder is ice deposition over permafrost."
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	flora_diversity = 0
	has_trees = TRUE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list()
	possible_themes = list(/datum/exoplanet_theme/snow/assunzione)
	place_near_main = list(1,0)
	var/landing_area

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/Initialize()
	. = ..()
	var/area/overmap/map = GLOB.map_overmap
	for(var/obj/effect/overmap/visitable/sector/port_volturno/P in map)
		P.x = x
		P.y = y

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_map()
	lightlevel = 0
	..()

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "assunzione")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		// hey at least 97% of the the atmosphere hasn't condensed to a liquid yet!
		atmosphere.temperature = 103
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/assunzione/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results
