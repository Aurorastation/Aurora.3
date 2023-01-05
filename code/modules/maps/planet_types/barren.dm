/obj/effect/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#6c6c6c"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null
	possible_random_ruins = list(/datum/map_template/ruin/exoplanet/abandoned_mining, /datum/map_template/ruin/exoplanet/hideout, /datum/map_template/ruin/exoplanet/crashed_shuttle_01)

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/get_surface_color()
	return "#6C6251"

/datum/random_map/noise/exoplanet/barren
	descriptor = "barren exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/barren
	flora_prob = 0.1
	flora_diversity = 0
	fauna_prob = 0

/datum/random_map/noise/exoplanet/barren/New()
	if(prob(10))
		flora_diversity = 1
	..()

/turf/simulated/floor/exoplanet/barren
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/decals/decals.dmi', "asteroid[rand(0,9)]")

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/area/exoplanet/barren
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren

//asteroid

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid
	name = "mineral asteroid"
	desc = "A large, resource rich asteroid."
	surface_color = COLOR_GRAY
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	possible_random_ruins = list(/datum/map_template/ruin/exoplanet/abandoned_mining, /datum/map_template/ruin/exoplanet/carp_nest, /datum/map_template/ruin/exoplanet/hideout, /datum/map_template/ruin/exoplanet/crashed_shuttle_01)
	place_near_main = list(1, 1)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/romanovich
	name = "romanovich cloud asteroid"
	desc = "A phoron rich asteroid."
	possible_themes = list(/datum/exoplanet_theme/mountains/phoron)
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich/phoron)

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "asteroid exoplanet"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash