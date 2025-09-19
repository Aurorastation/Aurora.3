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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
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
			/obj/structure/flora/ausbushes/stalkybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
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
			/obj/structure/flora/tree/grove = 1,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/ywflowers = 1,
			/obj/structure/flora/ausbushes/brflowers = 1,
			/obj/structure/flora/ausbushes/ppflowers = 1,
			/obj/structure/flora/ausbushes/grassybush = 1,
			/obj/structure/flora/ausbushes/palebush = 1,
			/obj/structure/flora/ausbushes = 1,
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)

//Biesel

/singleton/biome/grass/biesel
	turf_type = /turf/simulated/floor/exoplanet/grass/grove
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)

/singleton/biome/grass/riverside/biesel
	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/floor/exoplanet/water/shallow = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/reedbush = 1,
			/obj/structure/flora/ausbushes/stalkybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/aquatic/fish/gupper = 1,
			/mob/living/simple_animal/aquatic/fish/cod = 1
		)
	)

/singleton/biome/grass/forest/biesel
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/grove = 1,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/ywflowers = 1,
			/obj/structure/flora/ausbushes/brflowers = 1,
			/obj/structure/flora/ausbushes/ppflowers = 1,
			/obj/structure/flora/ausbushes/grassybush = 1,
			/obj/structure/flora/ausbushes/palebush = 1,
			/obj/structure/flora/ausbushes = 1,
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/yithian = 2,
			/mob/living/simple_animal/tindalos = 2,
			/mob/living/simple_animal/cosmozoan = 1,
		)
	)

//Moghes Biomes
//TODO - add Moghes flora and fauna here when they're implemented, as well as generic structure/flora for the planet.

/singleton/biome/grass/moghes
	turf_type = /turf/simulated/floor/exoplanet/grass/moghes
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, -0.1, 360, 4),
		WILDLIFE = list(POISSON_SAMPLE, 10)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/bush/jungle/random = 3,
			/obj/structure/flora/bush/jungle/b/random = 3,
			/obj/structure/flora/bush/jungle/c/random = 3,
			/obj/effect/landmark/exoplanet_spawn/plant = 3
		),

		GRASSES = list(
			/obj/structure/flora/grass/junglegrass/random = 4,
			/obj/structure/flora/grass/junglegrass/dense/random = 2,
			/obj/structure/flora/grass/junglegrass/rocky/random = 1
		),

		WILDLIFE = list(
			/mob/living/carbon/human/stok/moghes = 1,
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/hostile/retaliate/hegeranzi = 1,
			/mob/living/simple_animal/hostile/shrieker = 1,
			/mob/living/simple_animal/otzek = 1
			//other mobs when added
		)
	)

/singleton/biome/grass/forest/moghes
	turf_type = /turf/simulated/floor/exoplanet/grass/moghes
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 5),
		SMALL_FLORA = list(POISSON_SAMPLE, 1),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 4),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(LARGE_FLORA, SMALL_FLORA)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/jungle/small/random = 5,
			/obj/structure/flora/tree/jungle/random = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/jungle/large/random = 1,
			/obj/structure/flora/bush/jungle/random = 3,
			/obj/structure/flora/bush/jungle/b/random = 3,
			/obj/structure/flora/bush/jungle/c/random = 3,
			/obj/effect/landmark/exoplanet_spawn/plant = 3
		),
		GRASSES = list(
			/obj/structure/flora/grass/junglegrass/random = 4,
			/obj/structure/flora/grass/junglegrass/dense/random = 2,
			/obj/structure/flora/grass/junglegrass/rocky/random = 1
		),
		WILDLIFE = list(
			/mob/living/carbon/human/stok/moghes = 1,
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/hostile/retaliate/hegeranzi = 1,
			/mob/living/simple_animal/hostile/shrieker = 1,
			/mob/living/simple_animal/otzek = 1
			//other mobs when added
		)
	)

/singleton/biome/grass/riverside/moghes
	turf_type = /turf/simulated/floor/exoplanet/grass/moghes
	generators = list(
		PLANET_TURF = list(HEIGHT_MOD, 0.95),
		SMALL_FLORA = list(POISSON_SAMPLE, 1),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	exclusive_generators = list(PLANET_TURF)
	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/floor/exoplanet/water/shallow/moghes = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/reedbush = 1,
			/obj/structure/flora/ausbushes/stalkybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/carbon/human/stok/moghes = 1,
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/hostile/retaliate/hegeranzi = 1,
			/mob/living/simple_animal/hostile/shrieker = 1,
			/mob/living/simple_animal/aquatic/fish/moghes = 1,
			/mob/living/simple_animal/otzek = 1
			//other mobs when added
		)
	)

/singleton/biome/grass/chaparral/moghes
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/carbon/human/stok/moghes = 1,
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/hostile/retaliate/hegeranzi = 1,
			/mob/living/simple_animal/hostile/shrieker = 1,
			/mob/living/simple_animal/otzek = 1
			//other mobs when added
		)
	)


//Ouerea Biomes
//TODO: Ouerea flora and fauna
/singleton/biome/grass/ouerea
	turf_type = /turf/simulated/floor/exoplanet/grass
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/otzek = 1,
			/mob/living/simple_animal/miervesh = 1
		)
	)

/singleton/biome/grass/forest/ouerea
	turf_type = /turf/simulated/floor/exoplanet/grass
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/otzek = 1,
			/mob/living/simple_animal/miervesh = 1
		)
	)

/singleton/biome/grass/riverside/ouerea
	turf_type = /turf/simulated/floor/exoplanet/grass
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
			/obj/structure/flora/ausbushes/stalkybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/aquatic/fish/moghes = 1,
			/mob/living/simple_animal/otzek = 1,
			/mob/living/simple_animal/miervesh = 1
		)
	)

/singleton/biome/grass/chaparral/ouerea
	turf_type = /turf/simulated/floor/exoplanet/grass
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/threshbeast = 1,
			/mob/living/simple_animal/otzek = 1,
			/mob/living/simple_animal/miervesh = 1
		)
	)

//Xanu Biomes
//TODO: Xanu flora and fauna
/singleton/biome/grass/xanu
	turf_type = /turf/simulated/floor/exoplanet/grass/stalk
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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list() // No wildlife assets for xanu
	)

/singleton/biome/grass/forest/xanu
	turf_type = /turf/simulated/floor/exoplanet/grass/stalk

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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list()
	)

/singleton/biome/grass/riverside/xanu
	turf_type = /turf/simulated/floor/exoplanet/grass/stalk

	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/floor/exoplanet/water/shallow = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/ausbushes/reedbush = 1,
			/obj/structure/flora/ausbushes/stalkybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/aquatic/fish/cod = 1,
			/mob/living/simple_animal/aquatic/fish/gupper = 1
		)
	)

/singleton/biome/grass/chaparral/xanu
	turf_type = /turf/simulated/floor/exoplanet/dirt_konyang

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
			/obj/structure/flora/ausbushes/fernybush = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 1
		),
		WILDLIFE = list()
	)
