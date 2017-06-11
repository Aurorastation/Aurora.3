// -- Datum events --
// This is a light-weight alternative to Bay's events system.
// It's a bit more hard-coded, but simpler.

#define EVENT_DEF(PARENT_TYPE,NAME) \
	/##PARENT_TYPE/tmp/list/##NAME_listeners; \
	##PARENT_TYPE/on_##NAME(datum/callback/callback) { \
		if (!istype(callback)) {                                     \
			CRASH("Invalid callback supplied to event listener [#NAME]."); \
		}                                                            \
		. = SOFT_REF(callback);                                      \
		LAZYSET(##NAME_listeners, callback, TRUE);                         \
	} \
	##PARENT_TYPE/unregister_on_##NAME(callback_id) { \
		var/cb = locate(unregister_id);        \
		if (!cb) {                             \
			return FALSE;                      \
		}                                      \
		var/old_len = LAZYLEN(##NAME_listeners);     \
		if (!old_len) {                        \
			return FALSE;                      \
		}                                      \
		LAZYREMOVE(##NAME_listeners, cb);            \
		return LAZYLEN(##NAME_listeners) != old_len; \
	} \
	##PARENT_TYPE/invoke_on_##NAME(...) { \
		for (var/thing in ##NAME_listeners) { \
			var/datum/callback/cb = thing; \
			cb.Invoke(...); \
		} \
	}

/atom/movable
	var/tmp/list/recursive_listeners

EVENT_DEF(/atom/movable, move)

/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if (move_listeners)
		InvokeOnMove(src, old_loc, loc)
	
	if (LAZYLEN(recursive_listeners))
		for (var/thing in recursive_listeners)
			var/atom/movable/AM = thing
			if (QDELETED(AM))
				LAZYREMOVE(recursive_listeners, AM)
				continue

			AM.invoke_on_move(src, old_loc, loc)

/atom/movable/Destroy()
	move_listeners = null
	var/atom/movable/aloc = loc
	if (istype(aloc))
		LAZYREMOVE(aloc.recursive_listeners, src)

	return ..()

/atom/movable/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if (AM.move_listeners)
		LAZYADD(recursive_listeners, AM)

/atom/movable/Exited(atom/movable/AM, atom/old_loc)
	. = ..()
	LAZYREMOVE(recursive_listeners, AM)

EVENT_DEF(/datum, Destroy)
