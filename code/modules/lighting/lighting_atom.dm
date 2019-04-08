#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

/atom
	var/light_power = 1 // Intensity of the light.
	var/light_range = 0 // Range in tiles of the light.
	var/light_color     // Hexadecimal RGB string representing the colour of the light.
	var/uv_intensity = 255	// How much UV light is being emitted by this object. Valid range: 0-255.
	var/light_wedge		// The angle that the light's emission should be restricted to. null for omnidirectional.
#ifdef ENABLE_SUNLIGHT
	var/light_novis     // If TRUE, visibility checks will be skipped when calculating this light.
#endif

	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!
	var/tmp/list/light_sources       // Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.

// Nonesensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999

// The proc you should always use to set the light of this atom.
/atom/proc/set_light(var/l_range, var/l_power, var/l_color = NONSENSICAL_VALUE, var/uv = NONSENSICAL_VALUE, var/angle = NONSENSICAL_VALUE, var/no_update = FALSE)
	//L_PROF(src, "atom_setlight")

	if(l_range > 0 && l_range < MINIMUM_USEFUL_LIGHT_RANGE)
		l_range = MINIMUM_USEFUL_LIGHT_RANGE	//Brings the range up to 1.4, which is just barely brighter than the soft lighting that surrounds players.
	if (l_power != null)
		light_power = l_power

	if (l_range != null)
		light_range = l_range

	if (l_color != NONSENSICAL_VALUE)
		light_color = l_color

	if (uv != NONSENSICAL_VALUE)
		set_uv(uv, no_update = TRUE)

	if (angle != NONSENSICAL_VALUE)
		light_wedge = angle

	if (no_update)
		return

	update_light()

#undef NONSENSICAL_VALUE

/atom/proc/set_uv(var/intensity, var/no_update)
	//L_PROF(src, "atom_setuv")
	if (intensity < 0 || intensity > 255)
		intensity = min(max(intensity, 255), 0)

	uv_intensity = intensity

	if (no_update)
		return

	update_light()

// Will update the light (duh).
// Creates or destroys it if needed, makes it update values, makes sure it's got the correct source turf...
/atom/proc/update_light()
	if (QDELING(src))
		return

	//L_PROF(src, "atom_update")

	if (!light_power || !light_range) // We won't emit light anyways, destroy the light source.
		QDEL_NULL(light)
	else
		if (!istype(loc, /atom/movable)) // We choose what atom should be the top atom of the light here.
			. = src
		else
			. = loc

#ifdef ENABLE_SUNLIGHT
		if (light) // Update the light or create it if it does not exist.
			light.update(.)
		else if (light_novis)
			light = new/datum/light_source/sunlight(src, .)
		else
			light = new/datum/light_source(src, .)
#else 
		if (light)
			light.update(.)
		else
			light = new /datum/light_source(src, .)
#endif

// If we have opacity, make sure to tell (potentially) affected light sources.
/atom/movable/Destroy()
	var/turf/T = loc

	. = ..()
	
	if (opacity && istype(T))
		T.recalc_atom_opacity()
		T.reconsider_lights()


// Should always be used to change the opacity of an atom.
// It notifies (potentially) affected light sources so they can update (if needed).
/atom/proc/set_opacity(var/new_opacity)
	if (new_opacity == opacity)
		return

	//L_PROF(src, "atom_setopacity")

	opacity = new_opacity
	var/turf/T = loc
	if (!isturf(T))
		return

	if (new_opacity == TRUE)
		T.has_opaque_atom = TRUE
		T.reconsider_lights()
#ifdef AO_USE_LIGHTING_OPACITY
		T.regenerate_ao()
#endif
	else
		var/old_has_opaque_atom = T.has_opaque_atom
		T.recalc_atom_opacity()
		if (old_has_opaque_atom != T.has_opaque_atom)
			T.reconsider_lights()

/atom/movable/forceMove()
	. = ..()

	var/datum/light_source/L
	var/thing
	for (thing in light_sources)
		L = thing
		L.source_atom.update_light()
