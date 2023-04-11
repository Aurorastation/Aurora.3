/datum/exoplanet_theme/arid
	name = "Arid"
	surface_turfs = list(
		/turf/simulated/mineral
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/arid/scrub,
			BIOME_SEMIARID = /singleton/biome/arid/thorn,
			BIOME_SUBHUMID = /singleton/biome/arid/thorn,
			BIOME_HUMID = /singleton/biome/arid/scrub
			),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/arid,
			BIOME_SEMIARID = /singleton/biome/arid/scrub,
			BIOME_SUBHUMID = /singleton/biome/arid/thorn,
			BIOME_HUMID = /singleton/biome/arid/thorn
			),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/arid,
			BIOME_SEMIARID = /singleton/biome/arid,
			BIOME_SUBHUMID = /singleton/biome/arid/scrub,
			BIOME_HUMID = /singleton/biome/arid/thorn
			),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/arid,
			BIOME_SEMIARID = /singleton/biome/arid,
			BIOME_SUBHUMID = /singleton/biome/arid,
			BIOME_HUMID = /singleton/biome/arid/scrub
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
