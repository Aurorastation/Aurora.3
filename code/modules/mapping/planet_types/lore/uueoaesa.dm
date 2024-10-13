//Omzoli
/obj/effect/overmap/visitable/sector/exoplanet/barren/omzoli
	name = "Omzoli"
	desc = "A small and barren planet, bereft of anything other than scientific value and some small mineral deposits"
	color = "#a39f9e"
	icon_state = "globe"
	rock_colors = list(COLOR_GRAY80)
	possible_themes = list(/datum/exoplanet_theme/barren)
	features_budget = 1
	surface_color = "#6b6464"
	generated_name = FALSE
	charted = "Unathi core world. Charted 2403CE, Sol Alliance Department of Colonization"
	geology = "Low mineral levels. No active geothermal signatures detected. "
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/izweski_probe, /datum/map_template/ruin/exoplanet/heph_survey_post, /datum/map_template/ruin/exoplanet/kazhkz_crash)

/obj/effect/overmap/visitable/sector/exoplanet/barren/omzoli/get_surface_color()
	return "#6b6464"

/obj/effect/overmap/visitable/sector/exoplanet/barren/omzoli/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/omzoli/generate_ground_survey_result()
	..()
	ground_survey_result += "<br>Trace mineral deposits detected in regolith"
	ground_survey_result += "<br>Planetary rotation counter to spin of local star and other planets in system"
	ground_survey_result += "<br>Carbon-dating indicates planetary age of at least 6.32 billion years"
	ground_survey_result += "<br>Lack of atmosphere and unusual rotation can cause extremely wild temperature fluctuations"
	ground_survey_result += "<br>High chance of meteor impact indicated through analysis of local surface craters"

//Pid
/obj/effect/overmap/visitable/sector/exoplanet/barren/pid
	name = "Pid"
	desc = "Tret's moon, now home to a majority of K'laxan k'ois farming efforts."
	icon_state = "asteroid"
	color = "#ddff61"
	rock_colors = list("#93948f")
	features_budget = 1
	surface_color = "#83857f"
	charted = "Natural satellite of Tret, Unathi core world. Charted 2403CE, Sol Alliance Department of Colonization"
	alignment = "Izweski Hegemony"
	generated_name = FALSE
	small_flora_types = list(/datum/seed/koisspore)
	possible_themes = list(/datum/exoplanet_theme/barren/pid)
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	planetary_area = /area/exoplanet/barren/pid
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/pid_crashed_shuttle, /datum/map_template/ruin/exoplanet/pid_kois_farm, /datum/map_template/ruin/exoplanet/izweski_probe, /datum/map_template/ruin/exoplanet/heph_survey_post, /datum/map_template/ruin/exoplanet/kazhkz_crash)

/obj/effect/overmap/visitable/sector/exoplanet/barren/pid/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
		atmosphere.temperature = T0C + 20
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/pid/generate_ground_survey_result()
	..()
	ground_survey_result += "<br>Trace elements of phoron and biological matter detected in local atmosphere"
	ground_survey_result += "<br>Small mineral deposits detected, largely untapped"
	ground_survey_result += "<br>Evidence of lava tubes being present in the subsurface"
	ground_survey_result += "<br>K'ois spores detected in local soil. Sample destruction recommended"
	ground_survey_result += "<br>Surface soil may provide adequate radiation shielding"


//Ytizi Belt Asteroid. This exists solely for unique away site spawns, and is otherwise indistinguishable from a regular asteroid
/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ytizi
	name = "Ytizi Belt asteroid"
	desc = "One of the many mineral-rich asteroids found in the Uueoa-Esa system's asteroid belt"
	icon_state = "asteroid2"
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid, /datum/exoplanet_theme/barren/asteroid/ice)
	ruin_planet_type = PLANET_LORE
	features_budget = 3
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/heph_mining_station, /datum/map_template/ruin/exoplanet/miners_guild_outpost, /datum/map_template/ruin/exoplanet/sol_listening_post, /datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01, /datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01, /datum/map_template/ruin/exoplanet/digsite, /datum/map_template/ruin/exoplanet/abandoned_outpost, /datum/map_template/ruin/exoplanet/izweski_probe, /datum/map_template/ruin/exoplanet/heph_survey_post, /datum/map_template/ruin/exoplanet/kazhkz_crash)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ytizi/pre_ruin_preparation()
	if(istype(theme, /datum/exoplanet_theme/barren/asteroid/ice))
		surface_color = COLOR_BLUE_GRAY
	else
		surface_color = COLOR_GRAY

//Chanterel
/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/chanterel
	name = "Chanterel"
	desc = "Moghes' only moon. Rich in minerals, it is home to several mining operations."
	icon_state = "asteroid"
	color = "#dddedc"
	possible_themes = list(/datum/exoplanet_theme/barren/asteroid/chanterel)
	rock_colors = list("#c9c9c7")
	features_budget = 3
	surface_color = "#a3a3a3"
	charted = "Natural satellite of Moghes, Unathi homeworld. Charted 2403CE, Sol Alliance Department of Colonization"
	geology = "Large mineral deposits. No sign of geothermal activity."
	generated_name = FALSE
	ring_chance = 0
	ruin_planet_type = PLANET_LORE
	place_near_main = list(2,2)
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/heph_mining_station, /datum/map_template/ruin/exoplanet/miners_guild_outpost, /datum/map_template/ruin/exoplanet/digsite, /datum/map_template/ruin/exoplanet/abandoned_outpost, /datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01, /datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01, /datum/map_template/ruin/exoplanet/izweski_probe, /datum/map_template/ruin/exoplanet/heph_survey_post, /datum/map_template/ruin/exoplanet/kazhkz_crash)
	scanimage = "chanterel.png"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/chanterel/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "chanterel")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/chanterel/generate_ground_survey_result()
	..()
	ground_survey_result += "<br>No geothermal activity observed in the planetary core"
	ground_survey_result += "<br>Silicon carbides found deep in the crust"
	ground_survey_result += "<br>Oxygen found in locally stable metal oxides"
	ground_survey_result += "<br>Regolith rich in heavy silicate alloys"
	ground_survey_result += "<br>Traces of fusile material"

//Moghes
/obj/effect/overmap/visitable/sector/exoplanet/moghes
	name = "Moghes"
	desc = "The hot and arid homeworld of the Unathi race, and capital world of the Izweski Hegemony. Moghes is currently suffering from an ongoing ecological collapse due to recent nuclear war."
	icon_state = "globe2"
	color = "#dfe08d"
	planetary_area = /area/exoplanet/moghes
	massvolume = "0.97/1.03"
	surfacegravity = "0.93"
	charted = "Unathi homeworld. Charted 2403CE, Sol Alliance Department of Colonization"
	alignment = "Izweski Hegemony"
	geology = "High tectonic heat. Significant geothermal activity detected."
	weather = "Global full-atmosphere hydrological weather system. Substantial meteorological activity, violent storms unpredictable. Heavy radioactive contamination detected in atmosphere."
	surfacewater = "34% surface water. Weak tidal forces from natural satellite."
	scanimage = "moghes.png"
	ring_chance = 0
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/grass/moghes) //default to untouched lands in case pre_ruin_preparation fucks up
	features_budget = 8
	flora_diversity = 0
	has_trees = FALSE
	initial_weather_state = /singleton/state/weather/calm/jungle_planet
	small_flora_types = list(/datum/seed/xuizi, /datum/seed/gukhe, /datum/seed/sarezhi, /datum/seed/flower/serkiflower, /datum/seed/sthberry)
	surface_color = "#e8faff"
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	ruin_type_whitelist = list(/datum/map_template/ruin/exoplanet/moghes_village) //defaults to village bc for some reason nothing spawns if this is empty
	place_near_main = list(2,2)
	actors = list("reptilian humanoid", "three-faced reptilian humanoid", "a statue", "a sword", "an unidentifiable object", "an Unathi skull", "a staff", "a fishing spear", "reptilian humanoids", "unusual devices", "a pyramid")
	var/landing_region

/obj/effect/overmap/visitable/sector/exoplanet/moghes/pre_ruin_preparation()
	if(prob(30))
		landing_region = "Untouched Lands"
	else
		landing_region = "Wasteland"
	switch(landing_region)
		if("Untouched Lands")
			possible_themes = list(/datum/exoplanet_theme/grass/moghes) //non-nuked theme
			surface_color = "#164a14"
			//Untouched Lands ruins
			ruin_type_whitelist = list(
			/datum/map_template/ruin/exoplanet/moghes_village,
			/datum/map_template/ruin/exoplanet/moghes_heph_mining,
			/datum/map_template/ruin/exoplanet/moghes_bar,
			/datum/map_template/ruin/exoplanet/moghes_hegemony_base,
			/datum/map_template/ruin/exoplanet/moghes_skakh,
			/datum/map_template/ruin/exoplanet/moghes_thakh,
			/datum/map_template/ruin/exoplanet/moghes_kung_fu,
			/datum/map_template/ruin/exoplanet/moghes_fishing_spot,
			/datum/map_template/ruin/exoplanet/moghes_memorial,
			/datum/map_template/ruin/exoplanet/moghes_guild_mining,
			/datum/map_template/ruin/exoplanet/moghes_threshbeast_herd,
			/datum/map_template/ruin/exoplanet/moghes_diona_traders,
			/datum/map_template/ruin/exoplanet/moghes_untouched_tyrant
		)

		if("Wasteland")
			possible_themes = list(/datum/exoplanet_theme/desert/wasteland) //nuked theme
			surface_color = "#faeac5"
			set_weather(/singleton/state/weather/calm/desert_planet)
			//Wasteland ruins
			ruin_type_whitelist = list(
				/datum/map_template/ruin/exoplanet/moghes_guwandi,
				/datum/map_template/ruin/exoplanet/moghes_gawgaryn_bikers,
				/datum/map_template/ruin/exoplanet/moghes_kataphract_wasteland,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_dorviza,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_ozeuoi,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_vihnmes,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_village,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_izweski,
				/datum/map_template/ruin/exoplanet/moghes_siakh,
				/datum/map_template/ruin/exoplanet/moghes_queendom,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_klax,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_reclaimer,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_mikuetz,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_crater,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_oasis,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_battlefield,
				/datum/map_template/ruin/exoplanet/moghes_ruined_base,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_tomb,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_bomb,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_crash,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_priests,
				/datum/map_template/ruin/exoplanet/moghes_dead_guwandi,
				/datum/map_template/ruin/exoplanet/moghes_gawgaryn_riders,
				/datum/map_template/ruin/exoplanet/moghes_wasteland_tyrant
			)

	desc += " The landing sites are located in the [landing_region]."

/obj/effect/overmap/visitable/sector/exoplanet/moghes/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/moghes/generate_map()
	if(prob(75))
		lightlevel = rand(5,10)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/moghes/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		if(landing_region == "Wasteland")
			atmosphere.temperature = T0C + rand(40, 50)
		else
			atmosphere.temperature = T0C + rand(30, 40)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/moghes/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/moghes/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "moghes")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/obj/effect/overmap/visitable/sector/exoplanet/moghes/generate_ground_survey_result()
	..()
	switch(landing_region)
		if("Untouched Lands")
			ground_survey_result += "<br>Low levels of radioactive material detected in the soil"
			ground_survey_result += "<br>Signs indicate soil is undergoing signs of early nutrient depletion"
			ground_survey_result += "<br>Stratigraphy indicates low risk of tectonic activity in this region"
			ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
			ground_survey_result += "<br>Soft clays detected, composed of quartz and calcites"
			ground_survey_result += "<br>Trace signs of radioactive contamination present in local surface water deposits"

		if("Wasteland")
			ground_survey_result += "<br>Extremely high levels of radioactive material detected in the soil"
			ground_survey_result += "<br>Soil near-completely depleted of nutrients."
			ground_survey_result += "<br>High concentration of decayed organic matter detected in soil samples"
			ground_survey_result += "<br>Fragmented concrete detected within local soil. High levels of radiation indicated"
			ground_survey_result += "<br>Geological analysis suggests there were once large bodies of water in this region"
			ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
			if(prob(10))
				ground_survey_result += "<br>Signs of a large subterranean aquifer in this region"


//Ouerea
/obj/effect/overmap/visitable/sector/exoplanet/ouerea
	name = "Ouerea"
	desc = "The fourth planet from the Uueoa-Esa star, Ouerea was the first planet colonized by the Unathi. It is now home to most of the Hegemony's food production, as ecological collapse devastated Moghes"
	icon_state = "globe1"
	color = "#0b9e68"
	planetary_area = /area/exoplanet/ouerea
	massvolume = "0.94/1.0"
	surfacegravity = "0.98"
	charted = "Unathi core world. Charted 2403CE, Sol Alliance Department of Colonization"
	alignment = "Izweski Hegemony"
	geology = "High-energy geothermal signature, tectonic activity non-obstructive to surface environment"
	weather = "Global full-atmosphere hydrological weather system. Dangerous meteorological activity not present"
	surfacewater = "67% surface water. Four major surface seas detected."
	rock_colors = null
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/grass/ouerea)
	features_budget = 6
	ring_chance = 0
	flora_diversity = 0
	has_trees = FALSE
	small_flora_types = list(/datum/seed/xuizi, /datum/seed/gukhe, /datum/seed/aghrassh)
	generated_name = FALSE
	ruin_planet_type = PLANET_LORE
	initial_weather_state = /singleton/state/weather/calm/jungle_planet
	ruin_type_whitelist = list(
		/datum/map_template/ruin/exoplanet/ouerea_heph_mining,
		/datum/map_template/ruin/exoplanet/ouerea_village,
		/datum/map_template/ruin/exoplanet/ouerea_bar, /datum/map_template/ruin/exoplanet/ouerea_autakh,
		/datum/map_template/ruin/exoplanet/ouerea_hegemony_base,
		/datum/map_template/ruin/exoplanet/ouerea_farm,
		/datum/map_template/ruin/exoplanet/ouerea_fishing_spot,
		/datum/map_template/ruin/exoplanet/ouerea_sol_base,
		/datum/map_template/ruin/exoplanet/ouerea_skrell_base,
		/datum/map_template/ruin/exoplanet/ouerea_guild_mining,
		/datum/map_template/ruin/exoplanet/ouerea_nt_ruin,
		/datum/map_template/ruin/exoplanet/ouerea_freewater,
		/datum/map_template/ruin/exoplanet/ouerea_battlefield,
		/datum/map_template/ruin/exoplanet/ouerea_threshbeast_herd
	)
	place_near_main = list(2,2)

/obj/effect/overmap/visitable/sector/exoplanet/ouerea/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/ouerea/generate_map()
	if(prob(75))
		lightlevel = rand(5,10)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/ouerea/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.remove_ratio(1)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
		atmosphere.temperature = T0C + rand(25, 30)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/ouerea/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/ouerea/generate_ground_survey_result()
	..()
	ground_survey_result += "<br>High quality natural fertilizer found in subterranean pockets"
	ground_survey_result += "<br>Chemical extraction indicates soil is rich in major and secondary nutrients for agriculture"
	ground_survey_result += "<br>Extensive subterranean water deposits detected"
	ground_survey_result += "<br>Stratigraphy indicates moderate risk of tectonic activity in this region"
	ground_survey_result += "<br>Muddy dirt rich in organic material"
	ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	ground_survey_result += "<br>High nitrogen and phosphorus contents of the soil"
