var/global/ntnrc_uid = 0
/datum/ntnet_conversation
	var/id
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/chatclient/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/list/clients = list()
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

/datum/ntnet_conversation/proc/add_message(var/message, var/username, var/mob/user, var/reply_ref)
	log_ntirc("[user.client.ckey]/([username]) : [message]", ckey=key_name(user), conversation=title)

	for(var/datum/computer_file/program/chatclient/C in clients)
		if(C.program_state > PROGRAM_STATE_KILLED)
			C.computer.output_message(FONT_SMALL("<b>([get_title(C)]) <i>[username]</i>:</b> [message] (<a href='byond://?src=\ref[C];Reply=1;target=[src.title]'>Reply</a>)"), 0)

	message = "[worldtime2text()] [username]: [message]"
	messages.Add(message)
	trim_message_list()

/datum/ntnet_conversation/proc/add_status_message(var/message)
	messages.Add("[worldtime2text()] -!- [message]")
	trim_message_list()

/datum/ntnet_conversation/proc/trim_message_list()
	if(messages.len <= 50)
		return
	for(var/message in messages)
		messages -= message
		if(messages.len <= 50)
			return

/datum/ntnet_conversation/proc/add_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C))
		return
	if (C in clients)
		return
	clients.Add(C)
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)
	for(var/datum/computer_file/program/chatclient/CC in clients)
		if(CC.program_state > PROGRAM_STATE_KILLED && CC != C)
			if(!direct)
				CC.computer.output_message(FONT_SMALL("<b>([get_title(CC)]) <i>[C.username]</i> has entered the chat.</b>"), 0)

/datum/ntnet_conversation/proc/begin_direct(var/datum/computer_file/program/chatclient/CA, var/datum/computer_file/program/chatclient/CB)
	if(!istype(CA) || !istype(CB))
		return
	direct = TRUE
	clients.Add(CA)
	clients.Add(CB)
	
	add_status_message("[CA.username] has opened direct conversation.")
	if(CB.program_state > PROGRAM_STATE_KILLED)
		CB.computer.output_message(FONT_SMALL("<b>([get_title(CB)]) <i>[CA.username]</i> has opened direct conversation with you.</b>"), 0)

/datum/ntnet_conversation/proc/remove_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)

	// Channel operator left, pick new operator
	if(C == operator)
		operator = null
		if(clients.len)
			var/datum/computer_file/program/chatclient/newop = pick(clients)
			changeop(newop)

	for(var/datum/computer_file/program/chatclient/CC in clients)
		if(CC.program_state > PROGRAM_STATE_KILLED && CC != C)
			CC.computer.output_message(FONT_SMALL("<b>([get_title(CC)]) <i>[C.username]</i> has left the chat.</b>"), 0)


/datum/ntnet_conversation/proc/changeop(var/datum/computer_file/program/chatclient/newop)
	if(istype(newop))
		operator = newop
		add_status_message("Channel operator status transferred to [newop.username].")

/datum/ntnet_conversation/proc/change_title(var/newtitle, var/datum/computer_file/program/chatclient/client)
	if(operator != client)
		return 0 // Not Authorised

	add_status_message("[client.username] has changed channel title from [get_title(client)] to [newtitle]")
	
	for(var/datum/computer_file/program/chatclient/C in clients)
		if(C.program_state > PROGRAM_STATE_KILLED && C != client)
			C.computer.output_message(FONT_SMALL("([get_title(C)]) <i>[client.username]</i> has changed the channel title to <b>[newtitle]</b>."), 0)
	title = newtitle

/datum/ntnet_conversation/proc/get_title(var/datum/computer_file/program/chatclient/cl = null)
	if(direct)
		var/names = list()
		for(var/datum/computer_file/program/chatclient/C in clients)
			names += C.username
		if(cl)
			names -= cl.username
		return "\[DM] [english_list(names)]"
	else
		return title

/datum/ntnet_conversation/proc/get_dead_title()
	if(direct)
		var/names = list()
		for(var/datum/computer_file/program/chatclient/C in clients)
			names += C.username
		return "\[DM] [english_list(names)]"
	else
		return title

/datum/ntnet_conversation/proc/can_see(var/datum/computer_file/program/chatclient/cl)
	if(cl in clients)
		return TRUE
	if(cl.netadmin_mode)
		return TRUE
	if(!direct)
		return TRUE
	return FALSE
