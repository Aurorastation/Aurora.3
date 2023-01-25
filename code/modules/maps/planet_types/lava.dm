/obj/effect/overmap/visitable/sector/exoplanet/lava
	name = "lava exoplanet"
	desc = "An exoplanet with a lot of volcanic activity."
	color = "#575d5e"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/lava, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 4
	surface_color = "#575d5e"
	water_color = null

	possible_random_ruins = list(
		/datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01,
		/datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01,
		/datum/map_template/ruin/exoplanet/mystery_ship_1,
		/datum/map_template/ruin/exoplanet/drill_site)

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/lava/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/lava/get_surface_color()
	return "#575d5e"

/datum/random_map/noise/exoplanet/lava
	descriptor = "lava exoplanet"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/basalt
	water_type = /turf/simulated/lava
	water_level_min = 3
	water_level_max = 5
	flora_prob = 0
	flora_diversity = 0
	fauna_prob = 0

/area/exoplanet/lava
	name = "\improper Planetary surface"
	ambience = AMBIENCE_LAVA
	base_turf = /turf/unsimulated/floor/asteroid/basalt