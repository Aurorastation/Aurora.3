/datum/computer_file/program/ntsl2_interpreter
	filename = "ntslinterpreter"
	filedesc = "NTSL2++ Interpreter"
	extended_desc = "This program is used to run NTSL2+ programs."
	program_icon_state = "generic"
	usage_flags = PROGRAM_ALL
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	var/datum/ntsl2_program/computer/running
	var/is_running = FALSE
	var/datum/computer_file/script/opened = NULL
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/ntsl2_interpreter/kill_program()
	..()
	if(istype(running))
		running.kill()
		running = null
		is_running = FALSE

/datum/computer_file/program/ntsl2_interpreter/run_program(mob/user)
	. = ..()
	if(.)
		running = SSntsl2.new_program_computer(src)

/datum/computer_file/program/ntsl2_interpreter/Topic(href, href_list)
	if(..())
		return TRUE

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["PRG_execfile"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/data/F = HDD.find_file_by_name(href_list["PRG_execfile"])
		if(istype(F))
			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")
			is_running = TRUE
			
			if(istype(running))
				running.name = href_list["PRG_execfile"]
				running.execute(oldtext, usr)

	if(href_list["editfile"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/data/F = HDD.find_file_by_name(href_list["editfile"])
		if(istype(F))
			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")
			
			ui.data["code"] = oldtext
			. = TRUE

	if(href_list["PRG_closefile"])
		. = TRUE
		if(istype(running))
			running.kill()
			running = SSntsl2.new_program_computer(src)
			is_running = FALSE

	if(href_list["PRG_topic"])
		if(istype(running))
			running.handle_topic(href_list["PRG_topic"])
		. = 1

	if(href_list["PRG_refresh"])
		. = TRUE

	/*if(.)
		SSnanoui.update_uis(NM)
*/

/datum/computer_file/program/ntsl2_interpreter/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-ntsl-main", 450, 520, filedesc)
	ui.open()

/datum/computer_file/program/ntsl2_interpreter/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-ntsl-main", 450, 520, filedesc)
	return TRUE

/datum/computer_file/program/ntsl2_interpreter/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	. = ..()
	data = . || data || list("mode" = "list", "terminal" = "", "code" = "", "files" = "")
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	data["mode"] = "list" // List is default mode
	if(is_running)
		data["mode"] = "program"
	else if (istype(opened))
		data["mode"] = "edit"
	else
		for(var/datum/computer_file/script/F in computer?.stored_files)
			if(F.filetype == "NTS" && !F.password)
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable
				)))
	

/*
/datum/nano_module/program/computer_ntsl2_interpreter
	name = "NTSL2++ Interpreter"

/datum/nano_module/program/computer_ntsl2_interpreter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/ntsl2_interpreter/PRG
	if(program)
		PRG = program
	else
		return

	var/obj/item/computer_hardware/hard_drive/HDD

	if(!PRG.computer || !PRG.computer.hard_drive)
		data["error"] = "I/O ERROR: Unable to access hard drive."
	else if(istype(PRG.running) && PRG.is_running)
		data["running"] = PRG.running.name
		data["terminal"] = PRG.running.buffer
	else
		HDD = PRG.computer.hard_drive
		var/list/files[0]
		for(var/datum/computer_file/F in HDD.stored_files)
			if(F.filetype == "TXT" && !F.password)
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable
				)))
		data["files"] = files

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntsl_interpreter.tmpl", "NTSL2+ Interpreter", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
*/