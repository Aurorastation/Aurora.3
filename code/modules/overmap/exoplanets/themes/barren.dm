/datum/exoplanet_theme/barren
	name = "Barren"
	surface_turfs = list(
		/turf/simulated/mineral/planet,
		/turf/simulated/floor/exoplanet/barren
	)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/barren
			)
	)

	mountain_threshold = 0.6

	heat_levels = list(
		BIOME_POLAR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

/datum/exoplanet_theme/barren/raskara
	name = "Raskara"
	surface_turfs = list(
		/turf/simulated/mineral/planet,
		/turf/simulated/floor/exoplanet/barren/raskara
	)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/barren/raskara
			)
	)

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

/datum/exoplanet_theme/barren/asteroid/ice
	name = "Ice Asteroid"
	surface_turfs = list(
		/turf/simulated/mineral/planet,
		/turf/simulated/floor/exoplanet/ice,
		/turf/simulated/floor/exoplanet/ice/dark
	)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/barren/asteroid/ice
			)
	)

/datum/exoplanet_theme/barren/asteroid/phoron
	name = "Romanovich Asteroid"
	wall_ore_levels = list(
		ORE_PHORON		= 0.7,
		ORE_PLATINUM 	= 0.6,
		ORE_DIAMOND 	= 0.6,
		ORE_URANIUM 	= 0.7,
		ORE_GOLD 		= 0.68,
		ORE_SILVER 		= 0.7,
		ORE_COAL 		= 0.9,
		ORE_IRON 		= 0.92,
	)
	ground_ore_levels = list(
		SURFACE_ORES = list(
			ORE_IRON = list(2, 4),
			ORE_GOLD = list(0, 2),
			ORE_SILVER = list(0, 2),
			ORE_URANIUM = list(0, 2)
		),
		RARE_ORES = list(
			ORE_GOLD = list(1, 3),
			ORE_SILVER = list(1, 3),
			ORE_URANIUM = list(1, 3),
			ORE_PLATINUM = list(1, 3),
			ORE_PHORON = list(0, 2)
		),
		DEEP_ORES = list(
			ORE_URANIUM = list(0, 2),
			ORE_DIAMOND = list(0, 2),
			ORE_PLATINUM = list(2, 4),
			ORE_HYDROGEN = list(1, 3),
			ORE_PHORON = list(0, 2)
		)
	)
