// /program/ files are executable programs that do things.
ABSTRACT_TYPE(/datum/computer_file/program)
	filetype = "PRG"

	/// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
	filename = "UnknownProgram"

	/// User-friendly name of this program.
	filedesc = "Unknown Program"

	/// Program type, used to determine if program runs in background or not.
	var/program_type = PROGRAM_NORMAL

	/// List of required accesses to run the program.
	var/required_access_run

	/// List of required accesses to download the program.
	var/required_access_download

	/// Whether the program checks for required_access when run. (1 = requires single access, 2 = requires single access from list, 3 = requires all access from list)
	var/requires_access_to_run = PROGRAM_ACCESS_ONE

	/// Whether the program checks for required_access when downloading. (1 = requires single access, 2 = requires single access from list, 3 = requires all access from list)
	var/requires_access_to_download = PROGRAM_ACCESS_ONE

	/// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/program_state = PROGRAM_STATE_KILLED

	/**
	 * The device that runs this program
	 *
	 * **Only supported way to set this is by calling set_computer()**
	 */
	var/obj/item/modular_computer/computer

	/// Short description of this program's function.
	var/extended_desc = "N/A"

	/// Program-specific screen icon state
	var/program_icon_state

	/// Program-specific keyboard icon state (really only applies to consoles but can be used for other purposes like having mix-n-match screens)
	var/program_key_icon_state

	/// Set to TRUE for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet = FALSE

	/// Optional, if above is set to TRUE checks for specific function of NTNet (currently NTNET_SOFTWAREDOWNLOAD, NTNET_PEERTOPEER, NTNET_SYSTEMCONTROL and NTNET_COMMUNICATION)
	var/requires_ntnet_feature = FALSE

	/// NTNet status, updated every tick by computer running this program. Don't use this for checks if NTNet works, computers do that. Use this for calculations, etc.
	var/ntnet_status = TRUE

	/// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET combination) or PROGRAM_ALL
	var/usage_flags = PROGRAM_ALL

	/// Optional string that describes what NTNet server/system this program connects to. Used in default logging.
	var/network_destination

	/// Whether the program can be downloaded from NTNet. Set to 0 to disable.
	var/available_on_ntnet = TRUE

	/// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to 1 to enable.
	var/available_on_syndinet = FALSE

	/// Set to TRUE if computer that's running us was emagged. Computer updates this every Process() tick
	var/computer_emagged = FALSE

	/// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!
	var/ui_header

	/// The color of light the computer should emit when this program is open.
	var/color = "#FFFFFF"

	/// PROGRAM_STATE_KILLED or PROGRAM_STATE_ACTIVE - specifies whether this program's service is running.
	var/service_state = PROGRAM_STATE_DISABLED

	var/silent = FALSE

	/// Name of the TGUI Interface
	var/tgui_id

	/// Theme of this TGUI interface
	var/tgui_theme = "scc"

	/// If this TGUI should autoupdate or not.
	var/ui_auto_update = TRUE

	// TO BE DEPRECATED:
	var/datum/nano_module/NM								// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/nanomodule_path										// Path to nanomodule, make sure to set this if implementing new program.

/datum/computer_file/program/New(obj/item/modular_computer/comp)
	..()
	if(comp)
		if(comp == "Compless") // we're software in the air, don't need a computer
			return
		else if(istype(comp))
			set_computer(comp)
		else
			crash_with("Comp was of the wrong type for [src.filename]")
	else
		crash_with("Comp was not sent for [src.filename]")

/datum/computer_file/program/Destroy()
	if(!QDELETED(computer))
		computer.idle_threads -= src
		computer.enabled_services -= src
		set_computer(null)
	. = ..()
	GC_TEMPORARY_HARDDEL

/datum/computer_file/program/ui_host()
	if(computer)
		return computer.ui_host()

/datum/computer_file/program/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(tgui_id) // we shouldn't use ui_interact on TGUI programs; see [code/modules/modular_computers/computers/modular_computer/ui.dm]
		stack_trace("Computer program tgUI [src] with tgui_id [tgui_id] called ui_interact on program datum")
	if(computer)
		. = computer.ui_interact(user, ui)

/datum/computer_file/program/update_static_data(mob/user, datum/tgui/ui)
	. = ..()
	if(computer)
		. = computer.update_static_data(user, ui)

/datum/computer_file/program/update_static_data_for_all_viewers()
	. = ..()
	if(computer)
		. = computer.update_static_data_for_all_viewers()

/datum/computer_file/program/clone(var/rename = FALSE, var/computer)
	var/datum/computer_file/program/temp = ..(rename, computer)
	temp.required_access_run = required_access_run
	temp.required_access_download = required_access_download
	temp.nanomodule_path = nanomodule_path
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.requires_ntnet_feature = requires_ntnet_feature
	temp.usage_flags = usage_flags
	return temp

/**
 * Sets the computer this program is running on
 *
 * * computer - The computer to set this program to, or `null` to remove it
 */
/datum/computer_file/program/proc/set_computer(obj/item/modular_computer/computer)
	SHOULD_NOT_SLEEP(TRUE)

	//Not setting something already being deleted
	if(istype(computer) && QDELETED(computer))
		return

	//It's already the same
	if(src.computer == computer)
		return

	//Stop listening for the old computer
	if(istype(src.computer))
		UnregisterSignal(src.computer, COMSIG_QDELETING)

	src.computer = computer

	//Start listening for the new computer, if it's one
	if(istype(computer))
		RegisterSignal(computer, COMSIG_QDELETING, PROC_REF(on_computer_deleted))

/**
 * Handles signal when the computer we are referencing is deleted
 */
/datum/computer_file/program/proc/on_computer_deleted()
	SIGNAL_HANDLER
	qdel(src)

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_icon()

// Attempts to create a log in global ntnet datum. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(var/text)
	if(computer)
		return computer.add_log(text)
	return FALSE

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag = 0, var/loud = FALSE, var/mob/user = null)
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
			if(!(check in I.access)) //Fail on first miss
				if(loud)
					to_chat(user, SPAN_WARNING("\The [computer] flashes, \"Access Denied.\"."))
				return FALSE
	else // Should never happen - So fail silently
		return FALSE

// Override to set when a program shouldn't appear in the program list
/datum/computer_file/program/proc/program_hidden()
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

	if(istype(computer, /obj/item/modular_computer/silicon/pai))
		check_type = requires_access_to_run
		access_to_check = required_access_run

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
			if(!(check in I.access)) //Fail on first miss
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

/// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/grants_equipment_vision(var/mob/user)
	if(NM)
		return NM.grants_equipment_vision(user)

/datum/computer_file/program/proc/message_dead(var/message)
	for(var/mob/M in GLOB.player_list)
		if(M.stat == DEAD && (M.client && M.client.prefs.toggles & CHAT_GHOSTEARS))
			if(isnewplayer(M))
				continue
			to_chat(M, message)
