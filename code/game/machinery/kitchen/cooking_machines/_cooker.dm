/obj/machinery/appliance/cooker
	var/temperature = T20C
	var/min_temp = 80 + T0C	//Minimum temperature to do any cooking
	var/optimal_temp = 200 + T0C	//Temperature at which we have 100% efficiency. efficiency is lowered on either side of this
	var/optimal_power = 1.1//cooking power at 100%

	var/loss = 1	//Temp lost per proc when equalising
	var/resistance = 320000	//Resistance to heating. combines with heating power to determine how long heating takes

	var/light_x = 0
	var/light_y = 0
	cooking_coeff = 0
	cooking_power = 0

/obj/machinery/appliance/cooker/examine(var/mob/user)
	. = ..()
	if (.)	//no need to duplicate adjacency check
		if (!stat)
			if (temperature < min_temp)
				to_chat(user, span("warning", "\The [src] is still heating up and is too cold to cook anything yet."))
			else
				to_chat(user, span("notice", "It is running at [round(get_efficiency(), 0.1)]% efficiency!"))
			to_chat(user, "Temperature: [round(temperature - T0C, 0.1)]C / [round(optimal_temp - T0C, 0.1)]C")
		else
			to_chat(user, span("warning", "It is switched off."))

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
		to_chat(usr, span("notice","It's empty."))

/obj/machinery/appliance/cooker/proc/get_efficiency()
	. = (cooking_power / optimal_power) * 100

/obj/machinery/appliance/cooker/Initialize()
	. = ..()
	loss = (active_power_usage / resistance)*0.5
	cooking_objs = list()
	for (var/i = 0, i < max_contents, i++)
		cooking_objs.Add(new /datum/cooking_item/(new container_type(src)))
	cooking = 0

	queue_icon_update()

/obj/machinery/appliance/cooker/update_icon()
	cut_overlays()
	var/image/light
	if (use_power == 2 && !stat)
		light = image(icon, "light_on")
	else
		light = image(icon, "light_off")
	light.pixel_x = light_x
	light.pixel_y = light_y
	add_overlay(light)

/obj/machinery/appliance/cooker/machinery_process()
	if (!stat)
		heat_up()
	else
		var/turf/T = get_turf(src)
		if (temperature > T.temperature)
			equalize_temperature()
	..()

/obj/machinery/appliance/cooker/power_change()
	. = ..()
	queue_icon_update()

/obj/machinery/appliance/cooker/proc/update_cooking_power()
	var/temp_scale = 0
	if(temperature > min_temp)
		if(temperature >= optimal_temp)
			temp_scale = 1
		else
			temp_scale = (temperature - 73.15) / (optimal_temp - 73.15)
		//If we're between min and optimal this will yield a value in the range 0.7 to 1

	cooking_coeff = optimal_power * temp_scale
	RefreshParts()

/obj/machinery/appliance/cooker/proc/heat_up()
	if (temperature < optimal_temp)
		if (use_power == 1 && ((optimal_temp - temperature) > 5))
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			use_power = 2.//If we're heating we use the active power
			update_icon()
		temperature += heating_power / resistance
		update_cooking_power()
		return 1
	else
		if (use_power == 2)
			use_power = 1
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			update_icon()
		//We're holding steady. temperature falls more slowly
		if (prob(25))
			equalize_temperature()
			return -1

/obj/machinery/appliance/cooker/proc/equalize_temperature()
	temperature -= loss//Temperature will fall somewhat slowly
	update_cooking_power()

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
