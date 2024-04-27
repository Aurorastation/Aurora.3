/obj/machinery/computer/shuttle_control/multi/lift
	name = "lift controller"
	icon = 'icons/obj/computer.dmi'
	icon_state = "lift"
	icon_screen = null
	density = FALSE
	req_access = null
	ui_template = "ShuttleControlConsoleMultiLift"

/obj/machinery/computer/shuttle_control/multi/lift/wall
	icon_state = "lift_wall"

/obj/machinery/computer/shuttle_control/multi/lift/ui_interact(mob/user, datum/tgui/ui)
	var/datum/shuttle/autodock/multi/lift/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(user, SPAN_WARNING("Unable to establish link with the shuttle."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_template, "[shuttle_tag] Control", ui_x=470, ui_y=300)
		ui.open()

/obj/machinery/computer/shuttle_control/multi/lift/ui_data(mob/user)
	. = ..()

	var/datum/shuttle/autodock/multi/lift/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(istype(shuttle))
		var/list/destination_keys = list()
		for(var/key in shuttle.get_destinations())
			destination_keys.Add(key)
		. += list(
			"destinations" = destination_keys,
		)

/obj/machinery/computer/shuttle_control/multi/lift/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/multi/lift/shuttle, var/action, var/list/params)
	if(action == "pick")
		shuttle.set_destination(params["destination"], usr)
		return TRUE

	if(action == "cancel")
		shuttle.final_location = null // no return so parent can handle it

	return ..()
