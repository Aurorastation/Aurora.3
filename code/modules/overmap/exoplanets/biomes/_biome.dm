/singleton/biome
	/// Base turf this biome generates
	var/turf_type
	/*
	 * Flora and fauna generation works off of poisson disk sampling. In short, that means uniformly placed random points within the biome.
	 * The values below are the radius (in turfs, more or less) that one object must be from another to be able to spawn.
	 * Thus, a value of 1 would cause very tight clumps, while 3 would be dense but walkable, and 7 would be more spread out.
	 * Grass works off a strict binary (because otherwise it looks weird); if you define grass types, it will pick between them. Otherwise, it will not.
	 */
	/// Minimum radius one chosen piece of flora must be from another
	var/radius_flora = 0
	/// As above, for fauna (mobs)
	var/radius_fauna = 0
	/// Weighted list of flora types to spawn; for example setting one type to 3 and the other to 1 will result in a 75% / 25% mix on average
	var/list/avail_flora = list()
	/// Weighted list of fauna types to spawn
	var/list/avail_fauna = list()
	/// Weighted list of grass types to spawn
	var/list/avail_grass = list()

/singleton/biome/mountain
	turf_type = /turf/simulated/mineral

/singleton/biome/water
	turf_type = /turf/simulated/floor/exoplanet/water/shallow
