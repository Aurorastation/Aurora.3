/obj/machinery/computer/shuttle_control/multi
	ui_template = "ShuttleControlConsoleMulti"

/obj/machinery/computer/shuttle_control/multi/ui_data(mob/user)
	. = ..()

	var/datum/shuttle/autodock/multi/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/multi/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/multi/shuttle, var/action, var/list/params)
	if(action == "pick")
		var/dest_key = tgui_input_list(user, "Choose shuttle destination.", "Shuttle Destination", shuttle.get_destinations())
		if(dest_key && (!use_check(usr) || (isobserver(usr) && check_rights(R_ADMIN, FALSE))))
			shuttle.set_destination(dest_key, usr)
		return TRUE

	return ..()

/obj/machinery/computer/shuttle_control/multi/antag
	ui_template = "ShuttleControlConsoleMultiAntag"

/obj/machinery/computer/shuttle_control/multi/antag/ui_data(mob/user)
	. = ..()

	var/datum/shuttle/autodock/multi/antag/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(istype(shuttle))
		. += list(
			"cloaked" = shuttle.cloaked,
		)

/obj/machinery/computer/shuttle_control/multi/antag/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/multi/antag/shuttle, var/action, var/list/params)
	if(action == "toggle_cloaked")
		shuttle.cloaked = !shuttle.cloaked
		return TRUE

	return ..()

/obj/machinery/computer/shuttle_control/multi/can_move(var/datum/shuttle/autodock/shuttle, var/user)
	if(istype(shuttle, /datum/shuttle/autodock/multi/antag))
		var/datum/shuttle/autodock/multi/antag/our_shuttle = shuttle
		if(our_shuttle.returned)
			to_chat(user, SPAN_WARNING("You don't have enough fuel for another trip!"))
			return FALSE
		else if(our_shuttle.next_location == our_shuttle.home_waypoint)
			if(our_shuttle.return_warning_cooldown < world.time)
				our_shuttle.return_warning_cooldown = world.time + 60 SECONDS
				tgui_alert(user, "If you return to base, you won't be able to return to [SSatlas.current_map.station_short]. Launch again if you're sure about this.", "Shuttle Control", list("Acknowledged."))
				return FALSE
	return ..()
