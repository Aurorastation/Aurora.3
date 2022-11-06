//Ae'themir
/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir
	name = "Ae'themir"
	desc = "A planet comprised mainly of solid common minerals and silicate."
	color = "#B1A69B"
	rock_colors = list(COLOR_GRAY80)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 2
	surface_color = "#B1A69B"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir/get_surface_color()
	return "#B1A69B"

//Az'Mar
/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar
	name = "Az'Mar"
	desc = "A small planet with a caustic shale crust. The surface is extremely hot and dense."
	color = "#B1A69B"
	rock_colors = list("#4a3f41")
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 2
	surface_color = "#4a3f41"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/get_surface_color()
	return "#4a3f41"

/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T0C + 500
		atmosphere.update_values()

//Sahul
/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul
	name = "lava exoplanet"
	desc = "Az'mar's moon is a celestial body composed primarily of molten metals."
	generated_name = FALSE
	ring_chance = 0

//Raskara
/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara
	name = "Raskara"
	desc = "A barren moon orbiting Adhomai."
	color = "#373737"
	rock_colors = list("#373737")
	planetary_area = /area/exoplanet/barren/raskara
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren/raskara, /datum/random_map/noise/ore)
	features_budget = 2
	surface_color = "#373737"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara/get_surface_color()
	return "#B1A69B"

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
	name = "\improper Raskara Surface"
	ambience = AMBIENCE_OTHERWORLDLY
	base_turf = /turf/simulated/floor/exoplanet/barren/raskara

//Adhomai
/obj/effect/overmap/visitable/sector/exoplanet/adhomai
	name = "Adhomai"
	desc = "The Tajaran homeworld. Adhomai is a cold and icy world, suffering from almost perpetual snowfall and extremely low temperatures."
	color = "#dcdcdc"
	planetary_area = /area/exoplanet/adhomai
	rock_colors = null
	plant_colors = null
	possible_themes = list(/datum/exoplanet_theme/mountains/adhomai)
	map_generators = list(/datum/random_map/noise/exoplanet/snow/adhomai, /datum/random_map/noise/ore)
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	generated_name = FALSE

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_map()
	if(prob(50))
		lightlevel = rand(1,7)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_planet_image()
	skybox_image = image('icons/skybox/lore_planets.dmi', "adhomai")

/obj/effect/overmap/visitable/sector/exoplanet/adhomai/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T0C - 5
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/snow/adhomai
	descriptor = "Adhomai"
	smoothing_iterations = 1
	flora_prob = 5
	water_level_max = 3
	land_type = /turf/simulated/floor/exoplanet/snow
	water_type = /turf/simulated/floor/exoplanet/ice
	fauna_types = list(/mob/living/simple_animal/ice_tunneler, /mob/living/simple_animal/fatshouter, /mob/living/simple_animal/hostile/retaliate/rafama)

/datum/random_map/noise/exoplanet/snow/adhomai/generate_flora()
	for(var/i = 1 to flora_diversity)
		var/seed_chosen = pick("shand", "mtear", "earthenroot", "nifberries", "nfrihi", "nmshaan")
		var/datum/seed/chosen_seed = SSplants.seeds[seed_chosen]

		small_flora_types += chosen_seed

/area/exoplanet/adhomai
	name = "Adhomian Wilderness"
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow

/turf/simulated/floor/exoplanet/mineral/adhomai
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	temperature = T0C - 5
