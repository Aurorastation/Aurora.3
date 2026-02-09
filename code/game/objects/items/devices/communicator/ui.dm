/obj/item/communicator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Communicator")
		// Todo: Once the UI is finished(ish), check if disabling autoupdate is viable
		ui.open()

/obj/item/communicator/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/communicator/ui_data(mob/user)
	var/alist/data = alist()

	// Todo: Lots of identical loops here. Alternative?
	// Todo: Move loops to static data?
	var/list/incoming_calls = list()
	for(var/caller_address, caller_name in incoming_call_invites)
		incoming_calls.Add(list(alist(
			"address" = caller_address,
			"name" = caller_name // Todo: Sanitize? (VOREStation is sanitising this. Check why.)
		)))

	var/list/outgoing_calls = list()
	for(var/target_address, target_name in outgoing_call_invites)
		outgoing_calls.Add(list(alist(
			"address" = target_address,
			"name" = target_name
		)))

	var/list/callers = list()
	for(var/obj/item/communicator/comm as anything in connected_callers)
		callers.Add(list(alist(
			"ownerName" = comm.owner_name,
			"ref" = REF(comm)
		)))

	var/list/friends = list()
	for(var/contact_address, contact_name in friends_list)
		friends.Add(list(alist(
			"address" = contact_address,
			"name" = contact_name
		)))

	var/list/public_devices = list()
	for(var/obj/item/communicator/comm as anything in GLOB.all_communicators)
		if(comm != src && comm.exonet?.visible_on_network)
			var/datum/exonet_protocol/E = comm.exonet
			public_devices.Add(list(alist(
				"address" = E.address,
				"name" = comm.owner_name
			)))

	// Device information
	data["ownerName"] = owner_name
	data["ownerOccupation"] = owner_occupation
	data["friendsList"] = friends
	data["incomingFriendRequests"] = incoming_friend_requests
	data["outgoingFriendRequests"] = outgoing_friend_requests
	data["incomingCalls"] = incoming_calls
	data["outgoingCalls"] = outgoing_calls
	data["connectedCallers"] = callers
	data["flashlightOn"] = flashlight_on

	// Other general information
	data["time"] = worldtime2text()
	data["publicDevices"] = public_devices
	//data["connectionStatus"] todo

	return data

/obj/item/communicator/ui_static_data(mob/user)
	var/alist/data = alist()
	return data

/obj/item/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("friend_request_send")
			exonet.send_message(params["selected_address"], EXONET_CATG_FRIEND_REQ, EXONET_TYPE_REQUEST)
		if("friend_request_respond")
			var/friend_address = params["selected_address"]
			var/obj/item/communicator/friend_comm = exonet.get_atom_from_address(friend_address)
			if(!friend_comm || !(friend_address in incoming_friend_requests))
				return

			var/choice = tgui_alert(usr, "Friend request from [friend_comm.owner_name]", "Friend Request", list("Accept", "Decline"))
			if(choice == "Accept")
				add_friend(friend_comm)
			else if(choice == "Decline")
				incoming_friend_requests -= friend_address
				friend_comm.outgoing_friend_requests -= exonet.address
				friend_comm.message_holding_mob(SPAN_WARNING("[owner_name] has declined your friend request!"))

		if("toggle_flashlight")
			flashlight_on = !flashlight_on
			set_light(flashlight_range * flashlight_on)
