/atom/movable/lighting_overlay
	name          = ""
	anchored      = TRUE
	icon          = LIGHTING_ICON
	icon_state    = LIGHTING_BASE_ICON_STATE
	color         = LIGHTING_BASE_MATRIX
	mouse_opacity = 0
	layer         = LIGHTING_LAYER
	invisibility  = INVISIBILITY_LIGHTING
	simulated     = 0
	blend_mode    = BLEND_MULTIPLY

	var/needs_update = FALSE

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/atom/movable/lighting_overlay/New()
	SSlighting.lighting_overlays += src

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0
	
	needs_update = TRUE
	SSlighting.overlay_queue += src

/atom/movable/lighting_overlay/Destroy(force = FALSE)
	if (!force)
		return QDEL_HINT_LETMELIVE	// STOP DELETING ME

	//L_PROF(loc, "overlay_destroy")
	SSlighting.lighting_overlays -= src
	SSlighting.overlay_queue     -= src

	var/turf/T   = loc
	if (istype(T))
		T.lighting_overlay = null
		T.luminosity = 1
	
	return ..()

// This is a macro PURELY so that the if below is actually readable.
#define ALL_EQUAL ((rr == gr && gr == br && br == ar) && (rg == gg && gg == bg && bg == ag) && (rb == gb && gb == bb && bb == ab))

/atom/movable/lighting_overlay/proc/update_overlay()
	if (QDELING(src))	// This shouldn't happen.
		return

	var/turf/T = loc
	if (!istype(T)) // Erm...
		if (loc)
			warning("A lighting overlay realised its loc was NOT a turf (actual loc: [loc], [loc.type]) in update_overlay() and got deleted!")

		else
			warning("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")

		qdel(src, TRUE)
		return

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/list/corners = T.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners)
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)
	luminosity = max > LIGHTING_SOFT_THRESHOLD

// The RNG introduced by LIGHTING_USE_MEMORY_HACK makes this shortcut ineffective.
#ifndef LIGHTING_USE_MEMORY_HACK
	var/rr = cr.cache_r
	var/rg = cr.cache_g
	var/rb = cr.cache_b

	var/gr = cg.cache_r
	var/gg = cg.cache_g
	var/gb = cg.cache_b

	var/br = cb.cache_r
	var/bg = cb.cache_g
	var/bb = cb.cache_b

	var/ar = ca.cache_r
	var/ag = ca.cache_g
	var/ab = ca.cache_b

	if ((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = null
	else if (!luminosity)
		icon_state = LIGHTING_DARKNESS_ICON_STATE
		color = null
	else if (ALL_EQUAL && rr == LIGHTING_DEFAULT_TUBE_R && rg == LIGHTING_DEFAULT_TUBE_G && rb == LIGHTING_DEFAULT_TUBE_B)
		icon_state = LIGHTING_STATION_ICON_STATE
		color = null
	else
		icon_state = LIGHTING_BASE_ICON_STATE
		color = list(
			rr, rg, rb, 0,
			gr, gg, gb, 0,
			br, bg, bb, 0,
			ar, ag, ab, 0,
			0, 0, 0, 1
		)
#else 
	color = list(
		cr.cache_r, cr.cache_g, cr.cache_b, 0,
		cg.cache_r, cg.cache_g, cg.cache_b, 0,
		cb.cache_r, cb.cache_g, cb.cache_b, 0,
		ca.cache_r, ca.cache_g, ca.cache_b, 0,
		0, 0, 0, 1
	)
#endif 

	if (bound_overlay)
		update_above()

#undef ALL_EQUAL

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/lighting_overlay/ex_act(severity)
	return 0

/atom/movable/lighting_overlay/singularity_act()
	return

/atom/movable/lighting_overlay/singularity_pull()
	return

/atom/movable/lighting_overlay/singuloCanEat()
	return FALSE

/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_overlay/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		//L_PROF(loc, "overlay_forcemove")
		. = ..()

/atom/movable/lighting_overlay/shuttle_move(turf/loc)
	return
