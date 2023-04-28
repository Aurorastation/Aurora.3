/singleton/biome/jungle
	turf_type = /turf/simulated/floor/exoplanet/grass/grove
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 7),
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 4),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/jungle/small/random = 5,
			/obj/structure/flora/tree/jungle/random = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/jungle/large/random = 1,
			/obj/structure/flora/bush/jungle/random = 3,
			/obj/structure/flora/bush/jungle/b/random = 3,
			/obj/structure/flora/bush/jungle/c/random = 3
		),
		GRASSES = list(
			/obj/effect/floor_decal/junglegrass/random = 4,
			/obj/effect/floor_decal/junglegrass/dense/random = 2,
			/obj/effect/floor_decal/junglegrass/rocky/random = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 1,
			/mob/living/simple_animal/tindalos = 1
		)
	)
	exclusive_generators = list(LARGE_FLORA, SMALL_FLORA)

/singleton/biome/jungle/clearing
	// same as /jungle but without any blocking objs
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, -0.1, 360, 4),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/bush/jungle/random = 3,
			/obj/structure/flora/bush/jungle/b/random = 3,
			/obj/structure/flora/bush/jungle/c/random = 3
		),
		GRASSES = list(
			/obj/effect/floor_decal/junglegrass/random = 4,
			/obj/effect/floor_decal/junglegrass/dense/random = 2,
			/obj/effect/floor_decal/junglegrass/rocky/random = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 1,
			/mob/living/simple_animal/tindalos = 1
		)
	)

/singleton/biome/jungle/dense
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 2),
		GRASSES = list(ALWAYS_GEN),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
