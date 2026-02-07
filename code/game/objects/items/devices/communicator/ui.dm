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

	// Device information
	data["ownerName"] = owner_name
	data["ownerOccupation"] = owner_occupation || "Swipe ID to set."
	data["incomingCalls"] = incoming_calls
	data["outgoingCalls"] = outgoing_calls
	data["connectedCallers"] = callers
	data["flashlightOn"] = flashlight_on

	// Other general information
	data["time"] = worldtime2text()
	//data["connecitonStatus"] todo

	return data

/obj/item/communicator/ui_static_data(mob/user)


/obj/item/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
