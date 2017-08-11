/datum/light_source/novis

/datum/light_source/novis/update_corners()
	set waitfor = FALSE
	var/update = FALSE

	if (QDELETED(source_atom))
		qdel(src)
		return

	if (source_atom.light_power != light_power)
		light_power = source_atom.light_power
		update = TRUE

	if (source_atom.light_range != light_range)
		light_range = source_atom.light_range
		update = TRUE

	if (!top_atom)
		top_atom = source_atom
		update = TRUE

	if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		update = TRUE

	if (!light_range || !light_power)
		qdel(src)
		return

	if (isturf(top_atom))
		if (source_turf != top_atom)
			source_turf = top_atom
			update = TRUE
	else if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		update = TRUE

	if (!source_turf)
		return	// Somehow we've got a light in nullspace, no-op.

	if (light_range && light_power && !applied)
		update = TRUE

	if (source_atom.light_color != light_color)
		light_color = source_atom.light_color
		parse_light_color()
		update = TRUE

	else if (applied_lum_r != lum_r || applied_lum_g != lum_g || applied_lum_b != lum_b)
		update = TRUE

	if (update)
		needs_update = LIGHTING_CHECK_UPDATE
	else if (needs_update == LIGHTING_CHECK_UPDATE)
		return	// No change.

	var/list/datum/lighting_corner/corners = list()
	var/list/turf/turfs                    = list()
	var/thing
	var/datum/lighting_corner/C
	var/turf/T
	var/Tthing
	var/list/Tcorners
	var/Sx = source_turf.x
	var/Sy = source_turf.y
	var/actual_range = light_range	// novis sources don't support directional lighting.

	// We don't need no damn vis checks!
	for (Tthing in RANGE_TURFS(Ceiling(light_range), source_turf))
		T = Tthing
		check_t:

		if (T.dynamic_lighting || T.light_sources)
			Tcorners = T.corners
			if (!T.lighting_corners_initialised)
				T.lighting_corners_initialised = TRUE

				if (!Tcorners)
					T.corners = list(null, null, null, null)
					Tcorners = T.corners

				for (var/i = 1 to 4)
					if (Tcorners[i])
						continue

					Tcorners[i] = new /datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])

			if (!T.has_opaque_atom)
				for (thing in Tcorners)
					C = thing
					corners[C] = 0

		turfs += T

		CHECK_TICK

		if (isopenturf(T) && T:below)
			T = T:below
			goto check_t

	LAZYINITLIST(affecting_turfs)

	var/list/L = turfs - affecting_turfs // New turfs, add us to the affecting lights of them.
	affecting_turfs += L
	for (thing in L)
		T = thing
		LAZYADD(T.affecting_lights, src)

	L = affecting_turfs - turfs // Now-gone turfs, remove us from the affecting lights.
	affecting_turfs -= L
	for (thing in L)
		T = thing
		LAZYREMOVE(T.affecting_lights, src)

	LAZYINITLIST(effect_str)
	if (needs_update == LIGHTING_VIS_UPDATE)
		for (thing in corners - effect_str)
			C = thing
			LAZYADD(C.affecting, src)
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_XY(C, FALSE, Sx, Sy)
	else
		L = corners - effect_str
		for (thing in L)
			C = thing
			LAZYADD(C.affecting, src)
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_XY(C, FALSE, Sx, Sy)

		for (thing in corners - L)
			C = thing
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_XY(C, FALSE, Sx, Sy)

	L = effect_str - corners
	for (thing in L)
		C = thing
		REMOVE_CORNER(C, FALSE)
		LAZYREMOVE(C.affecting, src)

	effect_str -= L

	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b
	applied_lum_u = lum_u

	UNSETEMPTY(effect_str)
	UNSETEMPTY(affecting_turfs)

/datum/light_source/novis/check_light_cone()
	return FALSE

/datum/light_source/novis/update_angle()
	return

#define QUEUE_UPDATE(level) \
	var/_should_update = needs_update == LIGHTING_NO_UPDATE; \
	if (needs_update < level) {        \
		needs_update = level;          \
	}                                  \
	if (_should_update) {              \
		SSlighting.light_queue += src; \
	}

/datum/light_source/novis/update(atom/new_top_atom)
	// This top atom is different.
	if (new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom) // Remove ourselves from the light sources of that top atom.
			LAZYREMOVE(top_atom.light_sources, src)

		top_atom = new_top_atom

		if (top_atom != source_atom)
			if(!top_atom.light_sources)
				top_atom.light_sources = list()

			top_atom.light_sources += src // Add ourselves to the light sources of our new top atom.

	//L_PROF(source_atom, "source_update")

	QUEUE_UPDATE(LIGHTING_CHECK_UPDATE)

/datum/light_source/novis/force_update()
	QUEUE_UPDATE(LIGHTING_FORCE_UPDATE)

/datum/light_source/novis/vis_update()
	QUEUE_UPDATE(LIGHTING_VIS_UPDATE)


#undef QUEUE_UPDATE
