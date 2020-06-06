/obj/machinery/appliance/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovenopen"
	cook_type = "baked"
	appliancetype = OVEN
	food_color = "#A34719"
	can_burn_food = 1
	active_power_usage = 6 KILOWATTS
	heating_power = 6000
	//Based on a double deck electric convection oven

	resistance = 30000 // Approx. 12 minutes.
	idle_power_usage = 2 KILOWATTS
	//uses ~30% power to stay warm
	optimal_power = 1.2

	light_x = 2
	max_contents = 5
	container_type = /obj/item/reagent_containers/cooking_container/oven

	stat = POWEROFF	//Starts turned off

	var/open = FALSE // Start closed so people don't heat up ovens with the door open

	output_options = list(
		"Pizza" = /obj/item/reagent_containers/food/snacks/variable/pizza,
		"Bread" = /obj/item/reagent_containers/food/snacks/variable/bread,
		"Pie" = /obj/item/reagent_containers/food/snacks/variable/pie,
		"Cake" = /obj/item/reagent_containers/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/reagent_containers/food/snacks/variable/pocket,
		"Kebab" = /obj/item/reagent_containers/food/snacks/variable/kebab,
		"Waffles" = /obj/item/reagent_containers/food/snacks/variable/waffles,
		"Cookie" = /obj/item/reagent_containers/food/snacks/variable/cookie,
		"Donut" = /obj/item/reagent_containers/food/snacks/variable/donut
	)

	component_types = list(
			/obj/item/circuitboard/oven,
			/obj/item/stock_parts/capacitor = 3,
			/obj/item/stock_parts/scanning_module,
			/obj/item/stock_parts/matter_bin = 2
		)


/obj/machinery/appliance/cooker/oven/update_icon()
	if (!open)
		if (!stat)
			icon_state = "ovenclosed_on"
		else
			icon_state = "ovenclosed_off"
	else
		icon_state = "ovenopen"
	..()

/obj/machinery/appliance/cooker/oven/AltClick(var/mob/user)
	try_toggle_door(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/appliance/cooker/oven/verb/toggle_door()
	set src in oview(1)
	set category = "Object"
	set name = "Open/close oven door"

	try_toggle_door(usr)

/obj/machinery/appliance/cooker/oven/proc/try_toggle_door(mob/user)
	if (!isliving(usr) || isAI(user))
		return

	if (!usr.IsAdvancedToolUser())
		to_chat(usr, "You lack the dexterity to do that.")
		return

	if (!Adjacent(usr))
		to_chat(usr, "You can't reach the [src] from there, get closer!")
		return

	if (open)
		open = FALSE
		loss = (heating_power / resistance) * 0.5
	else
		open = TRUE
		loss = (heating_power / resistance) * 1.5
		//When the oven door is opened, oven slowly loses heat

	playsound(src, 'sound/machines/hatch_open.ogg', 20, 1)
	update_icon()

/obj/machinery/appliance/cooker/oven/proc/manip(var/obj/item/I)
	// check if someone's trying to manipulate the machine

	if(I.iscrowbar() || I.isscrewdriver() || istype(I, /obj/item/storage/part_replacer))
		return TRUE
	else
		return FALSE

/obj/machinery/appliance/cooker/oven/can_insert(var/obj/item/I, var/mob/user)
	if (!open && !manip(I))
		to_chat(user, "<span class='warning'>You can't put anything in while the door is closed!</span>")
		return 0

	else
		return ..()


//If an oven's door is open it will lose heat every proc, even if it also gained it
//But dont call equalize twice in one stack. A return value of -1 from the parent indicates equalize was already called
/obj/machinery/appliance/cooker/oven/heat_up()
	.=..()
	if (open && . != -1)
		var/turf/T = get_turf(src)
		if (temperature > T.temperature)
			equalize_temperature()

/obj/machinery/appliance/cooker/oven/can_remove_items(var/mob/user)
	if (!open)
		to_chat(user, "<span class='warning'>You can't take anything out while the door is closed!</span>")
		return FALSE

	else
		return ..()


//Oven has lots of recipes and combine options. The chance for interference is high, so
//If a combine target is set the oven will do it instead of checking recipes
/obj/machinery/appliance/cooker/oven/finish_cooking(var/datum/cooking_item/CI)
	if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		src.visible_message("<span class='notice'>\The [src] pings!</span>")
		combination_cook(CI)
		return
	else
		..()
