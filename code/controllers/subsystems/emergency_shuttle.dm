var/datum/controller/subsystem/emergency_shuttle/emergency_shuttle

/datum/controller/subsystem/emergency_shuttle
	name = "Emergency Shuttle"
	flags = SS_NO_TICK_CHECK | SS_NO_INIT

	var/datum/shuttle/autodock/ferry/emergency/shuttle

	var/launch_time			//the time at which the shuttle will be launched
	var/force_time			//the time at which the shuttle will be forced
	var/auto_recall = 0		//if set, the shuttle will be auto-recalled
	var/auto_recall_time	//the time at which the shuttle will be auto-recalled
	var/evac = 0			//1 = emergency evacuation, 0 = crew transfer
	var/wait_for_launch = 0	//if the shuttle is waiting to launch
	var/wait_for_force = 0 	//if the shuttle is waiting to be forced
	var/autopilot = 1		//set to 0 to disable the shuttle automatically launching

	var/deny_shuttle = 0	//allows admins to prevent the shuttle from being called
	var/departed = 0		//if the shuttle has left the station at least once

/datum/controller/subsystem/emergency_shuttle/Recover()
	// Just copy all the stuff over.
	src.shuttle = emergency_shuttle.shuttle
	src.launch_time = emergency_shuttle.launch_time
	src.auto_recall = emergency_shuttle.auto_recall
	src.auto_recall_time = emergency_shuttle.auto_recall_time
	src.evac = emergency_shuttle.evac
	src.wait_for_launch = emergency_shuttle.wait_for_launch
	src.autopilot = emergency_shuttle.autopilot
	src.deny_shuttle = emergency_shuttle.deny_shuttle

/datum/controller/subsystem/emergency_shuttle/New()
	NEW_SS_GLOBAL(emergency_shuttle)

/datum/controller/subsystem/emergency_shuttle/fire()
	if(!shuttle)
		return
	if (wait_for_launch)
		if (evac && auto_recall && world.time >= auto_recall_time)
			recall()
		if (world.time >= launch_time)	//time to launch the shuttle
			stop_launch_countdown()

			if (!shuttle.location)	//leaving from the station
				//launch the pods!
				for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
					if (!pod.arming_controller || pod.arming_controller.armed)
						pod.launch(src)

			if (autopilot)
				shuttle.launch(src)
	if (wait_for_force)
		if (world.time > force_time)
			stop_force_countdown()
			if(waiting_to_leave())
				shuttle.launch(src)
				shuttle.force_launch(src)


/datum/controller/subsystem/emergency_shuttle/proc/shuttle_arrived()
	if (!shuttle.location)	//at station
		if (autopilot)
			set_launch_countdown(SHUTTLE_LEAVETIME)	//get ready to return

			if (evac)
				set_force_countdown(SHUTTLE_FORCETIME)
				priority_announcement.Announce(replacetext(current_map.emergency_shuttle_docked_message, "%ETD%", round(estimate_launch_time()/60,1)), new_sound = 'sound/AI/emergencyshuttledock.ogg')
			else
				set_force_countdown(SHUTTLE_LEAVETIME)
				var/list/fields = list(
					"%ETA%" = round(emergency_shuttle.estimate_launch_time()/60,1),
					"%dock%" = current_map.dock_name
				)
				priority_announcement.Announce(replacemany(current_map.shuttle_docked_message, fields), new_sound = 'sound/AI/shuttledock.ogg')

		//arm the escape pods
		if (evac)
			for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
				if (pod.arming_controller)
					pod.arming_controller.arm()

//begins the launch countdown and sets the amount of time left until launch
/datum/controller/subsystem/emergency_shuttle/proc/set_launch_countdown(var/seconds)
	wait_for_launch = 1
	launch_time = world.time + seconds*10

//begins the launch countdown and sets the amount of time left until launch
/datum/controller/subsystem/emergency_shuttle/proc/set_force_countdown(var/seconds)
	if(!wait_for_force)
		wait_for_force = 1
		force_time = world.time + seconds*10

/datum/controller/subsystem/emergency_shuttle/proc/stop_launch_countdown()
	wait_for_launch = 0

/datum/controller/subsystem/emergency_shuttle/proc/stop_force_countdown()
	wait_for_force = 0

//calls the shuttle for an emergency evacuation
/datum/controller/subsystem/emergency_shuttle/proc/call_evac()
	if(!can_call()) return

	//set the launch timer
	autopilot = 1
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION

	evac = 1
	priority_announcement.Announce(replacetext(current_map.emergency_shuttle_called_message, "%ETA%", round(estimate_arrival_time()/60)), new_sound = 'sound/AI/emergencyshuttlecalled.ogg')
	for(var/area/A in all_areas)
		if(istype(A, /area/hallway))
			A.readyalert()

//calls the shuttle for a routine crew transfer
/datum/controller/subsystem/emergency_shuttle/proc/call_transfer()
	if(!can_call()) return

	//set the launch timer
	autopilot = 1
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION

	var/list/replacements = list(
		"%ETA%" = round(estimate_arrival_time()/60),
		"%dock%" = current_map.dock_name
	)
	priority_announcement.Announce(replacemany(current_map.shuttle_called_message, replacements), new_sound = 'sound/AI/shuttlecalled.ogg')

//recalls the shuttle
/datum/controller/subsystem/emergency_shuttle/proc/recall()
	if (!can_recall()) return

	wait_for_launch = 0
	shuttle.cancel_launch(src)

	if (evac)
		priority_announcement.Announce(current_map.emergency_shuttle_recall_message, new_sound = 'sound/AI/emergencyshuttlerecalled.ogg')

		for(var/area/A in all_areas)
			if(istype(A, /area/hallway))
				A.readyreset()
		evac = 0
	else
		priority_announcement.Announce(current_map.shuttle_recall_message, new_sound = 'sound/AI/shuttlerecalled.ogg')

/datum/controller/subsystem/emergency_shuttle/proc/can_call()
	if (!universe.OnShuttleCall(null))
		return 0
	if (deny_shuttle)
		return 0
	if (shuttle.moving_status != SHUTTLE_IDLE || !shuttle.location)	//must be idle at centcom
		return 0
	if (wait_for_launch)	//already launching
		return 0
	return 1

//this only returns 0 if it would absolutely make no sense to recall
//e.g. the shuttle is already at the station or wasn't called to begin with
//other reasons for the shuttle not being recallable should be handled elsewhere
/datum/controller/subsystem/emergency_shuttle/proc/can_recall()
	if (shuttle.moving_status == SHUTTLE_INTRANSIT)	//if the shuttle is already in transit then it's too late
		return 0
	if (!shuttle.location)	//already at the station.
		return 0
	if (!wait_for_launch)	//we weren't going anywhere, anyways...
		return 0
	return 1

/datum/controller/subsystem/emergency_shuttle/proc/get_shuttle_prep_time()
	// During mutiny rounds, the shuttle takes twice as long.
	if(SSticker.mode)
		return SHUTTLE_PREPTIME * SSticker.mode.shuttle_delay
	return SHUTTLE_PREPTIME


/*
	These procs are not really used by the controller itself, but are for other parts of the
	game whose logic depends on the emergency shuttle.
*/

//returns 1 if the shuttle is docked at the station and waiting to leave
/datum/controller/subsystem/emergency_shuttle/proc/waiting_to_leave()
	if(!shuttle)
		return
	if (shuttle.location)
		return 0	//not at station
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_INTRANSIT)

//so we don't have emergency_shuttle.shuttle.location everywhere
/datum/controller/subsystem/emergency_shuttle/proc/location()
	if (!shuttle)
		return 1 	//if we dont have a shuttle datum, just act like it's at centcom
	return shuttle.location

//returns the time left until the shuttle arrives at it's destination, in seconds
/datum/controller/subsystem/emergency_shuttle/proc/estimate_arrival_time()
	var/eta
	if (shuttle.has_arrive_time())
		//we are in transition and can get an accurate ETA
		eta = shuttle.arrive_time
	else
		//otherwise we need to estimate the arrival time using the scheduled launch time
		eta = launch_time + shuttle.move_time*10 + shuttle.warmup_time*10
	return (eta - world.time)/10

//returns the time left until the shuttle launches, in seconds
/datum/controller/subsystem/emergency_shuttle/proc/estimate_launch_time()
	return (launch_time - world.time)/10

/datum/controller/subsystem/emergency_shuttle/proc/has_eta()
	if(!shuttle)
		return
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle has gone to the station and come back at least once,
//used for game completion checking purposes
/datum/controller/subsystem/emergency_shuttle/proc/returned()
	return (departed && shuttle.moving_status == SHUTTLE_IDLE && shuttle.location)	//we've gone to the station at least once, no longer in transit and are idle back at centcom

//returns 1 if the shuttle is not idle at centcom
/datum/controller/subsystem/emergency_shuttle/proc/online()
	if (isnull(shuttle))
		return FALSE
	if (!shuttle.location)	//not at centcom
		return TRUE
	if (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)
		return TRUE
	return FALSE

//returns 1 if the shuttle is currently in transit (or just leaving) to the station
/datum/controller/subsystem/emergency_shuttle/proc/going_to_station()
	return (!shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle is currently in transit (or just leaving) to centcom
/datum/controller/subsystem/emergency_shuttle/proc/going_to_centcom()
	return (shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)


/datum/controller/subsystem/emergency_shuttle/proc/get_status_panel_eta()
	if (online())
		if (shuttle.has_arrive_time())
			var/timeleft = emergency_shuttle.estimate_arrival_time()
			return "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

		if (waiting_to_leave())
			if (shuttle.moving_status == SHUTTLE_WARMUP)
				return "Departing..."

			var/timeleft = emergency_shuttle.estimate_launch_time()
			return "ETD-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

	return ""
/*
	Some slapped-together star effects for maximum spess immershuns. Basically consists of a
	spawner, an ender, and bgstar. Spawners create bgstars, bgstars shoot off into a direction
	until they reach a starender.
*/

/obj/effect/bgstar
	name = "star"
	var/speed = 10
	var/direction = SOUTH
	layer = 2 // TURF_LAYER

/obj/effect/bgstar/New()
	..()
	pixel_x += rand(-2,30)
	pixel_y += rand(-2,30)
	var/starnum = pick("1", "1", "1", "2", "3", "4")

	icon_state = "star"+starnum

	speed = rand(2, 5)

/obj/effect/bgstar/proc/startmove()

	while(src)
		sleep(speed)
		step(src, direction)
		for(var/obj/effect/starender/E in loc)
			qdel(src)
			return

/obj/effect/starender
	invisibility = 101

/obj/effect/starspawner
	invisibility = 101
	var/spawndir = SOUTH
	var/spawning = 0

/obj/effect/starspawner/West
	spawndir = WEST

/obj/effect/starspawner/proc/startspawn()
	spawning = 1
	while(spawning)
		sleep(rand(2, 30))
		var/obj/effect/bgstar/S = new/obj/effect/bgstar(locate(x,y,z))
		S.direction = spawndir
		spawn()
			S.startmove()
