/proc/to_chat(target, message)
	if(!target || !message)
		return

	if(target == world)
		target = clients

	if(!istext(message))
		CRASH("to_chat called with invalid input type")
		return

	var/original_message = message

	. = list()
	if(!islist(target))
		target = list(target)

	for(var/I in target)
		var/client/C = CLIENT_FROM_VAR(I)
		if(!isclient(C))
			continue

		DIRECT_OUTPUT(C, original_message)

		if(!C.chat || C.chat.broken)
			continue

		if(C.chat)
			C.chat.queue += message
			. += C.chat

	if(!SSchat?.init_state)
		for(var/I in .)
			var/datum/chat/C = I
			C.ProcessQueue()
	else
		SSchat.Queue(.)

	. = null

