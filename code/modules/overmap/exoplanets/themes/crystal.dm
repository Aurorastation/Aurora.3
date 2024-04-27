/datum/exoplanet_theme/crystal
	name = "Crystalline"
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)

	perlin_zoom = 21
	mountain_threshold = 0.5

	heat_levels = list(
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

	possible_biomes = list(
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/crystal
		)
	)
