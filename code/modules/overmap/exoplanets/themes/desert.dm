/datum/exoplanet_theme/desert
	name = "Desert"
	surface_turfs = list(
		/turf/simulated/mineral/planet
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/desert/scrub,
			BIOME_SEMIARID = /singleton/biome/desert/thorn,
			BIOME_SUBHUMID = /singleton/biome/desert/thorn,
			BIOME_HUMID = /singleton/biome/desert/scrub
			),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert/scrub,
			BIOME_SUBHUMID = /singleton/biome/desert/thorn,
			BIOME_HUMID = /singleton/biome/desert/thorn
			),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert,
			BIOME_SUBHUMID = /singleton/biome/desert/scrub,
			BIOME_HUMID = /singleton/biome/desert/thorn
			),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert,
			BIOME_SUBHUMID = /singleton/biome/desert,
			BIOME_HUMID = /singleton/biome/desert/scrub
			)
	)

	heat_levels = list(
		BIOME_POLAR = 0.1,
		BIOME_COOL = 0.3,
		BIOME_WARM = 0.5,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 0.6,
		BIOME_SEMIARID = 0.8,
		BIOME_SUBHUMID = 0.9,
		BIOME_HUMID = 1.0
	)

/datum/exoplanet_theme/desert/savannah
	name = "Savannah"

	humidity_levels = list(
		BIOME_ARID = 0.3,
		BIOME_SEMIARID = 0.6,
		BIOME_SUBHUMID = 0.8,
		BIOME_HUMID = 1.0
	)
