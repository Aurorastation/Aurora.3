/datum/exoplanet_theme/volcanic
	name = "Volcanic"
	surface_turfs = list(
		/turf/simulated/mineral/lava
	)

	perlin_zoom = 21
	mountain_threshold = 0.6

	heat_levels = list(
		BIOME_POLAR = 0.3,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/lava
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/barren/asteroid/basalt
		)
	)
