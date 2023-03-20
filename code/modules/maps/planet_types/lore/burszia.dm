//Burzsia Prime or Burzsia I
/obj/effect/overmap/visitable/sector/exoplanet/barren/burzsiai
	name = "Burzsia I"
	desc = "The only planet within Burzsia, it is used as a junction for Hephaestus Industries' mineral extraction and refinery operations."
	color = "#ad9c9c"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 10
	generated_name = FALSE
	ring_chance = 0.0
	surface_color = "#807d7a"
	water_color = null
	place_near_main = list(8, 8)

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/hideout,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/crashed_coc_skipjack,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/barren/burzsiai/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/burzsiai/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/burzsiai/get_surface_color()
	return "#6C6251"

/datum/random_map/noise/exoplanet/barren
	descriptor = "Burszia I's surface"
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

//Burzsia Secondus or Burzsia II
/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaii
	name = "Burzsia II"
	desc = "A large, resource rich asteroid belt."
	surface_color = COLOR_GRAY
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	generated_name = FALSE
	place_near_main = list(5, 5)

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaii/update_icon()
  icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaii/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "Burszia II's surface"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash

//Burzsai IIa

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiia
	name = "Burzsia IIa"
	desc = "A medium, resource rich asteroid."
	surface_color = COLOR_GRAY
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	generated_name = FALSE
	place_near_main = list(3, 6)

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiia/update_icon()
  icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiia/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "Burszia IIa's surface"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash

//Burzsai IIb

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiib
	name = "Burzsia IIb"
	desc = "A small, resource rich asteroid."
	surface_color = COLOR_GRAY
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	generated_name = FALSE
	place_near_main = list(7, 6)

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiib/update_icon()
  icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiib/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "Burszia IIb's surface"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash

//Burzsai IIc

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiic
	name = "Burzsia IIc"
	desc = "A medium, resource rich asteroid."
	surface_color = COLOR_GRAY
	map_generators = list(/datum/random_map/noise/exoplanet/barren/asteroid, /datum/random_map/noise/ore/rich)
	rock_colors = list(COLOR_ASTEROID_ROCK)
	planetary_area = /area/exoplanet/barren/asteroid
	generated_name = FALSE
	place_near_main = list(4, 8)

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiic/update_icon()
  icon_state = "asteroid[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsiaiic/generate_planet_image()
	skybox_image = image('icons/skybox/skybox_rock_128.dmi', "bigrock")
	skybox_image.color = pick(rock_colors)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "Burszia IIc's surface"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash
