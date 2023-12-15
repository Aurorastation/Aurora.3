/singleton/biome/snow
	turf_type = /turf/simulated/floor/exoplanet/snow
	generators = list(
		PLANET_TURF = list(BATCHED_NOISE, -0.2, 360, 16),
		GRASSES = list(BATCHED_NOISE, -0.4, 360, 4),
		LARGE_FLORA = list(POISSON_SAMPLE, 9),
		SMALL_FLORA = list(POISSON_SAMPLE, 6),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		PLANET_TURF = list(/turf/simulated/floor/exoplanet/permafrost = 1),
		GRASSES = list(
			/obj/structure/flora/grass/both = 2,
			/obj/structure/flora/grass/green = 1,
			/obj/structure/flora/grass/brown = 1
		),
		LARGE_FLORA = list(
			/obj/effect/floor_decal/snowdrift/large/random = 4,
			/obj/structure/flora/rock/snow = 4,
			/obj/structure/flora/tree/dead = 2,
			/obj/structure/flora/tree/pine = 1,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush = 2,
			/obj/effect/floor_decal/snowrocks = 1,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		),
		WILDLIFE = list(
			/mob/living/simple_animal/hostile/retaliate/samak = 1,
			/mob/living/simple_animal/hostile/retaliate/diyaab = 1,
			/mob/living/simple_animal/hostile/retaliate/shantak = 1
		)
	)
	exclusive_generators = list(LARGE_FLORA)

/singleton/biome/snow/forest
	generators = list(
		GRASSES = list(BATCHED_NOISE, -0.4, 360, 4),
		LARGE_FLORA = list(POISSON_SAMPLE, 4),
		SMALL_FLORA = list(POISSON_SAMPLE, 2),
		WILDLIFE = list(POISSON_SAMPLE, 8)
	)
	spawn_types = list(
		GRASSES = list(
			/obj/structure/flora/grass/both = 1,
			/obj/structure/flora/grass/green = 2,
			/obj/structure/flora/grass/brown = 1
		),
		LARGE_FLORA = list(
			/obj/structure/flora/rock/snow = 1,
			/obj/structure/flora/tree/dead = 2,
			/obj/structure/flora/tree/pine = 4,
			/obj/effect/landmark/exoplanet_spawn/large_plant = 3
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush = 3,
			/obj/effect/floor_decal/snowrocks = 1,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 3
		),
		WILDLIFE = list(
			/mob/living/simple_animal/hostile/retaliate/samak = 1,
			/mob/living/simple_animal/hostile/retaliate/diyaab = 1,
			/mob/living/simple_animal/hostile/retaliate/shantak = 1
		)
	)

// Adhomai

/singleton/biome/snow/adhomai
	spawn_types = list(
		PLANET_TURF = list(/turf/simulated/floor/exoplanet/permafrost = 1),
		GRASSES = list(
			/obj/structure/flora/grass/adhomai = 1
		),
		LARGE_FLORA = list(
			/obj/effect/floor_decal/snowdrift/large/random = 1,
			/obj/structure/flora/rock/adhomai = 1,
			/obj/structure/flora/tree/adhomai = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/adhomai = 3,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		),
		WILDLIFE = list(
			/mob/living/simple_animal/ice_tunneler = 1,
			/mob/living/simple_animal/ice_tunneler/male = 1,
			/mob/living/simple_animal/fatshouter = 1,
			/mob/living/simple_animal/fatshouter/male = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama/male = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama/baby = 1,
			/mob/living/simple_animal/hostile/wind_devil = 1,
			/mob/living/carbon/human/farwa/adhomai = 1,
			/mob/living/simple_animal/hostile/harron = 1,
			/mob/living/simple_animal/climber = 1,
			/mob/living/simple_animal/snow_strider = 1,
			/mob/living/simple_animal/nosehorn = 1
		)
	)

/singleton/biome/snow/forest/adhomai
	spawn_types = list(
		GRASSES = list(
			/obj/structure/flora/grass/adhomai = 1
		),
		LARGE_FLORA = list(
			/obj/effect/floor_decal/snowdrift/large/random = 1,
			/obj/structure/flora/rock/adhomai = 1,
			/obj/structure/flora/tree/adhomai = 4
		),
		SMALL_FLORA = list(
			/obj/structure/flora/bush/adhomai = 3,
			/obj/effect/floor_decal/snowdrift/random = 1,
			/obj/effect/landmark/exoplanet_spawn/plant = 2
		),
		WILDLIFE = list(
			/mob/living/simple_animal/ice_tunneler = 1,
			/mob/living/simple_animal/ice_tunneler/male = 1,
			/mob/living/simple_animal/fatshouter = 1,
			/mob/living/simple_animal/fatshouter/male = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama/male = 1,
			/mob/living/simple_animal/hostile/retaliate/rafama/baby = 1,
			/mob/living/simple_animal/hostile/wind_devil = 1,
			/mob/living/carbon/human/farwa/adhomai = 1,
			/mob/living/simple_animal/hostile/harron = 1,
			/mob/living/simple_animal/climber = 1,
			/mob/living/simple_animal/snow_strider = 1,
			/mob/living/simple_animal/nosehorn = 1
		)
	)

/singleton/biome/snow/adhomai/polar
	turf_type = /turf/simulated/floor/exoplanet/snow
	generators = list(
		LARGE_FLORA = list(POISSON_SAMPLE, 9),
		SMALL_FLORA = list(POISSON_SAMPLE, 9),
		WILDLIFE = list(POISSON_SAMPLE, 15)
	)
	spawn_types = list(
		LARGE_FLORA = list(
			/obj/effect/floor_decal/snowdrift/large/random = 1,
			/obj/structure/flora/rock/adhomai = 2,
			/obj/structure/flora/rock/ice = 3
		),
		SMALL_FLORA = list(
			/obj/structure/geyser = 1,
			/obj/effect/floor_decal/snowdrift/random = 1
		),
		WILDLIFE = list(
			/mob/living/simple_animal/scavenger = 1,
			/mob/living/simple_animal/ice_catcher = 1,
			/mob/living/simple_animal/hostile/plasmageist = 1,
			/mob/living/simple_animal/hostile/wriggler = 1
		)
	)

/singleton/biome/water/ice/polar
	turf_type = /turf/simulated/floor/exoplanet/ice/dark
