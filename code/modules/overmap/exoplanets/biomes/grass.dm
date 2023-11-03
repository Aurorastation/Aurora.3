/singleton/biome/grass
	turf_type = /turf/simulated/floor/exoplanet/grass/stalk
	generators = list(
		GRASS_1 = list(BATCHED_NOISE, -0.3, 360, 4),
		GRASS_2 = list(BATCHED_NOISE, -0.3, 360, 4),
		GRASS_3 = list(BATCHED_NOISE, -0.3, 360, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 6),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(GRASS_1, GRASS_2, GRASS_3)
	spawn_types = list(
		GRASS_1 = list(
			/obj/structure/flora/ausbushes/ywflowers = 1
		),
		GRASS_2 = list(
			/obj/structure/flora/ausbushes/brflowers = 1
		),
		GRASS_3 = list(
			/obj/structure/flora/ausbushes/ppflowers = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/ywflowers = 1,
			/obj/structure/flora/ausbushes/brflowers = 1,
			/obj/structure/flora/ausbushes/ppflowers = 1,
			/obj/structure/flora/ausbushes/grassybush = 1,
			/obj/structure/flora/ausbushes/palebush = 1,
			/obj/structure/flora/ausbushes = 1,
			/obj/structure/flora/ausbushes/fernybush = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)

/singleton/biome/grass/riverside
	generators = list(
		PLANET_TURF = list(HEIGHT_MOD, 0.95),
		SMALL_FLORA = list(POISSON_SAMPLE, 1),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(PLANET_TURF)
	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/floor/exoplanet/water/shallow = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/reedbush = 1,
			/obj/structure/flora/ausbushes/stalkybush = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/aquatic/fish/gupper = 1,
			/mob/living/simple_animal/aquatic/fish/cod = 1
		)
	)

/singleton/biome/grass/chaparral
	generators = list(
		GRASS_1 = list(BATCHED_NOISE, -0.4, 360, 4),
		GRASS_2 = list(BATCHED_NOISE, -0.4, 360, 4),
		GRASS_3 = list(BATCHED_NOISE, -0.4, 360, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 3),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(GRASS_1, GRASS_2, GRASS_3)
	spawn_types = list(
		GRASS_1 = list(
			/obj/structure/flora/ausbushes/ywflowers = 1
		),
		GRASS_2 = list(
			/obj/structure/flora/ausbushes/brflowers = 1
		),
		GRASS_3 = list(
			/obj/structure/flora/ausbushes/ppflowers = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/grassybush = 1,
			/obj/structure/flora/ausbushes/palebush = 1,
			/obj/structure/flora/ausbushes = 1,
			/obj/structure/flora/ausbushes/fernybush = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)

/singleton/biome/grass/forest
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 5),
		SMALL_FLORA = list(POISSON_SAMPLE, 1),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(LARGE_FLORA)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/grove = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/ywflowers = 1,
			/obj/structure/flora/ausbushes/brflowers = 1,
			/obj/structure/flora/ausbushes/ppflowers = 1,
			/obj/structure/flora/ausbushes/grassybush = 1,
			/obj/structure/flora/ausbushes/palebush = 1,
			/obj/structure/flora/ausbushes = 1,
			/obj/structure/flora/ausbushes/fernybush = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)
