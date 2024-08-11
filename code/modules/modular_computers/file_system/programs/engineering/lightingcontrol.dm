/datum/computer_file/program/lighting_control
	filename = "lightctrl"
	filedesc = "Lighting Controller"
	program_icon_state = "power_monitor"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows mass-control of the station's lighting systems. This program cannot be run on tablet computers."
	required_access_run = ACCESS_HEADS
	required_access_download = ACCESS_CE
	requires_ntnet = TRUE
	network_destination = "APC Coordinator"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_STATIONBOUND
	size = 9
	color = LIGHT_COLOR_GREEN
	tgui_id = "LightingControl"
	tgui_theme = "hephaestus"

	var/context = "pub"
	var/lstate = "full"
	var/datum/weakref/lusr

/datum/computer_file/program/lighting_control/New()
	..()
	lstate = SSnightlight.is_active() ? "dark" : "full"

/datum/computer_file/program/lighting_control/proc/update_lighting()

	// whether to only select areas explicitly marked for nightlighting
	var/wl_only = context == "all" ? 0 : 1

	SSnightlight.can_fire = FALSE

	if (lstate == "dark")
		log_and_message_admins("enabled night-mode [wl_only ? "in public areas" : "globally"].", lusr.resolve())
		SSnightlight.activate(wl_only)
	else if (lstate == "full")
		log_and_message_admins("disabled night-mode [wl_only ? "in public areas" : "globally"].", lusr.resolve())
		SSnightlight.deactivate(wl_only)

/datum/computer_file/program/lighting_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	switch(action)
		if ("context")
			context = params["context"]
			. = TRUE
		if ("mode")
			lstate = params["mode"]
			. = TRUE
		if ("set")
			update_lighting()

/datum/computer_file/program/lighting_control/ui_data(mob/user)
	var/list/data = initial_data()

	lusr = WEAKREF(user)
	data["context"] = context
	data["status"] = lstate

	return data
