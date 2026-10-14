/**
 * One independently processed cell in a cellular automaton.
 *
 * Cells of the same concrete type which enter the same turf are offered a
 * chance to merge. A cell normally lives for one subsystem tick.
 */
/datum/automata_cell
	var/turf/in_turf

/datum/automata_cell/New(turf/location)
	..()
	if(!istype(location))
		qdel(src)
		return

	in_turf = location
	LAZYADD(in_turf.autocells, src)
	GLOB.automata_cells += src
	birth()

/datum/automata_cell/Destroy()
	GLOB.automata_cells -= src
	death()
	if(in_turf)
		LAZYREMOVE(in_turf.autocells, src)
	in_turf = null
	return ..()

/datum/automata_cell/proc/birth()
	return

/datum/automata_cell/proc/death()
	return

/// Return TRUE when src should be deleted after merging with other.
/datum/automata_cell/proc/merge(datum/automata_cell/other)
	return TRUE

/datum/automata_cell/proc/propagate(direction)
	var/turf/destination = get_step(in_turf, direction)
	if(!destination)
		return
	return new type(destination)

/datum/automata_cell/proc/update_state()
	qdel(src)
