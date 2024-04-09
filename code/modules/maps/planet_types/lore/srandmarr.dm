// --------------------------------- Ae'themir

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir
	name = "Ae'themir"
	desc = "A planet comprised mainly of solid common minerals and silicate."
	color = "#bf7c39"
	icon_state = "globe1"
	charted = "Tajaran core world, charted 2418CE, NanoTrasen Corporation"
	rock_colors = list(COLOR_GRAY80)
	features_budget = 1
	surface_color = "#B1A69B"
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/pra_exploration_drone)

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/get_surface_color()
	return "#B1A69B"

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Az'Mar

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar
	name = "Az'Mar"
	desc = "A small planet with a caustic shale crust. The surface is extremely hot and dense."
	charted = "Tajaran core world, charted 2418CE, NanoTrasen Corporation"
	color = "#8f4754"
	icon_state = "globe2"
	plant_colors = null
	rock_colors = list("#4a3f41")
	features_budget = 1
	surface_color = "#4a3f41"
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/pra_exploration_drone)

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/get_surface_color()
	return "#4a3f41"

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/get_atmosphere_color()
	return "#D8E2E9"

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_CHLORINE, MOLES_O2STANDARD)
		atmosphere.temperature = T0C + 500
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Sahul
/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul
	name = "Sahul"
	desc = "Az'mar's moon is a celestial body composed primarily of molten metals."
	charted = "Natural satellite of Az'mar, Tajaran core world, charted 2418CE, NanoTrasen Corporation"
	icon_state = "globe1"
	color = "#cf1020"
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/pra_exploration_drone)
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Raskara
/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara
	name = "Raskara"
	desc = "A barren moon orbiting Adhomai."
	icon_state = "globe1"
	color = "#ab46d4"
	rock_colors = list("#373737")
	planetary_area = /area/exoplanet/barren/raskara
	scanimage = "raskara.png"
	massvolume = "0.27/0.39"
	surfacegravity = "0.25"
	charted = "Natural satellite of Tajaran homeworld, charted 2418CE, NanoTrasen Corporation"
	geology = "Zero tectonic heat, completely dormant geothermal signature. Presumed dead core"
	possible_themes = list(/datum/exoplanet_theme/barren/raskara)
	features_budget = 1
	surface_color = "#373737"
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/raskara_ritual, /datum/map_template/ruin/exoplanet/raskara_okon, /datum/map_template/ruin/exoplanet/raskara_wreck, /datum/map_template/ruin/exoplanet/pra_exploration_drone)
	place_near_main = list(3, 3)

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/get_surface_color()
	return "#373737"

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "raskara")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Adhomai
/obj/effect/overmap/visitable/sector/exoplanet/adhomai
	name = "Adhomai"
	desc = "The Tajaran homeworld. Adhomai is a cold and icy world, suffering from almost perpetual snowfall and extremely low temperatures."
	icon_state = "globe2"
	color = "#b5dfeb"
	planetary_area = /area/exoplanet/adhomai
	initial_weather_state = /singleton/state/weather/calm/snow_planet
	scanimage = "adhomai.png"
	massvolume = "0.86/0.98"
	surfacegravity = "0.80"
	charted = "Tajaran homeworld, charted 2418CE, NanoTrasen Corporation"
	geology = "Minimal tectonic heat, miniscule geothermal signature overall"
	weather = "Global full-atmosphere hydrological weather system. Substantial meteorological activity, violent storms unpredictable"
	surfacewater = "Majority frozen, 78% surface water. Significant tidal forces from natural satellite"
	rock_colors = list("#6fb1b5")
	plant_colors = null
	flora_diversity = 0
	has_trees = FALSE
	possible_themes = list(/datum/exoplanet_theme/snow/adhomai)
	features_budget = 8
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	small_flora_types = list(/datum/seed/shand, /datum/seed/mtear, /datum/seed/earthenroot, /datum/seed/nifberries, /datum/seed/mushroom/nfrihi, /datum/seed/nmshaan)
	ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
	/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_bar,
	/datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout, /datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
	/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd)
	place_near_main = list(2, 2)
	var/landing_faction

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/pre_ruin_preparation()
	if(prob(15))
		landing_faction = "North Pole"
	else
		landing_faction = pick("People's Republic of Adhomai", "Democratic People's Republic of Adhomai", "New Kingdom of Adhomai")
	switch(landing_faction)
		if("People's Republic of Adhomai")
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout, /datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_abandoned_labor_camp,
			/datum/map_template/ruin/exoplanet/psis_outpost, /datum/map_template/ruin/exoplanet/pra_base, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue, /datum/map_template/ruin/exoplanet/pra_mining_camp, /datum/map_template/ruin/exoplanet/adhomai_nuclear_waste,
			/datum/map_template/ruin/exoplanet/adhomai_fallout_bunker, /datum/map_template/ruin/exoplanet/adhomai_schlorrgo_cage, /datum/map_template/ruin/exoplanet/adhomai_silo)

		if("Democratic People's Republic of Adhomai")
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout, /datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_amohdan,
			/datum/map_template/ruin/exoplanet/ala_cell, /datum/map_template/ruin/exoplanet/adhomai_chemical_testing, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue_toppled, /datum/map_template/ruin/exoplanet/ala_base,
			/datum/map_template/ruin/exoplanet/adhomai_deserter, /datum/map_template/ruin/exoplanet/adhomai_nuclear_waste_makeshift, /datum/map_template/ruin/exoplanet/adhomai_rredouane_shrine, /datum/map_template/ruin/exoplanet/adhomai_sole_rock_nomad)

		if("New Kingdom of Adhomai")
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout,/datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_amohdan, /datum/map_template/ruin/exoplanet/adhomai_archeology,
			/datum/map_template/ruin/exoplanet/nka_base, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue_toppled, /datum/map_template/ruin/exoplanet/adhomai_rredouane_shrine, /datum/map_template/ruin/exoplanet/adhomai_sole_rock_nomad)

		if("North Pole")
			features_budget = 1
			possible_themes = list(/datum/exoplanet_theme/snow/tundra/adhomai)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/north_pole_monolith, /datum/map_template/ruin/exoplanet/north_pole_nka_expedition, /datum/map_template/ruin/exoplanet/north_pole_worm)
			initial_weather_state = /singleton/state/weather/calm/arctic_planet

	desc += " The landing sites are located at the [landing_faction]'s territory."

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_map()
	if(prob(75))
		lightlevel = rand(3,10)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "adhomai")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		if(landing_faction == "North Pole")
			atmosphere.temperature = T0C - 40
		else
			atmosphere.temperature = T0C - 5
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results
