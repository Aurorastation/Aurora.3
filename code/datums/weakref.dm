/weakref
	var/ref

/weakref/New(datum/D)
	ref = SOFTREF(D)

/weakref/Destroy(force = 0)
	crash_with("Some fuck is trying to [force ? "force-" : ""]delete a weakref!")
	if (!force)
		return QDEL_HINT_LETMELIVE	// feck off

	return ..()

/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if (!QDELETED(D) && D.weakref == src)
		. = D
