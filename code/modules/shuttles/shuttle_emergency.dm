/datum/shuttle/autodock/ferry/emergency
	category = /datum/shuttle/autodock/ferry/emergency
	move_time = 10 MINUTES
	var/datum/evacuation_controller/shuttle/emergency_controller

/datum/shuttle/autodock/ferry/emergency/New()
	..()
	emergency_controller = GLOB.evacuation_controller
	if(!istype(emergency_controller))
		CRASH("Escape shuttle created without the appropriate controller type.")
	if(emergency_controller.shuttle)
		CRASH("An emergency shuttle has already been created.")
	emergency_controller.shuttle = src

/datum/shuttle/autodock/ferry/emergency/arrived()
	. = ..()

	if(!emergency_controller.has_evacuated())
		emergency_controller.finish_preparing_evac()

	if (istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorization()

	if((current_location == waypoint_offsite) && emergency_controller.has_evacuated())
		emergency_controller.shuttle_evacuated()

/datum/shuttle/autodock/ferry/emergency/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	..(destination, interim, emergency_controller.get_long_jump_time(), direction)

/datum/shuttle/autodock/ferry/emergency/shuttle_moved()
	if(next_location != waypoint_station)
		emergency_controller.shuttle_leaving() // This is a hell of a line. v
	..()

/datum/shuttle/autodock/ferry/emergency/can_launch(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_force(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//initiating or cancelling a launch ALWAYS requires authorization, but if we are already set to launch anyways than forcing does not.
		//this is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
		if (!(process_state == WAIT_LAUNCH || C.has_authorization()))
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_cancel(var/user)
	if(emergency_controller.has_evacuated())
		return 0
	//If we try to cancel it via the shuttle computer
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		// Check if the computer is sufficiently authorized
		if (!C.has_authorization())
			return 0

		// If the emergency shuttle is waiting to leave the station and the world time exceeded the force time
		if(GLOB.evacuation_controller.is_prepared() && (world.time > emergency_controller.force_time))
			return 0

	return ..()

/datum/shuttle/autodock/ferry/emergency/launch(var/user)
	if (!can_launch(user))
		return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = FALSE
			to_world(SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Launch sequence initiated!</b>"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the shuttle autopilot and activated launch sequence")
		message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and activated launch sequence")

	..(user)

/datum/shuttle/autodock/ferry/emergency/force_launch(var/user)
	if (!can_force(user))
		return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = FALSE
			to_world(SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!</b>"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the shuttle autopilot and forced immediate launch")
		message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and forced immediate launch")

	..(user)

/datum/shuttle/autodock/ferry/emergency/cancel_launch(var/user)
	if (!can_cancel(user))
		return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = FALSE
			to_world(SPAN_NOTICE("<b>Alert: The shuttle autopilot has been overridden. Launch sequence aborted!</b>"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the shuttle autopilot and cancelled launch sequence")
		message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and cancelled launch sequence")

	..(user)

/obj/machinery/computer/shuttle_control/emergency
	shuttle_tag = "Escape Shuttle"
	var/debug = 0
	var/req_authorizations = 2
	var/list/authorized = list()

/obj/machinery/computer/shuttle_control/emergency/proc/has_authorization()
	return (authorized.len >= req_authorizations || emagged)

/obj/machinery/computer/shuttle_control/emergency/proc/reset_authorization()
	//no need to reset emagged status. If they really want to go back to the station they can.
	authorized = initial(authorized)

//returns 1 if the ID was accepted and a new authorization was added, 0 otherwise
/obj/machinery/computer/shuttle_control/emergency/proc/read_authorization(var/obj/item/ident)
	if (!ident || !istype(ident))
		return 0
	if (authorized.len >= req_authorizations)
		return 0	//don't need any more

	var/list/access
	var/auth_name
	var/dna_hash

	var/obj/item/card/id/ID = ident.GetID()

	if(!ID)
		return

	access = ID.access
	auth_name = "[ID.registered_name], [ID.assignment]"
	dna_hash = ID.dna_hash

	if (!access || !istype(access))
		return 0	//not an ID

	if (dna_hash in authorized)
		src.visible_message("\The [src] buzzes. That ID has already been scanned.")
		return 0

	if (!(ACCESS_HEADS in access))
		src.visible_message("\The [src] buzzes, rejecting [ident].")
		return 0

	src.visible_message("\The [src] beeps as it scans [ident].")
	authorized[dna_hash] = auth_name
	if (req_authorizations - authorized.len)
		to_world(SPAN_NOTICE("<b>Alert: [req_authorizations - authorized.len] authorization\s needed to override the shuttle autopilot.</b>"))

	if(usr)
		log_admin("[key_name(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")
		message_admins("[key_name_admin(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")

	return 1

/obj/machinery/computer/shuttle_control/emergency/emag_act(var/remaining_charges, var/mob/user, var/hotwired = FALSE)
	if (!emagged)
		to_chat(user, SPAN_NOTICE("You short out \the [src]'s authorization protocols."))
		emagged = 1
		return 1

/obj/machinery/computer/shuttle_control/emergency/attackby(obj/item/attacking_item, mob/user)
	read_authorization(attacking_item)
	..()

/obj/machinery/computer/shuttle_control/emergency/ui_interact(mob/user, datum/tgui/ui)
	var/datum/shuttle/autodock/ferry/emergency/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(user, SPAN_WARNING("Unable to establish link with the shuttle."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapeShuttleControlConsole", "Escape Shuttle Control", ui_x=470, ui_y=420)
		ui.open()

/obj/machinery/computer/shuttle_control/emergency/ui_data(mob/user)
	var/datum/shuttle/autodock/ferry/emergency/shuttle = SSshuttle.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"
		if(SHUTTLE_HALT) shuttle_state = "halt"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else if (!shuttle.location)
				shuttle_status = "Standing-by at [SSatlas.current_map.station_name]."
			else
				shuttle_status = "Standing-by at [SSatlas.current_map.dock_name]."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has received command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	//build a list of authorizations
	var/list/auth_list[req_authorizations]

	if (!emagged)
		var/i = 1
		for (var/dna_hash in authorized)
			auth_list[i++] = list("auth_name"=authorized[dna_hash], "auth_hash"=dna_hash)

		while (i <= req_authorizations)	//fill up the rest of the list with blank entries
			auth_list[i++] = list("auth_name"="", "auth_hash"=null)
	else
		for (var/i = 1; i <= req_authorizations; i++)
			auth_list[i] = list("auth_name"="<font color=\"red\">ERROR</font>", "auth_hash"=null)

	var/has_auth = has_authorization()

	return list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller? 1 : 0,
		"docking_status" = shuttle.active_docking_controller? shuttle.active_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(src),
		"can_cancel" = shuttle.can_cancel(src),
		"can_force" = shuttle.can_force(src),
		"auth_list" = auth_list,
		"has_auth" = has_auth
	)

/obj/machinery/computer/shuttle_control/emergency/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "removeid")
		var/dna_hash = params["removeid"]
		authorized -= dna_hash

	if(!emagged && action == "scanid")
		//They selected an empty entry. Try to scan their id.
		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if (!read_authorization(H.get_active_hand()))	//try to read what's in their hand first
				read_authorization(H.wear_id)
