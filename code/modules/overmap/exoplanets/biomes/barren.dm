/singleton/biome/barren
	turf_type = /turf/simulated/floor/exoplanet/barren
	generators = list(
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		WILDLIFE = list(
			list() = 95,
			list(
				/mob/living/simple_animal/hostile/psiren = 6,
				/mob/living/simple_animal/hostile/psiren/ranged = 6,
				/mob/living/simple_animal/hostile/psiren/omen = 3,
				/mob/living/simple_animal/hostile/psiren/omen/beckoner = 1
			) = 5
		)
	)

/singleton/biome/barren/asteroid
	turf_type = /turf/simulated/floor/exoplanet/asteroid/ash
	generators = list(
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		WILDLIFE = list(
			list(
				/mob/living/simple_animal/hostile/gnat = 5,
				/mob/living/simple_animal/hostile/carp/asteroid = 3,
				/mob/living/simple_animal/hostile/carp/bloater = 1,
				/mob/living/simple_animal/hostile/carp/shark/reaver = 1,
				/mob/living/simple_animal/hostile/carp/shark/reaver/eel = 1
			) = 85,
			list(
				/mob/living/simple_animal/hostile/psiren = 6,
				/mob/living/simple_animal/hostile/psiren/ranged = 6,
				/mob/living/simple_animal/hostile/psiren/omen = 3,
				/mob/living/simple_animal/hostile/psiren/omen/beckoner = 1
			) = 15
		)
	)

/singleton/biome/barren/raskara
	turf_type = /turf/simulated/floor/exoplanet/barren/raskara
	generators = list()
	spawn_types = list()

/singleton/biome/barren/asteroid/ice
	turf_type = /turf/simulated/floor/exoplanet/ice

/singleton/biome/barren/pid
	turf_type = /turf/simulated/floor/exoplanet/barren
	generators = list(SMALL_FLORA = list(POISSON_SAMPLE, 7))
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		)
	)
