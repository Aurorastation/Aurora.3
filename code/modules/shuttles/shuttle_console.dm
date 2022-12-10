/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon_screen = "shuttle"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN

	var/shuttle_tag      // Used to coordinate data in shuttle controller.
	var/hacked = FALSE   // Has been emagged, no access restrictions.

	var/ui_template = "shuttle_control_console.tmpl"
	var/list/linked_helmets = list()

/obj/machinery/computer/shuttle_control/Initialize()
	. = ..()
	if(SSshuttle.shuttles[shuttle_tag])
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_tag]
		shuttle.shuttle_computers += src
	else
		SSshuttle.lonely_shuttle_computers += src

/obj/machinery/computer/shuttle_control/Destroy()
	SSshuttle.lonely_shuttle_computers -= src
	var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_tag]
	shuttle.shuttle_computers -= src
	for(var/obj/item/clothing/head/helmet/pilot/PH as anything in linked_helmets)
		PH.linked_console = null
	return ..()

/obj/machinery/computer/shuttle_control/attackby(obj/item/I, user)
	if(istype(I, /obj/item/clothing/head/helmet/pilot))
		var/obj/item/clothing/head/helmet/pilot/PH = I
		if(I in linked_helmets)
			to_chat(user, SPAN_NOTICE("You unlink \the [I] from \the [src]."))
			PH.set_console(null)
		else
			to_chat(user, SPAN_NOTICE("You link \the [I] to \the [src]."))
			PH.set_console(src)
			PH.set_hud_maptext("Shuttle Status: [get_shuttle_status(SSshuttle.shuttles[shuttle_tag])]")
		return
	return ..()

/obj/machinery/computer/shuttle_control/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ghost(var/mob/abstract/observer/user)
	if(check_rights(R_ADMIN, 0, user))
		ui_interact(user)

/obj/machinery/computer/shuttle_control/proc/get_ui_data(var/datum/shuttle/autodock/shuttle)
	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	return list(
		"shuttle_status" = get_shuttle_status(shuttle),
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller? 1 : 0,
		"docking_status" = shuttle.active_docking_controller? shuttle.active_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

/obj/machinery/computer/shuttle_control/proc/get_shuttle_status(var/datum/shuttle/autodock/shuttle)
	switch(shuttle.process_state)
		if(IDLE_STATE)
			var/cannot_depart = shuttle.current_location.cannot_depart(shuttle)
			if(shuttle.in_use)
				. = "Busy."
			else if(cannot_depart)
				. = cannot_depart
			else
				. = "Standing-by at \the [shuttle.get_location_name()]."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			. = "Shuttle has received a command and will depart shortly."
		if(WAIT_ARRIVE)
			. = "Proceeding to \the [shuttle.get_destination_name()]."
		if(WAIT_FINISH)
			. = "Arriving at destination now."

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
		return TOPIC_NOACTION

	if(href_list["move"])
		if(can_move(shuttle, user))
			shuttle.launch(src)
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["force"])
		if(can_move(shuttle, user))
			shuttle.force_launch(src)
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["cancel"])
		shuttle.cancel_launch(src)
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if (!istype(shuttle))
		to_chat(user,"<span class='warning'>Unable to establish link with the shuttle.</span>")
		return

	var/list/data = get_ui_data(shuttle)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[shuttle_tag] Shuttle Control", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/Topic(href_list, href_list)
	..()
	handle_topic_href(SSshuttle.shuttles[shuttle_tag], href_list, usr)

/obj/machinery/computer/shuttle_control/proc/update_helmets(var/datum/shuttle/autodock/shuttle)
	var/shuttle_status = get_shuttle_status(shuttle)
	for(var/obj/item/clothing/head/helmet/pilot/PH as anything in linked_helmets)
		PH.set_hud_maptext("Shuttle Status: [shuttle_status]")

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
