/datum/exoplanet_theme/snow
	name = "Boreal Forest"
	surface_turfs = list(
		/turf/simulated/mineral/planet
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/water/ice,
			BIOME_SEMIARID = /singleton/biome/snow
			),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/snow,
			BIOME_SEMIARID = /singleton/biome/snow/forest
			)
	)

	heat_levels = list(
		BIOME_POLAR = 0.3,
		BIOME_COOL = 1.0,
	)

	humidity_levels = list(
		BIOME_ARID = 0.7,
		BIOME_SEMIARID = 1.0
	)

/datum/exoplanet_theme/snow/tundra
	name = "Frozen Tundra"
	heat_levels = list(
		BIOME_POLAR = 0.7,
		BIOME_COOL = 1.0
	)
	mountain_threshold = 0.6

/datum/exoplanet_theme/snow/adhomai
	name = "Adhomai"
	surface_turfs = list(
		/turf/simulated/mineral/adhomai
	)
	mountain_threshold = 0.6
	mountain_biome = /singleton/biome/mountain/adhomai
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/water/ice,
			BIOME_SEMIARID = /singleton/biome/snow/adhomai
		),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/snow/adhomai,
			BIOME_SEMIARID = /singleton/biome/snow/forest/adhomai
		)
	)

/datum/exoplanet_theme/snow/tundra/adhomai
	name = "Adhomai North Pole"
	mountain_biome = /singleton/biome/mountain/adhomai
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/water/ice/polar,
			BIOME_SEMIARID = /singleton/biome/snow/adhomai/polar
		),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/snow/adhomai/polar,
			BIOME_SEMIARID = /singleton/biome/snow/adhomai/polar
		)
	)
