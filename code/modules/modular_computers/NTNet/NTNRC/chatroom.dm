var/global/ntnrc_chatroom_uid = 0
/datum/ntnet_chatroom
	var/id
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/communicator/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/clients = list()
	var/password

/datum/ntnet_chatroom/New(var/name, var/no_operator)
	id = ntnrc_chatroom_uid
	ntnrc_chatroom_uid++
	if(name)
		title = name
	if(ntnet_global)
		ntnet_global.communicator_channels.Add(src)
	if(no_operator)
		operator = "NanoTrasen Information Technology Division" // assign a fake operator
	..()

/datum/ntnet_chatroom/proc/add_client(var/datum/computer_file/program/communicator/C)
	if(!istype(C))
		return
	if(C in clients)
		return
	clients.Add(C)
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)
	for(var/datum/computer_file/program/communicator/CC in clients)
		if(CC.program_state > PROGRAM_STATE_KILLED && CC != C)
			CC.computer.output_message("<b>([title]) <i>[C.username]</i> has entered the vocalized chatroom.</b>", 0)

/datum/ntnet_chatroom/proc/remove_client(var/datum/computer_file/program/communicator/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)

	// Channel operator left, pick new operator
	if(C == operator)
		operator = null
		if(clients.len)
			var/datum/computer_file/program/communicator/newop = pick(clients)
			changeop(newop)

	for(var/datum/computer_file/program/communicator/CC in clients)
		if(CC.program_state > PROGRAM_STATE_KILLED && CC != C)
			CC.computer.output_message(FONT_SMALL("<b>([title]) <i>[C.username]</i> has left the vocalized chatroom.</b>"), 0)


/datum/ntnet_chatroom/proc/changeop(var/datum/computer_file/program/communicator/newop)
	if(istype(newop))
		operator = newop

/datum/ntnet_chatroom/proc/change_title(var/newtitle, var/datum/computer_file/program/communicator/client)
	if(operator != client)
		return 0 // Not Authorised
	
	for(var/datum/computer_file/program/communicator/C in clients)
		if(C.program_state > PROGRAM_STATE_KILLED && C != client)
			C.computer.output_message(FONT_SMALL("([title]) <i>[client.username]</i> has changed the chatroom title to <b>[newtitle]</b>."), 0)
	title = newtitle