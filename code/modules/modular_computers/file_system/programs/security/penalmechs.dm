/datum/computer_file/program/penal_mechs
	filename = "penalrobotics"
	filedesc = "Remote Penal Monitoring"
	program_icon_state = "security"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows monitoring and control of active penal robotics."
	required_access_run = ACCESS_ARMORY
	required_access_download = ACCESS_ARMORY
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	network_destination = "penal robotics monitoring system"
	size = 11
	usage_flags = PROGRAM_ALL_REGULAR
	color = LIGHT_COLOR_ORANGE
	tgui_id = "PenalMechs"

	var/obj/machinery/camera/current_camera

/datum/computer_file/program/penal_mechs/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	data["_PC"] = get_header_data(data["_PC"])

	var/list/mechs = list()
	var/list/robots = list()

	if(SSradio.telecomms_ping(computer))
		for(var/mech in SSvirtualreality.mechs[REMOTE_PRISON_MECH])
			var/mob/living/heavy_vehicle/M = mech

			if(!ismech(M))
				continue
			if(!AreConnectedZLevels(computer.loc.z, M.loc.z))
				continue
			var/list/mechData = list("location" = null, "name" = null, "pilot" = null, "ref" = "\ref[M]", "camera" = null, "lockdown" = null)

			mechData["name"] = M.name
			mechData["pilot"] = "[M.old_mob]"
			var/turf/mech_turf = get_turf(M)
			mechData["location"] = "[mech_turf.x], [mech_turf.y], [mech_turf.z]"

			mechData["camera_status"] = M.camera.status
			mechData["lockdown"] = M.lockdown
			mechs += list(mechData)

		for(var/robot in SSvirtualreality.robots[REMOTE_PRISON_ROBOT])
			var/mob/living/R = robot

			if(!ismob(R))
				continue
			if(!AreConnectedZLevels(computer.loc.z, R.loc.z))
				continue
			var/list/robotData = list("location" = null, "name" = null, "pilot" = null, "ref" = "\ref[R]")

			robotData["name"] = R.name
			robotData["pilot"] = "[R.old_mob]"
			var/turf/robot_turf = get_turf(R)
			robotData["location"] = "[robot_turf.x], [robot_turf.y], [robot_turf.z]"

			robots += list(robotData)

	data["mechs"] = sortByKey(mechs, "pilot")
	data["robots"] = sortByKey(robots, "pilot")

	data["current_cam_loc"] = current_camera ? "\ref[current_camera.loc]" : null

	return data


/datum/computer_file/program/penal_mechs/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("track_mech")
			if(current_camera)
				reset_current()
				usr.reset_view()
			else
				var/mob/living/heavy_vehicle/M = locate(params["track_mech"]) in GLOB.mob_list
				if(!istype(M))
					return FALSE
				var/obj/machinery/camera/C = M.camera
				if(C)
					switch_to_camera(usr, C)
			return TRUE

		if("lockdown_mech")
			var/mob/living/heavy_vehicle/M = locate(params["lockdown_mech"]) in GLOB.mob_list
			if(ismob(M))
				M.ToggleLockdown()
				return TRUE

		if("terminate")
			var/mob/living/M = locate(params["terminate"]) in GLOB.mob_list
			if(M?.old_mob && M.vr_mob)
				to_chat(M, SPAN_WARNING("Your connection to remote-controlled [M] is forcibly severed!"))
				M.body_return()
				return TRUE

		if("message_pilot")
			var/mob/living/M = locate(params["message_pilot"]) in GLOB.mob_list
			if(ismob(M))
				var/message = sanitize(input("Message to [M.old_mob]", "Set Message") as text|null)

				to_chat(usr, SPAN_NOTICE("Sending message to [M.old_mob]: [message]"))
				to_chat(M, SPAN_WARNING("Remote Penal Monitoring: [message]"))
				return TRUE

/datum/computer_file/program/penal_mechs/proc/switch_to_camera(var/mob/user, var/obj/machinery/camera/C)
	//don't need to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	if(isAI(user))
		var/mob/living/silicon/ai/A = user
		// Only allow non-carded AIs to view because the interaction with the eye gets all wonky otherwise.
		if(!A.is_in_chassis())
			return FALSE

		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return TRUE

	if(!is_contact_area(get_area(C)))
		to_chat(user, SPAN_NOTICE("This camera is too far away to connect to!"))
		return FALSE

	set_current(C)
	user.machine = ui_host()
	user.reset_view(current_camera)
	check_eye(user)
	return TRUE

/datum/computer_file/program/penal_mechs/proc/set_current(var/obj/machinery/camera/C)
	if(current_camera == C)
		return

	if(current_camera)
		reset_current()

	current_camera = C
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_initiated()

/datum/computer_file/program/penal_mechs/proc/reset_current()
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_cancelled()
	current_camera = null

/datum/computer_file/program/penal_mechs/check_eye(var/mob/user)
	if(!current_camera)
		return FALSE
	var/viewflag = current_camera.check_eye(user)
	if(viewflag < 0) //camera doesn't work
		reset_current()
	return viewflag
