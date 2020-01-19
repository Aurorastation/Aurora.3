/proc/weakref(datum/D)
	if(!istype(D))
		return
	if(QDELETED(D))
		return
	if(istype(D, /datum/weakref))
		return D
	if(!D.weakref)
		D.weakref = new/datum/weakref(D)
	return D.weakref

/datum/weakref
	var/ref

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
