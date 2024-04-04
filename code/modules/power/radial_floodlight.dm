/obj/machinery/power/radial_floodlight
	name = "radial floodlight"
	desc = "A floodlight that illuminates a wide area around it. It has to be wrenched down on top of a knot to work."
	icon = 'icons/obj/machinery/floodlight.dmi'
	icon_state = "radial_floodlight"
	anchored = FALSE
	density = TRUE
	active_power_usage = 800
	light_color = LIGHT_COLOR_TUNGSTEN

	var/on = FALSE
	var/brightness_on = 12

/obj/machinery/power/radial_floodlight/proc/toggle_active(var/force_state)
	if(!isnull(force_state))
		if(force_state == on)
			return
		on = force_state
	else
		on = !on
	if(on)
		set_light(brightness_on, 1)
		START_PROCESSING(SSprocessing, src)
	else
		set_light(0)
		STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/machinery/power/radial_floodlight/process()
	var/actual_load = draw_power(active_power_usage)
	if(!on || !anchored || (stat & BROKEN) || !powernet || actual_load < active_power_usage)
		toggle_active(FALSE)
		return

/obj/machinery/power/radial_floodlight/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		anchored = !anchored
		user.visible_message(SPAN_NOTICE("\The [user] [anchored ? "" : "un"]secures \the [src] [anchored ? "to" : "from"] the floor."),
							SPAN_NOTICE("You [anchored ? "" : "un"]secure \the [src] [anchored ? "to" : "from"] the floor."),
							SPAN_WARNING("You hear a ratcheting noise."))
		if(!anchored)
			toggle_active(FALSE)
		else
			connect_to_network()
		attacking_item.play_tool_sound(get_turf(src), 75)
		return
	return ..()

/obj/machinery/power/radial_floodlight/attack_hand(mob/user)
	if(!anchored)
		to_chat(user, SPAN_WARNING("\The [src] isn't anchored."))
		return
	if(!powernet)
		to_chat(user, SPAN_WARNING("\The [src] isn't connected to a power network."))
		return
	if(avail() < active_power_usage)
		to_chat(user, SPAN_WARNING("\The [src]'s power network doesn't have enough power."))
		return
	toggle_active()
	update_icon()

/obj/machinery/power/radial_floodlight/update_icon()
	cut_overlays()
	if(on)
		add_overlay(image(icon, src, "[icon_state]-light", EFFECTS_ABOVE_LIGHTING_LAYER))
