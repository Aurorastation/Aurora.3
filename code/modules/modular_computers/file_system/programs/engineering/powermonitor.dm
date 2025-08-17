/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	program_icon_state = "power_monitor"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program connects to sensors around the station to provide information about electrical systems."
	ui_header = "power_norm.gif"
	required_access_run = ACCESS_ENGINE
	required_access_download = ACCESS_CE
	requires_ntnet = TRUE
	network_destination = "power monitoring system"
	usage_flags = PROGRAM_ALL
	size = 9
	color = LIGHT_COLOR_ORANGE
	tgui_id = "PowerMonitor"
	tgui_theme = "hephaestus"
	var/has_alert = FALSE
	var/list/grid_sensors
	var/active_sensor	//name_tag of the currently selected sensor

/datum/computer_file/program/power_monitor/New()
	..()

/datum/computer_file/program/power_monitor/ui_data(mob/user)
	var/list/data = initial_data()
	var/list/sensors = list()
	var/obj/machinery/power/sensor/focus // Placeholder for selected sensor, if one has been selected from the UI list

	// Prepare list of sensors (see refresh_sensors()) and set focus to sensor based of active_sensor (see ui_act()->setsensor)
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	// Prepare return value: data["focus"] will dictate which view is visible (list or focused sensor)
	data["all_sensors"] = sensors // Represents main menu list of all found sensors
	if(focus)
		data["focus"] = focus.return_reading_data() // Force view to selected sensor, include focused sensors data
	else
		data["focus"] = null // Force view to main menu
	return data

/datum/computer_file/program/power_monitor/kill_program(forced)
	..()
	active_sensor = null // Reset UI navigation state

/datum/computer_file/program/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return TRUE
	return FALSE

// Refreshes list of active sensors kept on this computer.
/datum/computer_file/program/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/turf/T = get_turf(ui_host())
	if(!T) // Safety check
		return
	for(var/obj/machinery/power/sensor/S in SSmachinery.all_sensors)
		if(AreConnectedZLevels(S.z, computer.z) || (S.long_range))
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors += S

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/computer_file/program/power_monitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	if(action == "clear")
		active_sensor = null
		. = TRUE
	if(action == "refresh")
		refresh_sensors()
		. = TRUE
	if(action == "setsensor")
		active_sensor = params["setsensor"]
		. = TRUE

/datum/computer_file/program/power_monitor/process_tick()
	..()
	refresh_sensors()
	if(has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = TRUE
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = FALSE
