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
			/obj/structure/flora/tree/jungle/random = 1,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 1
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
			/obj/structure/flora/bush/jungle/c/random = 3,
			/obj/effect/landmark/exoplanet_spawn/plant = 3
		),
		GRASSES = list(
			/obj/structure/flora/grass/junglegrass/random = 4,
			/obj/structure/flora/grass/junglegrass/dense/random = 2,
			/obj/structure/flora/grass/junglegrass/rocky/random = 1
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

/singleton/biome/konyang
	turf_type = /turf/simulated/floor/exoplanet/konyang
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 7),
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 4)
	)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/flora/tree/konyang/spring = 3
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/konyang_reeds = 5,
			/obj/structure/flora/rock/konyang = 3,
			/obj/structure/flora/rock/konyang/small = 4,
			/obj/structure/flora/rock/konyang/moss = 1
		),
		GRASSES = list(
			/obj/effect/floor_decal/konyang_flowers = 3
		)
	)
	exclusive_generators = list(LARGE_FLORA, SMALL_FLORA)

/singleton/biome/konyang/clearing
	turf_type = /turf/simulated/floor/exoplanet/konyang
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 4)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/bush/konyang_reeds = 2,
			/obj/structure/flora/rock/konyang/small = 1
		),
		GRASSES = list(
			/obj/effect/floor_decal/konyang_flowers = 2
		)
	)

/singleton/biome/konyang/water//shallow water more fitting for coastlines
	turf_type = /turf/simulated/floor/exoplanet/water/shallow/konyang
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 5),
		WILDLIFE = list(POISSON_SAMPLE, 5)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/rock/konyang/water = 2
		),
		GRASSES = list(
			/obj/structure/flora/bush/konyang_reeds/water = 4
		),
		WILDLIFE = list(
			/mob/living/simple_animal/aquatic/fish = 1,
			/mob/living/simple_animal/aquatic/fish/gupper = 1,
			/mob/living/simple_animal/aquatic/fish/cod = 1
		)
	)

/singleton/biome/konyang/water/ocean//completely open water
	turf_type = /turf/simulated/floor/exoplanet/water/konyang
	generators = list(
		WILDLIFE = list(POISSON_SAMPLE, 3)
	)
	spawn_types = list(
		WILDLIFE = list(
			/mob/living/simple_animal/hostile/retaliate/aquatic/thresher = 1
		)
	)

/singleton/biome/konyang/caves
	turf_type = /turf/simulated/floor/exoplanet/dirt_konyang
	generators = list(
		SMALL_FLORA = list(POISSON_SAMPLE, 4)
	)
	spawn_types = list(
		SMALL_FLORA = list(
			/obj/structure/flora/rock/konyang = 2,
			/obj/structure/flora/rock/konyang/small = 5
		),
	)

/singleton/biome/konyang/abandoned//long-abandoned decrepit ghost town
	turf_type = /turf/simulated/floor/exoplanet/dirt_konyang
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 7),
		SMALL_FLORA = list(POISSON_SAMPLE, 4),
		GRASSES = list(BATCHED_NOISE, 0.1, 360, 4)
	)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/structure/utility_pole = 2,
			/obj/structure/utility_pole/street = 1,
			/obj/structure/utility_pole/power/central = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/konyang_reeds = 5,
			/obj/structure/flora/rock/konyang = 3,
			/obj/structure/flora/rock/konyang/small = 4,
			/obj/structure/girder = 4,
			/obj/effect/decal/cleanable/dirt = 8,
			/obj/structure/trash_pile = 7,
			/obj/structure/flora/rock/konyang/moss = 1,
			/obj/structure/grille = 4,
			/obj/item/stack/rods = 5,
			/obj/item/material/shard = 5,
			/obj/structure/flora/rock/konyang/moss = 1,
			/obj/structure/lattice/catwalk/indoor/urban = 2
		),
		GRASSES = list(
			/turf/simulated/floor/concrete = 3,
			/turf/simulated/floor/asphalt = 3,
			/turf/simulated/floor/sidewalk = 2,
			/turf/simulated/floor/plating = 3
		)
	)
	exclusive_generators = list(LARGE_FLORA, SMALL_FLORA)
