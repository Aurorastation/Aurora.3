/obj/machinery/power/radial_floodlight
	name = "radial floodlight"
	desc = "A floodlight that illuminates a wide area around it. It has to be wrenched down on top of a knot to work."
	icon = 'icons/obj/machinery/floodlight.dmi'
	icon_state = "radial_floodlight"
	anchored = FALSE
	density = TRUE
	light_system = MOVABLE_LIGHT
	light_color = LIGHT_COLOR_TUNGSTEN
	light_range = 8
	light_power = 3
	active_power_usage = 800 WATTS

	var/on = FALSE

/obj/machinery/power/radial_floodlight/proc/toggle_active(var/force_state)
	if(!isnull(force_state))
		on = force_state
	else
		on = !on

	if(on)
		update_use_power(POWER_USE_ACTIVE)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		playsound(loc, 'sound/effects/lighton.ogg', 65, 1)

	set_light_on(on)
	update_icon()

/obj/machinery/power/radial_floodlight/process()
	var/actual_load = draw_power(active_power_usage)
	if(!on || !anchored || (stat & BROKEN) || !powernet || actual_load < active_power_usage)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		update_use_power(POWER_USE_OFF)
		toggle_active(FALSE)
		return

/obj/machinery/power/radial_floodlight/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_WRENCH)
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
	ClearOverlays()
	if(on)
		var/image/light = image(icon, src, "[icon_state]-light")
		light.plane = ABOVE_LIGHTING_PLANE
		AddOverlays(light)
