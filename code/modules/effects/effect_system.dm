// -- Effect System --
// The base type for the new processor-driven effect system.
/datum/effect_system
	var/atom/movable/holder	 	// The object this effect is attached to. If this is set, the effect will not be qdel()'d at end of processing.

/datum/effect_system/New(var/queue = TRUE)
	..()
	if (queue)
		src.queue()

/datum/effect_system/Destroy()
	if(holder)
		holder = null
	..()

// Queues an effect.
/datum/effect_system/proc/queue()
	if (effect_master)
		effect_master.queue(src)
		return 1
	return 0

/datum/effect_system/proc/process()
	return holder ? EFFECT_HALT : EFFECT_DELETE	// Terminate effect if it's not attached to something.
