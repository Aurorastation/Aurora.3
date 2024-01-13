//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "ShuttleControlConsoleMultiExplore"
	var/obj/effect/overmap/visitable/ship/connected //Ship we're connected to

/obj/machinery/computer/shuttle_control/explore/Initialize()
	. = ..()
	if(istype(linked, /obj/effect/overmap/visitable/ship))
		connected = linked

/obj/machinery/computer/shuttle_control/explore/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()

	if(.)
		connected = linked
		LAZYSET(connected.consoles, src, TRUE)

/obj/machinery/computer/shuttle_control/explore/Destroy()
	if(connected)
		LAZYREMOVE(connected.consoles, src)
	. = ..()

/obj/machinery/computer/shuttle_control/explore/ui_data(mob/user)
	. = ..()

	var/datum/shuttle/autodock/overmap/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumption * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"destination_map_image" = shuttle.next_location ? SSholomap.minimaps_scan_base64[shuttle.next_location.z] : null,
			"destination_x" = shuttle.next_location?.x,
			"destination_y" = shuttle.next_location?.y,
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/overmap/shuttle, var/action, var/list/params)
	. = ..()
	if(. != null)
		return

	if(action == "pick")
		var/list/possible_d = shuttle.get_possible_destinations()
		var/D
		if(length(possible_d))
			D = tgui_input_list(usr, "Choose shuttle destination.", "Shuttle Destination", possible_d)
		else
			to_chat(usr, SPAN_WARNING("No valid landing sites in range."))
		if(CanInteract(user, physical_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
		return TRUE

/obj/machinery/computer/shuttle_control/explore/terminal
	name = "shuttle control terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "helm"
	icon_keyboard = "tech_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1
