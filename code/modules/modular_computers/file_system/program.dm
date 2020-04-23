// /program/ files are executable programs that do things.
/datum/computer_file/program
	filetype = "PRG"
	filename = "UnknownProgram"								// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
	var/required_access_run									// List of required accesses to run the program.
	var/required_access_download							// List of required accesses to download the program.
	var/requires_access_to_run = PROGRAM_ACCESS_ONE			// Whether the program checks for required_access when run. (1 = requires single access, 2 = requires single access from list, 3 = requires all access from list)
	var/requires_access_to_download = PROGRAM_ACCESS_ONE	// Whether the program checks for required_access when downloading. (1 = requires single access, 2 = requires single access from list, 3 = requires all access from list)
	var/datum/nano_module/NM								// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/nanomodule_path										// Path to nanomodule, make sure to set this if implementing new program.
	var/program_state = PROGRAM_STATE_KILLED				// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/obj/item/modular_computer/computer					// Device that runs this program.
	var/filedesc = "Unknown Program"						// User-friendly name of this program.
	var/extended_desc = "N/A"								// Short description of this program's function.
	var/program_icon_state									// Program-specific screen icon state
	var/requires_ntnet = FALSE								// Set to TRUE for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet_feature = FALSE						// Optional, if above is set to TRUE checks for specific function of NTNet (currently NTNET_SOFTWAREDOWNLOAD, NTNET_PEERTOPEER, NTNET_SYSTEMCONTROL and NTNET_COMMUNICATION)
	var/ntnet_status = TRUE									// NTNet status, updated every tick by computer running this program. Don't use this for checks if NTNet works, computers do that. Use this for calculations, etc.
	var/usage_flags = PROGRAM_ALL							// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET combination) or PROGRAM_ALL
	var/network_destination									// Optional string that describes what NTNet server/system this program connects to. Used in default logging.
	var/available_on_ntnet = TRUE							// Whether the program can be downloaded from NTNet. Set to 0 to disable.
	var/available_on_syndinet = FALSE						// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to 1 to enable.
	var/computer_emagged = FALSE							// Set to TRUE if computer that's running us was emagged. Computer updates this every Process() tick
	var/ui_header											// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!
	var/color = "#FFFFFF"								// The color of light the computer should emit when this program is open.

/datum/computer_file/program/New(var/obj/item/modular_computer/comp)
	..()
	if(comp && istype(comp))
		computer = comp

/datum/computer_file/program/Destroy()
	computer = null
	. = ..()

/datum/computer_file/program/ui_host()
	return computer.ui_host()

/datum/computer_file/program/clone()
	var/datum/computer_file/program/temp = ..()
	temp.required_access_run = required_access_run
	temp.required_access_download = required_access_download
	temp.nanomodule_path = nanomodule_path
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.requires_ntnet_feature = requires_ntnet_feature
	temp.usage_flags = usage_flags
	return temp

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_icon()

// Attempts to create a log in global ntnet datum. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(var/text)
	if(computer)
		return computer.add_log(text)
	return FALSE

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag = 0, var/loud = FALSE, var/mob/user)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Hardware Error - Incompatible software\"."))
		return FALSE
	return TRUE

/datum/computer_file/program/proc/get_signal(var/specific_action = 0)
	if(computer)
		return computer.get_ntnet_status(specific_action)
	return FALSE

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick()
	return TRUE

// Check if the user can run program. Only humans can operate computer. Automatically called in run_program()
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
// Check type determines how the access should be checked PROGRAM_ACCESS_ONE, PROGRAM_ACCESS_LIST_ONE, PROGRAM_ACCESS_LIST_ALL
/datum/computer_file/program/proc/can_run(var/mob/user, var/loud = FALSE, var/access_to_check, var/check_type)
	// Defaults to required_access_run
	if(!access_to_check)
		access_to_check = required_access_run

	//Default to requires_access_to_run
	if(!check_type)
		check_type = requires_access_to_run

	// No required_access, allow it.
	if(!access_to_check || !requires_access_to_run)
		return TRUE

	if(!istype(user))
		return FALSE

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"RFID Error - Unable to scan ID.\"."))
		return FALSE

	if(check_type == PROGRAM_ACCESS_ONE) //Check for single access
		if(access_to_check in I.access)
			return TRUE
		else if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
			return FALSE
	else if(check_type == PROGRAM_ACCESS_LIST_ONE)
		for(var/check in access_to_check) //Loop through all the accesse's to check
			if(check in I.access) //Success on first match
				return TRUE
		if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
	else if(check_type == PROGRAM_ACCESS_LIST_ALL)
		for(var/check in access_to_check) //Loop through all the accesse's to check
			if(!check in I.access) //Fail on first miss
				if(loud)
					to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
				return FALSE
	else // Should never happen - So fail silently
		return FALSE

// Check if the user can run program. Only humans can operate computer. Automatically called in run_program()
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
// Check type determines how the access should be checked PROGRAM_ACCESS_ONE, PROGRAM_ACCESS_LIST_ONE, PROGRAM_ACCESS_LIST_ALL
/datum/computer_file/program/proc/can_download(var/mob/user, var/loud = FALSE, var/access_to_check, var/check_type)
	// Defaults to required_access_run
	if(!access_to_check)
		access_to_check = required_access_download

	//Default to requires_access_to_run
	if(!check_type)
		check_type = requires_access_to_download

	// No required_access, allow it.
	if(!access_to_check || !requires_access_to_download)
		return TRUE

	if(!istype(user))
		return FALSE

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"RFID Error - Unable to scan ID.\"."))
		return FALSE

	if(check_type == PROGRAM_ACCESS_ONE) //Check for single access
		if(access_to_check in I.access)
			return TRUE
		else if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
			return FALSE
	else if(check_type == PROGRAM_ACCESS_LIST_ONE)
		for(var/check in access_to_check) //Loop through all the accesse's to check
			if(check in I.access) //Success on first match
				return TRUE
		if(loud)
			to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
			return FALSE
	else if(check_type == PROGRAM_ACCESS_LIST_ALL)
		for(var/check in access_to_check) //Loop through all the accesse's to check
			if(!check in I.access) //Fail on first miss
				if(loud)
					to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
				return FALSE
	else // Should never happen - So fail silently
		return FALSE

// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones
// always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data()
	if(computer)
		return computer.get_header_data()

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

// This is called every tick when the program is enabled. Ensure you do parent call if you override it. If parent returns 1 continue with UI initialisation.
// It returns 0 if it can't run or if NanoModule was used instead. I suggest using NanoModules where applicable.
/datum/computer_file/program/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(program_state != PROGRAM_STATE_ACTIVE) // Our program was closed. Close the ui if it exists.
		if(ui)
			ui.close()
		return computer.ui_interact(user)
	if(istype(NM))
		NM.ui_interact(user, ui_key, null, force_open)
		return FALSE
	return TRUE


// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return TRUE
	if(computer)
		return computer.Topic(href, href_list)

// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/check_eye(var/mob/user)
	if(NM)
		return NM.check_eye(user)
	else
		return -1