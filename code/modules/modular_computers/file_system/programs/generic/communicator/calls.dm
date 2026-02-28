/datum/computer_file/program/communicator/proc/request_voice_call(datum/computer_file/program/communicator/target_comm, target_address)
	if(!send_comm_request(target_address, CALL_REQUESTS))
		computer.output_error("Unable to call [target_address].")
		return
	current_tab = COMM_CALL_TAB
	target_comm.current_tab = COMM_CALL_TAB

/datum/computer_file/program/communicator/proc/cancel_voice_call(datum/computer_file/program/communicator/target_comm, target_address, message)
	cancel_comm_request(target_address, CALL_REQUESTS)
	if(message)
		target_comm.computer.output_error(message)
	current_tab = initial(current_tab)
	if(target_comm.current_tab == COMM_CALL_TAB && !target_comm.active_call)
		target_comm.current_tab = initial(target_comm.current_tab)

// TODO: Make sure this works
/datum/computer_file/program/communicator/proc/call_checks(caller_address)
	if(QDELETED(src))
		return FALSE
	if(!(caller_address in comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]))
		connecting_to_address = null
		return FALSE
	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[caller_address]
	if(QDELETED(caller_comm))
		computer.output_error("Connection to {[caller_address]} lost!")
		connecting_to_address = null
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
	connecting_to_address = null
	caller_comm.cancel_comm_request(get_computer_address(), CALL_REQUESTS)

	var/datum/comm_call/comm_call
	if(caller_comm.active_call) // If the caller already has a call going
		comm_call = caller_comm.active_call
	else
		comm_call = new()
		comm_call.add_device(caller_comm)
	comm_call.add_device(src)

	caller_comm.speakerphone_on = FALSE
	caller_comm.microphone_on = TRUE
	caller_comm.current_tab = COMM_CALL_TAB

/datum/computer_file/program/communicator/proc/end_call(message)
	active_call?.remove_device(src, message)
	if(current_tab == COMM_CALL_TAB)
		current_tab = initial(current_tab)
