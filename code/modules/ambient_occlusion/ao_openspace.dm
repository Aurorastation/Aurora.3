// Openturfs need special snowflake CAO and UA behavior - they're shadowing based on turf type instead of ao opacity, 
//   as well as applying the overlays to the openspace shadower object instead of the turf itself.

/turf/simulated/open/calculate_ao_neighbors()
	ao_neighbors = 0
	var/turf/T

	CALCULATE_NEIGHBORS(src, ao_neighbors, T, isopenturf(T))

/turf/simulated/open/update_ao()
	if (ao_overlays)
		shadower.cut_overlay(ao_overlays)
		ao_overlays.Cut()

	if (ao_neighbors == AO_ALL_NEIGHBORS)
		return

	var/list/cache = SSicon_cache.ao_cache

	for(var/i = 1 to 4)
		var/cdir = cornerdirs[i]
		var/corner = 0

		if (ao_neighbors & (1 << cdir))
			corner |= 2
		if (ao_neighbors & (1 << turn(cdir, 45)))
			corner |= 1
		if (ao_neighbors & (1 << turn(cdir, -45)))
			corner |= 4

		if (corner != 7)	// 7 is the 'no shadows' state, no reason to add overlays for it.
			var/image/I = cache["[corner]-[i]"]
			if (!I)
				I = make_ao_image(corner, i)

			LAZYADD(ao_overlays, I)

	UNSETEMPTY(ao_overlays)

	if (ao_overlays)
		shadower.add_overlay(ao_overlays)
