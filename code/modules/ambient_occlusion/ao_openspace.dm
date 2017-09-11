// Openturfs need special snowflake CAO and UA behavior - they're shadowing based on turf type instead of ao opacity, 
//   as well as applying the overlays to the openspace shadower object instead of the turf itself.

/turf/simulated/open/calculate_ao_neighbors()
	ao_neighbors = 0
	var/turf/T
	for (var/tdir in cardinal)
		T = get_step(src, tdir)
		if (isopenturf(T))
			ao_neighbors |= 1 << tdir

	if (ao_neighbors & N_NORTH)
		if (ao_neighbors & N_WEST)
			T = get_step(src, NORTHWEST)
			if (isopenturf(T))
				ao_neighbors |= N_NORTHWEST

		if (ao_neighbors & N_EAST)
			T = get_step(src, NORTHEAST)
			if (isopenturf(T))
				ao_neighbors |= N_NORTHEAST

	if (ao_neighbors & N_SOUTH)
		if (ao_neighbors & N_WEST)
			T = get_step(src, SOUTHWEST)
			if (isopenturf(T))
				ao_neighbors |= N_SOUTHWEST

		if (ao_neighbors & N_EAST)
			T = get_step(src, SOUTHEAST)
			if (isopenturf(T))
				ao_neighbors |= N_SOUTHEAST

/turf/simulated/open/update_ao()
	if (ao_overlays)
		shadower.cut_overlay(ao_overlays)
		ao_overlays.Cut()

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
