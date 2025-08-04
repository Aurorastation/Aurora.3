/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon_screen = "shuttle"
	icon_keyboard = "cyan_key"
	icon_keyboard_emis = "cyan_key_mask"
	light_color = LIGHT_COLOR_CYAN

	/// Used to coordinate data in shuttle controller.
	var/shuttle_tag

	var/ui_template = "ShuttleControlConsole"
	var/list/linked_helmets = list()
	var/can_rename_ship = FALSE

	/// For hotwiring, how many cycles are needed. This decreases by 1 each cycle and triggers at 0
	var/hotwire_progress = 8

/obj/machinery/computer/shuttle_control/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(initial(hotwire_progress) != hotwire_progress)
		if(hotwire_progress != 0)
			. += SPAN_NOTICE("The bottom panel appears open with wires hanging out. It can be repaired with additional cabling. <i>Current progress: [(hotwire_progress / initial(hotwire_progress)) * 100]%</i>")
		else
			. += SPAN_NOTICE("The bottom panel appears open with wires hanging out. It can be repaired with additional cabling.")

/obj/machinery/computer/shuttle_control/Initialize()
	. = ..()
	if(SSshuttle.shuttles[shuttle_tag])
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_tag]
		shuttle.shuttle_computers += src
	else
		SSshuttle.lonely_shuttle_computers += src

	RegisterSignal(src, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(handle_bullet_act))

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
			to_chat(user, SPAN_BOLD("You unlink \the [attacking_item] from \the [src]."))
			PH.set_console(null)
		else
			to_chat(user, SPAN_BOLD("You link \the [attacking_item] to \the [src]."))
			PH.set_console(src)
			PH.set_hud_maptext("Shuttle Status: [get_shuttle_status(SSshuttle.shuttles[shuttle_tag])]")
		return
	if(attacking_item.iscoil()) // Repair from hotwire
		var/obj/item/stack/cable_coil/C = attacking_item
		if(hotwire_progress >= initial(hotwire_progress))
			to_chat(usr, SPAN_BOLD("\The [src] does not require repairs."))
		else
			to_chat(usr, SPAN_BOLD("You attempt to replace some cabling for \the [src]..."))
			while(C.can_use(2, user))
				if(do_after(user, 15 SECONDS, src, DO_UNIQUE))
					if(hotwire_progress < initial(hotwire_progress))
						C.use(2)
						hotwire_progress++
						if(hotwire_progress >= initial(hotwire_progress))
							restore_access(user)
							return
						to_chat(usr, SPAN_BOLD("You replace some broken cabling of \the [src] <b>([(hotwire_progress / initial(hotwire_progress)) * 100]%)</b>."))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 30, TRUE)
			return

	if(attacking_item.iswirecutter()) // Hotwiring
		if(!req_access && !req_one_access && !emagged) // Already hacked/no need to hack
			to_chat(user, SPAN_BOLD("[src] is not access-locked."))
			return
		// Begin hotwire
		user.visible_message("<b>[user]</b> opens a panel underneath \the [src] and starts snipping wires...", SPAN_BOLD("You open the maintenance panel and attempt to hotwire \the [src]..."))
		while(hotwire_progress > 0)
			if(do_after(user, 15 SECONDS, src, DO_UNIQUE))
				hotwire_progress--
				if(hotwire_progress <= 0)
					emag_act(user=user, hotwired=TRUE)
					return
				to_chat(user, SPAN_BOLD("You snip some cabling from \the [src] <b>([((initial(hotwire_progress)-hotwire_progress) / initial(hotwire_progress)) * 100]%)</b>."))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 30, TRUE)
			else
				return
	return ..()

/obj/machinery/computer/shuttle_control/attack_hand(mob/user)
	if(use_check_and_message(user))
		return
	if(!emagged && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return FALSE
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/computer/shuttle_control/attack_ghost(var/mob/abstract/ghost/observer/user)
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
	if(GET_Z(shuttle.next_location) in SSodyssey.scenario_zlevels)
		if(SSodyssey.site_landing_restricted)
			to_chat(user, SPAN_WARNING("You are not cleared to land on this site yet! You must wait for your ship's sensor scans to be done first!"))
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

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/hotwired = FALSE)
	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been subverted."))
		return FALSE
	emagged = TRUE
	if(hotwired)
		user.visible_message(SPAN_WARNING("\The [src] sparks as a panel suddenly opens and burnt cabling spills out!"),SPAN_BOLD("You short out the console's ID checking system. It's now available to everyone!"))
	else
		user.visible_message(SPAN_WARNING("\The [src] sparks!"),SPAN_BOLD("You short out the console's ID checking system. It's now available to everyone!"))
	spark(src, 2, 0)
	hotwire_progress = 0
	return TRUE

/// Used to restore access removed from emag_act() by setting access from req_access_old and req_one_access_old
/obj/machinery/computer/shuttle_control/proc/restore_access(var/mob/user)
	if(!emagged)
		to_chat(user, SPAN_WARNING("There is no access to restore for \the [src]!"))
		return FALSE
	emagged = FALSE
	to_chat(user, "You repair out the console's ID checking system. It's access restrictions have been restored.")
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE)
	hotwire_progress = initial(hotwire_progress)
	return TRUE

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act(severity)
	. = ..()

	return

/obj/machinery/computer/shuttle_control/proc/handle_bullet_act(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER

	visible_message("\The [projectile] ricochets off \the [src]!")
	return COMPONENT_BULLET_BLOCKED
