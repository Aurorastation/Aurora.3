// Mirror of the `CommunicatorTab` enum in '../Communicator/types.ts'.
#define HOME_TAB 0
#define PHONE_TAB 1
#define CONTACTS_TAB 2
#define MESSAGING_TAB 3
#define SETTINGS_TAB 4
#define CALL_TAB 5

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

	caller_comm.current_tab = CALL_TAB
