/datum/computer_file/program/communicator/proc/request_voice_call(datum/computer_file/program/communicator/target_comm, target_address)
	if(active_call && target_comm?.active_call == active_call)
		computer.output_error("That communicator is already in this call.")
		return FALSE
	if(!send_comm_request(target_address, CALL_REQUESTS))
		computer.output_error("Unable to call {[target_address]}.")
		return FALSE
	current_tab = COMM_CALL_TAB
	target_comm.current_tab = COMM_CALL_TAB
	computer.output_notice("Calling {[target_address]}...")
	refresh_icon_state()
	target_comm.refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/cancel_voice_call(datum/computer_file/program/communicator/target_comm, target_address, message)
	cancel_comm_request(target_address, CALL_REQUESTS)
	if(message && target_comm)
		target_comm.computer.output_error(message)
	current_tab = initial(current_tab)
	if(target_comm?.current_tab == COMM_CALL_TAB && !target_comm.active_call)
		target_comm.current_tab = initial(target_comm.current_tab)
	refresh_icon_state()
	target_comm?.refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/call_checks(caller_address)
	if(QDELETED(src) || !(caller_address in comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]) || active_call)
		connecting_to_address = null
		return FALSE
	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[caller_address]
	if(QDELETED(caller_comm) || GLOB.active_communicator_apps[get_computer_address()] != src)
		computer.output_error("Connection to {[caller_address]} lost!")
		connecting_to_address = null
		return FALSE
	return TRUE

/datum/computer_file/program/communicator/proc/accept_call(datum/computer_file/program/communicator/caller_comm)
	var/caller_address = caller_comm?.get_computer_address()
	if(!caller_address || !call_checks(caller_address))
		return FALSE
	connecting_to_address = caller_address
	caller_comm.cancel_comm_request(get_computer_address(), CALL_REQUESTS)

	var/datum/comm_call/new_call = caller_comm.active_call
	if(!new_call)
		new_call = new()
		new_call.add_device(caller_comm)
	new_call.add_device(src)

	connecting_to_address = null
	speakerphone_on = FALSE
	microphone_on = TRUE
	current_tab = COMM_CALL_TAB
	caller_comm.current_tab = COMM_CALL_TAB
	computer.output_notice("Connection to [caller_comm.computer] established!")
	caller_comm.computer.output_notice("Connection to [computer] established!")

	// A connected phone must not keep ringing other callers.
	var/list/other_callers = comm_requests[INCOMING_REQUESTS][CALL_REQUESTS].Copy()
	for(var/other_address in other_callers)
		var/datum/computer_file/program/communicator/other_comm = GLOB.active_communicator_apps[other_address]
		if(other_comm)
			other_comm.cancel_voice_call(src, get_computer_address(), "[get_user_name()] is now busy.")
		else
			comm_requests[INCOMING_REQUESTS][CALL_REQUESTS] -= other_address
	refresh_icon_state()
	caller_comm.refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/end_call(message)
	if(!active_call)
		return FALSE
	active_call.remove_device(src, message)
	if(current_tab == COMM_CALL_TAB)
		current_tab = initial(current_tab)
	refresh_icon_state()
	return TRUE
