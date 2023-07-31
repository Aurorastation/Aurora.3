/singleton/biome/marsh
	turf_type = /turf/simulated/floor/exoplanet/grass/marsh
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 15),
		GRASSES = list(BATCHED_NOISE, -0.1, 360, 16),
		SMALL_FLORA = list(POISSON_SAMPLE, 6),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(LARGE_FLORA)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/mushroom = 1
		),
		GRASSES = list(
			/obj/effect/floor_decal/fungus/random = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/mushroom = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 1,
			/mob/living/simple_animal/tindalos = 1,
			/mob/living/simple_animal/cosmozoan = 3,
		)
	)

/singleton/biome/marsh/forest
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, -0.3, 360, 16),
		SMALL_FLORA = list(POISSON_SAMPLE, 2),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
