/datum/computer_file/program/ntsl2_interpreter
	filename = "ntslinterpreter"
	filedesc = "NTSL2+ Interpreter"
	extended_desc = "This program is used to run NTSL2+ programs."
	program_icon_state = "generic"
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	nanomodule_path = /datum/nano_module/program/computer_ntsl2_interpreter

	var/datum/ntsl_program/running
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/ntsl2_interpreter/process_tick()
	if(istype(running))
		running.cycle(5000)
	..()

/datum/computer_file/program/ntsl2_interpreter/kill_program()
	..()
	if(istype(running))
		running.kill()
		running = null

/datum/computer_file/program/ntsl2_interpreter/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["PRG_execfile"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/data/F = HDD.find_file_by_name(href_list["PRG_execfile"])
		if(istype(F))
			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")
			running = ntsl2.new_program(oldtext, src, usr)
			if(istype(running))
				running.name = href_list["PRG_execfile"]

	if(href_list["PRG_closefile"])
		. = TRUE
		if(istype(running))
			running.kill()
			running = null

	if(href_list["PRG_topic"])
		if(istype(running))
			var/topc = href_list["PRG_topic"]
			if(copytext(topc, 1, 2) == "?")
				topc = copytext(topc, 2) + "?" + input("", "Enter Data")
			running.topic(topc)
			running.cycle(300)
		. = TRUE

	if(href_list["PRG_refresh"])
		. = TRUE

	if(.)
		SSnanoui.update_uis(NM)


/datum/nano_module/program/computer_ntsl2_interpreter
	name = "NTSL2+ Interpreter"

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
	else if(istype(PRG.running))
		data["running"] = PRG.running.name
		data["terminal"] = PRG.running.get_terminal()
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