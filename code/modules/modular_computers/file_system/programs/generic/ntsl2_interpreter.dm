/datum/computer_file/program/ntsl2_interpreter
	filename = "ntslinterpreter"
	filedesc = "NTSL2++ Interpreter"
	extended_desc = "This program is used to run NTSL2++ scripts."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	usage_flags = PROGRAM_ALL
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	var/datum/ntsl2_program/computer/running
	var/is_running = FALSE
	var/datum/computer_file/script/opened
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/ntsl2_interpreter/kill_program()
	. = ..()
	if(istype(running))
		running.kill()
		running = null
		opened = null
		is_running = FALSE

/datum/computer_file/program/ntsl2_interpreter/run_program(mob/user)
	. = ..()
	if(.)
		running = SSntsl2.new_program_computer(CALLBACK(src, PROC_REF(buffer_callback_handler)))

/datum/computer_file/program/ntsl2_interpreter/Topic(href, href_list)
	if(..())
		return TRUE

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["execute_file"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/script/F = HDD.find_file_by_name(href_list["execute_file"])
		if(istype(F))
			var/code = F.code

			if(istype(running))
				running.execute(code, usr)
				is_running = TRUE

	if(href_list["stop"])
		. = TRUE
		if(istype(running))
			running.kill()
			// Prepare for next execution
			running = SSntsl2.new_program_computer(CALLBACK(src, PROC_REF(buffer_callback_handler)))
			is_running = FALSE

	if(href_list["edit_file"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/script/F = HDD.find_file_by_name(href_list["edit_file"])
		if(istype(F))
			opened = F

	if(href_list["close"])
		. = TRUE
		if(istype(opened))
			opened.code = href_list["code"]
			opened.calculate_size()
			opened = null

	if(href_list["new"])
		. = TRUE
		if(!opened)
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive

			opened = new()
			opened.filename = sanitize(href_list["new"])
			HDD.store_file(opened)

	if(href_list["execute"])
		. = TRUE
		if(istype(opened))
			opened.code = href_list["code"]
			opened.calculate_size()

			if(istype(running))
				running.execute(opened.code, usr)
				is_running = TRUE

	if(href_list["terminal_topic"])
		if(istype(running))
			running.handle_topic(href_list["terminal_topic"])
		. = TRUE

	if(.)
		SSvueui.check_uis_for_change(src)
		return FALSE

/datum/computer_file/program/ntsl2_interpreter/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-ntsl-main", 600, 520, filedesc)
	ui.open()

/datum/computer_file/program/ntsl2_interpreter/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-ntsl-main", 600, 520, filedesc)
	return TRUE

/datum/computer_file/program/ntsl2_interpreter/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	. = ..()
	data = . || data || list("mode" = "list", "terminal" = "", "code" = "", "files" = list())
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/obj/item/computer_hardware/hard_drive/hdd = computer?.hard_drive

	if(is_running && istype(running))
		data["mode"] = "program"
		data["terminal"] = running.buffer
		. = data
	else if (istype(opened))
		VUEUI_SET_CHECK(data["mode"], "edit", ., data)
		VUEUI_SET_CHECK(data["code"], opened.code, ., data)
	else
		VUEUI_SET_CHECK(data["mode"], "list", ., data)


	data["files"] = list()
	for(var/datum/computer_file/script/F in hdd?.stored_files)
		if(F.filetype == "NTS" && !F.password)
			data["files"] += list(list(
				"name" = F.filename,
				"type" = F.filetype,
				"size" = F.size,
				"undeletable" = F.undeletable
			))


/datum/computer_file/program/ntsl2_interpreter/proc/buffer_callback_handler()
	SSvueui.check_uis_for_change(src)
