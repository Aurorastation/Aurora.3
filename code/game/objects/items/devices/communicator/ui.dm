/obj/item/communicator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Communicator")
		ui.open()

/obj/item/communicator/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/communicator/ui_data(mob/user)
	var/alist/data = alist()

	var/list/call_requests = list("incoming" = list(), "outgoing" = list())
	for(var/address in incoming_requests[CALL_REQUESTS])
		call_requests["incoming"] += address
	for(var/address in outgoing_requests[CALL_REQUESTS])
		call_requests["outgoing"] += address

	var/list/friend_requests = list("incoming" = list(), "outgoing" = list())
	for(var/address in incoming_requests[FRIEND_REQUESTS])
		friend_requests["incoming"] += address
	for(var/address in outgoing_requests[FRIEND_REQUESTS])
		friend_requests["outgoing"] += address

	var/list/callers = list()
	for(var/obj/item/communicator/comm as anything in connected_callers)
		callers.Add(list(alist(
			"ownerName" = comm.owner_name,
			"ref" = REF(comm)
		)))

	var/list/friends = list()
	for(var/address, name in friends_list)
		friends.Add(list(alist(
			"address" = address,
			"name" = name
		)))

	data["callRequests"] = call_requests
	data["friendRequests"] = friend_requests
	data["friendsList"] = friends
	data["connectedCallers"] = callers

	data["ownerName"] = owner_name
	data["ownerOccupation"] = owner_occupation
	data["flashlightOn"] = flashlight_on
	data["time"] = worldtime2text()
	data["connectionStatus"] = TRUE // todo

	return data

/obj/item/communicator/ui_static_data(mob/user)
	var/alist/data = alist()

	var/list/all_communicators = list()
	for(var/obj/item/communicator/comm as anything in GLOB.all_communicators - src)
		if(!comm.exonet)
			continue
		all_communicators.Add(list(alist(
			"address" = comm.exonet.address,
			"ownerName" = comm.owner_name,
			"visible" = comm.exonet.visible_on_network
		)))

	data["allCommunicators"] = all_communicators

	return data

/obj/item/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("refresh_devices")
			update_static_data(usr, ui)
		if("friend_request_send")
			exonet.send_message(params["selected_address"], EXONET_CATG_FRIEND_REQ, EXONET_TYPE_REQUEST)
		if("friend_request_respond")
			var/friend_address = params["selected_address"]
			var/obj/item/communicator/friend_comm = exonet.get_atom_from_address(friend_address)
			if(!friend_comm || !(friend_address in incoming_requests[FRIEND_REQUESTS]))
				return

			var/choice = tgui_alert(usr, "Friend request from [friend_comm.owner_name]", "Friend Request", list("Accept", "Decline"))
			if(choice == "Accept")
				add_friend(friend_comm)
			else if(choice == "Decline")
				incoming_requests[FRIEND_REQUESTS] -= friend_address
				friend_comm.outgoing_requests[FRIEND_REQUESTS] -= exonet.address
				friend_comm.message_holding_mob(SPAN_WARNING("[owner_name] has declined your friend request!"))

		if("toggle_flashlight")
			flashlight_on = !flashlight_on
			set_light(flashlight_range * flashlight_on)

#undef CALL_REQUESTS
#undef FRIEND_REQUESTS
