/obj/effect/overmap/visitable/sector/exoplanet/lava
	name = "lava exoplanet"
	desc = "An exoplanet with a lot of volcanic activity."
	color = "#575d5e"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/lava, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 3
	surface_color = "#575d5e"
	water_color = null

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