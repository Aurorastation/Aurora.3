GLOBAL_DATUM_INIT(moved_event, /singleton/observ/moved, new)

/singleton/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/singleton/observ/moved/register(var/eventSource, var/datum/procOwner, var/proc_call)
	. = ..()
	var/atom/movable/child = eventSource
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && !GLOB.moved_event.is_listening(parent, child))
			GLOB.moved_event.register(parent, child, TYPE_PROC_REF(/atom/movable, recursive_move))
			child = parent
			parent = child.loc

/singleton/observ/moved/unregister(event_source, datum/listener, proc_call)
	. = ..()
	var/atom/movable/child = event_source
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && GLOB.moved_event.is_listening(parent, child))
			GLOB.moved_event.unregister(parent, child, TYPE_PROC_REF(/atom/movable, recursive_move))
			child = parent
			parent = child.loc

/singleton/observ/moved/proc/register_all_movement(var/event_source, var/listener)
	GLOB.moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	GLOB.dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/singleton/observ/moved/proc/unregister_all_movement(var/event_source, var/listener)
	GLOB.moved_event.unregister(event_source, listener, /atom/movable/proc/recursive_move)
	GLOB.dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)

/********************
* Movement Handling *
********************/

/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	GLOB.moved_event.raise_event(src, old_loc, new_loc)
