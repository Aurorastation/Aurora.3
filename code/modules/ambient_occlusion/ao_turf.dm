#ifdef AO_USE_LIGHTING_OPACITY
#define AO_TURF_CHECK(T) (!T.has_opaque_atom)
#else
#define AO_TURF_CHECK(T) (!T.density || !T.opacity)
#endif

/turf
	var/permit_ao = TRUE
	var/tmp/list/ao_overlays	// Current ambient occlusion overlays. Tracked so we can reverse them without dropping all priority overlays.
	var/tmp/ao_neighbors
	var/ao_queued = AO_UPDATE_NONE

/turf/proc/regenerate_ao()
	for (var/thing in RANGE_TURFS(1, src))
		var/turf/T = thing
		if (T.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/calculate_ao_neighbors()
	ao_neighbors = 0
	if (!permit_ao)
		return

	var/turf/T
	for (var/tdir in cardinal)
		T = get_step(src, tdir)
		if (T && AO_TURF_CHECK(T))
			ao_neighbors |= 1 << tdir

	if (ao_neighbors & N_NORTH)
		if (ao_neighbors & N_WEST)
			T = get_step(src, NORTHWEST)
			if (AO_TURF_CHECK(T))
				ao_neighbors |= N_NORTHWEST

		if (ao_neighbors & N_EAST)
			T = get_step(src, NORTHEAST)
			if (AO_TURF_CHECK(T))
				ao_neighbors |= N_NORTHEAST

	if (ao_neighbors & N_SOUTH)
		if (ao_neighbors & N_WEST)
			T = get_step(src, SOUTHWEST)
			if (AO_TURF_CHECK(T))
				ao_neighbors |= N_SOUTHWEST

		if (ao_neighbors & N_EAST)
			T = get_step(src, SOUTHEAST)
			if (AO_TURF_CHECK(T))
				ao_neighbors |= N_SOUTHEAST

/proc/make_ao_image(corner, i)
	var/list/cache = SSicon_cache.ao_cache
	var/cstr = "[corner]"
	var/key = "[cstr]-[i]"

	var/image/I = image('icons/turf/flooring/shadows.dmi', cstr, dir = 1 << (i-1))
	I.alpha = WALL_AO_ALPHA
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA|RESET_COLOR|TILE_BOUND

	. = cache[key] = I

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSocclusion.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

/turf/proc/update_ao()
	if (ao_overlays)
		cut_overlay(ao_overlays, TRUE)
		ao_overlays.Cut()

	if (!permit_ao)
		return

	var/list/cache = SSicon_cache.ao_cache

	if (!has_opaque_atom)
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
					I = make_ao_image(corner, i)	// this will also add the image to the cache.

				if (!pixel_x && !pixel_y && !pixel_w && !pixel_z)	// We can only use the cache if we're not shifting.
					LAZYADD(ao_overlays, I)
				else
					// There's a pixel var set, so we're going to need to make a new instance just for this type.
					var/mutable_appearance/MA = new(I)
					// We invert the offsets here to counteract the pixel shifting of the parent turf.
					MA.pixel_x = -(pixel_x)
					MA.pixel_y = -(pixel_y)
					MA.pixel_w = -(pixel_w)
					MA.pixel_z = -(pixel_z)

					LAZYADD(ao_overlays, MA)

	UNSETEMPTY(ao_overlays)

	if (ao_overlays)
		add_overlay(ao_overlays, TRUE)
