/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon_screen = "shuttle"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN

	var/shuttle_tag      // Used to coordinate data in shuttle controller.
	var/hacked = FALSE   // Has been emagged, no access restrictions.

	var/ui_template = "ShuttleControlConsole"
	var/list/linked_helmets = list()
	var/can_rename_ship = FALSE

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

/obj/machinery/computer/shuttle_control/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/clothing/head/helmet/pilot))
		var/obj/item/clothing/head/helmet/pilot/PH = attacking_item
		if(attacking_item in linked_helmets)
			to_chat(user, SPAN_NOTICE("You unlink \the [attacking_item] from \the [src]."))
			PH.set_console(null)
		else
			to_chat(user, SPAN_NOTICE("You link \the [attacking_item] to \the [src]."))
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

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, datum/tgui/ui)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(user, SPAN_WARNING("Unable to establish link with the shuttle."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_template, "[shuttle_tag] Shuttle Control", ui_x=470, ui_y=450)
		ui.open()

/obj/machinery/computer/shuttle_control/ui_data(mob/user)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]

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
		"can_rename_ship" = can_rename_ship,
		"ship_name" = shuttle.name,
	)

/obj/machinery/computer/shuttle_control/ui_act(action, params)
	. = ..()
	if(.)
		return

	return handle_topic_href(usr, SSshuttle.shuttles[shuttle_tag], action, params)

/obj/machinery/computer/shuttle_control/proc/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/shuttle, var/action, var/list/params)
	if(!istype(shuttle))
		return FALSE

	if(action == "move")
		if(can_move(shuttle, user))
			shuttle.launch(src)
			return TRUE
		return FALSE

	if(action == "force")
		if(can_move(shuttle, user))
			shuttle.force_launch(src)
			return TRUE
		return FALSE

	if(action == "cancel")
		shuttle.cancel_launch(src)
		return TRUE

	if(action == "rename")
		var/new_name = tgui_input_text(user, "Select new name for this ship.", "Rename this ship", shuttle.name, MAX_NAME_LEN)
		if(new_name)
			shuttle.name = new_name
		return TRUE

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

/obj/machinery/computer/shuttle_control/emp_act(severity)
	. = ..()

	return
