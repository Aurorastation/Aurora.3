/datum/exoplanet_theme/jungle
	// Welcome to the
	name = "Jungle"
	surface_turfs = list(
		/turf/simulated/mineral
	)
	mountain_threshold = 0.8
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/water,
			BIOME_SEMIARID = /singleton/biome/jungle/clearing,
			BIOME_SUBHUMID = /singleton/biome/jungle
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/jungle/clearing,
			BIOME_SEMIARID = /singleton/biome/jungle,
			BIOME_SUBHUMID = /singleton/biome/jungle/dense
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/jungle,
			BIOME_SEMIARID = /singleton/biome/jungle/dense,
			BIOME_SUBHUMID = /singleton/biome/jungle/dense
		)
	)

	heat_levels = list(
		BIOME_COOL = 0.3,
		BIOME_WARM = 0.6,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 0.3,
		BIOME_SEMIARID = 0.6,
		BIOME_SUBHUMID = 1.0
	)
