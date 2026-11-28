/singleton/biome/crystal
	turf_type = /turf/simulated/floor/exoplanet/crystal
	generators = list(
		GRASSES = list(BATCHED_NOISE, -0.1, 360, 16),
		LARGE_FLORA = list(POISSON_SAMPLE, 12),
		WILDLIFE = list(POISSON_SAMPLE, 12)
	)
	spawn_types = list(
		GRASSES = list(
			/obj/effect/floor_decal/crystal/random = 1
		),
		LARGE_FLORA = list(
			/obj/structure/flora/rock/spire = 1,
			/obj/structure/flora/tree/crystal = 1
		),
		WILDLIFE = list(
			list(
				/mob/living/simple_animal/cosmozoan = 1
			) = 90,
			list(
				/mob/living/simple_animal/hostile/psiren = 6,
				/mob/living/simple_animal/hostile/psiren/ranged = 6,
				/mob/living/simple_animal/hostile/psiren/omen = 3,
				/mob/living/simple_animal/hostile/psiren/omen/beckoner = 1
			) = 10
		)
	)

/singleton/biome/crystal/mountain
	turf_type = /turf/simulated/mineral/crystal
