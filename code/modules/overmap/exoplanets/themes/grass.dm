/datum/exoplanet_theme/grass
	name = "Grasslands" // Not gm_flatgrass, but pretty close
	surface_turfs = list(
		/turf/simulated/floor/exoplanet/grass,
		/turf/simulated/mineral/planet
	)
	mountain_threshold = 0.9
	possible_biomes = list(
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/grass/chaparral,
			BIOME_SEMIARID = /singleton/biome/grass/forest,
			BIOME_SUBHUMID = /singleton/biome/grass/forest
		),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/grass/chaparral,
			BIOME_SEMIARID = /singleton/biome/grass,
			BIOME_SUBHUMID = /singleton/biome/grass/riverside
		),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/grass,
			BIOME_SEMIARID = /singleton/biome/grass/riverside,
			BIOME_SUBHUMID = /singleton/biome/grass/riverside
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

/datum/exoplanet_theme/grass/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	. = ..()
	surface_color = E.grass_color

/datum/exoplanet_theme/grass/marsh
	name = "Fungal Marsh"
	surface_turfs = list(
		/turf/simulated/mineral/planet
	)
	possible_biomes = list(
		BIOME_WARM = list(
			BIOME_SUBHUMID = /singleton/biome/marsh,
			BIOME_HUMID = /singleton/biome/marsh/forest
		),
		BIOME_EQUATOR = list(
			BIOME_SUBHUMID = /singleton/biome/marsh,
			BIOME_HUMID = /singleton/biome/marsh/forest
		)

	)
	heat_levels = list(
		BIOME_WARM = 0.5,
		BIOME_EQUATOR = 1.0
	)
	humidity_levels = list(
		BIOME_SUBHUMID = 0.4,
		BIOME_HUMID = 1.0
	)
