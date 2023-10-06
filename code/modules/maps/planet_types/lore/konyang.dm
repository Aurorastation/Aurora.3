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
	features_budget = 8
	surface_color = null//pre colored
	water_color = null//pre colored
	rock_colors = null//pre colored
	plant_colors = null//pre colored
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = null
	possible_themes = null
	place_near_main = list(1,0)
	var/landing_theme
	var/landing_details

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_map()
	lightlevel = 50
	..()

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "konyang")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/konyang/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/konyang/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		atmosphere.temperature = T20C
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/konyang/pre_ruin_preparation()
	landing_theme = pick("settled jungles", "uncharted jungles", "subterranean cavities", "open sea", "abandoned infrastructure")
	switch(landing_theme)
		if("settled jungles")
			possible_themes = list(/datum/exoplanet_theme/konyang)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_landing_zone)
			landing_details = " Charts indicate potential native habitats in proximity. Permissable landing zones include a Conglomerate-operated shuttle outpost."

		if("uncharted jungles")
			possible_themes = list(/datum/exoplanet_theme/konyang/uncharted)
			ruin_type_whitelist = list (null)
			landing_details = " No existing infrastructure is in place to support landing. Permissable landing zone is expected to be a natural clearing."

		if("subterranean cavities")
			possible_themes = list(/datum/exoplanet_theme/konyang/underground)
			lightlevel = 0
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_caves_landing_zone)
			landing_details = " Existing Conglomerate-operated infrastructure allows for unassisted landing. Permissable landing zone is within subterranean Conglomerate-operated shuttle pad."

		if("open sea")
			possible_themes = list(/datum/exoplanet_theme/konyang/ocean)
			ruin_type_whitelist = list (/datum/map_template/ruin/exoplanet/konyang_naval_landing_zone)
			landing_details = " Existing Conglomerate-operated infrastructure allows for unassisted landing. Permissable landing zone is expected to be a surface-bouyant naval shuttle pad."

		if("abandoned infrastructure")
			possible_themes = list(/datum/exoplanet_theme/konyang/abandoned)
			ruin_type_whitelist = list (null)
			landing_details = " Existing derelict infrastructure allows for unassisted landing. Permissable landing zone is expected to be a paved untagged pad."

	desc += " Designated landing zones provide generic survey descriptor of [landing_theme]. [landing_details]"
