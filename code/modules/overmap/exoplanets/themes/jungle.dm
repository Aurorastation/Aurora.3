/datum/exoplanet_theme/jungle
	// Welcome to the
	name = "Jungle"
	surface_turfs = list(
		/turf/simulated/mineral/planet
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

/datum/exoplanet_theme/konyang
	name = "Konyang"
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 0.6
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang/clearing,
			BIOME_SUBHUMID = /singleton/biome/konyang/clearing
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang/clearing,
			BIOME_SUBHUMID = /singleton/biome/konyang
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/konyang/clearing,
			BIOME_SEMIARID = /singleton/biome/konyang,
			BIOME_SUBHUMID = /singleton/biome/konyang
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

/datum/exoplanet_theme/konyang/uncharted
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 0.8
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang,
			BIOME_SUBHUMID = /singleton/biome/konyang
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/konyang,
			BIOME_SEMIARID = /singleton/biome/konyang/clearing,
			BIOME_SUBHUMID = /singleton/biome/konyang
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/konyang,
			BIOME_SEMIARID = /singleton/biome/konyang,
			BIOME_SUBHUMID = /singleton/biome/konyang
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

/datum/exoplanet_theme/konyang/ocean
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 1
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang/water/ocean,
			BIOME_SUBHUMID = /singleton/biome/konyang/water/ocean
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang/water,
			BIOME_SUBHUMID = /singleton/biome/konyang/water/ocean
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/konyang/water/ocean,
			BIOME_SEMIARID = /singleton/biome/konyang/water,
			BIOME_SUBHUMID = /singleton/biome/konyang/water
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

/datum/exoplanet_theme/konyang/underground//more cave biomes TBD
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 0.35
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/konyang/caves,
			BIOME_SEMIARID = /singleton/biome/konyang/caves,
			BIOME_SUBHUMID = /singleton/biome/konyang/caves
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/konyang/caves,
			BIOME_SEMIARID = /singleton/biome/konyang/caves,
			BIOME_SUBHUMID = /singleton/biome/konyang/caves
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/konyang/caves,
			BIOME_SEMIARID = /singleton/biome/konyang/caves,
			BIOME_SUBHUMID = /singleton/biome/konyang/caves
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


/datum/exoplanet_theme/konyang/abandoned
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 0.8
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/konyang/water,
			BIOME_SEMIARID = /singleton/biome/konyang,
			BIOME_SUBHUMID = /singleton/biome/konyang/abandoned
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/konyang/abandoned,
			BIOME_SEMIARID = /singleton/biome/konyang/clearing,
			BIOME_SUBHUMID = /singleton/biome/konyang
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/konyang,
			BIOME_SEMIARID = /singleton/biome/konyang/abandoned,
			BIOME_SUBHUMID = /singleton/biome/konyang/abandoned
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
