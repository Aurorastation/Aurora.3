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
	desc = "A smart lightswitch designed by Idris Incorporated for entertainment venues, this one has additional controls for adjusting the color and brightness of the compartment's lighting."
	var/current_light_color = LIGHT_COLOR_HALOGEN
	var/current_brightness = 1.0
	var/static/list/color_options = list(
		"Standard" = LIGHT_COLOR_HALOGEN,
		"Red" = LIGHT_COLOR_RED,
		"Green" = LIGHT_COLOR_GREEN,
		"Blue" = LIGHT_COLOR_BLUE,
		"Magenta" = LIGHT_COLOR_VIOLET
	)

/obj/machinery/light_switch/idris/Initialize()
	. = ..()
	if(!area.lightswitch)
		on = TRUE
		area.lightswitch = TRUE

/obj/machinery/light_switch/idris/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] is not responding."))
		return

	var/choice = show_control_menu(user)
	if(!choice)
		return

	handle_menu_choice(user, choice)

// displays the radial control menu for the smart switch
/obj/machinery/light_switch/idris/proc/show_control_menu(mob/user)
	var/list/choices = list()

	var/image/power_toggle = image('icons/obj/machinery/button.dmi', null, "light[on ? 0 : 1]")
	choices[on ? "Turn Off" : "Turn On"] = power_toggle

	for(var/color_name in color_options)
		var/image/color_icon = image('icons/obj/machinery/light.dmi', null, "lbulb")
		color_icon.color = color_options[color_name]
		choices[color_name] = color_icon

	var/image/custom_color = image('icons/obj/machinery/light.dmi', null, "lbulb")
	custom_color.color = "#ff5e00"
	choices["Custom Color"] = custom_color

	var/image/brightness_icon = image('icons/obj/machinery/light.dmi', null, "lbulb")
	brightness_icon.color = current_light_color
	brightness_icon.alpha = 128
	choices["Brightness"] = brightness_icon

	return show_radial_menu(user, src, choices, uniqueid = "lightswitch_[REF(src)]", radius = 42, require_near = !issilicon(user), tooltips = TRUE)

/obj/machinery/light_switch/idris/proc/handle_menu_choice(mob/user, choice)
	if(choice == "Turn Off" || choice == "Turn On")
		handle_power_toggle()
		return

	if(choice == "Brightness")
		handle_brightness_adjustment(user)
		return

	if(choice == "Custom Color")
		handle_custom_color(user)
		return

	handle_preset_color(choice)

/obj/machinery/light_switch/idris/proc/handle_power_toggle()
	playsound(src, /singleton/sound_category/switch_sound, 30)
	on = !on
	sync_lights()
	intent_message(BUTTON_FLICK, 5)

//brightness adjustment
/obj/machinery/light_switch/idris/proc/handle_brightness_adjustment(mob/user)
	var/display_value = convert_brightness_to_display(current_brightness)
	var/input = input(user, "Enter brightness (0-100%):", "Brightness", display_value) as num|null
	if(isnull(input))
		return

	current_brightness = convert_display_to_brightness(input)
	apply_lighting_changes()


// custom color selection
/obj/machinery/light_switch/idris/proc/handle_custom_color(mob/user)
	var/new_color = input(user, "Choose light color:", "Custom Light Color", current_light_color) as color|null
	if(!new_color)
		return

	current_light_color = sanitize_hexcolor(new_color, current_light_color)
	apply_lighting_changes()


// preset color selection
/obj/machinery/light_switch/idris/proc/handle_preset_color(color_name)
	current_light_color = color_options[color_name]
	apply_lighting_changes()

// applies current color and brightness settings to all lights in the area
/obj/machinery/light_switch/idris/proc/apply_lighting_changes()
	if(!area)
		return

	if(!on)
		on = TRUE

	var/list/saved_switchcounts = list()
	for(var/obj/machinery/light/light in area)
		saved_switchcounts[light] = light.switchcount

	sync_lights()

	for(var/obj/machinery/light/light in area)
		apply_light_modifications(light)
		if(light in saved_switchcounts)
			light.switchcount = saved_switchcounts[light]

// applies color and brightness modifications
/obj/machinery/light_switch/idris/proc/apply_light_modifications(obj/machinery/light/light)
	if(!light.brightness_range || !light.brightness_power)
		return

	if(light.emergency_mode)
		light.emergency_mode = FALSE
	light.no_emergency = TRUE

	light.brightness_color = current_light_color
	light.default_color = current_light_color

	var/power_multiplier = current_brightness ** 2.2
	var/range_multiplier = sqrt(current_brightness)

	light.brightness_power = initial(light.brightness_power) * power_multiplier
	light.brightness_range = initial(light.brightness_range) * range_multiplier

	if(light.supports_nightmode && light.nightmode)
		light.set_light(light.night_brightness_range, light.night_brightness_power, light.brightness_color)
	else
		light.set_light(light.brightness_range, light.brightness_power, light.brightness_color)

	light.update_icon()

// converts internal brightness value (0.8-1.0) to display value (0-100)
/obj/machinery/light_switch/idris/proc/convert_brightness_to_display(brightness)
	return ((brightness - 0.8) / 0.2) * 100

// converts display value (0-100) to internal brightness value (0.8-1.0)
/obj/machinery/light_switch/idris/proc/convert_display_to_brightness(display_value)
	return 0.8 + (clamp(display_value, 0, 100) / 100) * 0.2
