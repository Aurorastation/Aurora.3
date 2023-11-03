var/singleton/observ/moved/moved_event = new()

/singleton/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/singleton/observ/moved/register(var/eventSource, var/datum/procOwner, var/proc_call)
	. = ..()
	var/atom/movable/child = eventSource
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && !moved_event.is_listening(parent, child))
			moved_event.register(parent, child, TYPE_PROC_REF(/atom/movable, recursive_move))
			child = parent
			parent = child.loc

/singleton/observ/moved/unregister(event_source, datum/listener, proc_call)
	. = ..()
	var/atom/movable/child = event_source
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && moved_event.is_listening(parent, child))
			moved_event.unregister(parent, child, TYPE_PROC_REF(/atom/movable, recursive_move))
			child = parent
			parent = child.loc

/singleton/observ/moved/proc/register_all_movement(var/event_source, var/listener)
	moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/singleton/observ/moved/proc/unregister_all_movement(var/event_source, var/listener)
	moved_event.unregister(event_source, listener, /atom/movable/proc/recursive_move)
	dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)

/********************
* Movement Handling *
********************/

/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	moved_event.raise_event(src, old_loc, new_loc)

/atom/Entered(var/atom/movable/am, atom/old_loc)
	..()
	moved_event.raise_event(am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(moved_event.has_listeners(am) && !moved_event.is_listening(src, am))
		moved_event.register(src, am, TYPE_PROC_REF(/atom/movable, recursive_move))

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(moved_event.is_listening(src, am, TYPE_PROC_REF(/atom/movable, recursive_move)))
		moved_event.unregister(src, am)
