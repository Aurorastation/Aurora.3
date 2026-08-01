//Shuttle controller computer for shuttles going between sectors
/obj/structure/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "ShuttleControlConsoleMultiExplore"
	var/obj/effect/overmap/visitable/ship/connected //Ship we're connected to
	var/emergency_power_window //Time window for emergency power from Pilot: Spacecraft + Electrical Engineering skills

/obj/structure/machinery/computer/shuttle_control/explore/attackby(obj/item/attacking_item, mob/user)
	var/electrical_level = user.GetComponent(ELECTRICAL_ENGINEERING_SKILL_COMPONENT)?.skill_level

	if(electrical_level > SKILL_LEVEL_UNFAMILIAR && (emergency_power_window || stat & NOPOWER) && istype(attacking_item, /obj/item/cell))
		var/obj/item/cell/battery = attacking_item
		var/pilot_level = user.GetComponent(PILOT_SPACECRAFT_SKILL_COMPONENT)?.skill_level
		user.visible_message("<b>[user]<b> opens a panel underneath \the [src]...", SPAN_NOTICE("You start searching for the power port to attempt an emergency power bypass..."))
		emergency_power_window = world.time
		if(pilot_level == SKILL_LEVEL_UNFAMILIAR && Adjacent(user) && user.get_active_hand() == battery)
			if(do_after(user, 3 SECONDS))
				to_chat(user, SPAN_NOTICE("Although unfamiliar with spacecraft to find it fast, your electrical intuition knows there's a port somewhere..."))
			else
				user.visible_message("<b>[user]</b> closes the panel underneath \the [src].", SPAN_WARNING("You need to stay and look longer if you want to perform a bypass."))
				return
		while(battery.percent() > 0 && Adjacent(user) && user.get_active_hand() == battery)
			if(do_after(user, 3 SECONDS))
				if((pilot_level == SKILL_LEVEL_UNFAMILIAR && do_after(user, 2 SECONDS)) || pilot_level >= SKILL_LEVEL_FAMILIAR)
					var/bypass_value = battery.maxcharge/10
					emergency_power_window += bypass_value/((100 - pilot_level * 3)/electrical_level) SECONDS // should be 10m for high-caps
					playsound(src.loc, 'sound/machines/click.ogg', 30)
					battery.charge -= bypass_value
					user.visible_message("<b>[user]</b> presses into some port with a click.<BR><i>\The [src]'s power bypass timer notifies there are <b>[round((emergency_power_window - world.time)/10)]</b> seconds of emergency power remaining.</i>", SPAN_NOTICE("You press into the port with \the [battery] transferring 10% into \the [src] and leaving \the [battery] with [battery.percent()]%<BR>\The [src]'s power bypass timer notifies there are <b>[round((emergency_power_window - world.time)/10)]</b> seconds of emergency power remaining."))
					stat &= ~NOPOWER
					update_icon()
		return

/obj/structure/machinery/computer/shuttle_control/explore/Initialize()
	. = ..()
	if(istype(linked, /obj/effect/overmap/visitable/ship))
		connected = linked

/obj/structure/machinery/computer/shuttle_control/explore/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()

	if(.)
		connected = linked
		LAZYSET(connected.consoles, src, TRUE)

/obj/structure/machinery/computer/shuttle_control/explore/Destroy()
	if(connected)
		LAZYREMOVE(connected.consoles, src)
	. = ..()

/obj/structure/machinery/computer/shuttle_control/explore/ui_data(mob/user)
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

/obj/structure/machinery/computer/shuttle_control/explore/handle_topic_href(var/mob/user, var/datum/shuttle/autodock/overmap/shuttle, var/action, var/list/params)
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
		if(CanInteract(user, GLOB.physical_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
		return TRUE

/obj/structure/machinery/computer/shuttle_control/explore/terminal
	name = "shuttle control terminal"
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_screen = "helm"
	icon_keyboard = "tech_key"
	icon_keyboard_emis = "tech_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1
