/datum/computer_file/program/comm
	filename = "comm"
	filedesc = "Command and Communications Program"
	program_icon_state = "comm"
	program_key_icon_state = "lightblue_key"
	extended_desc = "Used to command and control the station. Can relay long-range communications."
	required_access_run = ACCESS_HEADS
	required_access_download = ACCESS_HEADS
	requires_ntnet = TRUE
	size = 12
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_SILICON_AI
	network_destination = "station long-range communication array"
	color = LIGHT_COLOR_BLUE
	tgui_id = "CommandCommunications"
	ui_auto_update = FALSE
	var/datum/comm_message_listener/message_core
	var/intercept = FALSE
	var/can_call_shuttle = FALSE //If calling the shuttle should be available from this console
	var/centcomm_message_cooldown = 0
	var/announcement_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new

/datum/computer_file/program/comm/New(obj/item/modular_computer/comp, intercept_printing = FALSE, shuttle_call = FALSE)
	..()
	intercept = intercept_printing
	can_call_shuttle = shuttle_call
	message_core = new
	crew_announcement.newscast = TRUE

/datum/computer_file/program/comm/clone()
	var/datum/computer_file/program/comm/temp = ..()
	temp.message_core.messages = null
	temp.message_core.messages = message_core.messages.Copy()
	return temp

/datum/computer_file/program/comm/ui_data(mob/user)
	var/list/data = initial_data()

	data["emagged"] = computer_emagged
	data["net_comms"] = !!get_signal(NTNET_COMMUNICATION) //Double !! is needed to get 1 or 0 answer
	data["net_syscont"] = !!get_signal(NTNET_SYSTEMCONTROL)
	data["message_printing_intercepts"] = intercept
	if(computer)
		data["have_printer"] = !!computer.nano_printer
	else
		data["have_printer"] = FALSE

	data["can_call_shuttle"] = can_call_shuttle()
	data["isAI"] = issilicon(usr)
	data["authenticated"] = is_authenticated(user)
	data["boss_short"] = SSatlas.current_map.boss_short
	data["current_security_level"] = GLOB.security_level
	data["current_security_level_title"] = num2seclevel(GLOB.security_level)
	data["current_maint_all_access"] = GLOB.maint_all_access

	data["def_SEC_LEVEL_DELTA"] = SEC_LEVEL_DELTA
	data["def_SEC_LEVEL_YELLOW"] = SEC_LEVEL_YELLOW
	data["def_SEC_LEVEL_BLUE"] = SEC_LEVEL_BLUE
	data["def_SEC_LEVEL_GREEN"] = SEC_LEVEL_GREEN

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages
	data["message_deletion_allowed"] = l != GLOB.global_message_listener

	var/list/processed_evac_options = list()
	if(!isnull(GLOB.evacuation_controller))
		for (var/datum/evacuation_option/EO in GLOB.evacuation_controller.available_evac_options())
			if(EO.abandon_ship)
				continue
			var/list/option = list()
			option["option_text"] = EO.option_text
			option["option_target"] = EO.option_target
			option["needs_syscontrol"] = EO.needs_syscontrol
			option["silicon_allowed"] = EO.silicon_allowed
			processed_evac_options += list(option)
	data["evac_options"] = processed_evac_options

	return data

/datum/computer_file/program/comm/proc/is_authenticated(var/mob/user)
	return can_run(user)

/datum/computer_file/program/comm/proc/obtain_message_listener()
	return GLOB.global_message_listener

/datum/computer_file/program/comm/proc/can_call_shuttle()
	return can_call_shuttle

/datum/computer_file/program/comm/proc/set_announcement_cooldown(var/cooldown)
	announcement_cooldown = cooldown

/datum/computer_file/program/comm/proc/set_centcomm_message_cooldown(var/cooldown)
	centcomm_message_cooldown = cooldown

/datum/computer_file/program/comm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	var/mob/user = usr
	var/ntn_comm = !!get_signal(NTNET_COMMUNICATION)
	var/ntn_cont = !!get_signal(NTNET_SYSTEMCONTROL)
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(action)
		if("emergencymaint")
			if(is_authenticated(user) && (isAI(user) || !issilicon(user)))
				if(GLOB.maint_all_access)
					revoke_maint_all_access()
					feedback_inc("alert_comms_maintRevoke",1)
					log_and_message_admins("disabled emergency maintenance access")
				else
					make_maint_all_access()
					feedback_inc("alert_comms_maintGrant",1)
					log_and_message_admins("enabled emergency maintenance access")
		if("announce")
			if(is_authenticated(user) && !issilicon(usr) && ntn_comm)
				if(user)
					var/obj/item/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcement_cooldown)
					to_chat(usr, "Please allow at least one minute to pass between announcements")
					return
				var/input = tgui_input_text(usr, "Please write a message to announce to the [station_name()] crew.", "Priority Announcement", multiline = TRUE, encode = FALSE)
				if(!input || computer.use_check_and_message(usr))
					return FALSE
				var/was_hearing = HAS_TRAIT(computer, TRAIT_HEARING_SENSITIVE)
				if(!was_hearing)
					computer.become_hearing_sensitive()
				usr.say(STRIP_HTML_FULL(input, MAX_MESSAGE_LEN))
				if(!was_hearing)
					computer.lose_hearing_sensitivity()
				var/affected_zlevels = GetConnectedZlevels(GET_Z(computer))
				crew_announcement.Announce(computer.registered_message, zlevels = affected_zlevels)
				set_announcement_cooldown(TRUE)
				addtimer(CALLBACK(src, PROC_REF(set_announcement_cooldown), FALSE), 600) //One minute cooldown
		if("message")
			if(params["target"] == "emagged")
				if(is_authenticated(user) && computer_emagged && !issilicon(usr) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
						return TRUE
					var/input = sanitize(tgui_input_text(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.", "Emergency M&#e55sage", multiline = TRUE, encode = FALSE))
					if(!input || computer.use_check_and_message(usr))
						return FALSE
					Syndicate_announce(input, usr)
					to_chat(usr, SPAN_NOTICE("Message successfully transmitted."))
					log_say("[key_name(usr)] has sent a message to the syndicate: [input]")
					centcomm_message_cooldown = TRUE
					addtimer(CALLBACK(src, PROC_REF(set_centcomm_message_cooldown), FALSE), 300) // thirty second cooldown
			else if(params["target"] == "regular")
				if(is_authenticated(user) && !issilicon(usr) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
						return
					if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Traitor funs.
						to_chat(usr, SPAN_WARNING("No Emergency Bluespace Relay detected. Unable to transmit message."))
						return
					var/input = sanitize(tgui_input_text(usr, "Please choose a message to transmit to [SSatlas.current_map.boss_name] via quantum entanglement.", "Emergency Message", multiline = TRUE, encode = FALSE))
					if(!input || computer.use_check_and_message(usr))
						return
					Centcomm_announce(input, usr)
					to_chat(usr, SPAN_NOTICE("Message successfully transmitted."))
					log_say("[key_name(usr)] has sent a message to [SSatlas.current_map.boss_short]: [input]")
					centcomm_message_cooldown = TRUE
					addtimer(CALLBACK(src, PROC_REF(set_centcomm_message_cooldown), FALSE), 300) // thirty second cooldown
		if("evac")
			if(is_authenticated(user))
				var/datum/evacuation_option/selected_evac_option = GLOB.evacuation_controller.evacuation_options[params["target"]]
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && issilicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				var/confirm = alert("Are you sure you want to [selected_evac_option.option_desc]?", filedesc, "No", "Yes")
				if (confirm == "Yes" && !computer.use_check_and_message(usr))
					GLOB.evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			if(is_authenticated(user) && ntn_cont)
				switch(params["target"])
					if("message")
						post_display_status("message", params["line1"], params["line2"])
					if("alert")
						post_display_status("alert", params["alert"])
					else
						post_display_status(params["target"])

		if("setalert")
			if(is_authenticated(user) && (!issilicon(usr) || isAI(usr)) && ntn_cont && ntn_comm)
				var/current_level = text2num(params["target"])
				var/confirm = tgui_alert(usr, "Are you sure you want to change alert level to [num2seclevel(current_level)]?", filedesc, list("No", "Yes"))
				if(confirm == "Yes" && !computer.use_check_and_message(usr, (isAI(usr) ? USE_ALLOW_NON_ADJACENT : FALSE)))
					var/old_level = GLOB.security_level
					if(!current_level)
						current_level = SEC_LEVEL_GREEN
					if(current_level < SEC_LEVEL_GREEN)
						current_level = SEC_LEVEL_GREEN
					if(current_level > SEC_LEVEL_BLUE)
						current_level = SEC_LEVEL_BLUE
					set_security_level(current_level)
					if(GLOB.security_level != old_level)
						log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
						message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
						switch(GLOB.security_level)
							if(SEC_LEVEL_GREEN)
								feedback_inc("alert_comms_green",1)
							if(SEC_LEVEL_BLUE)
								feedback_inc("alert_comms_blue",1)
							if(SEC_LEVEL_YELLOW)
								feedback_inc("alert_comms_yellow",1)
			else
				to_chat(usr, SPAN_WARNING("You press the button, but a red light flashes and nothing happens.")) //This should never happen
		if("delmessage")
			if(is_authenticated(user) && ntn_comm && l != GLOB.global_message_listener)
				l.Remove(params["messageid"])
		if("printmessage")
			if(is_authenticated(user) && ntn_comm)
				if(computer && computer.nano_printer)
					if(!computer.nano_printer.print_text(params["contents"], params["title"]))
						to_chat(usr, SPAN_WARNING("Hardware error: Printer was unable to print the file. It may be out of paper."))
					else
						computer.visible_message(SPAN_NOTICE("\The [computer] prints out paper."))
		if("toggleintercept")
			if(is_authenticated(user) && ntn_comm)
				if(computer?.nano_printer)
					intercept = !intercept

	return TRUE

/datum/computer_file/program/comm/intercept/New(obj/item/modular_computer/comp, intercept_printing, shuttle_call)
	. = ..(comp, TRUE, shuttle_call)

/*
General message handling stuff
*/
GLOBAL_LIST_EMPTY_TYPED(comm_message_listeners, /datum/comm_message_listener)
GLOBAL_DATUM_INIT(global_message_listener, /datum/comm_message_listener, new()) //May be used by admins
GLOBAL_VAR_INIT(last_message_id, 0)

/proc/get_comm_message_id()
	GLOB.last_message_id = GLOB.last_message_id + 1
	return GLOB.last_message_id

/proc/post_comm_message(var/message_title, var/message_text)
	var/list/message = list()
	message["id"] = get_comm_message_id()
	message["title"] = message_title
	message["contents"] = message_text

	for (var/datum/comm_message_listener/l in GLOB.comm_message_listeners)
		l.Add(message)

	for (var/obj/item/modular_computer/computer in get_listeners_by_type("modular_computers", /obj/item/modular_computer))
		if(computer?.working && !!computer.nano_printer && computer.hard_drive?.stored_files.len)
			var/datum/computer_file/program/comm/C = locate(/datum/computer_file/program/comm) in computer.hard_drive.stored_files
			if(C?.intercept)
				computer.nano_printer.print_text(message_text, message_title, "#deebff")


/datum/comm_message_listener
	var/list/messages

/datum/comm_message_listener/New()
	..()
	messages = list()
	GLOB.comm_message_listeners.Add(src)

/datum/comm_message_listener/Destroy(force)
	GLOB.comm_message_listeners.Remove(src)
	. = ..()

/datum/comm_message_listener/proc/Add(var/list/message)
	messages[++messages.len] = message

/datum/comm_message_listener/proc/Remove(var/list/message)
	messages -= list(message)
/*
Command action procs
*/
/proc/post_display_status(var/command, var/data1, var/data2)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency)
		return


	var/datum/signal/status_signal = new
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [key_name(usr)] set status screen message with: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(signal = status_signal)

//Returns 1 if recalled 0 if not
/proc/cancel_call_proc(var/mob/user)
	if(!(ROUND_IS_STARTED) || !GLOB.evacuation_controller)
		return FALSE

	if(SSatlas.current_map.shuttle_call_restarts && SSatlas.current_map.shuttle_call_restart_timer)
		deltimer(SSatlas.current_map.shuttle_call_restart_timer)
		SSatlas.current_map.shuttle_call_restart_timer = null
		log_game("[key_name(user)] has stopped the 'shuttle' round restart.", key_name(user))
		message_admins("[key_name_admin(user)] has stopped the 'shuttle' round restart.", 1)
		to_world(FONT_LARGE(SPAN_VOTE(SSatlas.current_map.shuttle_recall_message)))
		return

	if(SSticker.mode.name == "Meteor")
		return FALSE

	if(GLOB.evacuation_controller.cancel_evacuation())
		log_and_message_admins("has cancelled the evacuation.", user)
		return TRUE
	return FALSE


/proc/is_relay_online()
	for(var/obj/machinery/bluespacerelay/M in SSmachinery.machinery)
		if(M.stat == 0)
			return TRUE
	return FALSE

//Returns 1 if called 0 if not
/proc/call_shuttle_proc(var/mob/user, var/_evac_type = TRANSFER_CREW)
	if((!(ROUND_IS_STARTED) || !GLOB.evacuation_controller))
		return FALSE

	if(!GLOB.universe.OnShuttleCall(usr))
		to_chat(user, SPAN_WARNING("A bluespace connection cannot be established! Please check the user manual for more information."))
		return FALSE

	if(GLOB.evacuation_controller.deny)
		to_chat(user, SPAN_WARNING("An evacuation cannot be sent at this time. Please try again later."))
		return FALSE

	if(world.time < GLOB.config.time_to_call_emergency_shuttle)
		to_chat(user, SPAN_WARNING("An evacuation cannot be sent at this time. Please wait another [round((GLOB.config.time_to_call_emergency_shuttle-world.time)/600)] minute\s before trying again."))
		return FALSE

	if(GLOB.evacuation_controller.is_on_cooldown()) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, GLOB.evacuation_controller.get_cooldown_message())

	if(GLOB.evacuation_controller.is_evacuating())
		to_chat(user, "An evacuation is already underway.")
		return

	if(GLOB.evacuation_controller.call_evacuation(user, _evac_type))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has called a shuttle.")

	return TRUE

/proc/init_shift_change(var/mob/user, var/force = FALSE)
	if(!(ROUND_IS_STARTED) || !GLOB.evacuation_controller)
		return

	if(SSatlas.current_map.shuttle_call_restarts)
		SSatlas.current_map.shuttle_call_restart_timer = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reboot_world)), 10 MINUTES, TIMER_UNIQUE|TIMER_STOPPABLE)
		log_game("[user? key_name(user) : "Autotransfer"] has called the 'shuttle' round restart.")
		message_admins("[user? key_name_admin(user) : "Autotransfer"] has called the 'shuttle' round restart.", 1)
		to_world(FONT_LARGE(SPAN_VOTE(SSatlas.current_map.shuttle_called_message)))
		return

	. = GLOB.evacuation_controller.call_evacuation(null, _evac_type = TRANSFER_CREW, autotransfer = TRUE)

	//delay events in case of an autotransfer
	if(.)
		SSevents.delay_events(EVENT_LEVEL_MODERATE, 10200) //17 minutes
		SSevents.delay_events(EVENT_LEVEL_MAJOR, 10200)

	log_game("[user? key_name(user) : "Autotransfer"] has called the shuttle.")
	message_admins("[user? key_name_admin(user) : "Autotransfer"] has called the shuttle.", 1)
