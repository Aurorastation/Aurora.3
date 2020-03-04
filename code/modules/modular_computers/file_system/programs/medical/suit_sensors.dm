/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors Monitoring"
	program_icon_state = "crew"
	extended_desc = "This program connects to life signs monitoring system to provide basic information on crew health."
	required_access_run = access_medical
	required_access_download = access_cmo
	requires_ntnet = TRUE
	network_destination = "crew lifesigns monitoring system"
	size = 11
	usage_flags = PROGRAM_LAPTOP | PROGRAM_TELESCREEN | PROGRAM_CONSOLE | PROGRAM_SILICON | PROGRAM_TABLET
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/suit_sensors/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-medical-sensors", 800, 600, "Suit Sensors Monitoring")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/suit_sensors/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, "mcomputer-medical-sensors", 800, 600, "Suit Sensors Monitoring"))
		var/datum/vueui/ui = o
		// Let's ensure our ui's autoupdate after transfer.
		// TODO: revert this value on transfer out.
		ui.auto_update_content = TRUE
	return TRUE


/datum/computer_file/program/suit_sensors/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	var/datum/signal/signal
	signal = telecomms_process_active()

	VUEUI_SET_CHECK(data["isAI"], isAI(user), ., data)
	data["crewmembers"] = list()
	if(signal.data["done"] == 1)
		for(var/z_level in current_map.map_levels)
			data["crewmembers"] += crew_repository.health_data(z_level)
	
	return data // This UI needs to constantly update


/datum/computer_file/program/suit_sensors/Topic(href, href_list)
	. = ..()

	if(href_list["track"])
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H) 