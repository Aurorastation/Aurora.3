var/global/ntnrc_uid = 0
/datum/ntnet_conversation
	var/id
	var/title = "Untitled Conversation"
	var/datum/ntnet_user/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/list/users = list()
	var/direct = FALSE
	var/password

/datum/ntnet_conversation/New(var/name, var/no_operator)
	id = ntnrc_uid
	ntnrc_uid++
	if(name)
		title = name
	if(ntnet_global)
		ntnet_global.chat_channels.Add(src)
	if(no_operator)
		operator = "NanoTrasen Information Technology Division" // assign a fake operator
	..()

/datum/ntnet_conversation/proc/process_message(var/datum/ntnet_message/message, var/update_ui = TRUE)
	var/admin_log = message.format_admin_log()
	if (admin_log)
		log_ntirc("[message.user.client.ckey]/([message.nuser.username]): [admin_log]", ckey=key_name(message.user), conversation=title)

	for(var/datum/ntnet_user/U in users)
		for(var/datum/computer_file/program/chat_client/Cl)
			var/notification_text = message.format_chat_notification(src, Cl)
			if(notification_text && Cl.can_receive_notification(message.client))
				Cl.computer.output_message(notification_text, 0)
				if(message.play_sound)
					Cl.play_notification_sound(message.client)

	var/ntnet_log = message.format_ntnet_log(src)
	if(ntnet_log)
		ntnet_global.add_log(ntnet_log, message.client.computer.network_card, TRUE)

	var/chat_log = message.format_chat_log(src)
	if(chat_log)
		messages.Add(chat_log)
		trim_message_list()
	
	if(update_ui)
		for(var/datum/ntnet_user/U in users)
			for(var/datum/computer_file/program/chat_client/Cl)
				SSvueui.check_uis_for_change(Cl)

/datum/ntnet_conversation/proc/trim_message_list()
	if(messages.len <= 50)
		return
	for(var/message in messages)
		messages -= message
		if(messages.len <= 50)
			return

/datum/ntnet_conversation/proc/add_client(var/datum/computer_file/program/chat_client/C)
	if(!istype(C))
		return
	if (C in clients)
		return
	clients.Add(C)
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)
	for(var/datum/computer_file/program/chat_client/CC in clients)
		if(CC.can_receive_notification(C))
			if(!direct)
				CC.computer.output_message(FONT_SMALL("<b>([get_title(CC)]) <i>[C.username]</i> has entered the chat.</b>"), 0)

/datum/ntnet_conversation/proc/begin_direct(var/datum/computer_file/program/chat_client/CA, var/datum/computer_file/program/chat_client/CB)
	if(!istype(CA) || !istype(CB))
		return
	direct = TRUE
	clients.Add(CA)
	clients.Add(CB)


	
	add_status_message("[CA.username] has opened direct conversation.")
	if(CB.can_receive_notification(C))
		CB.computer.output_message(FONT_SMALL("<b>([get_title(CB)]) <i>[CA.username]</i> has opened direct conversation with you.</b>"), 0)

/datum/ntnet_conversation/proc/remove_client(var/datum/computer_file/program/chat_client/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)

	// Channel operator left, pick new operator
	if(C == operator)
		operator = null
		if(clients.len)
			var/datum/computer_file/program/chat_client/newop = pick(clients)
			changeop(newop)

	for(var/datum/computer_file/program/chat_client/CC in clients)
		if(CC.can_receive_notification(C))
			CC.computer.output_message(FONT_SMALL("<b>([get_title(CC)]) <i>[C.username]</i> has left the chat.</b>"), 0)


/datum/ntnet_conversation/proc/change_title(var/newtitle, var/datum/computer_file/program/chat_client/client)
	if(operator != client)
		return 0 // Not Authorised

	add_status_message("[client.username] has changed channel title from [get_title(client)] to [newtitle]")
	
	for(var/datum/computer_file/program/chat_client/C in clients)
		if(C.can_receive_notification(client))
			C.computer.output_message(FONT_SMALL("([get_title(C)]) <i>[client.username]</i> has changed the channel title to <b>[newtitle]</b>."), 0)
	title = newtitle



/// EXTERNAL PROCs

/datum/ntnet_conversation/proc/get_title(var/datum/computer_file/program/chat_client/cl = null)
	if(direct)
		var/names = list()
		for(var/datum/computer_file/program/chat_client/C in clients)
			names += C.username
		if(cl)
			names -= cl.username
		return "\[DM] [english_list(names)]"
	else
		return title

/datum/ntnet_conversation/proc/can_see(var/datum/computer_file/program/chat_client/cl)
	if(cl.netadmin_mode)
		return TRUE
	if(istype(cl.my_user))
		if(cl.my_user in users)
			return TRUE
	else
		for(var/datum/ntnet_user/user in users)
			if(cl in user.clients)
				return TRUE
	if(!direct)
		return TRUE
	return FALSE

/datum/ntnet_conversation/proc/can_interact(var/datum/computer_file/program/chat_client/cl)
	if(cl.netadmin_mode)
		return TRUE
	if(istype(cl.my_user))
		if(cl.my_user in users)
			return TRUE
	else
		for(var/datum/ntnet_user/user in users)
			if(cl in user.clients)
				return TRUE
	return FALSE

/datum/ntnet_conversation/proc/cl_send(var/datum/computer_file/program/chat_client/Cl, var/message)
	if(!istype(Cl))
		return
	if(!can_interact(Cl))
		return
	var/datum/ntnet_message/message/msg = new(Cl)
	msg.message = message
	process_message(msg)

/datum/ntnet_conversation/proc/cl_join(var/datum/computer_file/program/chat_client/Cl)
	if(!istype(Cl) || !can_see(Cl))
		return
	var/datum/ntnet_message/join/msg = new(Cl)
	users.Add(Cl.my_user)
	if(!operator)
		operator = Cl.my_user
		var/datum/ntnet_message/new_op/msg2 = new(Cl)
		process_message(msg, FALSE)
		process_message(msg2)
		return
	process_message(msg)

/datum/ntnet_conversation/proc/cl_leave(var/datum/computer_file/program/chat_client/Cl)
	if(!istype(Cl) || !istype(Cl.my_user) || !(Cl.my_user in users))
		return
	if(!can_interact(Cl))
		return
	var/datum/ntnet_message/leave/msg = new(Cl)
	users.Remove(Cl.my_user)
	if(operator == Cl.my_user)
		if(users.len)
			operator = pick(users)
			var/datum/ntnet_message/new_op/msg2 = new()
			msg2.nuser = operator
			process_message(msg, FALSE)
			process_message(msg2)
			return
	process_message(msg)

