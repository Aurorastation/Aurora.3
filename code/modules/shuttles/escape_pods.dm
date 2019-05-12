/datum/shuttle/ferry/escape_pod
	var/capacity = 2
	var/first_try = TRUE
	location = 0
	warmup_time = 0
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/arming_controller
	var/list/destinations[5]
	var/mode = 1
	var/mode_change = FALSE

/datum/shuttle/ferry/escape_pod/init_docking_controllers()
	..()
	arming_controller = locate(dock_target_station)
	if(!istype(arming_controller))
		to_world("<span class='danger'>warning: escape pod with station dock tag [dock_target_station] could not find it's dock target!</span>")

	if(docking_controller)
		var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller_master = docking_controller.master
		if(!istype(controller_master))
			to_world("<span class='danger'>warning: escape pod with docking tag [docking_controller_tag] could not find it's controller master!</span>")
		else
			controller_master.pod = src

/datum/shuttle/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/ferry/escape_pod/can_force()
	if (arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return 0	//dont allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/ferry/escape_pod/can_cancel()
	return 0

/datum/shuttle/ferry/escape_pod/proc/check_capacity()
	var/area/A = get_area(docking_controller.master)
	var/num_mobs = 0
	if(A)
		for(var/mob/living/carbon in A.contents)
			num_mobs++
		if((num_mobs > capacity) && first_try) // Each passenger over capacity increases chances to crash by 50%
			first_try = FALSE
			docking_controller.master.visible_message("\bold [docking_controller.master]\ states \"<span class='warning'>Warning, escape pod is over capacity! The designated capacity is [capacity]. Forcing to launch may result into crashing of the pod!\"</span>")
			return FALSE
		else if(!first_try && prob((num_mobs - capacity) * 50))
			process_state = CRASH_SHUTTLE
			undock()
			docking_controller.master.visible_message("\bold [docking_controller.master]\ states \"<span class='warning'>Warning, loosing altitude. Brace for impact!\"</span>")
			return FALSE
	return TRUE

/datum/shuttle/ferry/escape_pod/launch(var/user)
	if(!can_launch() || !check_capacity())
		return
	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = WAIT_LAUNCH
	undock()

/datum/shuttle/ferry/escape_pod/crash_shuttle()
	var/distance = pick(list(10, 15, 18, 20, 22, 25, 35))
	destinations[4] = new destinations[4]
	for(var/turf/T in area_station)
		var/turf/T_n = get_turf(locate(T.x, T.y + distance, T.z))

		T_n = get_turf(locate(T.x, T.y + distance, T.z))
		if(T_n)
			destinations[4].contents += T_n
	move(area_station, destinations[4])
	explosion(pick(destinations[4].contents), 1, 0, 1, 1, 0) // explosion inside of the shuttle, as in we damaged it
	process_state = IDLE_STATE

//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	var/datum/shuttle/ferry/escape_pod/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"mode" = pod.mode,
		"mode_change" = pod.mode_change,
		"emagged" = emagged,
		"can_force" = pod.can_force() || emagged || (emergency_shuttle.departed && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["command"] == "manual_arm")
		pod.arming_controller.arm()
	else if(href_list["command"] == "force_launch")
		if (pod.can_force() || emagged)
			pod.check_capacity()
			pod.force_launch(src, emagged)
		else if (emergency_shuttle.departed && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
			pod.launch(src)
	else if(href_list["destination"])
		var/m = text2num(href_list["destination"])
		if(!m)
			return
		switch(m)
			if(1)
				pod.area_offsite = locate(pod.destinations[1])
			if(2)
				pod.area_offsite = locate(pod.destinations[2])
			if(3)
				pod.area_offsite = locate(pod.destinations[3])
		pod.mode = m
	return 0

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/emag_act(var/remaining_charges, var/mob/user)
	emagged = TRUE
	to_chat(user, span("notice", "You short circuit the control. Unlocking new destination!"))
	warn_ai("Warning: malware detected in one of the escape pods controllers!")
	return TRUE

//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/Initialize()
	. = ..()
	docking_program = new/datum/computer/file/embedded_program/docking/simple/escape_pod(src)
	program = docking_program

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/armed = null
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You emag the [src], arming the escape pod!</span>")
		emagged = 1
		if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
			var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
			if (!P.armed)
				P.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	if(!armed)
		armed = 1
		open_door()


/datum/computer/file/embedded_program/docking/simple/escape_pod/receive_user_command(command)
	if (!armed)
		return
	..(command)

/datum/computer/file/embedded_program/docking/simple/escape_pod/process()
	..()
	if (eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_docking()
	return

/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_docking()
	return 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_undocking()
	eject_time = world.time + eject_delay*10
