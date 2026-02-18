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

// Mirror of the `CommunicatorTab` enum in '../Communicator/types.ts'.
#define HOME_TAB 0
#define PHONE_TAB 1
#define CONTACTS_TAB 2
#define MESSAGING_TAB 3
#define SETTINGS_TAB 4
#define ACTIVE_CALL_TAB 5

// {computer address: app}
GLOBAL_LIST_EMPTY(active_communicator_apps)

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

	var/current_tab = HOME_TAB

	var/speakerphone_on = FALSE
	var/microphone_on = TRUE
	var/ringtone = "beep"
	var/ringer_on = TRUE

/datum/computer_file/program/communicator/New(obj/item/modular_computer/comp)
	. = ..()
	if(!istype(comp))
		return
	if(computer.network_card?.identification_addr)
		GLOB.active_communicator_apps[computer.network_card.identification_addr] = src

	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_INSTALLED, PROC_REF(on_hw_installed))
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_UNINSTALLED, PROC_REF(on_hw_uninstalled))

/datum/computer_file/program/communicator/proc/on_hw_installed(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(istype(H, /obj/item/computer_hardware/network_card))
		GLOB.active_communicator_apps[computer.network_card.identification_addr] = src

/datum/computer_file/program/communicator/proc/on_hw_uninstalled(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(istype(H, /obj/item/computer_hardware/network_card))
		var/obj/item/computer_hardware/network_card/net_card = H
		GLOB.active_communicator_apps -= net_card.identification_addr

/datum/computer_file/program/communicator/proc/get_computer_address()
	return computer.network_card?.identification_addr

/datum/computer_file/program/communicator/proc/get_program_user() as /datum/ntnet_user
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

	var/call_duration
	var/list/connected_callers = list()
	if(program_user.active_call)
		call_duration = time2text(world.timeofday - program_user.active_call.call_start_time, "mm:ss")
		for(var/datum/computer_file/program/communicator/comm as anything in program_user.active_call.connected_comms)
			if(comm != src)
				connected_callers += comm.get_program_user()?.username

	var/alist/data = alist()
	data["currentTab"] = current_tab
	data["callDuration"] = call_duration
	data["callSettings"] = alist("speakerphoneOn" = speakerphone_on, "microphoneOn" = microphone_on)
	data["friendsList"] = program_user.friends
	data["connectedCallers"] = connected_callers
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
	for(var/address in GLOB.active_communicator_apps)
		var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
		var/datum/ntnet_user/comm_user = comm.get_program_user()
		// Skip any unregistered devices and ourself
		if(comm == src || !comm_user || comm_user == program_user)
			continue

		ntnet_users += USER_DATA(comm_user, address)

	data["user"] = USER_DATA(program_user, get_computer_address())
	data["allUsers"] = ntnet_users
	return data

// Todo: Redo ALL OF THIS it's so bad :(
/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/datum/ntnet_user/program_user = get_program_user()
	if(!program_user)
		return TRUE

	// If there's a "target_address" parameter, get all of the target's details ready. (Returning if anything is invalid)
	var/target_address = params["target_address"]
	var/datum/computer_file/program/communicator/target_comm
	var/datum/ntnet_user/target_user
	// If there *isn't* a target address, skip this stuff.
	if(target_address)
		target_comm = GLOB.active_communicator_apps[target_address]
		target_user = target_comm?.get_program_user()
		if(!target_user)
			computer.output_error("ERROR: Unable to locate user at address {[target_address]}.")
			// Todo: clean up any matching addresses in user requests since it isn't available anymore
			return FALSE

	switch(action)
		if("switch_tab")
			current_tab = params["new_tab"]

		if("refresh_data")
			update_static_data(usr, ui)

		if("friend_request")
			if(params["action"] == "send")
				program_user.send_comm_request(get_computer_address(), target_address, FRIEND_REQUESTS)
				target_comm.computer.output_notice("Friend request recieved from [program_user.username]!")
			else if(params["action"] == "respond")
				var/choice = tgui_alert(usr, "Friend request from [target_user.username]", "Friend Request", list("Accept", "Decline"))
				if(choice == null)
					return
				// Accept and decline both remove the request.
				target_user.remove_comm_request(target_address, get_computer_address(), FRIEND_REQUESTS)
				if(choice == "Accept")
					program_user.add_friend(target_user)
					target_comm.computer.output_notice("[program_user.username] has accepted your friend request!")

		if("call_request")
			/* -- Sending a request to someone else: -- */
			if(params["action"] == "send")
				if(program_user.send_comm_request(get_computer_address(), target_address, CALL_REQUESTS))
					target_comm.current_tab = ACTIVE_CALL_TAB
					return // todo target notification
			if(params["action"] == "cancel")
				if(program_user.remove_comm_request(get_computer_address(), target_address, CALL_REQUESTS))
					if(target_comm.current_tab == ACTIVE_CALL_TAB)
						target_comm.current_tab = initial(target_comm.current_tab)

			/* -- Recieving a request from someone else: -- */
			if(params["action"] == "accept")
				target_user.remove_comm_request(target_address, get_computer_address(), CALL_REQUESTS)

				var/datum/comm_call/comm_call
				if(target_user.active_call)
					comm_call = target_user.active_call
				else
					comm_call = new()
					comm_call.add_device(target_comm)
				comm_call.add_device(src)
				target_comm.current_tab = ACTIVE_CALL_TAB
				return // todo
			if(params["action"] == "decline")
				if(target_user.remove_comm_request(target_address, get_computer_address(), CALL_REQUESTS))
					if(target_comm.current_tab == ACTIVE_CALL_TAB)
						target_comm.current_tab = initial(target_comm.current_tab)
				return // todo target notification

		if("remove_friend")
			for(var/datum/ntnet_user/U as anything in GLOB.ntnet_global.users)
				if(U.username == params["target_name"])
					program_user.remove_friend(U.username)
					U.remove_friend(program_user.username)

		if("end_call")
			program_user.active_call?.remove_device(src)

		if("toggle_speakerphone")
			speakerphone_on = !speakerphone_on

		if("toggle_mute")
			microphone_on = !microphone_on
			program_user.active_call?.set_mute(src, microphone_on)
	return TRUE

#undef REQUESTS_DATA
#undef USER_DATA
#undef HOME_TAB
#undef PHONE_TAB
#undef CONTACTS_TAB
#undef MESSAGING_TAB
#undef SETTINGS_TAB
#undef ACTIVE_CALL_TAB
