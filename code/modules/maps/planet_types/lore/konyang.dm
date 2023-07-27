/obj/effect/overmap/visitable/sector/exoplanet/konyang
	name = "Konyang"
	desc = "A Coalition world which was recently Solarian territory, now resting on the fringes of the northern Frontier. It possesses very humid weather and highly developed infrastructure, boasting a population in some billions."
	icon_state = "globe2"
	color = "#68e968"
	planetary_area = /area/exoplanet/grass/konyang
	scanimage = "konyang.png"
	massvolume = "0.89/0.99"
	surfacegravity = "0.93"
	charted = "Coalition world, initial Solarian colonization circa 2305"
	geology = "Low-energy tectonic heat signature, minimal surface disruption"
	weather = "Global full-atmosphere hydrological weather system. Substantial meteorological activity, violent storms unpredictable"
	surfacewater = "Majority potable, 88% surface water. Significant tidal forces from natural satellite"
	possible_themes = list(/datum/exoplanet_theme/konyang)
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = null
	place_near_main = list(0, 0)

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_map()
	lightlevel = 100
	..()

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "konyang")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/konyang/update_icon()
	return
