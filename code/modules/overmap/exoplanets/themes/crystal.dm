/datum/exoplanet_theme/crystal
	name = "Crystalline"

	surface_turfs = list(
		/turf/simulated/mineral/crystal
	)
	surface_color = "#6fb1b5"

	perlin_zoom = 21

	mountain_threshold = 0.5
	mountain_biome = /singleton/biome/crystal/mountain

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

/datum/exoplanet_theme/crystal/mountain
	mountain_threshold = 0.0
