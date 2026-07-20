/**
 * Contains helper procs shared by command-facing modular computer apps.
 */

/**
 * General message handling stuff
 */
GLOBAL_LIST_EMPTY(comm_messages) //May be used by admins
GLOBAL_VAR_INIT(last_message_id, 0)

/**
 * Command sensor data helpers
 */
/proc/build_crew_sensor_lookup(var/list/z_levels)
	var/list/lookup = list(
		"by_ref" = list(),
		"by_name" = list()
	)
	if(!length(z_levels) || !GLOB.crew_repository)
		return lookup

	for(var/z_level in z_levels)
		for(var/list/crewmember_data as anything in GLOB.crew_repository.health_data(z_level))
			if(crewmember_data["ref"])
				lookup["by_ref"][crewmember_data["ref"]] = crewmember_data
			if(crewmember_data["name"])
				lookup["by_name"][crewmember_data["name"]] = crewmember_data

	return lookup

/proc/get_crew_sensor_data_for_member(var/datum/record/general/general_record, var/mob/living/carbon/human/live_member, var/list/sensor_lookup)
	if(!sensor_lookup)
		return
	if(istype(live_member))
		var/list/by_ref = sensor_lookup["by_ref"]
		var/list/by_ref_match = by_ref["[REF(live_member)]"]
		if(by_ref_match)
			return by_ref_match

	if(general_record?.name)
		var/list/by_name = sensor_lookup["by_name"]
		return by_name[general_record.name]

/proc/build_crew_tracking_sample(var/list/sensor_data, var/obj/effect/overmap/visitable/horizon)
	if(!sensor_data || sensor_data["stype"] < SUIT_SENSOR_TRACKING)
		return list("tracking" = FALSE)
	if(isnull(sensor_data["x"]) || isnull(sensor_data["y"]) || isnull(sensor_data["z"]))
		return list("tracking" = FALSE)

	var/list/tracking = list(
		"tracking" = TRUE,
		"x" = sensor_data["x"],
		"y" = sensor_data["y"],
		"z" = sensor_data["z"],
		"area" = sensor_data["area"]
	)
	if(istype(horizon))
		var/obj/effect/overmap/current_sector = GLOB.map_sectors["[sensor_data["z"]]"]
		tracking["sector"] = current_sector
		tracking["sector_name"] = current_sector ? current_sector.name : "Unknown"
		tracking["deployed_offship"] = current_sector && current_sector != horizon
	return tracking

/proc/get_crew_tracking_distance(var/list/tracking_a, var/list/tracking_b)
	if(!tracking_a || !tracking_b || !tracking_a["tracking"] || !tracking_b["tracking"])
		return
	if(tracking_a["z"] != tracking_b["z"])
		return
	if(isnull(tracking_a["x"]) || isnull(tracking_a["y"]) || isnull(tracking_b["x"]) || isnull(tracking_b["y"]))
		return

	var/delta_x = tracking_a["x"] - tracking_b["x"]
	var/delta_y = tracking_a["y"] - tracking_b["y"]
	return round(sqrt(delta_x * delta_x + delta_y * delta_y), 1)

/**
 * Command action procs
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

/proc/post_comm_message(var/message_title, var/message_text)
	var/list/message = list()
	GLOB.last_message_id++
	message["id"] = GLOB.last_message_id
	message["title"] = message_title
	message["contents"] = message_text

	GLOB.comm_messages += list(message)

	for(var/obj/item/modular_computer/computer in get_listeners_by_type("modular_computers", /obj/item/modular_computer))
		if(computer?.working && !!computer.nano_printer && computer.hard_drive?.stored_files.len)
			var/datum/computer_file/program/comm_control/comm_control_app = locate(/datum/computer_file/program/comm_control) in computer.hard_drive.stored_files
			if(comm_control_app?.intercept)
				computer.nano_printer.print_text(message_text, message_title, "#deebff")


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
	for(var/obj/structure/machinery/bluespacerelay/M in SSmachinery.machinery)
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
