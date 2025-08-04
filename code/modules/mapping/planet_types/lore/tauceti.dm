// --------------------------------- Caprice

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice
	name = "Caprice"
	desc = "A scorching-hot volcanic planet close to Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	alignment = "Federal Republic of Biesel"
	icon_state = "globe1"
	color = "#cf1020"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice/generate_ground_survey_result()
	ground_survey_result = "<br>Natural caverns and artificial tunnels"

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.temperature = T0C + 400
		atmosphere.update_values()

// --------------------------------- Luthien

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien
	name = "Luthien"
	desc = "A desert planet with a thin, unbreathable atmosphere of primarily nitrogen."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	rock_colors = list("#e49135")
	color = "#e49135"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/luthien/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien/generate_ground_survey_result()
	ground_survey_result = "<br>Sandy soil with organic fungal contamination"

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.update_values()

// --------------------------------- Valkyrie

/obj/effect/overmap/visitable/sector/exoplanet/barren/valkyrie
	name = "Valkyrie"
	desc = "The moon of Tau Ceti, the third planet to be settled in the system."
	charted = "Natural satellite of Tau Ceti, charted 2147CE, Sol Alliance Department of Colonization."
	alignment = "Federal Republic of Biesel"
	icon_state = "globe1"
	rock_colors = list("#4a3f41")
	color = "#4a3f41"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/valkyrie/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/valkyrie/generate_ground_survey_result()
	ground_survey_result = "<br>Soil with presence of nitrogen deposits"

// --------------------------------- New Gibson

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson
	name = "New Gibson"
	desc = "An ice world just outside the outer edge of the habitable zone."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	alignment = "Federal Republic of Biesel"
	icon_state = "globe1"
	features_budget = 1
	possible_themes = list(/datum/exoplanet_theme/snow/tundra)
	rock_colors = list(COLOR_GUNMETAL)
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/gibson_mining, /datum/map_template/ruin/exoplanet/gibson_resupply)

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/generate_ground_survey_result()
	ground_survey_result = "<br>Mineral-rich soil with presence of artificial structures"

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.temperature = T0C - 200
		atmosphere.update_values()

// --------------------------------- Chandras

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras
	name = "Chandras"
	desc = "An an icy body in a distant orbit of Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	color = "#b2abbf"
	rock_colors = list("#b2abbf")
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/generate_ground_survey_result()
	ground_survey_result = "<br>Soil with presence of nitrogen and ice deposits"

// --------------------------------- Dumas

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas
	name = "Dumas"
	desc = "An extremely small rocky body that orbits within the far reaches of Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "asteroid"
	generated_name = FALSE
	ring_chance = 0
	place_near_main = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas/generate_ground_survey_result()
	ground_survey_result = "<br>No notable deposits underground"

// --------------------------------- Biesel
/obj/effect/overmap/visitable/sector/exoplanet/biesel
	name = "Biesel"
	desc = "The third closest planet to Tau Ceti's star, Biesel is an Earth-like planet that benefits from a temperate climate and breathable atmosphere. It is the capital planet of the Republic of Biesel."
	alignment = "Federal Republic of Biesel"
	icon_state = "globe2"
	color = "#5B8958"
	planetary_area = /area/exoplanet/grass
	scanimage = "biesel.png"
	massvolume = "0.95~/1.1"
	surfacegravity = "0.99"
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	geology = "Low-energy tectonic heat signature, minimal surface disruption"
	weather = "Global full-atmosphere hydrological weather system."
	surfacewater = "Majority potable, 75% surface water. Significant tidal forces from natural satellite"
	rock_colors = list(COLOR_BROWN)
	flora_diversity = 0
	possible_themes = list(/datum/exoplanet_theme/grass/biesel)
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list(
		/datum/map_template/ruin/exoplanet/abandoned_warehouse_1,
		/datum/map_template/ruin/exoplanet/abandoned_warehouse_2,
		/datum/map_template/ruin/exoplanet/biesel_camp_site,
		/datum/map_template/ruin/exoplanet/cargo_ruins_1,
		/datum/map_template/ruin/exoplanet/cargo_ruins_2,
		/datum/map_template/ruin/exoplanet/cargo_ruins_3,
		/datum/map_template/ruin/exoplanet/pra_camp_site)
	place_near_main = list(2, 2)

/obj/effect/overmap/visitable/sector/exoplanet/biesel/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/biesel/generate_map()
	if(prob(75))
		lightlevel = rand(5,10)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/biesel/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "biesel")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/biesel/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		atmosphere.temperature = T20C
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/biesel/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/biesel/generate_ground_survey_result()
	ground_survey_result = "Notable mineral deposits located underground"
