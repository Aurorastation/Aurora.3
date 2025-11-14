
// ----------------- themes

/datum/exoplanet_theme/volcanic/tret
	name = "Tret"

	surface_color = "#444444"

	surface_turfs = list(
		/turf/simulated/mineral/lava/tret
	)

	perlin_zoom = 21

	mountain_biome = /singleton/biome/mountain/basalt/tret
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
			BIOME_ARID = /singleton/biome/barren/asteroid/basalt/tret
		)
	)

/datum/exoplanet_theme/volcanic/tret/mountain
	mountain_threshold = 0.0

// ----------------- biomes

/singleton/biome/mountain/basalt/tret
	turf_type = /turf/simulated/mineral/lava/tret

/singleton/biome/barren/asteroid/basalt/tret
	turf_type = /turf/simulated/floor/exoplanet/basalt/tret

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

/turf/simulated/floor/exoplanet/basalt/tret
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)

/turf/simulated/lava/tret
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)
	canSmoothWith = list(
			/turf/simulated/lava/tret,
			/turf/simulated/mineral/lava/tret
	)

/turf/simulated/floor/exoplanet/plating/tret
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)
