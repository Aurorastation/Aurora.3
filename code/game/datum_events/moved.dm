/atom/movable
	var/list/move_listeners

/atom/movable/proc/OnMove(datum/callback/callback)
	if (!move_listeners || !move_listeners[callback.object])
		LAZYSET(move_listeners, callback.object, callback)
		if (callback.object && callback.object != GLOBAL_PROC)
			callback.object.OnDestroy(CALLBACK(src, .proc/UnregisterOnMove, callback.object))

		var/atom/movable/parent = loc
		var/atom/movable/child = src
		while (istype(parent) && (!parent.move_listeners || !(parent.move_listeners[child])))
			parent.OnMove(CALLBACK(child, .proc/recursive_move))
			child = parent
			parent = child.loc

/atom/movable/proc/UnregisterOnMove(object)
	if (!move_listeners)
		return FALSE

	move_listeners[object] = null
	move_listeners -= object

	UNSETEMPTY(move_listeners)
	. = TRUE

/atom/movable/proc/RaiseOnMove(atom/movable/source, atom/old_loc, atom/new_loc)
	if (!move_listeners)
		return FALSE

	. = 0
	for (var/thing in move_listeners)
		var/datum/callback/cb = move_listeners[thing]
		cb.InvokeAsync(source, old_loc, new_loc)
		.++

/atom/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if (AM.move_listeners)
		AM.RaiseOnMove(AM, old_loc, loc)

/atom/movable/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if (AM.move_listeners && !(move_listeners && move_listeners[AM]))
		OnMove(CALLBACK(AM, .proc/recursive_move))

/atom/movable/proc/recursive_move(atom/movable/AM, old_loc, new_loc)
	if (move_listeners)
		RaiseOnMove(AM, old_loc, new_loc)

/atom/movable/proc/move_to_destination(atom/movable/AM, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if (T && T != loc)
		forceMove(T)

/atom/movable/forceMove(atom/dest)
	var/oldloc = loc
	. = ..()
	if (. && move_listeners)
		RaiseOnMove(src, oldloc, loc)
