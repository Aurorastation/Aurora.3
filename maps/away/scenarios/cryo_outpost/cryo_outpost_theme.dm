
// ----------------- themes

/datum/exoplanet_theme/desert/cryo_outpost
	name = "Cryo Outpost"

	surface_color = "#5c5142"

/datum/exoplanet_theme/desert/cryo_outpost/mountain
	mountain_threshold = 0.0

/datum/exoplanet_theme/grass/cryo_outpost

	surface_color = "#5c5142"

	surface_turfs = list(
		/turf/simulated/floor/exoplanet/grass,
		/turf/simulated/mineral/planet
	)

	mountain_threshold = 0.9

	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/grass/chaparral,
			BIOME_SEMIARID = /singleton/biome/grass/forest,
			BIOME_SUBHUMID = /singleton/biome/grass/forest
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/grass/chaparral,
			BIOME_SEMIARID = /singleton/biome/grass/forest,
			BIOME_SUBHUMID = /singleton/biome/grass
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/grass,
			BIOME_SEMIARID = /singleton/biome/grass,
			BIOME_SUBHUMID = /singleton/biome/grass
		)
	)

	heat_levels = list(
		BIOME_COOL = 0.4,
		BIOME_WARM = 0.8,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 0.2,
		BIOME_SEMIARID = 0.5,
		BIOME_SUBHUMID = 1.0
	)

// ----------------- biomes
