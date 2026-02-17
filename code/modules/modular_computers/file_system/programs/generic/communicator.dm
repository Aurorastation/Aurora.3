#define REQUESTS_DATA(requests_list, category) ( \
	alist( \
		INCOMING_REQUESTS = requests_list[INCOMING_REQUESTS][category], \
		OUTGOING_REQUESTS = requests_list[OUTGOING_REQUESTS][category], \
	) \
)

#define USER_DATA(net_user, net_address) ( \
	list(alist( \
		"address" = net_address, \
		"username" = net_user.username, \
		"visible" = net_user.visible_on_network, \
		"ref" = REF(net_user), \
	)) \
)

/datum/computer_file/program/communicator
	filename = "ntnrc_comm"
	filedesc = "Communicator"
	//program_icon_state = todo
	//program_key_icon_state = todo // Stationary communicators
	extended_desc = "todo"
	//size = todo
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "todo"
	//color = todo
	tgui_id = "Communicator"

	var/ringtone = "beep"
	var/ringer_on = TRUE

/datum/computer_file/program/communicator/proc/get_computer_address()
	return computer.network_card?.identification_addr

/datum/computer_file/program/communicator/proc/get_program_user()
	return computer.registered_id?.chat_user

/datum/computer_file/program/communicator/run_program(mob/user)
	if(!get_computer_address())
		computer.output_error("ERROR: Unable to locate network card.")
		return
	return ..()

/datum/computer_file/program/communicator/event_registered()
	computer.registered_id.InitializeChatUser()
	update_static_data_for_all_viewers()

/datum/computer_file/program/communicator/event_unregistered()
	update_static_data_for_all_viewers() // todo: double check that unregistering while in an "app" resets properly

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/datum/ntnet_user/program_user = get_program_user()
	if(!program_user)
		// No user means the UI will show the 'Please register' screen, so no data is needed for the moment.
		return

	var/alist/data = alist()
	data["friendsList"] = program_user.friends
	data["callRequests"] = REQUESTS_DATA(program_user.comm_requests, CALL_REQUESTS)
	data["videoRequests"] = REQUESTS_DATA(program_user.comm_requests, VIDEO_REQUESTS)
	data["friendRequests"] = REQUESTS_DATA(program_user.comm_requests, FRIEND_REQUESTS)
	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	var/datum/ntnet_user/program_user = get_program_user()
	if(!program_user)
		return

	var/alist/data = alist()

	var/list/ntnet_users = list()
	// Using `GLOB.active_communicators` rather than `GLOB.ntnet_global.users` in order to only get users linked to a communicator.
	for(var/address in GLOB.active_communicators)
		var/obj/item/modular_computer/handheld/communicator/comm = GLOB.active_communicators[address]
		// Skip any unregistered devices and ourself
		if(!comm.registered_id?.chat_user)
			continue
		if(comm == computer || comm.registered_id.chat_user == program_user)
			continue

		ntnet_users += USER_DATA(comm.registered_id.chat_user, address)

	data["user"] = USER_DATA(program_user, get_computer_address())
	data["allUsers"] = ntnet_users
	return data

/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/datum/ntnet_user/program_user = get_program_user()
	if(!program_user)
		return FALSE

	switch(action)
		if("refresh_data")
			update_static_data(usr, ui)
		if("friend_request")
			var/target_address = params["selected_address"]
			var/obj/item/modular_computer/handheld/communicator/target_comm = GLOB.active_communicators[target_address]
			var/datum/ntnet_user/target_user = target_comm?.registered_id?.chat_user
			if(!target_user)
				computer.output_error("ERROR: Unable to locate user at address {[target_address]}.")
				return FALSE

			if(params["action"] == "send")
				target_user.add_comm_request(program_user, FRIEND_REQUESTS)
				target_comm.output_notice("Friend request recieved from [program_user.username]!")
			else if(params["action"] == "respond")
				var/choice = tgui_alert(usr, "Friend request from [target_user.username]", "Friend Request", list("Accept", "Decline"))
				if(choice == "Accept")
					program_user.add_friend(target_user)
					target_comm.output_notice("[program_user.username] has accepted your friend request!")
					return TRUE
				else if(choice == "Decline")
					program_user.remove_comm_request(target_user, FRIEND_REQUESTS)
		if("remove_friend")
			for(var/datum/ntnet_user/U as anything in GLOB.ntnet_global.users)
				if(U.username == params["selected_name"])
					program_user.remove_friend(U.username)
					U.remove_friend(program_user.username)

#undef REQUESTS_DATA
#undef USER_DATA
