/obj/machinery/appliance/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	on_icon = "oven_on"
	off_icon = "oven_off"
	cook_type = "baked"
	appliancetype = OVEN
	food_color = "#A34719"
	can_burn_food = 1
	active_power_usage	= 19000
	//Based on a double deck electric convection oven

	resistance = 72000
	idle_power_usage	= 6000
	//uses 30% power to stay warm
	optimal_power = 0.2

	light_x = 2
	max_contents = 5
	container_type = /obj/item/weapon/reagent_containers/cooking_container/oven

	stat = POWEROFF//Starts turned off

	var/open = 1

	output_options = list(
		"Pizza" = /obj/item/weapon/reagent_containers/food/snacks/variable/pizza,
		"Bread" = /obj/item/weapon/reagent_containers/food/snacks/variable/bread,
		"Pie" = /obj/item/weapon/reagent_containers/food/snacks/variable/pie,
		"Cake" = /obj/item/weapon/reagent_containers/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/weapon/reagent_containers/food/snacks/variable/pocket,
		"Kebab" = /obj/item/weapon/reagent_containers/food/snacks/variable/kebab,
		"Waffles" = /obj/item/weapon/reagent_containers/food/snacks/variable/waffles,
		"Cookie" = /obj/item/weapon/reagent_containers/food/snacks/variable/cookie,
		"Donut" = /obj/item/weapon/reagent_containers/food/snacks/variable/donut
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
	.=1
	if(user.stat || user.restrained())	return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)//No spamming the door, it makes a sound
	toggle_door()


/obj/machinery/appliance/cooker/oven/verb/toggle_door()
	set src in view()
	set name = "Open/close oven door"
	set category = null


	if (!isliving(usr))
		usr << "Ghosts can't mess with ovens."
		return

	if (isanimal(usr))
		usr << "You lack the dexterity to do that."
		return


	if (!Adjacent(usr))
		if (!issilicon(usr))
			usr << "You can't reach the [src] from there, get closer!"
			return

	if (open)
		open = 0
		loss = (active_power_usage / resistance)*0.5
	else
		open = 1
		loss = (active_power_usage / resistance)*4
		//When the oven door is opened, heat is lost MUCH faster

	playsound(src, 'sound/machines/hatch_open.ogg', 20, 1)
	update_icon()


/obj/machinery/appliance/cooker/oven/can_insert(var/obj/item/I, var/mob/user)
	if (!open)
		user << "<span class='warning'>You can't put anything in while the door is closed!</span>"
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
		user << "<span class='warning'>You can't take anything out while the door is closed!</span>"
		return 0

	else
		return ..()


//Oven has lots of recipes and combine options. The chance for interference is high, so
//If a combine target is set the oven will do it instead of checking recipes
/obj/machinery/appliance/cooker/oven/finish_cooking(var/datum/cooking_item/CI)
	if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		combination_cook(CI)
		return
	else
		..()
