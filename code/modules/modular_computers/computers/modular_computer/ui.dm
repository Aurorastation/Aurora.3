/obj/item/modular_computer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(ui && (!screen_on || !enabled || !computer_use_power()))
		ui.close()
		return

	if(!hard_drive || !hard_drive.stored_files || !hard_drive.stored_files.len)
		audible_message(SPAN_WARNING("\The [src] beeps three times, its screen displaying, \"DISK ERROR!\"."))
		return // No HDD, No HDD files list or no stored files. Something is very broken.

	if(!ui)
		if(active_program)
			ui = new(user, src, active_program.tgui_id, active_program.filedesc)
			ui.autoupdate = active_program.ui_auto_update
		else
			ui = new(user, src, "NTOSMain")
		ui.open()
		return

	var/old_open_ui = ui.interface
	if(active_program)
		ui.interface = active_program.tgui_id
		ui.autoupdate = active_program.ui_auto_update
		ui.title = active_program.filedesc
	else
		ui.interface = "NTOSMain"

	if(old_open_ui != ui.interface)
		// We've switched UIs!
		update_static_data(user, ui)
		ui.send_assets()

/obj/item/modular_computer/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/ntos),
	)

/obj/item/modular_computer/proc/get_header_data(list/data)
	LAZYINITLIST(data)
	data["PC_batteryicon"] = get_battery_icon()
	data["PC_showbatteryicon"] = !!battery_module
	data["PC_batterypercent"] = battery_module ? "[round(battery_module.battery.percent())] %" : "N/C"
	data["PC_apclinkicon"] = (tesla_link?.enabled && apc_powered) ? "charging.gif" : ""
	data["PC_device_theme"] = active_program ? active_program.tgui_theme : "scc"
	data["PC_ntneticon"] = get_ntnet_status_icon()
	data["PC_stationtime"] = worldtime2text()
	data["PC_stationdate"] = "[time2text(world.realtime, "DDD, Month DD")], [GLOB.game_year]"
	data["PC_showexitprogram"] = !!active_program
	data["PC_haslight"] = !!flashlight
	data["PC_lighton"] = flashlight?.enabled ? TRUE : FALSE
	data["PC_programheaders"] = list()
	if(idle_threads.len)
		var/list/program_headers = list()
		for(var/datum/computer_file/program/P as anything in idle_threads)
			if(!P.ui_header)
				continue
			program_headers.Add(list(list("icon" = P.ui_header)))
		data["PC_programheaders"] = program_headers
	return data

/obj/item/modular_computer/ui_static_data(mob/user)
	var/list/data = ..()
	if(active_program)
		data += active_program.ui_static_data(user)
		return data

	return data

/obj/item/modular_computer/ui_data(mob/user)
	var/list/data = get_header_data()
	if(active_program)
		data += active_program.ui_data(user)
		return data

	var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")
	data["programs"] = list()
	data["services"] = list()
	for(var/datum/computer_file/program/P in hard_drive.stored_files)
		if(P.program_hidden())
			continue
		if(!istype(P, /datum/computer_file/program/scanner) && !isnull(P.tgui_id))
			data["programs"] += list(list(
				"filename" = P.filename,
				"desc" = P.filedesc,
				"autorun" = istype(autorun) && (autorun.stored_data == P.filename),
				"running" = (P in idle_threads)
			))
		if(P.program_type & PROGRAM_SERVICE)
			data["services"] += list(list(
				"filename" = P.filename,
				"desc" = P.filedesc,
				"running" = (P in enabled_services) && (P.service_state > PROGRAM_STATE_KILLED)
			))

	return data

/obj/item/modular_computer/proc/get_battery_icon()
	if(battery_module)
		switch(battery_module.battery.percent())
			if(80 to 200)
				return "batt_100.gif"
			if(60 to 80)
				return "batt_80.gif"
			if(40 to 60)
				return "batt_60.gif"
			if(20 to 40)
				return "batt_40.gif"
			if(5 to 20)
				return "batt_20.gif"

	return "batt_5.gif"

/obj/item/modular_computer/proc/get_ntnet_status_icon()
	switch(get_ntnet_status())
		if(0)
			return "sig_none.gif"
		if(1)
			return "sig_low.gif"
		if(2)
			return "sig_high.gif"
		if(3)
			return "sig_lan.gif"
		else
			return ""

/obj/item/modular_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(active_program)
		. = active_program.ui_act(action, params, ui, state)

	if(action == "PC_exit")
		kill_program()
		return TRUE
	if(action == "PC_toggle_component")
		var/obj/item/computer_hardware/H = find_hardware_by_name(params["component"])
		if(istype(H))
			if(H.enabled)
				H.disable()
			else
				H.enable()
		. = TRUE
	if(action == "PC_togglelight")
		if(flashlight)
			flashlight.toggle()
		. = TRUE
	if(action == "PC_shutdown")
		shutdown_computer()
		return TRUE
	if(action == "PC_minimize")
		var/mob/user = usr
		if(user)
			minimize_program(user)
		. = TRUE
	if(action == "PC_killprogram")
		var/mob/user = usr
		var/datum/computer_file/program/P
		if(hard_drive)
			P = hard_drive.find_file_by_name(params["filename"])

		if(!istype(P) || P.program_state == PROGRAM_STATE_KILLED)
			return TRUE

		if(P.kill_program())
			to_chat(user, SPAN_NOTICE("Program [P.filename].[P.filetype] with PID [rand(100,999)] has been killed."))
		. = TRUE
	if(action == "PC_runprogram")
		run_program(params["filename"], usr)
		. = TRUE
	if(action == "PC_setautorun")
		if(hard_drive)
			set_autorun(params["filename"])
		. = TRUE
	if(action == "PC_register")
		if(registered_id)
			unregister_account()
		else if(GetID())
			register_account()
		. = TRUE
	if(action == "PC_toggleservice")
		if(params["service_to_toggle"] == "pai_access_lock" && istype(usr, /mob/living/silicon/pai))
			to_chat(usr, SPAN_WARNING("Access denied."))
		else
			toggle_service(params["service_to_toggle"], usr)
			. = TRUE

	playsound(src, click_sound, 50)
	update_icon()

/obj/item/modular_computer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. < UI_INTERACTIVE)
		if(user.machine)
			user.unset_machine()
