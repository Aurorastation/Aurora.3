/obj/machinery/computer/shuttle_control/multi
	ui_template = "shuttle_control_console_multi.tmpl"

/obj/machinery/computer/shuttle_control/multi/get_ui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/multi/handle_topic_href(var/datum/shuttle/autodock/multi/shuttle, var/list/href_list)
	..()

	if(href_list["pick"])
		var/dest_key = input("Choose shuttle destination", "Shuttle Destination") as null|anything in shuttle.get_destinations()
		if(dest_key && (!use_check(usr) || (isobserver(usr) && check_rights(R_ADMIN, FALSE))))
			shuttle.set_destination(dest_key, usr)
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/multi/antag
	ui_template = "shuttle_control_console_antag.tmpl"

/obj/machinery/computer/shuttle_control/multi/antag/get_ui_data(var/datum/shuttle/autodock/multi/antag/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"cloaked" = shuttle.cloaked,
		)

/obj/machinery/computer/shuttle_control/multi/antag/handle_topic_href(var/datum/shuttle/autodock/multi/antag/shuttle, var/list/href_list)
	..()

	if(href_list["toggle_cloaked"])
		shuttle.cloaked = !shuttle.cloaked
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/multi/can_move(var/datum/shuttle/autodock/shuttle, var/user)
	if(istype(shuttle, /datum/shuttle/autodock/multi/antag))
		var/datum/shuttle/autodock/multi/antag/our_shuttle = shuttle
		if(our_shuttle.returned)
			to_chat(user, SPAN_WARNING("You don't have enough fuel for another trip!"))
			return FALSE
		else if(our_shuttle.next_location == our_shuttle.home_waypoint)
			if(our_shuttle.return_warning_cooldown < world.time)
				our_shuttle.return_warning_cooldown = world.time + 60 SECONDS
				alert(user, "If you return to base, you won't be able to return to [current_map.station_short]. Launch again if you're sure about this.","Shuttle Control","Acknowledged.")
				return FALSE
	return ..()