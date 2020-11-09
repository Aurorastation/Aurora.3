/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/eventSource, var/datum/procOwner, var/proc_call)
	. = ..()
	var/atom/movable/child = eventSource
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && !EVENT_IS_LISTENING(moved, parent, child))
			REGISTER_EVENT(moved, parent, child, /atom/movable/proc/recursive_move)
			child = parent
			parent = child.loc

/********************
* Movement Handling *
********************/

/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	RAISE_EVENT(moved, list(src, old_loc, new_loc))

/atom/Entered(var/atom/movable/am, atom/old_loc)
	..()
	RAISE_EVENT(moved, am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(EVENT_HAS_LISTENERS(moved, am) && !EVENT_IS_LISTENING(moved, src, am))
		REGISTER_EVENT(moved, src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(EVENT_IS_LISTENING(moved, src, am, /atom/movable/proc/recursive_move))
		UNREGISTER_EVENT(moved, src, am)
