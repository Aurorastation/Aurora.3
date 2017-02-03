// -- Effect System --
// The base type for the new processor-driven effect system.
/datum/effect_system
	var/atom/movable/holder	 	// The object this effect is attached to. If this is set, the effect will not be qdel()'d at end of processing.
	var/no_del

/datum/effect_system/New(var/queue = TRUE, var/persistant = FALSE)
	. = ..()
	no_del = persistant
	if (queue)
		src.queue()

/datum/effect_system/Destroy()
	world.log << "## DEBUG: Effect destroyed!"
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
	return no_del ? EFFECT_HALT : EFFECT_DESTROY	// Terminate effect if it's not attached to something.

/datum/effect_system/proc/bind(var/target)
	holder = target
	no_del = TRUE
	world.log << "## DEBUG: Effect bound!"
