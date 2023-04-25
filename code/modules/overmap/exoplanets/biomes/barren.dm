/singleton/biome/barren
	turf_type = /turf/simulated/floor/exoplanet/barren

/singleton/biome/barren/asteroid
	turf_type = /turf/unsimulated/floor/asteroid/ash
	spawn_types = list(
		WILDLIFE = list(
			/mob/living/simple_animal/hostile/gnat = 5,
			/mob/living/simple_animal/hostile/carp/asteroid = 3,
			/mob/living/simple_animal/hostile/carp/bloater = 1,
			/mob/living/simple_animal/hostile/carp/shark/reaver = 1,
			/mob/living/simple_animal/hostile/carp/shark/reaver/eel = 1
		)
	)

/singleton/biome/barren/raskara
	turf_type = /turf/simulated/floor/exoplanet/barren/raskara
	generators = list()
	spawn_types = list()
