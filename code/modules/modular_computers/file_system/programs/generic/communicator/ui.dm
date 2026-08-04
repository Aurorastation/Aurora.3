#define REQUESTS_DATA(requests_list, category) ( \
	alist( \
		INCOMING_REQUESTS = requests_list[INCOMING_REQUESTS][category], \
		OUTGOING_REQUESTS = requests_list[OUTGOING_REQUESTS][category], \
	) \
)

#define COMM_DATA(comm_app, comm_address, user_name) ( \
	alist( \
		"address" = comm_address, \
		"username" = user_name, \
		"visible" = comm_app.visible_on_network, \
		"connectingToAddr" = comm_app.connecting_to_address, \
		"tier" = comm_app.get_device_tier(), \
	) \
)

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/alist/data = alist()
	var/list/active_friends = list()
	var/list/missing_friends = list()
	for(var/friend_address, friend_name in friends)
		var/datum/computer_file/program/communicator/friend_comm = GLOB.active_communicator_apps[friend_address]
		if(friend_comm)
			active_friends += list(COMM_DATA(friend_comm, friend_address, friend_comm.get_user_name()))
		else
			missing_friends += list(alist("address" = friend_address, "username" = friend_name))

	var/alist/active_call_data
	if(active_call)
		var/list/connected_comms = list()
		for(var/datum/computer_file/program/communicator/communicator as anything in active_call.connected_comms)
			connected_comms += communicator.get_computer_address()
		active_call_data = alist(
			"duration" = time2text(world.time - active_call.call_start_time, "mm:ss"),
			"connectedComms" = connected_comms,
		)

	var/list/active_chats_data = list()
	for(var/address in active_chats)
		var/datum/comm_chat/chat = active_chats[address]
		if(!chat)
			continue
		var/list/chat_messages = list()
		for(var/datum/comm_text_message/message as anything in chat.messages)
			chat_messages += list(alist(
				"content" = message.content,
				"senderAddress" = message.sender_address,
				"timeSent" = message.time_sent,
			))
		active_chats_data += list(alist(
			"chatTarget" = chat.get_other_address(src),
			"targetName" = chat.get_other_name(src),
			"messages" = chat_messages,
		))

	// Hidden numbers are only sent to clients that already know them through a contact, request, chat, or call.
	var/list/all_users = list()
	for(var/address in GLOB.active_communicator_apps)
		var/datum/computer_file/program/communicator/communicator = GLOB.active_communicator_apps[address]
		var/comm_username = communicator.get_user_name()
		if(communicator == src || !comm_username || (!communicator.visible_on_network && !knows_address(address)))
			continue
		all_users += list(COMM_DATA(communicator, address, comm_username))

	var/can_hologram = FALSE
	if(active_call && get_device_tier() >= COMMUNICATOR_TIER_HOLOGRAPHIC)
		for(var/datum/computer_file/program/communicator/other_comm as anything in active_call.connected_comms)
			if(other_comm != src && other_comm.get_device_tier() >= COMMUNICATOR_TIER_HOLOGRAPHIC)
				can_hologram = TRUE
				break

	data["currentTab"] = current_tab
	data["silent"] = computer.silent
	data["observer"] = isobserver(user)
	data["activeCall"] = active_call_data
	data["activeChats"] = active_chats_data
	data["callSettings"] = alist(
		"speakerphoneOn" = speakerphone_on,
		"microphoneOn" = microphone_on,
		"videoOn" = video_call_on,
		"hologramOn" = hologram_on,
		"canVideo" = !!get_video_target(),
		"canHologram" = can_hologram,
	)
	data["friendsList"] = alist("active" = active_friends, "missing" = missing_friends)
	data["callRequests"] = REQUESTS_DATA(comm_requests, CALL_REQUESTS)
	data["friendRequests"] = REQUESTS_DATA(comm_requests, FRIEND_REQUESTS)
	data["userComm"] = COMM_DATA(src, get_computer_address(), get_user_name())
	data["deviceTierName"] = get_tier_name()
	data["allUsers"] = all_users
	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	return alist(
		"noID" = !computer.registered_id,
		"canReset" = !istype(computer, /obj/item/modular_computer/handheld/communicator/landline),
	)

/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(isobserver(usr) && action != "switch_tab")
		to_chat(usr, SPAN_WARNING("Observers cannot operate communicators."))
		return TRUE

	if(params["target_address"])
		return handle_ui_act_target(action, params, ui, state)

	switch(action)
		if("switch_tab")
			var/new_tab = params["new_tab"]
			if(!isnum(new_tab))
				new_tab = text2num(new_tab)
			if(new_tab >= COMM_HOME_TAB && new_tab <= COMM_CALL_TAB)
				current_tab = new_tab

		if("end_call")
			end_call("[get_user_name()] hung up.")

		if("add_contact_manual", "friend_request_manual")
			var/address = lowertext(trim(tgui_input_text(usr, "Enter the communicator number to add.", "Add Contact", "fc00:", MAX_NTNET_ADDRESS_LEN)))
			if(!address)
				return FALSE
			if(!validate_ntnet_address(address) || address == get_computer_address())
				computer.output_error("ERROR: Invalid communicator number.")
				return FALSE
			var/datum/computer_file/program/communicator/contact_comm = GLOB.active_communicator_apps[address]
			var/contact_name = contact_comm?.get_user_name()
			if(!contact_name)
				contact_name = sanitize(tgui_input_text(usr, "Enter a name for this offline contact.", "Contact Name", address, MAX_NAME_LEN), MAX_NAME_LEN)
			if(!contact_name)
				return FALSE
			friends[address] = contact_name

		if("remove_friend")
			friends -= lowertext(params["friend_address"])

		if("toggle_speakerphone")
			speakerphone_on = !speakerphone_on

		if("toggle_mute")
			microphone_on = !microphone_on
			active_call?.set_microphone(src, microphone_on)

		if("toggle_video")
			toggle_video_call(usr)

		if("toggle_hologram")
			toggle_hologram()

		if("toggle_visibility")
			visible_on_network = !visible_on_network

		if("toggle_silent")
			computer.silent = !computer.silent

		if("set_username")
			var/new_name = sanitize(params["new_name"], MAX_NAME_LEN)
			if(!new_name || new_name == "__reset" || new_name == computer.registered_id?.registered_name)
				custom_username = null
			else
				custom_username = new_name
			for(var/friend_address in friends)
				var/datum/computer_file/program/communicator/friend_comm = GLOB.active_communicator_apps[friend_address]
				var/source_address = get_computer_address()
				if(friend_comm?.friends[source_address])
					friend_comm.friends[source_address] = get_user_name()

		if("reset_device")
			if(istype(computer, /obj/item/modular_computer/handheld/communicator/landline))
				return FALSE
			clean_variables(clear_chats = TRUE)
			computer.unregister_account()
			friends.Cut()
			current_tab = initial(current_tab)
			custom_username = initial(custom_username)
			visible_on_network = initial(visible_on_network)
			return FALSE
	return TRUE

/datum/computer_file/program/communicator/proc/handle_ui_act_target(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/target_address = lowertext(trim(params["target_address"]))
	if(!validate_ntnet_address(target_address) || target_address == get_computer_address())
		computer.output_error("ERROR: Invalid communicator number.")
		return FALSE
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!target_comm)
		computer.output_error("ERROR: Unable to locate user at number {[target_address]}.")
		return FALSE

	switch(action)
		if("add_contact")
			friends[target_address] = target_comm.get_user_name()

		if("friend_request")
			if(params["action"] == "send")
				send_comm_request(target_address, FRIEND_REQUESTS)
			else if(params["action"] == "respond")
				var/choice = tgui_alert(usr, "Contact request from [target_comm.get_user_name()]", "Contact Request", list("Accept", "Decline"))
				if(!choice)
					return FALSE
				target_comm.cancel_comm_request(get_computer_address(), FRIEND_REQUESTS)
				if(choice == "Accept")
					friends[target_address] = target_comm.get_user_name()
					target_comm.friends[get_computer_address()] = get_user_name()
					target_comm.computer.get_notification("Contact request accepted!", 1, get_user_name())

		if("call_request")
			switch(params["action"])
				if("send")
					request_voice_call(target_comm, target_address)
				if("cancel")
					cancel_voice_call(target_comm, target_address)
				if("accept")
					accept_call(target_comm)
				if("decline")
					target_comm.cancel_voice_call(src, get_computer_address(), "Your call to [get_user_name()] was declined.")

		if("start_chat")
			get_or_create_chat(target_comm)

		if("send_message")
			send_text_message(target_address, params["message"])
	return TRUE

#undef REQUESTS_DATA
#undef COMM_DATA
