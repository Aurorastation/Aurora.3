/datum
	var/datum/weakref/weakref

/datum/weakref
	var/ref

// Don't use this directly, use the WEAKREF macro.
/proc/_weakref(datum/D)
	if(!istype(D) || QDELETED(D))
		return
	if(!D.weakref)
		D.weakref = new(D)
	return D.weakref

/datum/weakref/New(datum/D)
	ref = SOFTREF(D)

/datum/weakref/Destroy(force = 0)
	crash_with("Some fuck is trying to [force ? "force-" : ""]delete a weakref!")
	if (!force)
		return QDEL_HINT_LETMELIVE	// feck off

	return ..()

/datum/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if (!QDELETED(D) && D.weakref == src)
		. = D
