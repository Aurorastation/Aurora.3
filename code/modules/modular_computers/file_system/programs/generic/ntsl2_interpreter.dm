/datum/computer_file/program/ntsl2_interpreter
	filename = "ntslinterpreter"
	filedesc = "NTSL2+ Interpreter"
	extended_desc = "This program is used to run NTSL2+ programs."
	program_icon_state = "generic"
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	var/datum/ntsl_program/running
	var/last_terminal_update = 0
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/ntsl2_interpreter/process_tick()
	if(istype(running))
		running.cycle(30000)
	. = ..()

/datum/computer_file/program/ntsl2_interpreter/kill_program()
	. = ..()
	if(istype(running))
		running.kill()
		running = null

/datum/computer_file/program/ntsl2_interpreter/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, running ? "mcomputer-generic-ntsl-terminal" : "mcomputer-generic-ntsl-selectfile", 450, 520, "NTSL2+ Interpreter")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/ntsl2_interpreter/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, running ? "mcomputer-generic-ntsl-terminal" : "mcomputer-generic-ntsl-selectfile", 450, 520, "NTSL2+ Interpreter"))
		var/datum/vueui/ui = o
		ui.auto_update_content = TRUE
	return TRUE

/datum/computer_file/program/ntsl2_interpreter/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	if(running)
		if(ui.activeui != "mcomputer-generic-ntsl-terminal")
			ui.activeui = "mcomputer-generic-ntsl-terminal"
			spawn(1)
				. = data
				ui_interact(user)
			return .
		else
			VUEUI_SET_CHECK(data["running_name"], running.name, ., data)
			var term = running.get_terminal()
			
			// If the terminal has changed, update the time in the program
			if(data["terminal"] != term)
				last_terminal_update = world.time
			
			// If the last update time has changed in the program, send it to the client.
			if(data["last_update"] != last_terminal_update)
				data["terminal"] = term
				data["last_update"] = last_terminal_update
				. = data
	else
		VUEUI_SET_CHECK(ui.activeui, "mcomputer-generic-ntsl-selectfile", ., data)
		LAZYINITLIST(data["files"])
		var/obj/item/computer_hardware/hard_drive/HDD

		if(!computer || !computer.hard_drive)
			VUEUI_SET_CHECK(ui.activeui, "mcomputer-generic-ntsl-error", ., data)
			VUEUI_SET_CHECK(data["error"], "I/O ERROR: Unable to access hard drive.", ., data)
		else
			HDD = computer.hard_drive
			for(var/datum/computer_file/F in HDD.stored_files)
				if(F.filetype == "TXT" && !F.password)
					LAZYINITLIST(data["files"][F.filename])
					VUEUI_SET_CHECK(data["files"][F.filename]["name"], F.filename, ., data)
					VUEUI_SET_CHECK(data["files"][F.filename]["type"], F.filetype, ., data)
					VUEUI_SET_CHECK(data["files"][F.filename]["size"], F.size, ., data)
					VUEUI_SET_CHECK(data["files"][F.filename]["undeletable"], F.undeletable, ., data)

/datum/computer_file/program/ntsl2_interpreter/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["execfile"])
		. = TRUE
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/datum/computer_file/data/F = HDD.find_file_by_name(href_list["execfile"])
		if(istype(F))
			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")
			running = ntsl2.new_program(oldtext, src, usr)
			if(istype(running))
				running.name = href_list["execfile"]
		SSvueui.check_uis_for_change(src)
	
	if(href_list["PRG_topic"])
		if(istype(running))
			var/topc = href_list["PRG_topic"]
			if(copytext(topc, 1, 2) == "?")
				topc = copytext(topc, 2) + "?" + input("", "Enter Data")
			running.topic(topc)
			running.cycle(5000)
		SSvueui.check_uis_for_change(src)
		. = TRUE

	if(href_list["closefile"])
		. = TRUE
		if(istype(running))
			running.kill()
			running = null
		SSvueui.check_uis_for_change(src)
	
	if(href_list["refresh"])
		SSvueui.check_uis_for_change(src)
		. = TRUE

	if(href_list["commandLineInput"])
		if(istype(running))
			var/content = "cmd?" + href_list["commandLineInput"]
			running.topic(content)
			running.cycle(5000)
		SSvueui.check_uis_for_change(src)
		. = TRUE