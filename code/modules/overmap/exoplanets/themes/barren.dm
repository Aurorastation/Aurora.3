/datum/exoplanet_theme/barren
	name = "Barren"
	surface_turfs = list(
		/turf/simulated/mineral,
		/turf/simulated/floor/exoplanet/barren
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/barren
			)
	)

	water_biome = null

	mountain_threshold = 0.7

	heat_levels = list(
		BIOME_POLAR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

	seed_flora = FALSE

/datum/exoplanet_theme/barren/asteroid
	name = "Asteroid"
	mountain_threshold = 0.5
	perlin_zoom = 21
	surface_turfs = list(
		/turf/simulated/mineral,
		/turf/unsimulated/floor/asteroid/ash
		)

	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/barren/asteroid
			)
	)

/datum/exoplanet_theme/barren/asteroid/phoron
	name = "Romanovich Asteroid"
	ore_levels = list(
		ORE_PLATINUM 	= 0.9,
		ORE_DIAMOND 	= 0.97,
		ORE_PHORON		= 0.85,
		ORE_URANIUM 	= 0.85,
		ORE_GOLD 		= 0.85,
		ORE_SILVER 		= 0.85,
		ORE_COAL 		= 0.6,
		ORE_IRON 		= 0.5,
	)
