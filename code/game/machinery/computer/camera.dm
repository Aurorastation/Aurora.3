//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/computer/security
	name = "security camera monitor"
	desc = "Used to access the various cameras on a vessel."
	icon_screen = "cameras"
	icon_keyboard = "yellow_key"
	light_color = LIGHT_COLOR_YELLOW
	var/current_network = null
	var/obj/machinery/camera/current_camera = null
	var/last_pic = 1.0
	var/list/network
	var/mapping = 0//For the overview file, interesting bit of code.
	var/cache_id = 0
	circuit = /obj/item/circuitboard/security

/obj/machinery/computer/security/Initialize()
	if(!network)
		network = current_map.station_networks.Copy()
	. = ..()
	if(network.len)
		current_network = network[1]

/obj/machinery/computer/security/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/computer/security/check_eye(var/mob/user as mob)
	if (user.stat || user.blinded || inoperable())
		return -1
	if(!current_camera)
		return 0
	var/viewflag = current_camera.check_eye(user)
	if ( viewflag < 0 ) //camera doesn't work
		reset_current()
	return viewflag

/obj/machinery/computer/security/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(..())
		return

	var/data[0]
	var/list/all_networks[0]
	for(var/nw in network)
		all_networks.Add(list(list(
							"tag" = nw,
							"has_access" = can_access_network(user, get_camera_access(nw))
							)))

	data["networks"] = all_networks

	if(current_network)
		data["cameras"] = camera_repository.cameras_in_network(current_network)
		data["current_camera"] = current_camera ? current_camera.nano_structure() : null
		data["current_network"] = current_network

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sec_camera.tmpl", "Camera Console", 900, 800)

		ui.add_template("mapContent", "sec_camera_map_content.tmpl")
		ui.add_template("mapHeader", "sec_camera_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/security/proc/can_access_network(var/mob/user, var/network_access)
	// No access passed, or 0 which is considered no access requirement. Allow it.
	if(!network_access)
		return TRUE

	return (check_camera_access(user, access_security) && security_level >= SEC_LEVEL_BLUE) || check_camera_access(user, network_access)

/obj/machinery/computer/security/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["switch_camera"])
		var/obj/machinery/camera/C = locate(href_list["switch_camera"]) in cameranet.cameras
		if(!C)
			return
		if(!(current_network in C.network))
			return

		var/access_granted = FALSE
		for(var/network in C.network)
			if(can_access_network(usr, get_camera_access(network)))
				access_granted = TRUE //We only need access to one of the networks.
		if(!access_granted)
			to_chat(usr, SPAN_WARNING("Access unauthorized."))
			return

		switch_to_camera(usr, C)
		return 1
	else if(href_list["switch_network"])
		if(href_list["switch_network"] in network)
			current_network = href_list["switch_network"]
		return 1
	else if(href_list["reset"])
		reset_current()
		usr.reset_view(current_camera)
		return 1

/obj/machinery/computer/security/attack_hand(var/mob/user as mob)
	if (src.z > 6)
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span> You're too far away from the ship!")
		return
	if(stat & (NOPOWER|BROKEN))	return

	if(!isAI(user))
		user.set_machine(src)
		user.reset_view(current_camera)
	ui_interact(user)

/obj/machinery/computer/security/proc/switch_to_camera(var/mob/user, var/obj/machinery/camera/C)
	//don't need to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	if(isAI(user))
		var/mob/living/silicon/ai/A = user
		// Only allow non-carded AIs to view because the interaction with the eye gets all wonky otherwise.
		if(!A.is_in_chassis())
			return 0

		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return 1

	if (user.stat || user.blinded || inoperable())
		return 0
	set_current(C)

	if(!is_contact_area(get_area(C)))
		to_chat(user, SPAN_NOTICE("This camera is too far away to connect to!"))
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.reset_view(current_camera)
	else
		user.reset_view(current_camera)
	check_eye(user)
	return 1

/obj/machinery/computer/security/proc/check_camera_access(var/mob/user, var/access)
	if(!access)
		return 1

	if(!istype(user))
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		return 0

	if(access in I.access)
		return 1

	return 0

//Camera control: moving.
/obj/machinery/computer/security/proc/jump_on_click(var/mob/user,var/A)
	if(user.machine != src)
		return
	var/obj/machinery/camera/jump_to
	if(istype(A,/obj/machinery/camera))
		jump_to = A
	else if(ismob(A))
		if(ishuman(A))
			jump_to = locate() in A:head
		else if(isrobot(A))
			jump_to = A:camera
	else if(isobj(A))
		jump_to = locate() in A
	else if(isturf(A))
		var/best_dist = INFINITY
		var/check_area = get_area(A)

		if (!check_area)
			return

		for(var/cc in SSmachinery.all_cameras)
			var/obj/machinery/camera/camera = cc
			if(!camera.loc)
				continue
			if (camera.loc.loc != check_area)
				continue
			if(!camera.can_use())
				continue
			if(!can_access_camera(camera))
				continue
			var/dist = get_dist(camera,A)
			if(dist < best_dist)
				best_dist = dist
				jump_to = camera
	if(isnull(jump_to))
		return
	if(can_access_camera(jump_to))
		switch_to_camera(user,jump_to)

/obj/machinery/computer/security/process()
	if(cache_id != camera_repository.camera_cache_id)
		cache_id = camera_repository.camera_cache_id
		SSnanoui.update_uis(src)

/obj/machinery/computer/security/proc/can_access_camera(var/obj/machinery/camera/C)
	var/list/shared_networks = src.network & C.network
	if(shared_networks.len)
		return 1
	return 0

/obj/machinery/computer/security/proc/set_current(var/obj/machinery/camera/C)
	if(current_camera == C)
		return

	if(current_camera)
		reset_current()

	src.current_camera = C
	if(current_camera)
		update_use_power(POWER_USE_ACTIVE)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_initiated()

/obj/machinery/computer/security/proc/reset_current()
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_cancelled()
	current_camera = null
	update_use_power(POWER_USE_IDLE)

//Camera control: mouse.
/atom/DblClick()
	..()
	if(istype(usr.machine,/obj/machinery/computer/security))
		var/obj/machinery/computer/security/console = usr.machine
		console.jump_on_click(usr,src)

/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/computer.dmi'
	icon_state = "wallframe"
	icon_screen = null
	light_range_on = 0
	network = list(NETWORK_THUNDER)
	density = 0
	circuit = null
	is_holographic = FALSE

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	circuit = null

/obj/machinery/computer/security/wooden_tv
	name = "security camera monitor"
	desc = "An old TV hooked into the ship's camera network."
	icon = 'icons/obj/computer.dmi'
	icon_state = "television"
	icon_screen = "detective_tv"
	circuit = null
	light_color = "#3848B3"
	light_power_on = 0.5

/obj/machinery/computer/security/mining
	name = "outpost camera monitor"
	desc = "Used to access the various cameras on the outpost."
	icon_screen = "miningcameras"
	icon_keyboard = "purple_key"
	light_color = LIGHT_COLOR_PURPLE
	network = list("MINE")
	circuit = /obj/item/circuitboard/security/mining
	light_color = LIGHT_COLOR_PURPLE

/obj/machinery/computer/security/engineering
	name = "engineering camera monitor"
	desc = "Used to monitor fires and breaches."
	icon_screen = "engineeringcameras"
	icon_keyboard = "yellow_key"
	light_color = LIGHT_COLOR_YELLOW
	circuit = /obj/item/circuitboard/security/engineering

/obj/machinery/computer/security/engineering/Initialize()
	if(!network)
		network = engineering_networks.Copy()
	. = ..()

/obj/machinery/computer/security/nuclear
	name = "head mounted camera monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_screen = "syndicam"
	icon_keyboard = "red_key"
	light_color = LIGHT_COLOR_RED
	network = list(NETWORK_MERCENARY)
	circuit = null

/obj/machinery/computer/security/nuclear/Initialize()
	. = ..()
	req_access = list(150)
