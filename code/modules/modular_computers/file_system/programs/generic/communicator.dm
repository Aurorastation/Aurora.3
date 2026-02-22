// BIG TODO: Ensure that ALL new datums and items being deleted individually and while midway through an action (e.g. calling someone) gets handled properly.
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
	) \
)

// Mirror of the `CommunicatorTab` enum in '../Communicator/types.ts'.
#define HOME_TAB 0
#define PHONE_TAB 1
#define CONTACTS_TAB 2
#define MESSAGING_TAB 3
#define SETTINGS_TAB 4
#define CALL_TAB 5

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

	var/datum/comm_call/active_call

	// list of friend names (string)
	// This is names so that if a friend's device goes offline they can still stay on the UI as 'unreachable'.
	// todo: if another communicator has the same name they can replace the actual person's communicator in the friends list
	var/list/friends = list()

	// request values are all ntnet addresses (todo: actual documentation)
	var/alist/comm_requests = alist(
		INCOMING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		),
		OUTGOING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		)
	)

	var/current_tab = HOME_TAB
	var/connecting_to_call = FALSE

	var/custom_username = null
	var/visible_on_network = TRUE
	var/speakerphone_on = FALSE
	var/microphone_on = TRUE
	var/ringer_on = TRUE
	var/ringtone = "beep"

/datum/computer_file/program/communicator/New(obj/item/modular_computer/comp)
	. = ..()
	if(!istype(comp))
		return
	if(computer.network_card?.identification_addr)
		GLOB.active_communicator_apps[computer.network_card.identification_addr] = src

	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_INSTALLED, PROC_REF(on_hw_installed))
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_UNINSTALLED, PROC_REF(on_hw_uninstalled))

/datum/computer_file/program/communicator/Destroy()
	// Try to clean up any requests to and from this communicator.
	var/comm_address = get_computer_address()
	if(comm_address)
		for(var/category in comm_requests[INCOMING_REQUESTS])
			for(var/address in comm_requests[INCOMING_REQUESTS][category])
				var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
				comm?.remove_comm_request(comm_address, category)
	for(var/category in comm_requests[OUTGOING_REQUESTS])
		for(var/address in comm_requests[OUTGOING_REQUESTS][category])
			remove_comm_request(address, category)

	for(var/address in GLOB.active_communicator_apps)
		if(GLOB.active_communicator_apps[address] == src)
			GLOB.active_communicator_apps -= address
	return ..()

/datum/computer_file/program/communicator/kill_program(forced)
	. = ..()
	current_tab = initial(current_tab)

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

/datum/computer_file/program/communicator/proc/get_user_name()
	return custom_username || computer.registered_id?.registered_name

// both of these are sender-side only
/datum/computer_file/program/communicator/proc/send_comm_request(target_address, category)
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!source_address || !target_comm)
		return FALSE

	comm_requests[OUTGOING_REQUESTS][category] |= target_address
	target_comm.comm_requests[INCOMING_REQUESTS][category] |= source_address
	return TRUE

/datum/computer_file/program/communicator/proc/remove_comm_request(target_address, category)
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!source_address || !target_comm)
		return FALSE

	comm_requests[OUTGOING_REQUESTS][category] -= target_address
	target_comm.comm_requests[INCOMING_REQUESTS][category] -= source_address
	return TRUE

// TODO: Make sure this works
/datum/computer_file/program/communicator/proc/call_checks(caller_address)
	if(QDELETED(src))
		return FALSE
	if(!(caller_address in comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]))
		connecting_to_call = FALSE
		return FALSE
	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[caller_address]
	if(QDELETED(caller_comm))
		computer.output_error("Connection to {[caller_address]} lost!")
		connecting_to_call = FALSE
		return FALSE
	return TRUE

/datum/computer_file/program/communicator/proc/call_connecting(datum/computer_file/program/communicator/caller_comm, caller_address)
	caller_comm.computer.output_notice("Connecting to {[get_computer_address()]}...")
	computer.output_notice("Connecting to {[caller_address]}...")
	sleep(1 SECOND)
	if(!call_checks(caller_address))
		return

	computer.output_notice("Dialing internally from [station_name()]...")
	sleep(2 SECONDS)
	if(!call_checks(caller_address))
		return

	computer.output_notice("Re-routing connection to [caller_comm.computer] at {[caller_address]}.")
	sleep(4 SECONDS)
	if(!call_checks(caller_address))
		return

	computer.output_notice("Connection to [caller_comm.computer] established!")
	caller_comm.computer.output_notice("Connection to [computer] established!")
	accept_call(caller_comm)

/datum/computer_file/program/communicator/proc/accept_call(datum/computer_file/program/communicator/caller_comm)
	connecting_to_call = FALSE
	caller_comm.remove_comm_request(get_computer_address(), CALL_REQUESTS)

	var/datum/comm_call/comm_call
	if(caller_comm.active_call) // If the caller already has a call going
		comm_call = caller_comm.active_call
	else
		comm_call = new()
		comm_call.add_device(caller_comm)
	comm_call.add_device(src)

	caller_comm.current_tab = CALL_TAB

/datum/computer_file/program/communicator/run_program(mob/user)
	if(!get_computer_address())
		computer.output_error("ERROR: Unable to locate network card.")
		return
	return ..()

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/alist/data = alist()

	if(!computer.registered_id)
		data["noID"] = TRUE
		// No ID means that the UI will show the 'Please register' screen, so no other data is needed until that changes.
		return data

	var/call_duration
	var/list/connected_callers = list()
	if(active_call)
		call_duration = time2text(world.timeofday - active_call.call_start_time, "mm:ss")
		for(var/datum/computer_file/program/communicator/comm as anything in active_call.connected_comms)
			if(comm != src)
				connected_callers += comm.get_computer_address()

	data["currentTab"] = current_tab
	data["ringerOn"] = ringer_on

	data["connectingToCall"] = connecting_to_call
	data["callDuration"] = call_duration
	data["callSettings"] = alist("speakerphoneOn" = speakerphone_on, "microphoneOn" = microphone_on)

	data["friendsList"] = friends
	data["connectedCallers"] = connected_callers
	data["callRequests"] = REQUESTS_DATA(comm_requests, CALL_REQUESTS)
	data["videoRequests"] = REQUESTS_DATA(comm_requests, VIDEO_REQUESTS)
	data["friendRequests"] = REQUESTS_DATA(comm_requests, FRIEND_REQUESTS)
	data["userComm"] = COMM_DATA(src, get_computer_address(), get_user_name())
	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	var/alist/data = alist()

	if(!computer.registered_id)
		return // See above

	var/list/ntnet_users = list()
	for(var/address in GLOB.active_communicator_apps)
		var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
		var/comm_username = comm.get_user_name()
		if(comm == src || !comm_username)
			continue

		ntnet_users += list(COMM_DATA(comm, address, comm_username))

	data["allUsers"] = ntnet_users // Todo: Maybe just put this in regular `ui_data()`, because it being static is causing some issues. (e.g. username changes)
	return data

/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	// Separated out to keep things slightly neater.
	if(params["target_address"])
		return handle_ui_act_target(action, params, ui, state)

	switch(action)
		if("switch_tab")
			current_tab = params["new_tab"]

		if("refresh_data")
			update_static_data(usr, ui)

		if("end_call")
			for(var/datum/computer_file/program/communicator/comm as anything in active_call.connected_comms - src)
				comm.computer.output_error("[get_user_name()] hung up.")
			active_call?.remove_device(src)
			current_tab = initial(current_tab)

		if("remove_friend")
			// The `friends` list is a list of names, so it's a bit more complicated to find their associated communicator.
			var/friend_name = params["target_name"]
			for(var/address in GLOB.active_communicator_apps)
				var/datum/computer_file/program/communicator/potential_comm = GLOB.active_communicator_apps[address]
				if(potential_comm.get_user_name() == friend_name)
					potential_comm.friends -= get_user_name()
					break

			friends -= friend_name

		if("toggle_speakerphone")
			speakerphone_on = !speakerphone_on

		if("toggle_mute")
			microphone_on = !microphone_on
			active_call?.set_mute(src, microphone_on)

		if("toggle_visibility")
			visible_on_network = !visible_on_network

		if("toggle_ringer")
			ringer_on = !ringer_on

		if("set_ringtone")
			var/new_ringtone = tgui_input_text(usr, "Set a new ringtone", "Ringtone", ringtone)
			if(new_ringtone)
				ringtone = new_ringtone

		if("set_username")
			var/new_name = params["new_name"]
			if(new_name == "__reset" || new_name == computer.registered_id?.registered_name)
				custom_username = null
			else
				custom_username = new_name
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
				target_comm.computer.output_notice("Friend request recieved from [get_user_name()]!")
			else if(params["action"] == "respond")
				var/target_username = target_comm.get_user_name()
				var/source_username = get_user_name()

				var/choice = tgui_alert(usr, "Friend request from [target_username]", "Friend Request", list("Accept", "Decline"))
				if(choice == null)
					return
				// Accept and decline both remove the request.
				target_comm.remove_comm_request(get_computer_address(), FRIEND_REQUESTS)
				if(choice == "Accept")
					friends |= target_username
					target_comm.friends |= source_username
					target_comm.computer.output_notice("[source_username] has accepted your friend request!")

		if("call_request")
			/* -- Sending a request to someone else: -- */
			if(params["action"] == "send")
				if(send_comm_request(target_address, CALL_REQUESTS))
					current_tab = CALL_TAB
					target_comm.current_tab = CALL_TAB
					target_comm.computer.output_notice("New call request from [get_user_name()]!")
			if(params["action"] == "cancel")
				if(remove_comm_request(target_address, CALL_REQUESTS))
					current_tab = initial(current_tab)
					target_comm.computer.output_error("Call request from [get_user_name()] cancelled.")
					if(target_comm.current_tab == CALL_TAB)
						target_comm.current_tab = initial(target_comm.current_tab)

			/* -- Responding to a request from someone else: -- */
			if(params["action"] == "accept")
				connecting_to_call = TRUE
				INVOKE_ASYNC(src, PROC_REF(call_connecting), target_comm, target_address)
			if(params["action"] == "decline")
				if(target_comm.remove_comm_request(get_computer_address(), CALL_REQUESTS))
					target_comm.computer.output_error("Your call request to [get_user_name()] was declined.")
					current_tab = initial(current_tab)
					if(target_comm.current_tab == CALL_TAB)
						target_comm.current_tab = initial(target_comm.current_tab)


	return TRUE

#undef REQUESTS_DATA
#undef COMM_DATA
#undef HOME_TAB
#undef PHONE_TAB
#undef CONTACTS_TAB
#undef MESSAGING_TAB
#undef SETTINGS_TAB
#undef CALL_TAB
