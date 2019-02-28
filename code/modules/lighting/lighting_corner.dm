/var/datum/lighting_corner/dummy/dummy_lighting_corner = new
// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
/var/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

// This is the reverse of the above - the position in the array is a dir. Update this if the above changes.
var/list/REVERSE_LIGHTING_CORNER_DIAGONAL = list(0, 0, 0, 0, 3, 4, 0, 0, 2, 1)

/datum/lighting_corner
	var/turf/t1	// These are in no particular order.
	var/t1i	// Our index in this turf's corners list.
	var/turf/t2
	var/t2i
	var/turf/t3
	var/t3i
	var/turf/t4
	var/t4i

	var/list/datum/light_source/affecting // Light sources affecting us.
	var/active                            = FALSE  // TRUE if one of our masters has dynamic lighting.

	var/x = 0
	var/y = 0
	var/z = 0

	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0
	var/lum_u = 0	// UV Radiation, not visible.

	var/needs_update = FALSE

	var/cache_r  = LIGHTING_SOFT_THRESHOLD
	var/cache_g  = LIGHTING_SOFT_THRESHOLD
	var/cache_b  = LIGHTING_SOFT_THRESHOLD
	var/cache_mx = 0

/datum/lighting_corner/New(turf/new_turf, diagonal)
	SSlighting.lighting_corners += src

	t1 = new_turf
	z = new_turf.z
	t1i = REVERSE_LIGHTING_CORNER_DIAGONAL[diagonal]

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	x = new_turf.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = new_turf.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T
	var/i

	// Diagonal one is easy.
	T = get_step(new_turf, diagonal)
	if (T) // In case we're on the map's border.
		if (!T.corners)
			T.corners = list(null, null, null, null)

		t2 = T
		i = REVERSE_LIGHTING_CORNER_DIAGONAL[diagonal]
		t2i = i
		T.corners[i] = src

	// Now the horizontal one.
	T = get_step(new_turf, horizontal)
	if (T) // Ditto.
		if (!T.corners)
			T.corners = list(null, null, null, null)

		t3 = T
		i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		t3i = i
		T.corners[i] = src

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if (T)
		if (!T.corners)
			T.corners = list(null, null, null, null)

		t4 = T
		i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		t4i = i
		T.corners[i] = src

	update_active()

#define OVERLAY_PRESENT(T) (T && T.lighting_overlay)

/datum/lighting_corner/proc/update_active()
	active = FALSE

	if (OVERLAY_PRESENT(t1) || OVERLAY_PRESENT(t2) || OVERLAY_PRESENT(t3) || OVERLAY_PRESENT(t4))
		active = TRUE

#undef OVERLAY_PRESENT

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(delta_r, delta_g, delta_b, delta_u, now = FALSE)
	if (!(delta_r + delta_g + delta_b))	// Don't check u since the overlay doesn't care about it.
		return

	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b
	lum_u += delta_u

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (!now)
		needs_update = TRUE
		SSlighting.corner_queue += src
	else
		update_overlays(TRUE)

#define UPDATE_MASTER(T) \
	if (T && T.lighting_overlay) { \
		if (now) { \
			T.lighting_overlay.update_overlay(); \
		} \
		else if (!T.lighting_overlay.needs_update) { \
			T.lighting_overlay.needs_update = TRUE; \
			SSlighting.overlay_queue += T.lighting_overlay; \
		} \
	}


#define AVERAGE_BELOW_CORNER(Tt, Ti) \
	if (TURF_IS_MIMICING(Tt)) { \
		T = GET_BELOW(Tt); \
		if (T && T.corners && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T)) { \
			C = T.corners[Ti]; \
			if (C) { \
				divisor += 1; \
				lr += C.lum_r; \
				lg += C.lum_g; \
				lb += C.lum_b; \
			} \
		} \
	}

#define UPDATE_ABOVE_CORNER(Tt, Ti) \
	if (Tt) { \
		T = GET_ABOVE(Tt); \
		if (TURF_IS_MIMICING(T) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T)) { \
			if (!T.corners) { \
				T.generate_missing_corners(); \
			} \
			C = T.corners[Ti]; \
			if (C && !C.needs_update) { \
				C.update_overlays(FALSE); \
			} \
		} \
	}

/datum/lighting_corner/proc/update_overlays(now = FALSE)
	var/lr = lum_r
	var/lg = lum_g
	var/lb = lum_b

#ifdef USE_CORNER_ZBLEED

	var/divisor = 1
	var/datum/lighting_corner/C
	var/turf/T

	AVERAGE_BELOW_CORNER(t1, t1i)
	AVERAGE_BELOW_CORNER(t2, t2i)
	AVERAGE_BELOW_CORNER(t3, t3i)
	AVERAGE_BELOW_CORNER(t4, t4i)

	if (divisor > 1)
		lr /= divisor
		lg /= divisor
		lb /= divisor

#endif

	// Cache these values a head of time so 4 individual lighting overlays don't all calculate them individually.
	var/mx = max(lr, lg, lb) // Scale it so 1 is the strongest lum, if it is above 1.
	. = 1 // factor
	if (mx > 1)
		. = 1 / mx

	else if (mx < LIGHTING_SOFT_THRESHOLD)
		. = 0 // 0 means soft lighting.

	if (.)
		cache_r = round(lr * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
		cache_g = round(lg * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
		cache_b = round(lb * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	else
		cache_r = cache_g = cache_b = LIGHTING_SOFT_THRESHOLD

	cache_mx = round(mx, LIGHTING_ROUND_VALUE)

	UPDATE_MASTER(t1)
	UPDATE_MASTER(t2)
	UPDATE_MASTER(t3)
	UPDATE_MASTER(t4)

#ifdef USE_CORNER_ZBLEED

	UPDATE_ABOVE_CORNER(t1, t1i)
	UPDATE_ABOVE_CORNER(t2, t2i)
	UPDATE_ABOVE_CORNER(t3, t3i)
	UPDATE_ABOVE_CORNER(t4, t4i)

#endif

#undef UPDATE_MASTER
#undef AVERAGE_BELOW_CORNER
#undef UPDATE_ABOVE_CORNER

/datum/lighting_corner/Destroy(force = FALSE)
	crash_with("Some fuck [force ? "force-" : ""]deleted a lighting corner.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	SSlighting.lighting_corners -= src
	return ..()

/datum/lighting_corner/dummy/New()
	return
