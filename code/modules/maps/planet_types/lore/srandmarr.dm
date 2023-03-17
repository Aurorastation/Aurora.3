//Ae'themir
/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir
	name = "Ae'themir"
	desc = "A planet comprised mainly of solid common minerals and silicate."
	color = "#bf7c39"
	icon_state = "globe1"
	rock_colors = list(COLOR_GRAY80)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 1
	surface_color = "#B1A69B"
	generated_name = FALSE
	ring_chance = 0
	possible_random_ruins = list (/datum/map_template/ruin/exoplanet/pra_exploration_drone)

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/get_surface_color()
	return "#B1A69B"

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/update_icon()
	return

//Az'Mar
/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar
	name = "Az'Mar"
	desc = "A small planet with a caustic shale crust. The surface is extremely hot and dense."
	color = "#8f4754"
	icon_state = "globe2"
	rock_colors = null
	plant_colors = null
	rock_colors = list("#4a3f41")
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 1
	surface_color = "#4a3f41"
	generated_name = FALSE
	ring_chance = 0
	possible_random_ruins = list (/datum/map_template/ruin/exoplanet/pra_exploration_drone)

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/get_surface_color()
	return "#4a3f41"

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/get_atmosphere_color()
	return "#D8E2E9"

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.adjust_gas(GAS_CHLORINE, MOLES_O2STANDARD)
		atmosphere.temperature = T0C + 500
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/update_icon()
	return

//Sahul
/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul
	name = "Sahul"
	desc = "Az'mar's moon is a celestial body composed primarily of molten metals."
	icon_state = "globe1"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul/update_icon()
	return

//Raskara
/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara
	name = "Raskara"
	desc = "A barren moon orbiting Adhomai."
	icon_state = "globe1"
	color = "#ab46d4"
	rock_colors = list("#373737")
	planetary_area = /area/exoplanet/barren/raskara
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren/raskara, /datum/random_map/noise/ore)
	features_budget = 1
	surface_color = "#373737"
	generated_name = FALSE
	ring_chance = 0
	possible_random_ruins = list (/datum/map_template/ruin/exoplanet/raskara_ritual, /datum/map_template/ruin/exoplanet/raskara_okon, /datum/map_template/ruin/exoplanet/raskara_wreck, /datum/map_template/ruin/exoplanet/pra_exploration_drone)
	place_near_main = list(3, 3)

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/get_surface_color()
	return "#373737"

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "raskara")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)

/datum/random_map/noise/exoplanet/barren/raskara
	land_type = /turf/simulated/floor/exoplanet/barren/raskara

/turf/simulated/floor/exoplanet/barren/raskara
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	color = "#373737"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()

/area/exoplanet/barren/raskara
	name = "Raskara Surface"
	ambience = AMBIENCE_OTHERWORLDLY
	base_turf = /turf/simulated/floor/exoplanet/barren/raskara

//Adhomai
/obj/effect/overmap/visitable/sector/exoplanet/adhomai
	name = "Adhomai"
	desc = "The Tajaran homeworld. Adhomai is a cold and icy world, suffering from almost perpetual snowfall and extremely low temperatures."
	icon_state = "globe2"
	color = "#b5dfeb"
	planetary_area = /area/exoplanet/adhomai
	rock_colors = null
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/mountains/adhomai)
	map_generators = list(/datum/random_map/noise/exoplanet/snow/adhomai, /datum/random_map/noise/ore/rich)
	features_budget = 8
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	generated_name = FALSE
	possible_random_ruins = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
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
			possible_random_ruins = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout, /datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_abandoned_labor_camp,
			/datum/map_template/ruin/exoplanet/psis_outpost, /datum/map_template/ruin/exoplanet/pra_base, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue, /datum/map_template/ruin/exoplanet/pra_mining_camp, /datum/map_template/ruin/exoplanet/adhomai_nuclear_waste,
			/datum/map_template/ruin/exoplanet/adhomai_fallout_bunker, /datum/map_template/ruin/exoplanet/adhomai_schlorrgo_cage, /datum/map_template/ruin/exoplanet/adhomai_silo)

		if("Democratic People's Republic of Adhomai")
			possible_random_ruins = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout, /datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_amohdan,
			/datum/map_template/ruin/exoplanet/ala_cell, /datum/map_template/ruin/exoplanet/adhomai_chemical_testing, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue_toppled, /datum/map_template/ruin/exoplanet/ala_base,
			/datum/map_template/ruin/exoplanet/adhomai_deserter, /datum/map_template/ruin/exoplanet/adhomai_nuclear_waste_makeshift, /datum/map_template/ruin/exoplanet/adhomai_rredouane_shrine)

		if("New Kingdom of Adhomai")
			possible_random_ruins = list (/datum/map_template/ruin/exoplanet/adhomai_hunting, /datum/map_template/ruin/exoplanet/adhomai_minefield, /datum/map_template/ruin/exoplanet/adhomai_village,
			/datum/map_template/ruin/exoplanet/adhomai_abandoned_village, /datum/map_template/ruin/exoplanet/adhomai_battlefield, /datum/map_template/ruin/exoplanet/adhomai_cavern, /datum/map_template/ruin/exoplanet/adhomai_raskara_ritual,
			/datum/map_template/ruin/exoplanet/adhomai_bar, /datum/map_template/ruin/exoplanet/adhomai_war_memorial, /datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout,/datum/map_template/ruin/exoplanet/adhomai_cavern_geist,
			/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest, /datum/map_template/ruin/exoplanet/adhomai_rafama_herd, /datum/map_template/ruin/exoplanet/adhomai_amohdan, /datum/map_template/ruin/exoplanet/adhomai_archeology,
			/datum/map_template/ruin/exoplanet/nka_base, /datum/map_template/ruin/exoplanet/adhomai_president_hadii_statue_toppled, /datum/map_template/ruin/exoplanet/adhomai_rredouane_shrine)

		if("North Pole")
			features_budget = 1
			map_generators = list(/datum/random_map/noise/exoplanet/snow/adhomai_north_pole, /datum/random_map/noise/ore/rich)
			possible_random_ruins = list (/datum/map_template/ruin/exoplanet/north_pole_monolith, /datum/map_template/ruin/exoplanet/north_pole_nka_expedition, /datum/map_template/ruin/exoplanet/north_pole_worm)

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
		if(landing_faction == "North Pole")
			atmosphere.temperature = T0C - 40
		else
			atmosphere.temperature = T0C - 5
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/update_icon()
	return

/datum/random_map/noise/exoplanet/snow/adhomai
	descriptor = "Adhomai"
	smoothing_iterations = 1
	flora_prob = 5
	water_level_max = 2
	land_type = /turf/simulated/floor/exoplanet/snow
	water_type = /turf/simulated/floor/exoplanet/ice
	fauna_types = list(/mob/living/simple_animal/ice_tunneler, /mob/living/simple_animal/ice_tunneler/male, /mob/living/simple_animal/fatshouter, /mob/living/simple_animal/fatshouter/male,
					/mob/living/simple_animal/hostile/retaliate/rafama, /mob/living/simple_animal/hostile/retaliate/rafama/male, /mob/living/simple_animal/hostile/retaliate/rafama/baby,
					/mob/living/simple_animal/hostile/wind_devil, /mob/living/carbon/human/farwa/adhomai, /mob/living/simple_animal/hostile/harron)

/datum/random_map/noise/exoplanet/snow/adhomai/generate_flora()
	for(var/i = 1 to flora_diversity)
		var/seed_chosen = pick("shand", "mtear", "earthenroot", "nifberries", "nfrihi", "nmshaan")
		var/datum/seed/chosen_seed = SSplants.seeds[seed_chosen]

		small_flora_types += chosen_seed

/datum/random_map/noise/exoplanet/snow/adhomai/get_additional_spawns(var/value, var/turf/T)
	..()
	if(istype(T, water_type))
		return
	if(T.density)
		return
	var/val = min(10,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(10))
				new /obj/structure/flora/rock/ice(T)
		if(3)
			if(prob(50))
				new /obj/structure/flora/grass/adhomai(T)
		if(4)
			if(prob(50))
				new /obj/structure/flora/bush/adhomai(T)
		if(5)
			if(prob(15))
				new /obj/structure/flora/tree/adhomai(T)
		if(6)
			if(prob(15))
				new /obj/structure/flora/rock/adhomai(T)
		if(7)
			if(prob(15))
				new /obj/effect/floor_decal/snowdrift(T)
		if(8)
			if(prob(10))
				new /obj/effect/floor_decal/snowdrift/large(T)

/datum/random_map/noise/exoplanet/snow/adhomai_north_pole
	descriptor = "Adhomai North pole"
	smoothing_iterations = 1
	flora_prob = 0
	water_level_max = 4
	land_type = /turf/simulated/floor/exoplanet/snow
	water_type = /turf/simulated/floor/exoplanet/ice/dark
	fauna_types = list(/mob/living/simple_animal/scavenger, /mob/living/simple_animal/ice_catcher, /mob/living/simple_animal/hostile/plasmageist, /mob/living/simple_animal/hostile/wriggler)

/datum/random_map/noise/exoplanet/snow/adhomai_north_pole/generate_flora()
	return

/datum/random_map/noise/exoplanet/snow/adhomai_north_pole/get_additional_spawns(var/value, var/turf/T)
	..()
	if(istype(T, water_type))
		return
	if(T.density)
		return
	var/val = min(10,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(25))
				new /obj/structure/flora/rock/ice(T)
		if(3)
			if(prob(10))
				new /obj/structure/geyser(T)
		if(4)
			if(prob(20))
				new /obj/structure/flora/rock/adhomai(T)
		if(5)
			if(prob(15))
				new /obj/effect/floor_decal/snowdrift(T)
		if(6)
			if(prob(10))
				new /obj/effect/floor_decal/snowdrift/large(T)

/area/exoplanet/adhomai
	name = "Adhomian Wilderness"
	ambience = list('sound/effects/wind/tundra0.ogg', 'sound/effects/wind/tundra1.ogg', 'sound/effects/wind/tundra2.ogg', 'sound/effects/wind/spooky0.ogg', 'sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai

/turf/simulated/floor/exoplanet/mineral/adhomai
	name = "icy rock"
	icon = 'icons/turf/flooring/ice_cavern.dmi'
	icon_state = "icy_rock"
	temperature = T0C - 5
	has_edge_icon = FALSE

/turf/simulated/floor/exoplanet/mineral/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "icy_rock[rand(1,19)]"

