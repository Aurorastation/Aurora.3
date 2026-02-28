/datum/comm_chat
	// todo: weakrefs?
	var/datum/computer_file/program/communicator/comm_1 // initiator
	var/datum/computer_file/program/communicator/comm_2 // target

	var/list/datum/comm_text_message/messages = list()

/datum/comm_chat/New(datum/computer_file/program/communicator/comm_1, datum/computer_file/program/communicator/comm_2)
	. = ..()
	src.comm_1 = comm_1
	src.comm_2 = comm_2

/datum/comm_chat/Destroy(force)
	comm_1.active_chats -= src
	comm_2.active_chats -= src
	QDEL_LIST(messages)
	return ..()

/datum/comm_chat/proc/send_message(message, sender_address)
	messages += new /datum/comm_text_message(message, sender_address)

/datum/comm_chat/proc/remove_message(message_ref, user_address)
	var/datum/comm_text_message/msg = locate(message_ref)
	if(msg?.sender_address == user_address)
		qdel(msg)

/datum/comm_chat/proc/edit_message(message_ref, new_message, user_address)
	var/datum/comm_text_message/msg = locate(message_ref)
	if(msg?.sender_address == user_address)
		msg.content = new_message


/datum/comm_text_message
	var/content
	var/sender_address
	var/time_sent

/datum/comm_text_message/New(content, sender_address)
	. = ..()
	src.content = content
	src.sender_address = sender_address
	time_sent = worldtime2text()
