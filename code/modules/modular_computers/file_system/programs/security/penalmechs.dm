/datum/computer_file/program/penal_mechs
	filename = "penalmechs"
	filedesc = "Remote Penal Monitoring"
	program_icon_state = "security"
	extended_desc = "This program allows monitoring and control of active penal miner mechs."
	required_access_run = access_armory
	required_access_download = access_armory
	requires_ntnet = 1
	available_on_ntnet = 1
	network_destination = "penal mining mech monitoring system"
	size = 11
	usage_flags = PROGRAM_ALL_REGULAR
	color = LIGHT_COLOR_ORANGE

	var/obj/machinery/camera/current_camera = null

/datum/computer_file/program/penal_mechs/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-security-penalcontroller", 500, 400, "Penal Mech Monitoring")
		ui.auto_update_content = 1
	ui.open()

/datum/computer_file/program/penal_mechs/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, "mcomputer-security-penalcontroller", 500, 400, "Penal Mech Monitoring"))
		var/datum/vueui/ui = o
		// Let's ensure our ui's autoupdate after transfer.
		// TODO: revert this value on transfer out.
		ui.auto_update_content = 1
	return TRUE

/datum/computer_file/program/penal_mechs/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	data["_PC"] = get_header_data(data["_PC"])
	
	var/datum/signal/signal
	signal = telecomms_process_active()

	var/list/mechs = list()
	var/list/robots = list()

	if(signal.data["done"])
		for(var/mech in SSvirtualreality.mechs["prisonmechs"])
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
			mechs[++mechs.len] = mechData

		for(var/robot in SSvirtualreality.robots["prisonrobots"])
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

			robots[++robots.len] = robotData

	data["mechs"] = sortByKey(mechs, "pilot")
	data["robots"] = sortByKey(robots, "pilot")

	data["current_cam_loc"] = current_camera ? "\ref[current_camera.loc]" : null

	return data // This UI needs to constantly update


/datum/computer_file/program/penal_mechs/Topic(href, href_list)
	. = ..()

	if(href_list["track_mech"])
		if(current_camera)
			reset_current()
			usr.reset_view()
		else
			var/mob/living/heavy_vehicle/M = locate(href_list["track_mech"]) in mob_list
			if(!istype(M))
				return FALSE
			var/obj/machinery/camera/C = M.camera
			if(C)
				switch_to_camera(usr, C)
		return TRUE

	if(href_list["lockdown_mech"])
		var/mob/living/heavy_vehicle/M = locate(href_list["lockdown_mech"]) in mob_list
		if(ismob(M))
			M.ToggleLockdown()
			return TRUE

	if(href_list["terminate"])
		var/mob/living/M = locate(href_list["terminate"]) in mob_list
		if(M?.old_mob && M.vr_mob)
			to_chat(M, span("warning", "Your connection to remote-controlled [M] is forcibly severed!"))
			M.body_return()
			return TRUE

	if(href_list["message_pilot"])
		var/mob/living/M = locate(href_list["message_pilot"]) in mob_list
		if(ismob(M))
			var/message = sanitize(input("Message to [M.old_mob]", "Set Message") as text|null)

			to_chat(usr, span("notice", "Sending message to [M.old_mob]: [message]"))
			to_chat(M, span("warning", "Remote Penal Monitoring: [message]"))
			return TRUE


// ToDo - Move this set of camera procs to a general datum when more VueUI programs need cameras
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
	if ( viewflag < 0 ) //camera doesn't work
		reset_current()
	return viewflag