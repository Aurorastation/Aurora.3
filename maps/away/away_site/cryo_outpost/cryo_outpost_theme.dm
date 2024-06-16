
// ----------------- themes

/datum/exoplanet_theme/volcanic/cryo_outpost
	name = "Tret"

	surface_color = "#444444"

	surface_turfs = list(
		/turf/simulated/mineral/lava/cryo_outpost
	)

	perlin_zoom = 21

	mountain_biome = /singleton/biome/mountain/basalt/cryo_outpost
	mountain_threshold = 0.6

	heat_levels = list(
		BIOME_POLAR = 0.3,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/lava
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/barren/asteroid/basalt/cryo_outpost
		)
	)

/datum/exoplanet_theme/volcanic/cryo_outpost/mountain
	mountain_threshold = 0.0

// ----------------- biomes

/singleton/biome/mountain/basalt/cryo_outpost
	turf_type = /turf/simulated/mineral/lava/cryo_outpost

/singleton/biome/barren/asteroid/basalt/cryo_outpost
	turf_type = /turf/simulated/floor/exoplanet/basalt/cryo_outpost

	generators = list(
		PLANET_TURF = list(BATCHED_NOISE, -0.1, 360, 32),
		SMALL_FLORA = list(POISSON_SAMPLE, 9)
	)
	exclusive_generators = list(PLANET_TURF)

	spawn_types = list(
		PLANET_TURF = list(
			/turf/simulated/lava = 1
		),
		SMALL_FLORA = list(
			/obj/structure/flora/rock/random = 1,
			/obj/structure/flora/rock/pile/random = 2
		)
	)

// ----------------- some turf defs

/turf/simulated/floor/exoplanet/basalt/cryo_outpost
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)

/turf/simulated/lava/cryo_outpost
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)
	canSmoothWith = list(
			/turf/simulated/lava/cryo_outpost,
			/turf/simulated/mineral/lava/cryo_outpost
	)

/turf/simulated/floor/exoplanet/plating/cryo_outpost
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)

// ----------------- fin
