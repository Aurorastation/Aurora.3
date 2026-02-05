/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	program_key_icon_state = "cyan_key"
	ui_header = "alarm_green.gif"
	program_icon_state = "alert:0"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = TRUE
	network_destination = "alarm monitoring network"
	usage_flags = PROGRAM_ALL
	size = 5
	color = LIGHT_COLOR_CYAN
	tgui_id = "AlarmMonitoring"
	var/list_cameras = 0						// Whether or not to list camera references. A future goal would be to merge this with the enginering/security camera console. Currently really only for AI-use.
	var/list/datum/alarm_handler/alarm_handlers // The particular list of alarm handlers this alarm monitor should present to the user.
	var/has_alert = FALSE

/datum/computer_file/program/alarm_monitor/New()
	..()
	alarm_handlers = list()

/datum/computer_file/program/alarm_monitor/all
	filename = "alarmmonitorall"
	filedesc = "Alarm Monitoring (All)"
	required_access_download = ACCESS_HEADS
	required_access_run = list(ACCESS_HEADS, ACCESS_EQUIPMENT)
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE

/datum/computer_file/program/alarm_monitor/all/New()
	..()
	alarm_handlers = SSalarm.all_handlers

/datum/computer_file/program/alarm_monitor/engineering
	filename = "alarmmonitoreng"
	filedesc = "Alarm Monitoring (Engineering)"
	required_access_download = ACCESS_ENGINE
	required_access_run = ACCESS_ENGINE

/datum/computer_file/program/alarm_monitor/engineering/New()
	..()
	alarm_handlers = list(GLOB.atmosphere_alarm, GLOB.camera_alarm, GLOB.fire_alarm, GLOB.power_alarm)

/datum/computer_file/program/alarm_monitor/security
	filename = "alarmmonitorsec"
	filedesc = "Alarm Monitoring (Security)"
	required_access_download = ACCESS_SECURITY
	required_access_run = ACCESS_SECURITY

/datum/computer_file/program/alarm_monitor/security/New()
	..()
	alarm_handlers = list(GLOB.camera_alarm, GLOB.motion_alarm)

/datum/computer_file/program/alarm_monitor/proc/register_alarm(var/object, var/procName)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.register_alarm(object, procName)

/datum/computer_file/program/alarm_monitor/proc/unregister_alarm(var/object)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.unregister_alarm(object)

/datum/computer_file/program/alarm_monitor/proc/all_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.alarms

	return all_alarms

/datum/computer_file/program/alarm_monitor/proc/major_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.major_alarms()

	return all_alarms

// Modified version of above proc that uses slightly less resources, returns 1 if there is a major alarm, 0 otherwise.
/datum/computer_file/program/alarm_monitor/proc/has_major_alarms()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		if(AH.has_major_alarms())
			return TRUE

	return FALSE

/datum/computer_file/program/alarm_monitor/proc/minor_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.minor_alarms()

	return all_alarms

/datum/computer_file/program/alarm_monitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "switchTo")
		var/obj/machinery/camera/C = locate(params["switchTo"]) in GLOB.cameranet.cameras
		if(!C)
			return

		usr.switch_to_camera(C)
		return 1

/datum/computer_file/program/alarm_monitor/ui_data(mob/user)
	. = ..()
	var/list/data = initial_data()

	var/list/categories = list()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		categories += list(list("category" = AH.category, "alarms" = list()))
		for(var/datum/alarm/A in AH.major_alarms())
			var/list/cameras = list()
			var/list/lost_sources = list()

			if(isAI(user))
				for(var/obj/machinery/camera/C in A.cameras())
					cameras += list(C.nano_structure())
			for(var/datum/alarm_source/AS in A.sources)
				if(!AS.source)
					lost_sources += list(AS.source_name)

			categories[categories.len]["alarms"] += list(list(
					"name" = sanitize(A.alarm_name()),
					"origin_lost" = A.origin == null,
					"has_cameras" = cameras.len,
					"cameras" = cameras,
					"lost_sources" = lost_sources.len ? sanitize(english_list(lost_sources, nothing_text = "", and_text = ", ")) : ""))
	data["categories"] = categories
	return data

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	if(has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert:2"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = TRUE
	else
		if(has_alert)
			program_icon_state = "alert:0"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = FALSE
	return TRUE

