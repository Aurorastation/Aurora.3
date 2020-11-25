/datum/computer_file/program/chat_client
	filename = "ntrc_client"
	filedesc = "Chat Client"
	program_icon_state = "command"
	extended_desc = "This program allows communication over the NTRC network."
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTRC server"
	available_on_ntnet = TRUE
	color = LIGHT_COLOR_GREEN
	silent = FALSE

	var/datum/ntnet_user/my_user = null
	var/netadmin_mode = FALSE		// Administrator mode (invisible to other users + bypasses passwords)
	var/set_offline = FALSE			// appear "invisible"

	var/ringtone = "beep"
	var/syndi_auth = FALSE


/datum/computer_file/program/chat_client/Destroy()
	return ..()

/datum/computer_file/program/chat_client/proc/can_receive_notification(var/datum/computer_file/program/chat_client/from)
	return (program_state > PROGRAM_STATE_KILLED && from != src)

/datum/computer_file/program/chat_client/proc/play_notification_sound(var/datum/computer_file/program/chat_client/from)
	if(!silent && src != from && program_state == PROGRAM_STATE_BACKGROUND)
		for (var/mob/O in hearers(2, get_turf(computer)))
			playsound(computer, 'sound/machines/twobeep.ogg', 50, 1)
			computer.output_message(text("[icon2html(computer, O)] *[ringtone]*"))

/datum/computer_file/program/chat_client/Topic(href, href_list)
	if(..())
		return TRUE

	// User only commands
	if(!istype(my_user))
		return
	if(href_list["send"])
		var/mob/living/user = usr
		if(ishuman(user))
			user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
		var/datum/ntnet_conversation/conv = locate(href_list["send"]["target"])
		var/message = sanitize(href_list["send"]["message"])
		if(istype(conv))
			conv.cl_send(src, message)
	if(href_list["join"])
		var/datum/ntnet_conversation/conv = locate(href_list["join"]["target"])
		var/password = sanitize(href_list["join"]["password"])
		if(istype(conv))


/datum/computer_file/program/chat_client/proc/add_message(var/message)
	if(!message)
		return
	channel.add_message(message, username, usr)
	message_dead(FONT_SMALL("<b>([channel.get_dead_title()]) [username]:</b> [message]"))

/datum/computer_file/program/chat_client/proc/direct_message()
	var/clients = list()
	var/names = list()
	for(var/cl in ntnet_global.chat_clients)
		var/datum/computer_file/program/chat_client/C = cl
		if(C.set_offline || C == src)
			continue
		clients[C.username] = C
		names += C.username
	names += "== Cancel =="
	var/picked = input(usr, "Select with whom you would like to start a conversation.") in names
	if(picked == "== Cancel ==")
		return
	var/datum/computer_file/program/chat_client/otherClient = clients[picked]
	if(picked)
		if(directmessagechannels[otherClient])
			channel = directmessagechannels[otherClient]
			return
		var/datum/ntnet_conversation/C = new /datum/ntnet_conversation("", TRUE)
		C.begin_direct(src, otherClient)
		channel = C
		directmessagechannels[otherClient] = C
		otherClient.directmessagechannels[src] = C

/datum/computer_file/program/chat_client/kill_program(var/forced = FALSE)
	if(!forced)
		var/confirm = alert("Are you sure you want to close the NTNRC Client? You will not be reachable via messaging if you do so.", "Close?", "Yes", "No")
		if((confirm != "Yes") || (CanUseTopic(usr) != STATUS_INTERACTIVE))
			return FALSE

	ntnet_global.chat_clients -= src

	channel = null
	..(forced)
	return TRUE

/datum/computer_file/program/chat_client/run_program(var/mob/user)
	if(!computer)
		return
	if(!istype(computer, /obj/item/modular_computer/silicon))
		if((!computer.registered_id && !computer.register_account(src)))
			return
	if(!(src in ntnet_global.chat_clients))
		ntnet_global.chat_clients += src
	if(!username)
		username = username_from_id()
	return ..(user)

/datum/computer_file/program/chat_client/proc/username_from_id()
	if(istype(computer, /obj/item/modular_computer/silicon))
		var/obj/item/modular_computer/silicon/SC = computer
		return SC.computer_host.name
	if(!computer.registered_id)
		return "Unknown"

	return "[computer.registered_id.registered_name] ([computer.registered_id.assignment])"

/datum/computer_file/program/chat_client/event_unregistered()
	..()
	computer.set_autorun(filename)
	ntnet_global.chat_clients -= src
	kill_program(TRUE)

/datum/computer_file/program/chat_client/event_silentmode()
	..()
	if(computer.silent != silent)
		silent = computer.silent

/datum/computer_file/program/chat_client/ui_interact()
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-chat-index", 575, 700, capitalize(filedesc))
	ui.open()

/datum/computer_file/program/chat_client/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-chat-index", 575, 700, capitalize(filedesc))
	return TRUE

/datum/computer_file/program/clientmanager/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	