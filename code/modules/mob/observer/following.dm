/mob/observer
	var/atom/following

/mob/observer/Destroy()
	. = ..()
	stop_following()

/mob/observer/proc/stop_following()
	if(!following)
		return
	destroyed_event.unregister(following, src)
	moved_event.unregister(following, src)
	dir_set_event.unregister(following, src)
	following = null

/mob/observer/proc/start_following(atom/a)
	stop_following()
	following = a
	destroyed_event.register(a, src, .proc/stop_following)
	moved_event.register(a, src, .proc/keep_following)
	dir_set_event.register(a, src, /atom/proc/recursive_dir_set)
	keep_following(new_loc = get_turf(following))

/mob/observer/proc/keep_following(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	forceMove(get_turf(new_loc))
