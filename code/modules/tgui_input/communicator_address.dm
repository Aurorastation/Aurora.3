/**
 * Opens a structured communicator-address input and returns a complete NTNet
 * address. The fixed fc00 prefix and separators are rendered by TGUI, so only
 * the three customizable four-character groups can be edited.
 */
/proc/tgui_input_communicator_address(mob/user, title = "Communicator Number", default, timeout = 0, ui_state = GLOB.always_state)
	if(!user)
		user = usr
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	if(!user.client)
		return

	if(!user.client.prefs.tgui_inputs)
		var/address = input(user, "Enter an address in the form fc00:xxxx:xxxx:xxxx.", title, default) as text|null
		return validate_ntnet_address(address) ? lowertext(address) : null

	var/datum/tgui_input_communicator_address/address_input = new(user, title, default, timeout, ui_state)
	address_input.ui_interact(user)
	address_input.wait()
	if(address_input)
		. = address_input.entry
		qdel(address_input)

/datum/tgui_input_communicator_address
	var/closed
	var/entry
	var/list/groups = list("0000", "0000", "0000")
	var/start_time
	var/timeout
	var/title
	var/datum/ui_state/state

/datum/tgui_input_communicator_address/New(mob/user, title, default, timeout, ui_state)
	src.title = title
	src.state = ui_state
	if(validate_ntnet_address(default))
		var/list/address_groups = splittext(lowertext(default), ":")
		groups = list(address_groups[2], address_groups[3], address_groups[4])
	if(timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_input_communicator_address/Destroy(force)
	SStgui.close_uis(src)
	state = null
	groups = null
	return ..()

/datum/tgui_input_communicator_address/proc/wait()
	while(!entry && !closed && !QDELETED(src))
		stoplag(1)

/datum/tgui_input_communicator_address/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommunicatorAddressInput")
		ui.open()

/datum/tgui_input_communicator_address/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_input_communicator_address/ui_state(mob/user)
	return state

/datum/tgui_input_communicator_address/ui_static_data(mob/user)
	return list(
		"groups" = groups,
		"large_buttons" = user.client.prefs.tgui_buttons_large,
		"swapped_buttons" = user.client.prefs.tgui_inputs_swapped,
		"title" = title,
	)

/datum/tgui_input_communicator_address/ui_data(mob/user)
	var/list/data = list()
	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))
	return data

/datum/tgui_input_communicator_address/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("submit")
			var/list/input_groups = params["groups"]
			if(!islist(input_groups) || length(input_groups) != 3)
				return TRUE
			var/address = lowertext("fc00:[input_groups[1]]:[input_groups[2]]:[input_groups[3]]")
			if(!validate_ntnet_address(address))
				to_chat(usr, SPAN_WARNING("Each communicator address group must contain exactly four letters or numbers."))
				return TRUE
			entry = address
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
	return FALSE
