var/static/list/datum/walk_to_custom/walking_list = list()

// Class that is essentially walk_to. Can call a callback when finished walking or was unable to reach destination.
// Accepts same paramaters as DM walk_to, plus accespts optional callback and timeout.
/datum/walk_to_custom
	var/source 						// our starting source as reference
	var/destination 				// destination as reference
	var/min_distance
	var/lag
	var/speed
	var/datum/callback/callback		// optional callback to call to notify if we succeed or failed.
	var/timeout 					// How long should we wait if we are stuck.
	var/last_time_stuck				// last time we got stuck, in world.time 1/10th of second.
	var/turf/previous_location 		// previous location used to check if we are stuck.

/datum/walk_to_custom/proc/walk_to_custom(var/Ref, var/Trg, var/Min = 0, var/Lag = 0, var/Speed = 0, var/datum/Callback, var/Timeout = 5 SECONDS)
	source = Ref
	destination = Trg
	min_distance = Min
	lag = Lag
	speed = Speed
	callback = Callback
	timeout = Timeout

	previous_location = get_turf(Ref)
	walk_to(Ref, Trg, Min, Lag, Speed)
	START_PROCESSING(SSfast_process, src)

/datum/walk_to_custom/Destroy()
	walking_list.Remove(source)

	callback = null
	STOP_PROCESSING(SSfast_process, src)
	. = ..()

/datum/walk_to_custom/process()
	if (get_turf(source) == get_turf(destination))
		notify(TRUE)
		QDEL_NULL(src)
		return

	if (timeout > 0 && previous_location == get_turf(source))
		if (last_time_stuck && (world.time >= last_time_stuck + timeout))
			timeout()
			return
		else if (!last_time_stuck)
			last_time_stuck = world.time

	else if(timeout > 0)
		last_time_stuck = world.time

	previous_location = get_turf(source)

/datum/walk_to_custom/proc/notify(var/reached)
	if(callback)
		callback.Invoke(reached)

/datum/walk_to_custom/proc/stop()
	walk(source, 0)

/datum/walk_to_custom/proc/timeout()
	notify(FALSE)
	stop()
	QDEL_NULL(src)

// Proc that is used for walk_to_custom, similar to `walk_to`. Returns reference to walking object if you want to stop it.
// Calling it on already walking object will restart walking.
/proc/start_walking(var/Ref, var/Trg, var/Min, var/Lag, var/Speed, var/datum/Callback, var/Timeout)
	if (walking_list[Ref])
		walking_list[Ref].stop()
		QDEL_NULL(walking_list[Ref])

	var/datum/walk_to_custom/walk = new()
	walk.walk_to_custom(Ref, Trg, Min, Lag, Speed, Callback, Timeout)

	walking_list[Ref] = walk
	return walk

// Proc that is used to stol walk_to_custom.
/proc/stop_walking(var/Ref)
	if (walking_list[Ref])
		walking_list[Ref].stop()
		QDEL_NULL(walking_list[Ref])
		walking_list.Remove(Ref)