
/obj/machinery/computer/shuttle_control/multi/lift
	name = "lift controller"
	icon = 'icons/obj/computer.dmi'
	icon_state = "lift"
	icon_screen = null
	density = FALSE
	req_access = null
	ui_template = "shuttle_control_console_multi_lift.tmpl"

/obj/machinery/computer/shuttle_control/multi/lift/wall
	icon_state = "lift_wall"

/obj/machinery/computer/shuttle_control/multi/lift/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if (!istype(shuttle))
		to_chat(user,"<span class='warning'>Unable to establish link with the shuttle.</span>")
		return

	var/list/data = get_ui_data(shuttle)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[shuttle_tag] Control", 470, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/multi/lift/get_ui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		var/list/destination_keys = list()
		for(var/key in shuttle.destinations_cache)
			destination_keys.Add(key)
		. += list(
			"destinations" = destination_keys,
		)

/obj/machinery/computer/shuttle_control/multi/handle_topic_href(var/datum/shuttle/autodock/multi/shuttle, var/list/href_list)
	if(href_list["pick"] && href_list["destination"])
		shuttle.set_destination(href_list["destination"], usr)
		return TOPIC_REFRESH
	..()
