// Events are sent to the program by the computer.
// Always include a parent call when overriding an event.

// This is performed on program startup. May be overriden to add extra logic. Remember to include ..() call. Return 1 on success, 0 on failure.
// When implementing new program based device, use this to run the program.
/datum/computer_file/program/proc/run_program(var/mob/user)
	if(can_run(user, 1) || !requires_access_to_run)
		if(nanomodule_path)
			NM = new nanomodule_path(src, new /datum/topic_manager/program(src), src)
		if(requires_ntnet && network_destination)
			generate_network_log("Connection opened to [network_destination].")
		program_state = PROGRAM_STATE_ACTIVE
		return TRUE
	return FALSE

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/proc/kill_program(var/forced = 0)
	program_state = PROGRAM_STATE_KILLED
	if(network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(NM)
		qdel(NM)
		NM = null
	return TRUE

// Is called when program service is being activated
// Returns 1 if service startup was sucessfull
/datum/computer_file/program/proc/service_activate()
	return FALSE

// Is called when program service is being deactivated
/datum/computer_file/program/proc/service_deactivate()
	return

// Is called when program service is being activated for first time.
/datum/computer_file/program/proc/service_enable()
	return service_activate()

// Is called when program service is being deactivated without
/datum/computer_file/program/proc/service_disable()
	return service_deactivate()

/// SECOND ORDER EVENTS

// Called when the ID card is removed from computer. ID is removed AFTER this proc.
/datum/computer_file/program/proc/event_idremoved(var/background)
	return

/datum/computer_file/program/proc/event_silentmode(var/background)
	return

// Called when an ID is unregistered from the device.
/datum/computer_file/program/proc/event_unregistered()
	return

// Called when an ID is unregistered from the device.
/datum/computer_file/program/proc/event_registered()
	return

// Called when the computer fails due to power loss. Override when program wants to specifically react to power loss.
/datum/computer_file/program/proc/event_powerfailure(var/background)
	if(program_state > PROGRAM_STATE_KILLED)
		kill_program(TRUE)

// Called when the network connectivity fails. Computer does necessary checks and only calls this when requires_ntnet_feature and similar variables are not met.
/datum/computer_file/program/proc/event_networkfailure(var/background)
	kill_program(TRUE)
	if(background)
		computer.output_error(FONT_SMALL(SPAN_WARNING("Process [filename].[filetype] (PID [rand(100,999)]) terminated - Network Error")))
	else
		computer.output_error(FONT_SMALL(SPAN_WARNING("NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.")))
