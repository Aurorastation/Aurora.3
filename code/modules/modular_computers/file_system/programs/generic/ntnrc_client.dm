/datum/computer_file/program/chat_client
	filename = "ntrc_client"
	filedesc = "Chat Client"
	program_icon_state = "command"
	extended_desc = "This program allows communication over the NTRC network."
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "NTRC server"
	available_on_ntnet = TRUE
	color = LIGHT_COLOR_GREEN
	silent = FALSE

	var/datum/ntnet_user/my_user
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
		playsound(computer, 'sound/machines/twobeep.ogg', 50, 1)
		computer.output_message("[icon2html(computer, world)] *[ringtone]*", 2)

/datum/computer_file/program/chat_client/Topic(href, href_list)
	if(..())
		return TRUE

	// User only commands
	if(!istype(my_user))
		return
	if(href_list["send"])
		var/mob/living/user = usr
		var/datum/ntnet_conversation/conv = locate(href_list["send"]["target"])
		var/message = sanitize(href_list["send"]["message"])
		if(istype(conv) && message)
			if(ishuman(user))
				user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
			conv.cl_send(src, message, user)
	if(href_list["join"])
		var/datum/ntnet_conversation/conv = locate(href_list["join"]["target"])
		var/password = sanitize(href_list["join"]["password"])
		if(istype(conv))
			if(conv.password)
				if(conv.password == password)
					conv.cl_join(src)
				else
					// How do I alert of password invalid?
			else
				conv.cl_join(src)
	if(href_list["leave"])
		var/datum/ntnet_conversation/conv = locate(href_list["leave"])
		if(istype(conv))
			conv.cl_leave(src)
		SSvueui.check_uis_for_change(src)
	if(href_list["kick"])
		var/datum/ntnet_conversation/conv = locate(href_list["kick"]["target"])
		var/datum/ntnet_user/tUser = locate(href_list["kick"]["user"])
		if(istype(conv) && istype(tUser))
			conv.cl_kick(src, tUser)
	if(href_list["set_password"])
		var/datum/ntnet_conversation/conv = locate(href_list["set_password"]["target"])
		var/password = sanitize(href_list["set_password"]["password"])
		if(istype(conv))
			conv.cl_set_password(src, password)
	if(href_list["new_channel"])
		ntnet_global.begin_conversation(src, sanitize(href_list["new_channel"]))
	if(href_list["delete"])
		var/datum/ntnet_conversation/conv = locate(href_list["delete"])
		if(istype(conv) && conv.can_manage(src))
			qdel(conv)
	if(href_list["direct"])
		var/datum/ntnet_user/tUser = locate(href_list["direct"])
		ntnet_global.begin_direct(src, tUser)
	if(href_list["ringtone"])
		var/newRingtone = href_list["ringtone"]
		var/obj/item/device/uplink/hidden/H = computer.hidden_uplink
		if(istype(H) && H.check_trigger(usr, lowertext(newRingtone), lowertext(H.pda_code)))
			to_chat(usr, SPAN_NOTICE("\The [computer] softly beeps."))
			syndi_auth = TRUE
			SSvueui.close_uis(src)
		else
			newRingtone = sanitize(newRingtone, 20)
			ringtone = newRingtone
	if(href_list["Reply"])
		var/mob/living/user = usr
		var/datum/ntnet_conversation/conv = locate(href_list["Reply"])
		var/message = sanitize(input(user, "Enter message or leave blank to cancel: "))
		if(istype(conv) && message)
			if(ishuman(user))
				user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
			conv.cl_send(src, message, user)
	
				
/datum/computer_file/program/chat_client/service_activate()
	. = ..()
	if(istype(my_user))
		my_user.clients.Add(src)
		ntnet_global.chat_clients.Add(src)
		return TRUE
	else
		return FALSE

/datum/computer_file/program/chat_client/service_deactivate()
	. = ..()
	my_user.clients.Remove(src)
	ntnet_global.chat_clients.Remove(src)

/datum/computer_file/program/chat_client/kill_program(var/forced = FALSE)
	return ..(forced)

/datum/computer_file/program/chat_client/run_program(var/mob/user)
	return ..(user)

/datum/computer_file/program/chat_client/event_registered()
	. = ..()
	computer.registered_id.InitializeChatUser()
	my_user = computer.registered_id.chat_user
	my_user.clients.Add(src)
	ntnet_global.chat_clients.Add(src)

/datum/computer_file/program/chat_client/event_unregistered()
	. = ..()
	my_user.clients.Remove(src)
	ntnet_global.chat_clients.Remove(src)
	my_user = null

/datum/computer_file/program/chat_client/event_silentmode()
	. = ..()
	silent = computer.silent

/datum/computer_file/program/chat_client/ui_interact(var/mob/user)
	if(computer.hidden_uplink && syndi_auth)
		if(alert(user, "Resume or close and secure?", filedesc, "Resume", "Close") == "Resume")
			computer.hidden_uplink.trigger(user)
			return
		else
			syndi_auth = FALSE

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-chat-index", 575, 700, capitalize(filedesc))
	ui.open()

/datum/computer_file/program/chat_client/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-chat-index", 575, 700, capitalize(filedesc))
	return TRUE

/datum/computer_file/program/chat_client/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	data["service"] = service_state > PROGRAM_STATE_KILLED
	data["registered"] = istype(my_user)
	data["ringtone"] = ringtone

	if(data["registered"] && data["service"])
		data["channels"] = list()
		for(var/c in ntnet_global.chat_channels)
			var/datum/ntnet_conversation/Channel = c
			if(istype(Channel) && Channel.can_see(src))
				var/ref = ref(Channel)
				var/can_interact = Channel.can_interact(src)
				var/can_manage = Channel.can_manage(src)
				data["channels"][ref] = list(
					"title" = Channel.get_title(src),
					"direct" = Channel.direct,
					"password" = !!Channel.password,
					"can_interact" = can_interact,
					"can_manage" = can_manage
				)
				if(can_interact)
					data["channels"][ref]["msg"] = Channel.messages
					data["channels"][ref]["users"] = list()
					for(var/datum/ntnet_user/U in Channel.users)
						var/uref = ref(U)
						data["channels"][ref]["users"][uref] = U.username
		data["users"] = list()
		for(var/u in ntnet_global.chat_users)
			var/datum/ntnet_user/nUser = u
			if(nUser != my_user)
				var/ref = ref(nUser)
				data["users"][ref] = nUser.username
	return data