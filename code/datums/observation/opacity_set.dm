//	Observer Pattern Implementation: Opacity Set
//		Registration type: /atom
//
//		Raised when: An /atom changes opacity using the set_opacity() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed opacity
//			/old_opacity: The opacity before the change.
//			/new_opacity: The opacity after the change.

var/singleton/observ/opacity_set/opacity_set_event = new()

/singleton/observ/opacity_set
	name = "Opacity Set"
	expected_type = /atom

/*******************
* Opacity Handling *
*******************/
/**
 * Sets the atom's opacity, calls the opacity set event, and update's the atom's turf's opacity information.
 *
 * **Parameters**:
 * - `new_opacity` boolean - The new opacity value.
 */
// /atom/proc/set_opacity(new_opacity)
// 	if(new_opacity != opacity)
// 		var/old_opacity = opacity
// 		opacity = new_opacity
// 		opacity_set_event.raise_event(src, old_opacity, new_opacity)
// 		if (isturf(loc))
// 			var/turf/T = loc
// 			if (opacity)
// 				T.has_opaque_atom = TRUE
// 				T.recalc_atom_opacity()
// 			else
// 				T.has_opaque_atom = null
// 			T.reconsider_lights()
// 		return TRUE
// 	else
// 		return FALSE

// Should always be used to change the opacity of an atom.
// It notifies (potentially) affected light sources so they can update (if needed).
/atom/proc/set_opacity(var/new_opacity)
	if (new_opacity == opacity)
		return FALSE

	//L_PROF(src, "atom_setopacity")
	
	var/old_opacity = opacity
	opacity = new_opacity
	opacity_set_event.raise_event(src, old_opacity, new_opacity)
	var/turf/T = loc
	if (!isturf(T))
		return FALSE

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
	return TRUE