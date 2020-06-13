/datum/computer_file/program/communicator
	filename = "communi"
	filedesc = "NTNet Communicator Service"
	extended_desc = "This program allows for verbal communication over the NTNRC network."
	program_icon_state = "generic"
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_communicator_client
	var/username
	var/datum/ntnet_chatroom/channel
	var/operator_mode = FALSE		// Channel operator mode
	var/netadmin_mode = FALSE		// Administrator mode (invisible to other users + bypasses passwords)
	color = LIGHT_COLOR_GREEN

/datum/computer_file/program/communicator/New()
	username = "DefaultUser[rand(100, 999)]"

/datum/computer_file/program/communicator/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["PRG_joinchannel"])
		. = TRUE
		var/datum/ntnet_chatroom/C
		for(var/datum/ntnet_chatroom/chan in ntnet_global.communicator_channels)
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
		message_dead(FONT_SMALL("<b>([C.title]) A new client ([username]) has entered the chat.</b>"))
		channel = C
	if(href_list["PRG_leavechannel"])
		. = TRUE
		if(channel)
			channel.remove_client(src)
			message_dead(FONT_SMALL(FONT_SMALL("<b>([channel.title]) A client ([username]) has left the chat.</b>")))
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
		var/datum/ntnet_chatroom/C = new /datum/ntnet_chatroom(channel_title)
		C.add_client(src)
		C.operator = src
		channel = C
		message_dead(FONT_SMALL("<b>([channel.title]) A new channel has been made by [username].</b>"))
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
	if(href_list["PRG_renamechannel"])
		. = TRUE
		if(!operator_mode || !channel)
			return TRUE
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new channel name or leave blank to cancel:"))
		if(!newname || !channel)
			return
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

/datum/nano_module/program/computer_communicator_client
	name = "NTNet Communicator Client"

/datum/nano_module/program/computer_communicator_client/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!ntnet_global || !ntnet_global.communicator_channels)
		return

	var/list/data = list()
	if(program)
		data = list("_PC" = program.get_header_data())

	var/datum/computer_file/program/communicator/C = program
	if(!istype(C))
		return

	data["adminmode"] = C.netadmin_mode
	if(C.channel)
		data["title"] = C.channel.title
		var/list/clients[0]
		for(var/datum/computer_file/program/communicator/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username,
				"active" = cl.program_state > PROGRAM_STATE_KILLED
			)))
		data["clients"] = clients
		C.operator_mode = (C.channel.operator == C) ? 1 : 0
		data["is_operator"] = C.operator_mode || C.netadmin_mode
	else // Channel selection screen
		var/list/all_channels[0]
		for(var/datum/ntnet_chatroom/conv in ntnet_global.communicator_channels)
			if(conv?.title)
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id,
					"con" = (program in conv.clients)
				)))
		data["all_channels"] = all_channels

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_communicator.tmpl", "NTNet Communicator Service", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)