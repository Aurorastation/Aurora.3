/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors Monitoring"
	program_icon_state = "crew"
	program_key_icon_state = "teal_key"
	extended_desc = "This program connects to life signs monitoring system to provide basic information on crew health."
	required_access_run = ACCESS_MEDICAL
	required_access_download = ACCESS_MEDICAL
	requires_ntnet = TRUE
	network_destination = "crew lifesigns monitoring system"
	size = 11
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_STATIONBOUND
	color = LIGHT_COLOR_CYAN
	tgui_id = "SuitSensors"
	tgui_theme = "nanotrasen"

/datum/computer_file/program/suit_sensors/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	data["isAI"] = isAI(user)
	data["crewmembers"] = list()
	if(SSradio.telecomms_ping(computer))
		for(var/z_level in SSatlas.current_map.map_levels)
			data["crewmembers"] += GLOB.crew_repository.health_data(z_level)

	data["security_level"] = seclevel2num(get_security_level())

	return data

/datum/computer_file/program/suit_sensors/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "track")
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(params["track"]) in GLOB.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
