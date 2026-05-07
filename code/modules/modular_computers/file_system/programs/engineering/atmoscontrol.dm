/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	program_icon_state = "atmos_control"
	program_key_icon_state = "cyan_key"
	extended_desc = "This program allows remote control of air alarms around the station. This program can not be run on tablet computers."
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run =  list(ACCESS_ATMOSPHERICS)
	required_access_download = list(ACCESS_ATMOSPHERICS)
	requires_ntnet = TRUE
	network_destination = "atmospheric control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_STATIONBOUND
	size = 17
	color = LIGHT_COLOR_CYAN
	tgui_id = "AtmosAlarmControl"
	tgui_theme = "hephaestus"

	var/list/monitored_alarms = list()

/datum/computer_file/program/atmos_control/New(obj/item/modular_computer/comp, var/list/new_access, var/list/monitored_alarm_ids)
	..()
	if(islist(new_access) && length(new_access))
		required_access_run = new_access

	get_alarms(monitored_alarm_ids)
	// machines may not yet be ordered at this point
	sortTim(monitored_alarms, GLOBAL_PROC_REF(cmp_name_asc), FALSE)

/datum/computer_file/program/atmos_control/proc/get_alarms(var/list/monitored_alarm_ids)
	if(computer)
		if(monitored_alarm_ids)
			for(var/obj/machinery/alarm/alarm in SSmachinery.processing)
				if(alarm.alarm_id && (alarm.alarm_id in monitored_alarm_ids) && AreConnectedZLevels(computer.z, alarm.z))
					monitored_alarms |= alarm
		else
			/// The computer of a silicon has null Z, so...
			var/turf/T = get_turf(computer)
			for(var/obj/machinery/alarm/alarm in SSmachinery.processing)
				if(AreConnectedZLevels(T.z, alarm.z))
					monitored_alarms |= alarm

/datum/computer_file/program/atmos_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		// Opens the interface for the given air alarm.
		if("alarm")
			var/obj/machinery/alarm/alarm = locate(params["alarm"]) in (monitored_alarms.len ? monitored_alarms : SSmachinery.processing)
			if(alarm)
				alarm.ui_interact(usr)
			return TRUE
		// Manually clear and repopulate the alarm list.
		if("refresh")
			monitored_alarms = list()
			get_alarms()

/datum/computer_file/program/atmos_control/ui_data(mob/user)
	var/list/data = initial_data()

	/// It is possible that a program may have a null computer at roundstart... somehow.
	if(!length(monitored_alarms))
		get_alarms()

	var/alarms = list()
	for(var/obj/machinery/alarm/alarm in monitored_alarms)
		alarms += list(list(
			"deck" = alarm.alarm_area.horizon_deck,
			"dept" = alarm.alarm_area.department,
			"subdept" = alarm.alarm_area.subdepartment,
			"name" = alarm.alarm_area_name,
			"searchname" = alarm.alarm_area_name_full,
			"ref"= "[REF(alarm)]",
			"danger" = max(alarm.danger_level, alarm.alarm_area.atmosalm)
		))
	data["alarms"] = alarms

	return data

