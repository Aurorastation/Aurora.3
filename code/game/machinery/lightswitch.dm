// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/machinery/button.dmi'
	icon_state = "light-p"
	anchored = 1.0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/on = 1
	var/area/area = null
	var/otherarea = null
	power_channel = AREA_USAGE_LIGHT
	z_flags = ZMM_MANGLE_PLANES
	//	luminosity = 1

/obj/machinery/light_switch/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "It is [on ? "on" : "off"]."

/obj/machinery/light_switch/Initialize()
	. = ..()
	src.area = get_area(src)
	var/area_display_name = get_area_display_name(area)

	if(otherarea)
		src.area = locate(text2path("/area/[otherarea]"))

	if(!name)
		name = "light switch ([area_display_name])"

	src.on = src.area.lightswitch
	addtimer(CALLBACK(src, PROC_REF(sync_lights)), 25)
	update_icon()

/obj/machinery/light_switch/update_icon()
	ClearOverlays()
	if(!(stat & NOPOWER))
		var/switch_overlay = image(icon, "light[on]-overlay")
		var/emissive_overlay = emissive_appearance(icon, "light[on]-overlay")
		AddOverlays(switch_overlay)
		AddOverlays(emissive_overlay)
		if (!light_range || light_color != on ? "#82ff4c" : "#f86060")
			set_light(2, 0.3, on ? "#82ff4c" : "#f86060")
	else if (light_range)
		set_light(FALSE)

/obj/machinery/light_switch/attack_hand(mob/user)
	playsound(src, /singleton/sound_category/switch_sound, 30)
	on = !on
	sync_lights()
	intent_message(BUTTON_FLICK, 5)

/obj/machinery/light_switch/proc/sync_lights()
	var/area/A = get_area(src)
	if(!A)
		return

	A.lightswitch = on

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.update_icon()

	for (var/obj/machinery/light/L in area)
		if (on)
			L.stat &= ~POWEROFF
		else
			L.stat |= POWEROFF
		L.update()

/obj/machinery/light_switch/power_change()
	if(!otherarea)
		..()

		update_icon()

/obj/machinery/light_switch/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return

	power_change()

/obj/machinery/light_switch/idris
	name = "idris smart switch"
	desc = "A smart lightswitch designed by Idris Incorporated for entertainment venues, this one has additional controls for adjusting the color and brightness of the room's lighting."

	var/current_light_color = LIGHT_COLOR_HALOGEN
	var/current_brightness = 1.0

	var/static/list/color_options = list(
		"Standard" = LIGHT_COLOR_HALOGEN,
		"Red" = LIGHT_COLOR_RED,
		"Green" = LIGHT_COLOR_GREEN,
		"Blue" = LIGHT_COLOR_BLUE,
		"Magenta" = LIGHT_COLOR_VIOLET
	)

/obj/machinery/light_switch/idris/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] is not responding."))
		return

	var/list/choices = list()

	var/image/power_toggle = image('icons/obj/machinery/button.dmi', null, "light[on ? 0 : 1]")
	choices[on ? "Turn Off" : "Turn On"] = power_toggle

	// color options
	for(var/color_name in color_options)
		var/image/color_icon = image('icons/obj/machinery/light.dmi', null, "lbulb")
		color_icon.color = color_options[color_name]
		choices[color_name] = color_icon

	// custom color option
	var/image/custom_color = image('icons/obj/machinery/light.dmi', null, "lbulb")
	custom_color.color = "#ff5e00"
	choices["Custom Color"] = custom_color

	// brightness option
	var/image/brightness_icon = image('icons/obj/machinery/light.dmi', null, "lbulb")
	brightness_icon.color = current_light_color
	brightness_icon.alpha = 128
	choices["Brightness"] = brightness_icon

	var/choice = show_radial_menu(user, src, choices, uniqueid = "lightswitch_[REF(src)]", radius = 42, require_near = !issilicon(user), tooltips = TRUE)
	if(!choice)
		return

	if(choice == "Turn Off" || choice == "Turn On")
		return ..()

	if(choice == "Brightness")
		//internal 0.8-1.0 maps to display 0-100
		var/display_value = ((current_brightness - 0.8) / 0.2) * 100
		var/input = input(user, "Enter brightness (0-100%):", "Brightness", display_value) as num|null
		if(isnull(input))
			return

		current_brightness = 0.8 + (clamp(input, 0, 100) / 100) * 0.2
	else if(choice == "Custom Color")
		var/new_color = input(user, "Choose light color:", "Custom Light Color", current_light_color) as color|null
		if(!new_color)
			return
		new_color = sanitize_hexcolor(new_color, current_light_color)
		current_light_color = new_color
	else
		current_light_color = color_options[choice]

	if(!on)
		on = TRUE

	sync_lights()

/obj/machinery/light_switch/idris/sync_lights()
	..()

	if(!on || !area)
		return

	for(var/obj/machinery/light/L in area)
		if(!L.brightness_range || !L.brightness_power)
			continue

		if(L.emergency_mode)
			L.emergency_mode = FALSE
		L.no_emergency = TRUE

		L.brightness_color = current_light_color
		L.default_color = current_light_color

		// use gamma correction (power of 2.2) for perceptually linear brightness cause it provides finer control at lower brightness levels
		var/power_multiplier = current_brightness ** 2.2

		// uses square root for range which prevents the light area from shrinking too dramatically
		var/range_multiplier = sqrt(current_brightness)

		L.brightness_power = initial(L.brightness_power) * power_multiplier
		L.brightness_range = initial(L.brightness_range) * range_multiplier

		// avoid triggering switchcount burn-out mechanism
		if(L.supports_nightmode && L.nightmode)
			L.set_light(L.night_brightness_range, L.night_brightness_power, L.brightness_color)
		else
			L.set_light(L.brightness_range, L.brightness_power, L.brightness_color)
		L.update_icon()
