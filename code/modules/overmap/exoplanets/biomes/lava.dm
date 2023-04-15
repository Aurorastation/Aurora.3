/singleton/biome/lava
	turf_type = /turf/simulated/lava

/singleton/biome/barren/asteroid/basalt
	turf_type = /turf/unsimulated/floor/asteroid/basalt
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 9),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/rock/random = 1,
			/obj/structure/flora/rock/pile/random = 2
		),
		WILDLIFE = list(
			/mob/living/simple_animal/hostile/gnat = 5,
			/mob/living/simple_animal/hostile/carp/asteroid = 3,
			/mob/living/simple_animal/hostile/carp/bloater = 1,
			/mob/living/simple_animal/hostile/carp/shark/reaver = 1,
			/mob/living/simple_animal/hostile/carp/shark/reaver/eel = 1
		)
	)
