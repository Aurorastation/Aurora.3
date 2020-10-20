#define UIDEBUG 1

/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_screen = "shuttle"
	light_color = LIGHT_COLOR_CYAN

	var/shuttle_tag      // Used to coordinate data in shuttle controller.
	var/hacked = FALSE   // Has been emagged, no access restrictions.

	var/ui_template = "shuttle-control-console"

/obj/machinery/computer/shuttle_control/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ghost(var/mob/abstract/observer/user)
	if(check_rights(R_ADMIN, 0, user))
		ui_interact(user)

/obj/machinery/computer/shuttle_control/proc/get_ui_data(var/datum/shuttle/autodock/shuttle)
	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE)
			shuttle_state = "idle"
		if(SHUTTLE_WARMUP)
			shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT)
			shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			var/cannot_depart = shuttle.current_location.cannot_depart(shuttle)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else if(cannot_depart)
				shuttle_status = cannot_depart
			else
				shuttle_status = "Standing-by at \the [shuttle.get_location_name()]."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has received command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to \the [shuttle.get_destination_name()]."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	var/engine_status
	switch(shuttle_state)
		if("idle")
			engine_status = "IDLE"
		if("warmup")
			engine_status = "STARTING IGNITION"
		if("in_transit")
			engine_status = "ENGAGED"
		else
			engine_status = "ERROR"

	var/datum/computer/file/embedded_program/docking/docking_controller = shuttle.active_docking_controller
	var/docking_status = null
	var/docking_override = FALSE
	if(docking_controller)
		docking_status = docking_controller.get_docking_status()
		docking_override = docking_controller.override_enabled

	if(docking_status)
		switch(docking_status)
			if("docked")
				docking_status = "DOCKED"
			if("docking")
				if(docking_override)
					docking_status = "DOCKING-MANUAL"
				else
					docking_status = "DOCKING"
			if("undocking")
				if(docking_override)
					docking_status = "UNDOCKING-MANUAL"
				else
					docking_status = "UNDOCKING"
			if("undocked")
				docking_status = "UNDOCKED"
			else
				docking_status = "ERROR"

	return list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"engine_status" = engine_status,
		"has_docking" = shuttle.active_docking_controller ? 1 : 0,
		"docking_status" = docking_status,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force()
	)

// This is a subset of the actual checks; contains those that give messages to the user.
/obj/machinery/computer/shuttle_control/proc/can_move(var/datum/shuttle/autodock/shuttle, var/user)
	var/cannot_depart = shuttle.current_location.cannot_depart(shuttle)
	if(cannot_depart)
		to_chat(user, SPAN_WARNING(cannot_depart))
		return FALSE
	if(!shuttle.next_location.is_valid(shuttle))
		to_chat(user, SPAN_WARNING("Destination zone is invalid or obstructed."))
		return FALSE
	return TRUE

/obj/machinery/computer/shuttle_control/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list, var/user)
	if(!istype(shuttle))
		return

	if(href_list["move"])
		if(can_move(shuttle, user))
			shuttle.launch(src)
			return
		return

	if(href_list["force"])
		if(can_move(shuttle, user))
			shuttle.force_launch(src)
			return
		return

	if(href_list["cancel"])
		shuttle.cancel_launch(src)
		return

/obj/machinery/computer/shuttle_control/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "shuttles-[ui_template]", 500, 450, "[shuttle_tag] Shuttle Control")
	ui.open()

/obj/machinery/computer/shuttle_control/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	if(!length(data))
		data = list()

	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return data
	
	data = get_ui_data(shuttle)

	return data

/obj/machinery/computer/shuttle_control/Topic(href_list, href_list)
	..()
	handle_topic_href(SSshuttle.shuttles[shuttle_tag], href_list, usr)
	SSvueui.check_uis_for_change(src)

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user)
	if(!hacked)
		req_access = list()
		hacked = TRUE
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return TRUE

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act()
	return
