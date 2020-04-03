/var/datum/controller/subsystem/arrivals/SSarrivals

/datum/controller/subsystem/arrivals
	name = "Arrivals"
	flags = SS_NO_INIT | SS_BACKGROUND | SS_NO_TICK_CHECK
	priority = SS_PRIORITY_ARRIVALS

	var/datum/shuttle/autodock/ferry/arrival/shuttle

	var/launch_time			//the time at which the shuttle will be launched
	var/wait_for_launch = 0	//if the shuttle is waiting to launch
	var/failreturnnumber = 0 // the number of times the shuttle failed to leave the station
	var/list/current_mobs = list()

/datum/controller/subsystem/arrivals/New()
	NEW_SS_GLOBAL(SSarrivals)

/datum/controller/subsystem/arrivals/fire()
	post_signal("arrivals")
	if (wait_for_launch)
		// Timing.
		if (world.time >= launch_time)	//time to launch the shuttle
			stop_launch_countdown()
			shuttle.try_jump()
			for(var/thing in current_mobs)
				var/mob/living/carbon/human/M = locate(thing)
				if (istype(M) && M.centcomm_despawn_timer)
					deltimer(M.centcomm_despawn_timer)
					M.centcomm_despawn_timer = null

			current_mobs.Cut()
	else
		// Sleep, we ain't doin' shit. on_hotzone_enter() will wake us.
		suspend()

// Called when a living mob enters the shuttle area.
/datum/controller/subsystem/arrivals/proc/on_hotzone_enter(mob/living/M)
	if (!shuttle.location)
		return

	if (istype(M))
		current_mobs += SOFTREF(M)

	wake()	// Wake the process.

	if (!wait_for_launch && shuttle.location == 1 && shuttle.moving_status == SHUTTLE_IDLE)
		set_launch_countdown(30)

/datum/controller/subsystem/arrivals/proc/on_hotzone_exit(mob/living/M)
	current_mobs -= SOFTREF(M)

//called when the shuttle has arrived.

/datum/controller/subsystem/arrivals/proc/shuttle_arrived()
	if (!shuttle.location)	//at station
		set_launch_countdown(30)	//get ready to return

/datum/controller/subsystem/arrivals/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/item/phylactery))
		return 1
	if(istype(A,/obj/effect/decal/wizard_mark))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

//begins the launch countdown and sets the amount of time left until launch
/datum/controller/subsystem/arrivals/proc/set_launch_countdown(var/seconds)
	wait_for_launch = 1
	launch_time = world.time + seconds*10
	wake()

/datum/controller/subsystem/arrivals/proc/stop_launch_countdown()
	wait_for_launch = 0

/datum/controller/subsystem/arrivals/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal, RADIO_ARRIVALS)
