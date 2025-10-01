/singleton/biome/snow/nuclear_silo
	turf_type = /turf/simulated/floor/ice/event5
	generators = list(
		PLANET_TURF = list(BATCHED_NOISE, -0.2, 360, 16),
	)
	spawn_types = list(
		PLANET_TURF = list(/turf/simulated/floor/ice/event5 = 1),
	)

/singleton/biome/snow/forest/nuclear_silo
	generators = list(	)
	spawn_types = list(
		GRASSES = list(),
		LARGE_FLORA = list(),
		SMALL_FLORA = list()
	)

/datum/exoplanet_theme/snow/nuclear_silo
	name = "Boreal Forest"
	surface_turfs = list(
		/turf/simulated/floor/ice/event5
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/snow/nuclear_silo,
			BIOME_SEMIARID = /singleton/biome/snow/nuclear_silo
			),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/snow/nuclear_silo,
			BIOME_SEMIARID = /singleton/biome/snow/forest/nuclear_silo
			)
	)

	heat_levels = list(
		BIOME_POLAR = 0.3,
		BIOME_COOL = 1.0,
	)

	humidity_levels = list(
		BIOME_ARID = 0.7,
		BIOME_SEMIARID = 1.0
	)
/datum/exoplanet_theme/snow/nuclear_silo/mountain
	mountain_threshold = 0.0

/datum/exoplanet_theme/snow/foothills/nuclear_silo
	name = "Foothills"
	heat_levels = list(
		BIOME_POLAR = 0.7,
		BIOME_COOL = 1.0
	)
	mountain_threshold = 0.6
