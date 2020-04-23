var/global/ntnrc_uid = 0
/datum/ntnet_conversation
	var/id
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/chatclient/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/list/clients = list()
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
		if(C.username == username || !C.computer.screen_on)
			continue
		if(C.computer.active_program == C || (C in C.computer.idle_threads))
			C.computer.output_message(FONT_SMALL("<b>([title]) [username]:</b> [message]"), 0)

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
	clients.Add(C)
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)

	for(var/datum/computer_file/program/chatclient/CC in clients)
		if(CC == C || !CC.computer.screen_on)
			continue
		if(CC.computer.active_program == CC || (CC in CC.computer.idle_threads))
			CC.computer.output_message(FONT_SMALL("<b>([title]) A new client ([C.username]) has entered the chat.</b>"), 0)

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
		if(CC == C || !CC.computer.screen_on)
			continue
		if(CC.computer.active_program == CC || (CC in CC.computer.idle_threads))
			CC.computer.output_message(FONT_SMALL("<b>([title]) A client ([C.username]) has left the chat.</b>"), 0)


/datum/ntnet_conversation/proc/changeop(var/datum/computer_file/program/chatclient/newop)
	if(istype(newop))
		operator = newop
		add_status_message("Channel operator status transferred to [newop.username].")

/datum/ntnet_conversation/proc/change_title(var/newtitle, var/datum/computer_file/program/chatclient/client)
	if(operator != client)
		return 0 // Not Authorised

	add_status_message("[client.username] has changed channel title from [title] to [newtitle]")
	title = newtitle

	for(var/datum/computer_file/program/chatclient/C in clients)
		if(C == client || !C.computer.screen_on)
			continue
		if(C.computer.active_program == src || (C in C.computer.idle_threads))
			C.computer.output_message(FONT_SMALL("([title]) A new client ([C.username]) has entered the chat."), 0)