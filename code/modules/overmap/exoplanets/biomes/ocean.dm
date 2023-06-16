/singleton/biome/ocean
	turf_type = /turf/simulated/floor/exoplanet/water/shallow/ocean
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 6),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/bush/seaweed = 4,
			/obj/structure/flora/bush/kelp = 4
		),
		WILDLIFE = list(
			/mob/living/simple_animal/aquatic/fish = 3,
			/mob/living/simple_animal/aquatic/fish/gupper = 2,
			/mob/living/simple_animal/aquatic/fish/cod = 1,
		)
	)

/singleton/biome/ocean/island
	generators = list(
		PLANET_TURF = list(HEIGHT_MOD, 0.95),
		SMALL_FLORA = list(POISSON_SAMPLE, 1)
	)
	exclusive_generators = list(PLANET_TURF)
	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/floor/exoplanet/coastal_sand = 3,
			/turf/simulated/mineral = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/rock/pile = 1,
			/obj/structure/flora/rock = 1
		),
	)
