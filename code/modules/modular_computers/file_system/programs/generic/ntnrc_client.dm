/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "NTNet Relay Chat Client"
	program_icon_state = "command"
	extended_desc = "This program allows communication over the NTNRC network."
	size = 8
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_chatclient
	var/last_message				// Used to generate the toolbar icon
	var/username
	var/datum/ntnet_conversation/channel
	var/operator_mode = FALSE		// Channel operator mode
	var/netadmin_mode = FALSE		// Administrator mode (invisible to other users + bypasses passwords)
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/chatclient/New()
	username = "DefaultUser[rand(100, 999)]"

/datum/computer_file/program/chatclient/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["PRG_speak"])
		. = TRUE
		if(!channel)
			return TRUE
		var/mob/living/user = usr
		var/message = sanitize(input(user, "Enter message or leave blank to cancel: "))
		if(!message || !channel)
			return
		channel.add_message(message, username, usr)

	if(href_list["PRG_joinchannel"])
		. = TRUE
		var/datum/ntnet_conversation/C
		for(var/datum/ntnet_conversation/chan in ntnet_global.chat_channels)
			if(chan.id == text2num(href_list["PRG_joinchannel"]))
				C = chan
				break

		if(!C)
			return TRUE

		if(netadmin_mode)
			channel = C		// Bypasses normal leave/join and passwords. Technically makes the user invisible to others.
			return TRUE

		if(C.password)
			var/mob/living/user = usr
			var/password = sanitize(input(user, "Access Denied. Enter password:"))
			if(C?.password == password)
				C.add_client(src)
				channel = C
			return TRUE
		C.add_client(src)
		channel = C
	if(href_list["PRG_leavechannel"])
		. = TRUE
		if(channel)
			channel.remove_client(src)
		channel = null
	if(href_list["PRG_newchannel"])
		. = TRUE
		var/mob/living/user = usr
		var/channel_title = sanitize(input(user, "Enter channel name or leave blank to cancel:"))
		if(!channel_title)
			return
		var/datum/ntnet_conversation/C = new /datum/ntnet_conversation(channel_title)
		C.add_client(src)
		C.operator = src
		channel = C
	if(href_list["PRG_toggleadmin"])
		. = TRUE
		if(netadmin_mode)
			netadmin_mode = FALSE
			if(channel)
				channel.remove_client(src) // We shouldn't be in channel's user list, but just in case...
				channel = null
			return TRUE
		var/mob/living/user = usr
		if(can_run(usr, 1, access_network))
			if(channel)
				var/response = alert(user, "Really engage admin-mode? You will be disconnected from your current channel!", "NTNRC Admin mode", "Yes", "No")
				if(response == "Yes")
					if(channel)
						channel.remove_client(src)
						channel = null
				else
					return
			netadmin_mode = TRUE
	if(href_list["PRG_changename"])
		. = TRUE
		var/mob/living/user = usr
		var/new_name = sanitize(input(user, "Enter new nickname or leave blank to cancel:"))
		if(!new_name)
			return TRUE
		if(channel)
			channel.add_status_message("[username] is now known as [new_name].")
		username = new_name

	if(href_list["PRG_savelog"])
		. = TRUE
		if(!channel)
			return
		var/mob/living/user = usr
		var/logname = input(user, "Enter desired logfile name (.log) or leave blank to cancel:")
		if(!logname || !channel)
			return TRUE
		var/datum/computer_file/data/logfile = new /datum/computer_file/data/logfile()
		// Now we will generate HTML-compliant file that can actually be viewed/printed.
		logfile.filename = logname
		logfile.stored_data = "\[b\]Logfile dump from NTNRC channel [channel.title]\[/b\]\[BR\]"
		for(var/logstring in channel.messages)
			logfile.stored_data += "[logstring]\[BR\]"
		logfile.stored_data += "\[b\]Logfile dump completed.\[/b\]"
		logfile.calculate_size()
		if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(logfile))
			if(!computer)
				// This program shouldn't even be runnable without computer.
				CRASH("Var computer is null!")
				return TRUE
			if(!computer.hard_drive)
				computer.visible_message("\The [computer] shows an \"I/O Error - Hard drive connection error\" warning.")
			else	// In 99.9% cases this will mean our HDD is full
				computer.visible_message("\The [computer] shows an \"I/O Error - Hard drive may be full. Please free some space and try again. Required space: [logfile.size]GQ\" warning.")
	if(href_list["PRG_renamechannel"])
		. = TRUE
		if(!operator_mode || !channel)
			return TRUE
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new channel name or leave blank to cancel:"))
		if(!newname || !channel)
			return
		channel.add_status_message("Channel renamed from [channel.title] to [newname] by operator.")
		channel.title = newname
	if(href_list["PRG_deletechannel"])
		. = TRUE
		if(channel && ((channel.operator == src) || netadmin_mode))
			qdel(channel)
			channel = null
	if(href_list["PRG_setpassword"])
		. = TRUE
		if(!channel || ((channel.operator != src) && !netadmin_mode))
			return TRUE

		var/mob/living/user = usr
		var/newpassword = sanitize(input(user, "Enter new password for this channel. Leave blank to cancel, enter 'nopassword' to remove password completely:"))
		if(!channel || !newpassword || ((channel.operator != src) && !netadmin_mode))
			return TRUE

		if(newpassword == "nopassword")
			channel.password = ""
		else
			channel.password = newpassword

/datum/computer_file/program/chatclient/process_tick()
	..()
	if(program_state != PROGRAM_STATE_KILLED)
		ui_header = "ntnrc_idle.gif"
		if(channel)
			// Remember the last message. If there is no message in the channel remember null.
			if(length(channel.messages) > 1) // len - 1 = 0 and that's array out of bounds
				last_message = channel.messages[channel.messages.len - 1]
			else
				last_message = null
		else
			last_message = null
		return 1
	if(channel?.messages?.len)
		ui_header = last_message == channel.messages[channel.messages.len - 1] ? "ntnrc_idle.gif" : "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/computer_file/program/chatclient/kill_program(var/forced = FALSE)
	if(channel)
		channel.remove_client(src)
		channel = null
	..(forced)

/datum/nano_module/program/computer_chatclient
	name = "NTNet Relay Chat Client"

/datum/nano_module/program/computer_chatclient/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!ntnet_global || !ntnet_global.chat_channels)
		return

	var/list/data = list()
	if(program)
		data = list("_PC" = program.get_header_data())

	var/datum/computer_file/program/chatclient/C = program
	if(!istype(C))
		return

	data["adminmode"] = C.netadmin_mode
	if(C.channel)
		data["title"] = C.channel.title
		var/list/messages[0]
		for(var/M in C.channel.messages)
			messages.Add(list(list(
				"msg" = M
			)))
		data["messages"] = messages
		var/list/clients[0]
		for(var/datum/computer_file/program/chatclient/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username
			)))
		data["clients"] = clients
		C.operator_mode = (C.channel.operator == C) ? 1 : 0
		data["is_operator"] = C.operator_mode || C.netadmin_mode

	else // Channel selection screen
		var/list/all_channels[0]
		for(var/datum/ntnet_conversation/conv in ntnet_global.chat_channels)
			if(conv && conv.title)
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id
				)))
		data["all_channels"] = all_channels

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_chat.tmpl", "NTNet Relay Chat Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)