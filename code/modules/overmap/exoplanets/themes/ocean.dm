/datum/exoplanet_theme/ocean
	name = "Ocean World"
	surface_turfs = list(
		/turf/simulated/floor/exoplanet/water/shallow/ocean,
		/turf/simulated/floor/exoplanet/coastal_sand,
		/turf/simulated/mineral
	)
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/ocean/island,
			BIOME_SEMIARID = /singleton/biome/ocean,
			BIOME_SUBHUMID = /singleton/biome/ocean
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/ocean,
			BIOME_SEMIARID = /singleton/biome/ocean/island,
			BIOME_SUBHUMID = /singleton/biome/ocean
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/ocean,
			BIOME_SEMIARID = /singleton/biome/ocean,
			BIOME_SUBHUMID = /singleton/biome/ocean/island
		)
	)

	heat_levels = list(
		BIOME_COOL = 0.4,
		BIOME_WARM = 0.8,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 0.2,
		BIOME_SEMIARID = 0.5,
		BIOME_SUBHUMID = 1.0
	)

/datum/exoplanet_theme/ocean/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	. = ..()
	surface_color = E.grass_color
