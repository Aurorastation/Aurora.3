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
	var/Sx = source_turf.x
	var/Sy = source_turf.y

	// We don't need no damn vis checks!
	for (Tthing in RANGE_TURFS(Ceiling(light_range), source_turf))
		T = Tthing
		check_t:
		for (thing in T.get_corners())
			C = thing
			corners[C] = 0

		turfs += T

		CHECK_TICK

		if (istype(T, /turf/simulated/open) && T:below)
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
