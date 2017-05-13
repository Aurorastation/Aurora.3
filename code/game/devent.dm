// -- Datum events --
// This is a light-weight alternative to Bay's events system.
// It's a bit more hard-coded, but simpler.

/datum/event_callback
	var/datum/callback/callback
	var/fire_id
	var/id

/datum/event_callback/New(datum/callback/callback, our_id)
	src.callback = callback
	fire_id = 0
	id = our_id

/atom/movable
	var/list/move_listeners
	var/devent_move_fireid = 0
	var/datum/callback/recursive_move_callback

/atom/movable/proc/OnMove(datum/callback/callback, id = null)
	if (!istype(callback))
		CRASH("Invalid callback supplied to OnMove().")
	
	LAZYADD(move_listeners, new /datum/event_callback(callback, id))

/atom/movable/proc/UnregisterOnMove(unregister_id)
	if (istext(unregister_id))
		// Locate the callback with the matching ID.
		for (var/thing in move_listeners)
			var/datum/event_callback/EC = thing
			if (EC.id == unregister_id)
				LAZYREMOVE(move_listeners, EC)
	else if (istype(unregister_id, /datum/callback))
		for (var/thing in move_listeners)
			var/datum/event_callback/EC = thing
			if (EC.callback == unregister_id)
				LAZYREMOVE(move_listeners, EC)
	else
		LAZYREMOVE(move_listeners, unregister_id)

/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if (move_listeners)
		// This is the current cycle of events, we only fire callbacks that have a cycle ID less than our current cycle.
		// This is to prevent a callback added to the list twice from firing twice, without much overhead.
		// As of this writing, only the Move event does this.
		devent_move_fireid++
		for (var/thing in move_listeners)
			var/datum/event_callback/EC
			var/datum/callback/cb = thing
			if (QDELING(cb))
				LAZYREMOVE(move_listeners, cb)
				continue
			
			if (cb.fire_id && cb.fire_id >= devent_move_fireid)
				// Don't fire the same callback twice if it's in the list twice.
				continue

			cb.Invoke(src, old_loc, loc)

// Copypasta from the above for performance.
/atom/movable/proc/TriggerOnMove(old_loc, new_loc)
	if (move_listeners)
		devent_move_fireid++
		for (var/thing in move_listeners)
			var/datum/event_callback/EC = thing
			if (QDELETED(EC))
				LAZYREMOVE(move_listeners, EC)
				continue

			var/datum/callback/event/cb = EC.callback
			if (QDELING(cb))
				LAZYREMOVE(move_listeners, EC)
				continue

			if (EC.fire_id && EC.fire_id >= devent_move_fireid)
				// Don't fire the same callback twice if it's in the list twice.
				continue

			cb.Invoke(src, old_loc, new_loc)

/atom/movable/Destroy()
	move_listeners = null
	return ..()

/atom/movable/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if (AM.move_listeners)
		LAZYADD(move_listeners, AM.move_listeners)

/atom/movable/Exited(atom/movable/AM, atom/old_loc)
	. = ..()
	if (AM.move_listeners)
		LAZYREMOVE(move_listeners, AM.move_listeners)

/datum
	var/list/destroy_listeners

/datum/proc/OnDestroy(datum/callback/callback)
	if (!istype(callback))
		CRASH("Invalid callback supplied to OnDestroy().")

	LAZYADD(destroy_listeners, callback)

/datum/proc/UnregisterOnDestroy(datum/callback/callback)
	LAZYREMOVE(destroy_listeners, callback)
