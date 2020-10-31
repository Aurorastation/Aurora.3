/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "Chat Client"
	program_icon_state = "command"
	extended_desc = "This program allows communication over the NTNRC network."
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_chatclient
	color = LIGHT_COLOR_GREEN
	silent = TRUE

	var/last_message				// Used to generate the toolbar icon
	var/username
	var/datum/ntnet_conversation/channel
	var/operator_mode = FALSE		// Channel operator mode
	var/netadmin_mode = FALSE		// Administrator mode (invisible to other users + bypasses passwords)
	var/set_offline = FALSE // appear "invisible"
	var/list/directmessagechannels = list()

	var/ringtone = "beep"
	var/syndi_auth = FALSE

/datum/computer_file/program/chatclient/New(var/obj/item/modular_computer/comp)
	..(comp)
	if(!comp)
		return

/datum/computer_file/program/chatclient/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["PRG_toggleringer"])
		. = TRUE
		silent = !silent

	if(href_list["PRG_setringtone"])
		. = TRUE
		var/t = input(usr, "Please enter new ringtone", filedesc, ringtone) as text|null
		if(!usr.Adjacent(computer) || !t)
			return
		var/obj/item/device/uplink/hidden/H = computer.hidden_uplink
		if(istype(H) && H.check_trigger(usr, lowertext(t), lowertext(H.pda_code)))
			to_chat(usr, SPAN_NOTICE("\The [computer] softly beeps."))
			syndi_auth = TRUE
			SSnanoui.close_uis(NM)
		else
			t = sanitize(t, 20)
			ringtone = t

	if(href_list["PRG_speak"])
		. = TRUE
		if(!channel)
			return TRUE
		var/mob/living/user = usr
		user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] computer's screen.")
		var/message = sanitize(input(user, "Enter message or leave blank to cancel: "))
		if(!message || !channel)
			return
		channel.add_message(message, username, usr)
		message_dead(FONT_SMALL("<b>([channel.get_dead_title()]) [username]:</b> [message]"))

	if(href_list["Reply"])
		. = TRUE
		if(!channel || channel.title != href_list["target"])
			to_chat(usr, SPAN_WARNING("The target chat isn't active on your program anymore!"))
			return
		var/mob/living/user = usr
		user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] computer's screen.")
		var/message = sanitize(input(user, "Enter message or leave blank to cancel: "))
		if(!message)
			return
		if(!channel || channel.title != href_list["target"])
			to_chat(usr, SPAN_WARNING("The target chat isn't active on your program anymore!"))
			return
		channel.add_message(message, username, usr)
		message_dead(FONT_SMALL("<b>([channel.get_dead_title()]) [username]:</b> [message]"))

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
		message_dead(FONT_SMALL("<b>([C.get_dead_title()]) A new client ([username]) has entered the chat.</b>"))
		channel = C
	if(href_list["PRG_leavechannel"])
		. = TRUE
		if(channel && !channel.direct)
			channel.remove_client(src)
			message_dead(FONT_SMALL(FONT_SMALL("<b>([channel.get_dead_title()]) A client ([username]) has left the chat.</b>")))
		channel = null
	if(href_list["PRG_backtomain"])
		. = TRUE
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
		message_dead(FONT_SMALL("<b>([channel.get_dead_title()]) A new channel has been made by [username].</b>"))
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
		var/comp_name = ckey(new_name)
		for(var/cl in ntnet_global.chat_clients)
			var/datum/computer_file/program/chatclient/C = cl
			if(ckey(C.username) == comp_name || comp_name == "cancel")
				alert(user, "This nickname is already taken.")
				return TRUE
		for(var/datum/ntnet_conversation/channel in ntnet_global.chat_channels)
			if(src in channel.clients)
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
				crash_with("Var computer is null!")
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
	if(href_list["PRG_directmessage"])
		. = TRUE
		var/clients = list()
		var/names = list()
		for(var/cl in ntnet_global.chat_clients)
			var/datum/computer_file/program/chatclient/C = cl
			if(C.set_offline || C == src)
				continue
			clients[C.username] = C
			names += C.username
		names += "== Cancel =="
		var/picked = input(usr, "Select with whom you would like to start a conversation.") in names
		if(picked == "== Cancel ==")
			return
		var/datum/computer_file/program/chatclient/otherClient = clients[picked]
		if(picked)
			if(directmessagechannels[otherClient])
				channel = directmessagechannels[otherClient]
				return
			var/datum/ntnet_conversation/C = new /datum/ntnet_conversation("", TRUE)
			C.begin_direct(src, otherClient)
			channel = C
			directmessagechannels[otherClient] = C
			otherClient.directmessagechannels[src] = C


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
	if(!forced)
		var/confirm = alert("Are you sure you want to close the NTNRC Client? You will not be reachable via messaging if you do so.", "Close?", "Yes", "No")
		if((confirm != "Yes") || (CanUseTopic(usr) != STATUS_INTERACTIVE))
			return FALSE

	channel = null
	..(forced)
	return TRUE

/datum/computer_file/program/chatclient/run_program(var/mob/user)
	if(!computer)
		return
	if((!computer.registered_id && !computer.register_account(src)) && (!computer.personal_ai || !computer.personal_ai.pai))
		return
	if(!(src in ntnet_global.chat_clients))
		ntnet_global.chat_clients += src
	if(!username)
		username = username_from_id()
	return ..(user)

/datum/computer_file/program/chatclient/proc/username_from_id()
	if(!computer || !computer.registered_id)
		if(computer.personal_ai && computer.personal_ai.pai)
			return computer.personal_ai.pai.name
		return "Unknown"

	return "[computer.registered_id.registered_name] ([computer.registered_id.assignment])"

/datum/computer_file/program/chatclient/event_unregistered()
	..()
	computer.set_autorun(filename)
	ntnet_global.chat_clients -= src
	kill_program(TRUE)

/datum/computer_file/program/chatclient/event_silentmode()
	..()
	if(silent == computer.silent)
		silent = !silent

/datum/nano_module/program/computer_chatclient
	name = "Chat Client"

/datum/nano_module/program/computer_chatclient/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!ntnet_global || !ntnet_global.chat_channels)
		return

	var/datum/computer_file/program/chatclient/C = program

	if(C.computer.hidden_uplink && C.syndi_auth)
		if(alert(user, "Resume or close and secure?", name, "Resume", "Close") == "Resume")
			C.computer.hidden_uplink.trigger(user)
			return
		else
			C.syndi_auth = FALSE

	var/list/data = list()
	if(program)
		data = list("_PC" = program.get_header_data())

	if(!istype(C))
		return

	data["adminmode"] = C.netadmin_mode
	if(C.channel)
		data["title"] = C.channel.get_title(C)
		var/list/messages[0]
		for(var/M in C.channel.messages)
			messages.Add(list(list(
				"msg" = M
			)))
		data["messages"] = messages
		var/list/clients[0]
		for(var/datum/computer_file/program/chatclient/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username,
				"active" = cl.program_state > PROGRAM_STATE_KILLED
			)))
		data["clients"] = clients
		C.operator_mode = (C.channel.operator == C) ? 1 : 0
		data["is_operator"] = C.operator_mode || C.netadmin_mode
		data["is_direct"] = C.channel.direct
	else // Channel selection screen
		var/list/all_channels[0]
		for(var/datum/ntnet_conversation/conv in ntnet_global.chat_channels)
			if(conv && conv.title && conv.can_see(program))
				all_channels.Add(list(list(
					"chan" = conv.get_title(C),
					"id" = conv.id,
					"con" = (program in conv.clients)
				)))
		data["all_channels"] = all_channels

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_chat.tmpl", "NTNet Relay Chat Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
