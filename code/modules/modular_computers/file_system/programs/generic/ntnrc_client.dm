/datum/computer_file/program/chat_client
	filename = "ntnrc_client"
	filedesc = "Chat Client"
	program_icon_state = "command"
	program_key_icon_state = "green_key"
	extended_desc = "This program allows communication over the NTRC network."
	size = 2
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "NTRC server"
	color = LIGHT_COLOR_GREEN
	tgui_id = "ChatClient"

	var/datum/ntnet_user/my_user
	var/datum/ntnet_conversation/focused_conv
	var/datum/ntnet_conversation/active

	var/netadmin_mode = FALSE		// Administrator mode (invisible to other users + bypasses passwords)
	var/set_offline = FALSE			// appear "invisible"
	var/ringtone = "beep"
	var/message_mute = FALSE
	var/syndi_auth = FALSE

/datum/computer_file/program/chat_client/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(ui)
		ui.autoupdate = FALSE

/datum/computer_file/program/chat_client/Destroy()
	service_deactivate()
	my_user = null
	focused_conv = null
	active = null

	return ..()

/datum/computer_file/program/chat_client/proc/can_receive_notification(var/datum/computer_file/program/chat_client/from)
	return ((program_state > PROGRAM_STATE_KILLED || service_state > PROGRAM_STATE_KILLED) && from != src && get_signal(NTNET_COMMUNICATION))

/datum/computer_file/program/chat_client/proc/play_notification_sound(var/datum/computer_file/program/chat_client/from)
	if(!silent && src != from && (program_state == PROGRAM_STATE_BACKGROUND || (program_state == PROGRAM_STATE_KILLED && service_state == PROGRAM_STATE_ACTIVE)))
		playsound(computer, 'sound/machines/twobeep.ogg', 50, 1)
		computer.output_message("[icon2html(computer, world)] *[ringtone]*", 2)

/datum/computer_file/program/chat_client/service_activate()
	. = ..()
	if(istype(my_user) && get_signal(NTNET_COMMUNICATION))
		activate_chat_client()
		return TRUE
	else
		return FALSE

/datum/computer_file/program/chat_client/service_deactivate()
	. = ..()
	deactivate_chat_client()

/datum/computer_file/program/chat_client/run_program(var/mob/user)
	if(!istype(my_user))
		if(istype(computer, /obj/item/modular_computer/silicon))
			var/obj/item/modular_computer/silicon/SC = computer
			var/mob/living/silicon/S = SC.computer_host
			S.id_card.InitializeChatUser()
			my_user = S.id_card.chat_user
		else
			if((!computer.registered_id && !computer.register_account(src)))
				return
	if(service_state == PROGRAM_STATE_DISABLED)
		computer.enable_service(null, user, src)
	if(computer.hidden_uplink && syndi_auth)
		if(alert(user, "Resume or close and secure?", filedesc, "Resume", "Close") == "Resume")
			computer.hidden_uplink.trigger(user)
			return
		else
			syndi_auth = FALSE
	return ..(user)

/datum/computer_file/program/chat_client/event_registered()
	. = ..()
	computer.registered_id.InitializeChatUser()
	my_user = computer.registered_id.chat_user
	if(service_state > PROGRAM_STATE_KILLED)
		activate_chat_client()
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/chat_client/event_unregistered()
	. = ..()
	if(service_state > PROGRAM_STATE_KILLED)
		deactivate_chat_client()
	my_user = null
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/chat_client/event_silentmode()
	. = ..()
	silent = computer.silent
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/chat_client/event_networkfailure(background)
	computer.update_static_data_for_all_viewers()
	return ..()

/datum/computer_file/program/chat_client/proc/activate_chat_client()
	if(!istype(my_user))
		return
	if(!(src in my_user.clients))
		my_user.clients.Add(src)
	if(!(src in GLOB.ntnet_global.chat_clients))
		GLOB.ntnet_global.chat_clients.Add(src)
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/chat_client/proc/deactivate_chat_client()
	if(!istype(my_user))
		return
	if(src in my_user.clients)
		my_user.clients.Remove(src)
	if(src in GLOB.ntnet_global.chat_clients)
		GLOB.ntnet_global.chat_clients.Remove(src)
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/chat_client/proc/handle_ntnet_user_deletion(var/datum/ntnet_user)
	if(ntnet_user == src.my_user)
		service_deactivate()
		my_user = null

/datum/computer_file/program/chat_client/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["service"] = service_state > PROGRAM_STATE_KILLED
	data["registered"] = istype(my_user)
	data["signal"] = get_signal(NTNET_COMMUNICATION)
	data["ringtone"] = ringtone
	data["netadmin_mode"] = netadmin_mode
	data["can_netadmin_mode"] = can_run(user, FALSE, ACCESS_NETWORK)
	data["message_mute"] = message_mute
	if(active && active.can_interact(src))
		var/ref = text_ref(active)
		var/can_interact = active.can_interact(src)
		var/can_manage = active.can_manage(src)
		var/list/our_channel = list(
			"ref" = ref,
			"title" = active.get_title(src),
			"direct" = active.direct,
			"password" = !!active.password,
			"can_interact" = can_interact,
			"can_manage" = can_manage,
			"focused" = (focused_conv == active)
		)
		if(can_interact)
			our_channel["users"] = list()
			for(var/datum/ntnet_user/U in active.users)
				var/uref = text_ref(U)
				our_channel["users"] += list(list("ref" = uref, "username" = U.username))
		data["active"] = our_channel
		data["msg"] = active.messages
	else
		data["active"] = null
		data["msg"] = null

	return data

/datum/computer_file/program/chat_client/ui_static_data(mob/user)
	var/list/data = list()
	if(istype(my_user) && get_signal(NTNET_COMMUNICATION) && (service_state > PROGRAM_STATE_KILLED))
		data["channels"] = list()
		for(var/c in GLOB.ntnet_global.chat_channels)
			var/datum/ntnet_conversation/channel = c
			if(istype(channel) && (channel.can_see(src)))
				var/ref = text_ref(channel)
				var/can_interact = channel.can_interact(src)
				var/can_manage = channel.can_manage(src)
				var/list/our_channel = list(
					"ref" = ref,
					"title" = channel.get_title(src),
					"direct" = channel.direct,
					"password" = !!channel.password,
					"can_interact" = can_interact,
					"can_manage" = can_manage,
					"focused" = (focused_conv == channel)
				)
				if(can_interact)
					our_channel["users"] = list()
					for(var/datum/ntnet_user/U in channel.users)
						var/uref = text_ref(U)
						our_channel["users"] += list(list("ref" = uref, "username" = U.username))
				data["channels"] += list(our_channel)

		data["users"] = list()
		for(var/u in GLOB.ntnet_global.chat_users)
			var/datum/ntnet_user/ntnet_user = u
			if(ntnet_user != my_user)
				data["users"] += list(list("ref" = text_ref(ntnet_user), "username" = ntnet_user.username))
	return data

/datum/computer_file/program/chat_client/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	if(action == "ringtone")
		var/new_ringtone = params["ringtone"]
		var/obj/item/device/uplink/hidden/H = computer.hidden_uplink
		if(istype(H) && H.check_trigger(usr, lowertext(new_ringtone), lowertext(H.pda_code)))
			to_chat(usr, SPAN_NOTICE("\The [computer] softly beeps."))
			syndi_auth = TRUE
			SStgui.close_uis(src)
		else
			new_ringtone = sanitize(new_ringtone, 20)
			ringtone = new_ringtone
			. = TRUE

	if(action == "mute_message")
		message_mute = !message_mute
		. = TRUE

	// User only commands
	if(!istype(my_user))
		return

	// Following actions require signal
	if(!get_signal(NTNET_COMMUNICATION))
		to_chat(usr, FONT_SMALL(SPAN_WARNING("\The [src] displays, \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists, contact your system administrator.\".")))
		return

	if(action == "send")
		var/mob/living/user = usr
		var/datum/ntnet_conversation/conv = locate(params["target"])
		var/message = params["message"]
		if(istype(conv) && message)
			if(ishuman(user))
				user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
			conv.cl_send(src, message, user)
		. = TRUE

	if(action == "focus")
		var/mob/living/user = usr
		var/datum/ntnet_conversation/conv = locate(params["focus"])
		if(istype(conv))
			if(ishuman(user))
				user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
			if(focused_conv == conv)
				focused_conv = null
			else
				focused_conv = conv
				computer.become_hearing_sensitive()
		. = TRUE

	if(action == "join")
		var/datum/ntnet_conversation/conv = locate(params["target"])
		var/password = params["password"]
		if(istype(conv))
			if(conv.password)
				if(conv.password == password)
					conv.cl_join(src)
				else
					to_chat(usr, SPAN_WARNING("Invalid password!"))
			else
				conv.cl_join(src)
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "set_active")
		if(isnull(params["set_active"]))
			active = null
			. = TRUE
		else
			var/datum/ntnet_conversation/conv = locate(params["set_active"])
			if(istype(conv))
				active = conv
				. = TRUE

	if(action == "leave")
		var/datum/ntnet_conversation/conv = locate(params["leave"])
		if(istype(conv))
			conv.cl_leave(src)
		if(active)
			active = null
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "kick")
		var/datum/ntnet_conversation/conv = locate(params["target"])
		var/datum/ntnet_user/tUser = locate(params["user"])
		if(istype(conv) && istype(tUser))
			conv.cl_kick(src, tUser)
			. = TRUE

	if(action == "set_password")
		var/datum/ntnet_conversation/conv = locate(params["target"])
		var/password = params["password"]
		if(istype(conv))
			conv.cl_set_password(src, password)
			. = TRUE

	if(action == "change_title")
		var/datum/ntnet_conversation/conv = locate(params["target"])
		var/newTitle = params["title"]
		if(istype(conv))
			conv.cl_change_title(src, newTitle)
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "new_channel")
		GLOB.ntnet_global.begin_conversation(src, sanitize(params["new_channel"]))
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "delete")
		var/datum/ntnet_conversation/conv = locate(params["delete"])
		if(istype(conv) && conv.can_manage(src))
			GLOB.ntnet_global.chat_channels.Remove(conv)
			qdel(conv)
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "direct")
		var/datum/ntnet_user/tUser = locate(params["direct"])
		GLOB.ntnet_global.begin_direct(src, tUser)
		computer.update_static_data_for_all_viewers()
		. = TRUE

	if(action == "toggleadmin")
		if(netadmin_mode)
			netadmin_mode = FALSE
		else
			var/mob/living/user = usr
			if(can_run(user, TRUE, ACCESS_NETWORK))
				netadmin_mode = TRUE
		computer.update_static_data_for_all_viewers()
		. = TRUE

/datum/computer_file/program/chat_client/Topic(href, href_list)
	. = ..()
	if(.)
		return TRUE

	if(href_list["Reply"])
		var/mob/living/user = usr
		if(ishuman(user))
			user.visible_message("[SPAN_BOLD("\The [user]")] taps on [user.get_pronoun("his")] [computer.lexical_name]'s screen.")
		var/datum/ntnet_conversation/conv = locate(href_list["Reply"])
		var/message = tgui_input_text(user, "Enter a message or leave blank to cancel.", "Chat Client")
		if(istype(conv) && message)
			conv.cl_send(src, message, user)
