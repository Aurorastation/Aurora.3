/singleton/biome
	/// Fallback turf if no PLANET_TURF generator is specified, which is true in most cases
	var/turf_type
	var/list/generators = list()
	var/list/spawn_types = list()
	var/list/exclusive_generators = list(LARGE_FLORA)

/singleton/biome/mountain
	turf_type = /turf/simulated/mineral

/singleton/biome/mountain/adhomai
	turf_type = /turf/simulated/mineral/adhomai

/singleton/biome/water
	turf_type = /turf/simulated/floor/exoplanet/water/shallow

/singleton/biome/water/ice
	turf_type = /turf/simulated/floor/exoplanet/ice
