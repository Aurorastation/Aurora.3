/singleton/biome/snow/nuclear_silo
	turf_type = /turf/simulated/floor/exoplanet/snow
	generators = list(
		PLANET_TURF = list(BATCHED_NOISE, -0.2, 360, 16),
		GRASSES = list(BATCHED_NOISE, -0.4, 360, 4),
		LARGE_FLORA = list(POISSON_SAMPLE, 9),
		SMALL_FLORA = list(POISSON_SAMPLE, 6),
	)
	spawn_types = list(
		PLANET_TURF = list(/turf/simulated/floor/exoplanet/permafrost = 1),
		GRASSES = list(
			/obj/structure/flora/grass/both = 2,
			/obj/structure/flora/grass/green = 1,
			/obj/structure/flora/grass/brown = 1
		),
		LARGE_FLORA = list(
			/obj/effect/floor_decal/snowdrift/large/random = 4,
			/obj/structure/flora/rock/snow = 4,
			/obj/structure/flora/tree/dead = 2,
			/obj/structure/flora/tree/pine = 1,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush = 2,
			/obj/effect/floor_decal/snowrocks = 1,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		)
	)
	exclusive_generators = list(LARGE_FLORA)

/singleton/biome/snow/forest/nuclear_silo
	generators = list(
		GRASSES = list(BATCHED_NOISE, -0.4, 360, 4),
		LARGE_FLORA = list(POISSON_SAMPLE, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 2),
	)
	spawn_types = list(
		GRASSES = list(
			/obj/structure/flora/grass/both = 1,
			/obj/structure/flora/grass/green = 2,
			/obj/structure/flora/grass/brown = 1
		),
		LARGE_FLORA = list(
			/obj/structure/flora/rock/snow = 1,
			/obj/structure/flora/tree/dead = 2,
			/obj/structure/flora/tree/pine = 4,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 3
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush = 3,
			/obj/effect/floor_decal/snowrocks = 1,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 3
		)
	)

/datum/exoplanet_theme/snow/nuclear_silo
	name = "Boreal Forest"
	surface_turfs = list(
		/turf/simulated/mineral/planet
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
