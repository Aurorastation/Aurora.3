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
	) \
)

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/alist/data = alist()

	var/list/active_friends = list()
	var/list/missing_friends = list()
	// If `friend_address` matches an active communicator, add that to the list.
	// Otherwise, add the friend's name and address to `missing_friends` in order to display some "can't find {friend name}" text.
	for(var/friend_address, friend_name in friends)
		var/datum/computer_file/program/communicator/friend_comm = GLOB.active_communicator_apps[friend_address]
		if(friend_comm)
			active_friends += list(COMM_DATA(friend_comm, friend_address, friend_comm.get_user_name()))
		else // Can't find the friend's communicator
			missing_friends += list(alist("address" = friend_address, "username" = friend_name))

	var/call_duration
	var/list/connected_callers = list()
	if(active_call)
		call_duration = time2text(world.timeofday - active_call.call_start_time, "mm:ss")
		for(var/datum/computer_file/program/communicator/comm as anything in active_call.connected_comms)
			if(comm != src)
				connected_callers += comm.get_computer_address()

	var/list/all_users = list()
	for(var/address in GLOB.active_communicator_apps)
		var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
		var/comm_username = comm.get_user_name()
		if(comm == src || !comm_username)
			continue

		all_users += list(COMM_DATA(comm, address, comm_username))

	data["currentTab"] = current_tab
	data["silent"] = computer.silent

	data["callDuration"] = call_duration
	data["callSettings"] = alist("speakerphoneOn" = speakerphone_on, "microphoneOn" = microphone_on)

	data["friendsList"] = alist("active" = active_friends, "missing" = missing_friends)
	data["connectedCallers"] = connected_callers
	data["callRequests"] = REQUESTS_DATA(comm_requests, CALL_REQUESTS)
	data["friendRequests"] = REQUESTS_DATA(comm_requests, FRIEND_REQUESTS)
	data["userComm"] = COMM_DATA(src, get_computer_address(), get_user_name())
	data["allUsers"] = all_users
	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	// If `noID` is true, the UI will show the 'Please register' screen.
	return alist("noID" = !computer.registered_id)

/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	// Separated out to keep things slightly neater.
	if(params["target_address"])
		return handle_ui_act_target(action, params, ui, state)

	switch(action)
		if("switch_tab")
			current_tab = params["new_tab"]

		if("end_call")
			for(var/datum/computer_file/program/communicator/comm as anything in active_call.connected_comms - src)
				comm.computer.output_error("[get_user_name()] hung up.")
			active_call?.remove_device(src)
			current_tab = initial(current_tab)

		if("friend_request_manual")
			var/address = tgui_input_text(usr, "Enter an address to send a friend request to", "Friend Request", "fc00:", MAX_NTNET_ADDRESS_LEN)
			var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
			if(!address || comm == src)
				return FALSE
			if(!comm)
				computer.output_error("ERROR: Unable to locate user at address {[address]}.")
				return FALSE
			if(address in friends)
				computer.output_error("ERROR: You are already friends with this user!")
				return FALSE

			send_comm_request(address, FRIEND_REQUESTS)
			computer.output_notice("Friend request sent successfully to {[address]}!")

		if("remove_friend")
			var/friend_address = params["friend_address"]
			var/datum/computer_file/program/communicator/potential_comm = GLOB.active_communicator_apps[friend_address]
			if(potential_comm)
				potential_comm.friends -= get_computer_address()

			friends -= friend_address

		if("toggle_speakerphone")
			speakerphone_on = !speakerphone_on

		if("toggle_mute")
			microphone_on = !microphone_on
			active_call?.set_mute(src, microphone_on)

		if("toggle_visibility")
			visible_on_network = !visible_on_network

		if("toggle_silent")
			computer.silent = !computer.silent

		if("set_username")
			var/new_name = trim(params["new_name"])
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
			clean_variables()
			computer.unregister_account()
			friends.Cut()
			current_tab = initial(current_tab)
			connecting_to_address = initial(connecting_to_address)
			custom_username = initial(custom_username)
			visible_on_network = initial(visible_on_network)
			return FALSE
	return TRUE

/datum/computer_file/program/communicator/proc/handle_ui_act_target(action, list/params, datum/tgui/ui, datum/ui_state/state)
	// Get all of the target's details ready. (Returning if anything is invalid)
	var/target_address = params["target_address"]
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!target_comm)
		computer.output_error("ERROR: Unable to locate user at address {[target_address]}.")
		// Todo: clean up any matching addresses in user requests since it isn't available anymore
		return FALSE

	switch(action)
		if("friend_request")
			if(params["action"] == "send")
				send_comm_request(target_address, FRIEND_REQUESTS)
			else if(params["action"] == "respond")
				var/target_username = target_comm.get_user_name()

				var/choice = tgui_alert(usr, "Friend request from [target_username]", "Friend Request", list("Accept", "Decline"))
				if(choice == null)
					return

				var/source_username = get_user_name()
				var/source_address = get_computer_address()
				if(!source_address) // just in case
					return
				// Accept and decline both remove the request.
				target_comm.cancel_comm_request(source_address, FRIEND_REQUESTS)
				if(choice == "Accept")
					friends[target_address] = target_username
					target_comm.friends[source_address] = source_username
					target_comm.computer.get_notification("Friend request accepted!", 1, source_username)

		if("call_request")
			switch(params["action"])
				/* -- Sending a request to someone else: -- */
				if("send")
					request_voice_call(target_comm, target_address)
				if("cancel")
					cancel_voice_call(target_comm, target_address)

				/* -- Responding to a request from someone else: -- */
				if("accept")
					connecting_to_address = target_address
					INVOKE_ASYNC(src, PROC_REF(call_connecting), target_comm, target_address)
				if("decline")
					target_comm.cancel_voice_call(src, get_computer_address(), "Your call request to [get_user_name()] was declined.")

	return TRUE

#undef REQUESTS_DATA
#undef COMM_DATA
