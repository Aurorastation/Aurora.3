/obj/effect/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#ad9c9c"
	scanimage = "barren.png"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/barren)
	map_generators = list()
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null
	ruin_planet_type = PLANET_BARREN
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

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

//asteroid

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid
	name = "mineral asteroid"
	desc = "A large, resource rich asteroid."
	massvolume = "Miniscule, not immediately apparent in mass"
	surfacegravity = "Miniscule, non-obstructive gravity well"
	surface_color = COLOR_GRAY
	scanimage = "asteroid.png"
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	ruin_planet_type = PLANET_ASTEROID
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

	place_near_main = list(1, 1)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/update_icon()
  icon_state = "asteroid[rand(1,3)]"

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
