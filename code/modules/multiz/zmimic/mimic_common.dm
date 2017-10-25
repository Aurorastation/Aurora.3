// Updates whatever openspace components may be mimicing us. On turfs this queues an openturf update on the above openturf, on movables this updates their bound movable (if present). Meaningless on any type other than `/turf` or `/atom/movable` (incl. children).
/atom/proc/update_above()
	return

/**
 * Used to check wether or not an atom can pass through a turf.
 *
 * @param	A The atom that's moving either up or down from this turf or to it.
 * @param	direction The direction of the atom's movement in relation to its
 * current position.
 *
 * @return	TRUE if A can pass in the movement direction, FALSE if not.
 */
/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return FALSE
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/**
 * Used to check whether or not the specific open turf eventually leads into spess.
 *
 * @return	TRUE if the turf eventually leads into space. FALSE otherwise.
 */
/turf/proc/is_above_space()
	var/turf/T = GetBelow(src)
	while (T && (T.flags & MIMIC_BELOW))
		T = GetBelow(T)

	return istype(T, /turf/space)

/turf/simulated/open/CanZPass(atom, direction)
	return TRUE

/turf/space/CanZPass(atom, direction)
	return TRUE
