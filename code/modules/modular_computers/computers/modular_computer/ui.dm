// Opens VueUI
/obj/item/modular_computer/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!screen_on || !enabled)
		if(ui)
			ui.close()
		return
	if(!computer_use_power())
		if(ui)
			ui.close()
		return

	// If we have an active program switch to it now.
	if(active_program)
		active_program.ui_interact(user)
		return

	// We are still here, that means there is no program loaded. Load the BIOS/ROM/OS/whatever you want to call it.
	// This screen simply lists available programs and user may select them.
	if(!hard_drive || !hard_drive.stored_files || !hard_drive.stored_files.len)
		visible_message(SPAN_WARNING("\The [src] beeps three times, its screen displaying, \"DISK ERROR!\"."))
		return // No HDD, No HDD files list or no stored files. Something is very broken.

	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-system-main", 400, 500, "NTOS Main Menu")
		ui.header = "modular-computer"
	ui.open()

/obj/item/modular_computer/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "mcomputer-system-main", 400, 500, "NTOS Main Menu")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = FALSE
		. = TRUE

// Gaters data for ui
/obj/item/modular_computer/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")
	VUEUI_SET_CHECK_IFNOTSET(data["programs"], list(), ., data)
	for(var/datum/computer_file/program/P in hard_drive.stored_files)
		VUEUI_SET_CHECK_IFNOTSET(data["programs"][P.filename], list(), ., data)
		VUEUI_SET_CHECK(data["programs"][P.filename]["desc"], P.filedesc, ., data)
		VUEUI_SET_CHECK(data["programs"][P.filename]["autorun"], (istype(autorun) && (autorun.stored_data == P.filename)), ., data)
		VUEUI_SET_CHECK(data["programs"][P.filename]["running"], (P in idle_threads), ., data)

// Handles user's GUI input
/obj/item/modular_computer/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["PC_exit"])
		kill_program()
		return TRUE
	if(href_list["PC_enable_component"])
		var/obj/item/computer_hardware/H = find_hardware_by_name(href_list["PC_enable_component"])
		if(H && istype(H) && !H.enabled)
			H.enabled = TRUE
		. = TRUE
	if(href_list["PC_disable_component"])
		var/obj/item/computer_hardware/H = find_hardware_by_name(href_list["PC_disable_component"])
		if(H && istype(H) && H.enabled)
			H.enabled = 0
		. = TRUE
	if(href_list["PC_shutdown"])
		shutdown_computer()
		return TRUE
	if(href_list["PC_minimize"])
		var/mob/user = usr
		minimize_program(user)

	if(href_list["PC_killprogram"])
		var/prog = href_list["PC_killprogram"]
		var/datum/computer_file/program/P
		var/mob/user = usr
		if(hard_drive)
			P = hard_drive.find_file_by_name(prog)

		if(!istype(P) || P.program_state == PROGRAM_STATE_KILLED)
			return

		P.kill_program(TRUE)
		update_uis()
		to_chat(user, SPAN_NOTICE("Program [P.filename].[P.filetype] with PID [rand(100,999)] has been killed."))

	if(href_list["PC_runprogram"])
		. = run_program(href_list["PC_runprogram"])
		ui_interact(usr)

	if(href_list["PC_setautorun"])
		if(!hard_drive)
			return
		var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")
		if(!istype(autorun))
			autorun = new /datum/computer_file/data()
			autorun.filename = "autorun"
			hard_drive.store_file(autorun)
		if(autorun.stored_data == href_list["PC_setautorun"])
			autorun.stored_data = null
		else
			autorun.stored_data = href_list["PC_setautorun"]

	if(.)
		update_uis()

// Function used to obtain data for header. All relevant entries begin with "PC_"
/obj/item/modular_computer/proc/get_header_data(data)
	if(!data)
		data = list()

	if(battery_module)
		switch(battery_module.battery.percent())
			if(80 to 200) // 100 should be maximal but just in case..
				VUEUI_SET_CHECK(data["batteryicon"], "batt_100.gif", ., data)
			if(60 to 80)
				VUEUI_SET_CHECK(data["batteryicon"], "batt_80.gif", ., data)
			if(40 to 60)
				VUEUI_SET_CHECK(data["batteryicon"], "batt_60.gif", ., data)
			if(20 to 40)
				VUEUI_SET_CHECK(data["batteryicon"], "batt_40.gif", ., data)
			if(5 to 20)
				VUEUI_SET_CHECK(data["batteryicon"], "batt_20.gif", ., data)
			else
				VUEUI_SET_CHECK(data["batteryicon"], "batt_5.gif", ., data)
		VUEUI_SET_CHECK(data["batterypercent"], "[round(battery_module.battery.percent())] %", ., data)
		data["showbatteryicon"] = 1
	else
		data["batteryicon"] = "batt_5.gif"
		VUEUI_SET_CHECK(data["batterypercent"], "N/C", ., data)
		data["showbatteryicon"] = battery_module ? 1 : 0

	if(tesla_link && tesla_link.enabled && apc_powered)
		VUEUI_SET_CHECK(data["apclinkicon"], "charging.gif", ., data)
	else
		VUEUI_SET_CHECK(data["apclinkicon"], "", ., data)

	switch(get_ntnet_status())
		if(0)
			VUEUI_SET_CHECK(data["ntneticon"], "sig_none.gif", ., data)
		if(1)
			VUEUI_SET_CHECK(data["ntneticon"], "sig_low.gif", ., data)
		if(2)
			VUEUI_SET_CHECK(data["ntneticon"], "sig_high.gif", ., data)
		if(3)
			VUEUI_SET_CHECK(data["ntneticon"], "sig_lan.gif", ., data)
		else
			VUEUI_SET_CHECK(data["ntneticon"], "", ., data)

	LAZYINITLIST(data["programheaders"])
	if(idle_threads.len)
		for(var/datum/computer_file/program/P in idle_threads)
			if(!P.ui_header)
				if(data["programheaders"][P.filename])
					data["programheaders"][P.filename] = null
					. = data
				continue
			VUEUI_SET_CHECK(data["programheaders"][P.filename], P.ui_header, ., data)

	VUEUI_SET_CHECK(data["showexitprogram"], !!active_program, ., data) // Hides "Exit Program" button on mainscreen