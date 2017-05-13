// -- Datum events --
// This is a light-weight alternative to Bay's events system.
// It's a bit more hard-coded, but simpler.

/atom/movable
	var/list/move_listeners

/atom/movable/proc/OnMove(datum/callback/callback)
	if (!istype(callback))
		CRASH("Invalid callback supplied to OnMove().")
	
	LAZYADD(move_listeners, callback)

/atom/movable/proc/UnregisterOnMove(datum/callback/callback)
	// Don't need to check type, removal of null or invalid type is valid.
	LAZYREMOVE(move_listeners, callback)

/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	for (var/thing in move_listeners)
		var/datum/callback/cb = thing
		if (QDELING(cb))
			LAZYREMOVE(move_listeners, cb)
			continue

		cb.Invoke(src, old_loc, loc)

/atom/movable/Destroy()
	move_listeners = null
	return ..()

/datum
	var/list/destroy_listeners

/datum/proc/OnDestroy(datum/callback/callback)
	if (!istype(callback))
		CRASH("Invalid callback supplied to OnDestroy().")

	LAZYADD(destroy_listeners, callback)

/datum/proc/UnregisterOnDestroy(datum/callback/callback)
	LAZYREMOVE(destroy_listeners, callback)
