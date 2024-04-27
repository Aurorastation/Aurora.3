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
	if(GLOB.ntnet_global)
		GLOB.ntnet_global.chat_channels.Add(src)
	if(no_operator)
		operator = "NanoTrasen Information Technology Division" // assign a fake operator
	..()

/datum/ntnet_conversation/proc/process_message(var/datum/ntnet_message/message, var/update_ui = TRUE)
	var/admin_log = message.format_admin_log()
	if (admin_log)
		log_ntirc("[message.user.client.ckey] ([message.user.client.mob.real_name])|([message.nuser.username]) -> ([title]): [GLOB.admin_log]", ckey=key_name(message.user), conversation=title)

	for(var/datum/ntnet_user/U in users)
		for(var/datum/computer_file/program/chat_client/Cl in U.clients)
			var/notification_text = message.format_chat_notification(src, Cl)
			if(notification_text && Cl.can_receive_notification(message.client))
				if(!Cl.message_mute)
					Cl.computer.output_message(notification_text, 0)
				if(message.play_sound)
					Cl.play_notification_sound(message.client)

	var/ntnet_log = message.format_ntnet_log(src)
	if(ntnet_log)
		GLOB.ntnet_global.add_log(ntnet_log, message.client.computer.network_card, TRUE)

	var/chat_log = message.format_chat_log(src)
	if(chat_log)
		messages.Add(chat_log)
		trim_message_list()

	if(update_ui)
		for(var/datum/ntnet_user/U in users)
			for(var/datum/computer_file/program/chat_client/Cl in U.clients)
				SStgui.update_uis(Cl)

/datum/ntnet_conversation/proc/trim_message_list()
	if(messages.len <= 50)
		return
	for(var/message in messages)
		messages -= message
		if(messages.len <= 50)
			return

/// EXTERNAL PROCs

/datum/ntnet_conversation/proc/get_title(var/datum/computer_file/program/chat_client/cl = null)
	if(direct)
		var/names = list()
		for(var/datum/ntnet_user/U in users)
			names += U.username
		if(istype(cl) && istype(cl.my_user))
			names -= cl.my_user.username
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

/datum/ntnet_conversation/proc/can_manage(var/datum/computer_file/program/chat_client/cl)
	if(cl.netadmin_mode)
		return TRUE
	if(cl.my_user == operator)
		return TRUE
	return FALSE

/datum/ntnet_conversation/proc/cl_send(var/datum/computer_file/program/chat_client/Cl, var/message, var/mob/user)
	if(!istype(Cl) || !can_interact(Cl))
		return
	var/datum/ntnet_message/message/msg = new(Cl)
	msg.message = message
	msg.user = user
	process_message(msg)

/datum/ntnet_conversation/proc/cl_join(var/datum/computer_file/program/chat_client/Cl)
	if(!istype(Cl) || !can_see(Cl) || direct)
		return
	if(Cl.my_user in users)
		return
	var/datum/ntnet_message/join/msg = new(Cl)
	Cl.my_user.channels.Add(src)
	users.Add(Cl.my_user)
	if(!operator)
		operator = Cl.my_user
		var/datum/ntnet_message/new_op/msg2 = new(Cl)
		process_message(msg, FALSE)
		process_message(msg2)
		return
	process_message(msg)

/datum/ntnet_conversation/proc/cl_leave(var/datum/computer_file/program/chat_client/Cl)
	if(!istype(Cl) || !istype(Cl.my_user) || !(Cl.my_user in users) || !can_interact(Cl) || direct)
		return
	if(Cl.focused_conv == src)
		Cl.focused_conv = null
	var/datum/ntnet_message/leave/msg = new(Cl)
	Cl.my_user.channels.Remove(src)
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

/datum/ntnet_conversation/proc/cl_change_title(var/datum/computer_file/program/chat_client/Cl, var/newTitle)
	if(!istype(Cl) || !istype(Cl.my_user) || !can_manage(Cl) || direct)
		return
	var/datum/ntnet_message/new_title/msg = new(Cl)
	msg.title = newTitle
	process_message(msg)
	title = newTitle

/datum/ntnet_conversation/proc/cl_set_password(var/datum/computer_file/program/chat_client/Cl, var/newPassword)
	if(!istype(Cl) || !istype(Cl.my_user) || !can_manage(Cl) || direct)
		return
	if(newPassword)
		password = newPassword
	else
		password = FALSE

/datum/ntnet_conversation/proc/cl_kick(var/datum/computer_file/program/chat_client/Cl, var/datum/ntnet_user/target)
	if(!istype(Cl) || !istype(Cl.my_user) || !can_manage(Cl) || !(target in users) || direct)
		return
	var/datum/ntnet_message/kick/msg = new(Cl)
	msg.target = target
	target.channels.Remove(src)
	users.Remove(target)
	if(operator == target)
		if(users.len)
			operator = pick(users)
			var/datum/ntnet_message/new_op/msg2 = new()
			msg2.nuser = operator
			process_message(msg, FALSE)
			process_message(msg2)
			return
	process_message(msg)
