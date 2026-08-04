/datum/comm_chat
	var/datum/computer_file/program/communicator/comm_1
	var/datum/computer_file/program/communicator/comm_2
	var/comm_1_address
	var/comm_2_address
	var/comm_1_name
	var/comm_2_name
	var/list/datum/comm_text_message/messages = list()

/datum/comm_chat/New(datum/computer_file/program/communicator/first_comm, datum/computer_file/program/communicator/second_comm)
	. = ..()
	if(!first_comm || !second_comm || first_comm == second_comm)
		return
	comm_1 = first_comm
	comm_2 = second_comm
	comm_1_address = first_comm.get_computer_address()
	comm_2_address = second_comm.get_computer_address()
	comm_1_name = first_comm.get_user_name()
	comm_2_name = second_comm.get_user_name()
	if(!comm_1_address || !comm_2_address)
		return
	comm_1.active_chats[comm_2_address] = src
	comm_2.active_chats[comm_1_address] = src

/datum/comm_chat/Destroy(force)
	if(comm_1?.active_chats[comm_2_address] == src)
		comm_1.active_chats -= comm_2_address
	if(comm_2?.active_chats[comm_1_address] == src)
		comm_2.active_chats -= comm_1_address
	comm_1 = null
	comm_2 = null
	QDEL_LIST(messages)
	return ..()

/// Reattaches a communicator with a matching number to a conversation retained by the other endpoint.
/datum/comm_chat/proc/attach_participant(datum/computer_file/program/communicator/communicator)
	if(!communicator)
		return FALSE
	var/address = communicator.get_computer_address()
	if(address == comm_1_address && !comm_1)
		comm_1 = communicator
		comm_1_name = communicator.get_user_name()
		communicator.active_chats[comm_2_address] = src
		return TRUE
	if(address == comm_2_address && !comm_2)
		comm_2 = communicator
		comm_2_name = communicator.get_user_name()
		communicator.active_chats[comm_1_address] = src
		return TRUE
	return communicator == comm_1 || communicator == comm_2

/// Removes one endpoint without destroying the history retained by the other endpoint.
/datum/comm_chat/proc/remove_participant(datum/computer_file/program/communicator/communicator)
	if(communicator == comm_1)
		if(comm_1.active_chats[comm_2_address] == src)
			comm_1.active_chats -= comm_2_address
		comm_1 = null
	else if(communicator == comm_2)
		if(comm_2.active_chats[comm_1_address] == src)
			comm_2.active_chats -= comm_1_address
		comm_2 = null
	else
		return FALSE
	if(!comm_1 && !comm_2)
		qdel(src)
	return TRUE

/datum/comm_chat/proc/get_other_address(datum/computer_file/program/communicator/communicator)
	if(communicator == comm_1)
		return comm_2_address
	if(communicator == comm_2)
		return comm_1_address

/datum/comm_chat/proc/get_other_name(datum/computer_file/program/communicator/communicator)
	if(communicator == comm_1)
		return comm_2?.get_user_name() || comm_2_name
	if(communicator == comm_2)
		return comm_1?.get_user_name() || comm_1_name

/datum/comm_chat/proc/send_message(message, datum/computer_file/program/communicator/sender)
	if(sender != comm_1 && sender != comm_2)
		return FALSE
	var/sender_address = sender.get_computer_address()
	if(!sender_address)
		return FALSE
	messages += new /datum/comm_text_message(message, sender_address)
	return TRUE

/datum/comm_text_message
	var/content
	var/sender_address
	var/time_sent

/datum/comm_text_message/New(content, sender_address)
	. = ..()
	src.content = content
	src.sender_address = sender_address
	time_sent = worldtime2text()
