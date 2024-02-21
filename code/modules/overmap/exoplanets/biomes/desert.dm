/singleton/biome/desert
	turf_type = /turf/simulated/floor/exoplanet/desert
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 7),
		LARGE_FLORA = list(POISSON_SAMPLE, 7),
		WILDLIFE = list(POISSON_SAMPLE, 25)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/rock/desert = 3,
			/obj/structure/flora/rock/desert/scrub = 2,
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		),
		LARGE_FLORA = list(
			/obj/effect/floor_decal/dune/random = 3,
			/obj/structure/flora/tree/desert/tiny = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/thinbug = 2,
			/mob/living/simple_animal/tindalos = 1
		)
	)

/singleton/biome/desert/scrub
	generators = list(
		GRASSES = list(BATCHED_NOISE, -0.1, 360, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		LARGE_FLORA = list(POISSON_SAMPLE, 7),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		GRASSES = list(
			/obj/structure/flora/grass/desert/bush = 1,
			/obj/structure/flora/grass/desert = 3
		),
		SMALL_FLORA = list(
			/obj/structure/flora/rock/desert = 1,
			/obj/structure/flora/rock/desert/scrub = 3,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		LARGE_FLORA = list(
			/obj/structure/flora/tree/desert/tiny = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/thinbug = 2,
			/mob/living/simple_animal/tindalos = 1
		)
	)

/singleton/biome/desert/thorn
	turf_type = /turf/simulated/floor/exoplanet/desert/rough
	generators = list(
		GRASSES = list(ALWAYS_GEN),
		SMALL_FLORA = list(POISSON_SAMPLE, 8),
		LARGE_FLORA = list(POISSON_SAMPLE, 4),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
	spawn_types = list(
		GRASSES = list(
			/obj/structure/flora/grass/desert/bush = 3,
			/obj/structure/flora/grass/desert = 2
		),
		SMALL_FLORA = list(
			/obj/structure/flora/rock/desert = 1,
			/obj/structure/flora/rock/desert/scrub = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		LARGE_FLORA = list(
			/obj/structure/flora/tree/desert/tiny = 4,
			/obj/structure/flora/tree/desert/small = 2,
			/obj/structure/flora/tree/desert = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/thinbug = 2,
			/mob/living/simple_animal/tindalos = 1
		)
	)
