/obj/machinery/appliance/cooker
	var/min_temp = 80 + T0C	//Minimum temperature to do any cooking
	var/optimal_temp = 200 + T0C	//Temperature at which we have 100% efficiency. efficiency is lowered on either side of this
	var/optimal_power = 1.1//cooking power at 100%
	var/set_temp = 200 + T0C
	var/temp_settings = 4 // the number of temperature settings to have, including min and optimal
	var/list/temp_options = list()

	var/loss = 1	//Temp lost per proc when equalising
	var/resistance = 320000	//Resistance to heating. combines with heating power to determine how long heating takes

	var/light_x = 0
	var/light_y = 0
	cooking_coeff = 0
	cooking_power = 0
	flags = null
	var/temperature = T20C

/obj/machinery/appliance/cooker/examine(var/mob/user)
	. = ..()
	if (.)	//no need to duplicate adjacency check
		if (!stat)
			if (temperature < min_temp)
				to_chat(user, SPAN_WARNING("\The [src] is still heating up and is too cold to cook anything yet."))
			else
				to_chat(user, SPAN_NOTICE("It is running at [round(get_efficiency(), 0.1)]% efficiency!"))
			to_chat(user, "Temperature: [round(temperature - T0C, 0.1)]C / [round(optimal_temp - T0C, 0.1)]C")
		else
			to_chat(user, SPAN_WARNING("It is switched off."))

/obj/machinery/appliance/cooker/list_contents(var/mob/user)
	if (cooking_objs.len)
		var/string = "Contains...</br>"
		var/num = 0
		for (var/a in cooking_objs)
			num++
			var/datum/cooking_item/CI = a
			if (CI && CI.container)
				string += "- [CI.container.label(num)], [report_progress(CI)]</br>"
		to_chat(usr, string)
	else
		to_chat(usr, SPAN_NOTICE("It's empty."))

/obj/machinery/appliance/cooker/proc/get_efficiency()
	. = (cooking_power / optimal_power) * 100

/obj/machinery/appliance/cooker/Initialize()
	. = ..()
	var/interval = (optimal_temp - min_temp)/temp_settings
	for(var/newtemp = min_temp - interval, newtemp<=optimal_temp, newtemp+=interval)
		var/image/disp_image = image('icons/mob/screen/radial.dmi', "radial_temp")
		var/hue = RotateHue(hsv(0, 255, 255), 120 * (1 - (newtemp-min_temp)/(optimal_temp-min_temp)))
		disp_image.color = HSVtoRGB(hue)
		temp_options["[newtemp - T0C]"] = disp_image
	temp_options["OFF"] = image('icons/misc/mark.dmi', "x3")
	loss = (active_power_usage / resistance)*0.5
	cooking_objs = list()
	// sorry, doesn't auto-start with containers!
	cooking = 0

	queue_icon_update()

/obj/machinery/appliance/cooker/attempt_toggle_power(mob/user)
	var/wasoff = stat & POWEROFF
	if (!isliving(user))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user, "You lack the dexterity to do that!")
		return

	if (user.stat || user.restrained() || user.incapacitated())
		return

	if (!Adjacent(user) && !issilicon(user))
		to_chat(user, "You can't reach [src] from here.")
		return

	var/desired_temp = show_radial_menu(user, src, temp_options - (wasoff ? "OFF" : "[set_temp-T0C]"), require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
	if(!desired_temp)
		return

	if(desired_temp == "OFF")
		stat |= POWEROFF
	else
		set_temp = text2num(desired_temp) + T0C
		to_chat(user, SPAN_NOTICE("You set [src] to [round(set_temp-T0C)]C."))
		stat &= ~POWEROFF
	use_power = !(stat & POWEROFF)
	if(wasoff != (stat & POWEROFF))
		user.visible_message("[user] turns [src] [use_power ? "on" : "off"].", "You turn [use_power ? "on" : "off"] [src].")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/cooker/update_icon()
	overlays.Cut()
	var/image/light
	if (use_power == 2 && !stat)
		light = image(icon, "light_on")
	else
		light = image(icon, "light_off")
	light.pixel_x = light_x
	light.pixel_y = light_y
	overlays += light

/obj/machinery/appliance/cooker/machinery_process()
	var/temp_change = heating_power
	var/datum/gas_mixture/loc_air = loc.return_air()
	if ((temperature >= set_temp) && (stat || use_power == 1))
		temperature -= min(loss, temperature - loc_air.temperature)
		temp_change = active_power_usage
	if(!stat)
		heat_up()
		update_cooking_power() // update!
	for(var/datum/cooking_item/CI in cooking_objs)
		if(!CI.container.reagents)
			continue
		if(CI.container.reagents.get_temperature() >= temperature)
			temp_change = loss
		CI.container.reagents.add_thermal_energy(temp_change)
	return ..()

/obj/machinery/appliance/cooker/power_change()
	. = ..()
	queue_icon_update()

/obj/machinery/appliance/cooker/proc/update_cooking_power()
	var/temp_scale = 0
	if(temperature > min_temp)
		if(temperature >= optimal_temp)
			temp_scale = Clamp(1 - ((optimal_temp - temperature) / optimal_temp), 0, 1)
		else
			temp_scale = temperature / optimal_temp
		//If we're between min and optimal this will yield a value in the range 0.7 to 1

	cooking_coeff = optimal_power * temp_scale
	RefreshParts() // this is what actually updates the cooking power, for some reason.

/obj/machinery/appliance/cooker/proc/heat_up()
	if (temperature < set_temp)
		if (use_power == 1 && ((set_temp - temperature) > 5))
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			use_power = 2 //If we're heating we use the active power
			update_icon()
		temperature += heating_power / resistance
		update_cooking_power()
		return 1
	else
		if (use_power == 2)
			use_power = 1
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			update_icon()

//Cookers do differently, they use containers
/obj/machinery/appliance/cooker/has_space(var/obj/item/I)
	if (istype(I, /obj/item/reagent_containers/cooking_container))
		//Containers can go into an empty slot
		if (cooking_objs.len < max_contents)
			return 1
	else
		//Any food items directly added need an empty container. A slot without a container cant hold food
		for (var/datum/cooking_item/CI in cooking_objs)
			if (CI.container.check_contents() == 0)
				return CI

	return 0

/obj/machinery/appliance/cooker/add_content(var/obj/item/I, var/mob/user)
	var/datum/cooking_item/CI = ..()
	if (CI && CI.combine_target)
		to_chat(user, "The [I] will be used to make a [selected_option]. Output selection is returned to default for future items.")
		selected_option = null
