// BIG TODO: Ensure that ALL new datums and items being deleted individually and while midway through an action (e.g. calling someone) gets handled properly.

/// Associative list of NTNet addresses and their corresponding [/datum/computer_file/program/communicator].
///
/// Communicator apps will only be present in this list if their parent [/obj/item/modular_computer/handheld/communicator] has both a registered user,
/// and a vaid NTNet address through its network card.
GLOBAL_LIST_EMPTY(active_communicator_apps)

/datum/computer_file/program/communicator
	filename = "ntnet_comm"
	filedesc = "Communicator"
	program_icon_state = "comm"
	extended_desc = "todo"
	//size = todo
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "todo"
	//color = todo
	tgui_id = "Communicator"

	var/datum/comm_call/active_call

	// {friend address: last known username}
	var/alist/friends = alist()

	// request values are all ntnet addresses (todo: actual documentation)
	var/alist/comm_requests = alist(
		INCOMING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			//VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		),
		OUTGOING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			//VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		)
	)

	var/current_tab = COMM_HOME_TAB
	var/connecting_to_address = null

	var/custom_username = null
	var/visible_on_network = TRUE
	var/speakerphone_on = FALSE
	var/microphone_on = TRUE

/datum/computer_file/program/communicator/New(obj/item/modular_computer/comp)
	. = ..()
	if(!istype(comp))
		return

	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_INSTALLED, PROC_REF(on_hw_installed))
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_UNINSTALLED, PROC_REF(on_hw_uninstalled))

/datum/computer_file/program/communicator/Destroy()
	clean_variables()
	remove_from_active()
	return ..()

/datum/computer_file/program/communicator/run_program(mob/user)
	add_to_active()
	if(!get_computer_address())
		computer.output_error("ERROR: Unable to locate network card.")
		return
	return ..()

/datum/computer_file/program/communicator/kill_program(forced)
	. = ..()
	current_tab = initial(current_tab)

/datum/computer_file/program/communicator/service_activate()


/datum/computer_file/program/communicator/event_registered()
	add_to_active()
	update_static_data_for_all_viewers()

/datum/computer_file/program/communicator/event_unregistered()
	remove_from_active()
	update_static_data_for_all_viewers()

/datum/computer_file/program/communicator/event_networkfailure(background)
	. = ..()
	remove_from_active()
	//todo: make this work when the program is closed too, probably through the service?
	//todo: stop the communicator program being downloaded by PDAs and stuff

/datum/computer_file/program/communicator/proc/on_hw_installed(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(computer.registered_id && istype(H, /obj/item/computer_hardware/network_card))
		add_to_active(computer.network_card.identification_addr)

/datum/computer_file/program/communicator/proc/on_hw_uninstalled(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(istype(H, /obj/item/computer_hardware/network_card))
		var/obj/item/computer_hardware/network_card/net_card = H
		remove_from_active(net_card.identification_addr)

/datum/computer_file/program/communicator/proc/add_to_active(address = null)
	address ||= get_computer_address()
	if(address)
		GLOB.active_communicator_apps[address] = src

/datum/computer_file/program/communicator/proc/remove_from_active(address = null)
	address ||= get_computer_address()
	if(address)
		GLOB.active_communicator_apps -= address

/datum/computer_file/program/communicator/proc/clean_variables()
	if(active_call)
		// `active_call` gets set to null in `remove_device()`.
		active_call.remove_device(src)

	// Try to clean up any requests to and from this communicator.
	var/comm_address = get_computer_address()
	if(comm_address)
		for(var/category in comm_requests[INCOMING_REQUESTS])
			for(var/address in comm_requests[INCOMING_REQUESTS][category])
				var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
				comm?.cancel_comm_request(comm_address, category)
	for(var/category in comm_requests[OUTGOING_REQUESTS])
		for(var/address in comm_requests[OUTGOING_REQUESTS][category])
			cancel_comm_request(address, category)

/datum/computer_file/program/communicator/proc/get_computer_address()
	return computer.network_card?.identification_addr

/datum/computer_file/program/communicator/proc/get_user_name()
	return custom_username || computer.registered_id?.registered_name


/datum/computer_file/program/communicator/proc/send_comm_request(target_address, category)
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!source_address || !target_comm)
		return FALSE

	if(!target_comm.recieve_comm_request(source_address, category))
		return FALSE
	comm_requests[OUTGOING_REQUESTS][category] |= target_address
	return TRUE

/datum/computer_file/program/communicator/proc/cancel_comm_request(target_address, category)
	comm_requests[OUTGOING_REQUESTS][category] -= target_address

	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(source_address && target_comm)
		target_comm.comm_requests[INCOMING_REQUESTS][category] -= source_address

/datum/computer_file/program/communicator/proc/recieve_comm_request(source_address, category)
	if(source_address in comm_requests[INCOMING_REQUESTS][category])
		return FALSE
	if(category == CALL_REQUESTS && active_call)
		return FALSE

	comm_requests[INCOMING_REQUESTS][category] |= source_address

	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[source_address]
	var/caller_name = caller_comm?.get_user_name() || "\[UNKNOWN\]"
	computer.get_notification("New [category] request!", 1, caller_name)
	return TRUE
