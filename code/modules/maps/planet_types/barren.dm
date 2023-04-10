/obj/effect/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#ad9c9c"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/barren)
	map_generators = list()
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/abandoned_mining,
		/datum/map_template/ruin/exoplanet/hideout,
		/datum/map_template/ruin/exoplanet/crashed_shuttle_01,
		/datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01,
		/datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01,
		/datum/map_template/ruin/exoplanet/mystery_ship_1,
		/datum/map_template/ruin/exoplanet/crashed_satelite,
		/datum/map_template/ruin/exoplanet/abandoned_listening_post,
		/datum/map_template/ruin/exoplanet/crashed_escape_pod_1,
		/datum/map_template/ruin/exoplanet/digsite,
		/datum/map_template/ruin/exoplanet/crashed_pod,
		/datum/map_template/ruin/exoplanet/crashed_coc_skipjack,
		/datum/map_template/ruin/exoplanet/drill_site)

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

/datum/random_map/noise/exoplanet/barren/asteroid
	descriptor = "asteroid exoplanet"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/ash
	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/hostile/carp/asteroid, /mob/living/simple_animal/hostile/carp/bloater, /mob/living/simple_animal/hostile/carp/shark/reaver,
					/mob/living/simple_animal/hostile/carp/shark/reaver/eel, /mob/living/simple_animal/hostile/gnat)
