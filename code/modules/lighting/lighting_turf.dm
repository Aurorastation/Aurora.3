/turf
	var/dynamic_lighting = TRUE
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/list/datum/light_source/affecting_lights       // List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay.
	var/tmp/list/datum/lighting_corner/corners
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	//L_PROF(src, "turf_reconsider")
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.vis_update()

// Forces a lighting update. Reconsider lights is preferred when possible.
/turf/proc/force_update_lights()
	//L_PROF(src, "turf_forceupdate")
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.force_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_overlay)
		if (lighting_overlay.loc != src)
			var/turf/badT = lighting_overlay.loc
			crash_with("Lighting overlay variable on turf [DEBUG_REF(src)] is insane, lighting overlay actually located on [DEBUG_REF(lighting_overlay.loc)] at ([badT.x],[badT.y],[badT.z])!")

		qdel(lighting_overlay, TRUE)
		lighting_overlay = null

	//L_PROF(src, "turf_clear_overlay")

	for (var/datum/lighting_corner/C in corners)
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if (lighting_overlay)
		return

	//L_PROF(src, "turf_build_overlay")

	var/area/A = loc
	if (A.dynamic_lighting && dynamic_lighting)
		if (!lighting_corners_initialised || !corners)
			generate_missing_corners()

		new /atom/movable/lighting_overlay(src)

		for (var/datum/lighting_corner/C in corners)
			if (!C.active) // We would activate the corner, calculate the lighting for it.
				for (var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C, TRUE)

				C.active = TRUE

// Returns the average color of this tile. Roughly corresponds to the color of a single old-style lighting overlay.
/turf/proc/get_avg_color()
	if (!lighting_overlay)
		return null

	var/lum_r
	var/lum_g
	var/lum_b

	for (var/datum/lighting_corner/L in corners)
		lum_r += L.lum_r
		lum_g += L.lum_g
		lum_b += L.lum_b

	lum_r = CLAMP01(lum_r / 4) * 255
	lum_g = CLAMP01(lum_g / 4) * 255
	lum_b = CLAMP01(lum_b / 4) * 255

	return "#[num2hex(lum_r, 2)][num2hex(lum_g, 2)][num2hex(lum_g, 2)]"

#define SCALE(targ,min,max) (targ - min) / (max - min)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_overlay)
		return 0.5

	var/totallums = 0
	for (var/datum/lighting_corner/L in corners)
		totallums += L.lum_r + L.lum_b + L.lum_g

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

// Gets the current UV illumination of the turf. Always 100% for space & other static-lit tiles.
/turf/proc/get_uv_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_overlay)
		return 1

	L_PROF(src, "turf_get_uv")

	var/totallums = 0
	for (var/datum/lighting_corner/L in corners)
		totallums += L.lum_u

	totallums /= 4	// average of four corners.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

#undef SCALE

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
#ifdef AO_USE_LIGHTING_OPACITY
	var/old = has_opaque_atom
#endif

	has_opaque_atom = FALSE
	if (opacity)
		has_opaque_atom = TRUE
	else
		for (var/thing in src) // Loop through every movable atom on our tile
			var/atom/movable/A = thing
			if (A.opacity)
				has_opaque_atom = TRUE
				break 	// No need to continue if we find something opaque.

#ifdef AO_USE_LIGHTING_OPACITY
	if (old != has_opaque_atom)
		regenerate_ao()
#endif

// If an opaque movable atom moves around we need to potentially update visibility.
/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()

	if (Obj && Obj.opacity && !has_opaque_atom)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

#ifdef AO_USE_LIGHTING_OPACITY
		// Hook for AO.
		regenerate_ao()
#endif

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/change_area(area/old_area, area/new_area)
	if (new_area.dynamic_lighting != old_area.dynamic_lighting)
		if (new_area.dynamic_lighting)
			lighting_build_overlay()

		else
			lighting_clear_overlay()

// This is inlined in lighting_source.dm and lighting_source_novis.dm.
// Update them too if you change this.
/turf/proc/get_corners()
	if (!dynamic_lighting && !light_sources)
		return null

	if (!lighting_corners_initialised)
		generate_missing_corners()

	if (has_opaque_atom)
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

// This is inlined in lighting_source.dm and lighting_source_novis.dm.
// Update them too if you change this.
/turf/proc/generate_missing_corners()
	if (!dynamic_lighting && !light_sources)
		return
		
	lighting_corners_initialised = TRUE
	if (!corners)
		corners = list(null, null, null, null)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i])
