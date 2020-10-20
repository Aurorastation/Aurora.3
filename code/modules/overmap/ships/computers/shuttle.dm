//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle-control-console-exploration"

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		. += list(
			"destinations" = shuttle.get_possible_destinations(),
			"current_destination" = shuttle.next_location? shuttle.next_location.name : shuttle.get_location_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list)
	. = ..()
	if(!istype(shuttle))
		return
	if(href_list["set_destination"])
		var/datum/vueui/ui = href_list["vueui"]
		if(!istype(ui))
			return
		var/destination_name = ui.data["current_destination"]
		if(destination_name != shuttle.get_location_name())
			shuttle.set_destination_with_tag(destination_name)