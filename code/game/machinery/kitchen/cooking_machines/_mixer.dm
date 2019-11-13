/*
The mixer subtype is used for  the candymaker and cereal maker. They are similar to cookers but with a few
fundamental differences


1. They have a single container which cant be removed. it will eject multiple contents
2. Items can't be added or removed once the process starts
3. Items are all placed in the same container when added directly
4. They do combining mode only. And will always combine the entire contents of the container into an output
*/

/obj/machinery/appliance/mixer
	max_contents = 1
	stat = POWEROFF
	cooking_coeff = 0.75
	active_power_usage = 3000
	idle_power_usage = 50

/obj/machinery/appliance/mixer/examine(var/mob/user)
	..()
	to_chat(user, span("notice", "It is currently set to make a [selected_option]"))

/obj/machinery/appliance/mixer/Initialize()
	. = ..()
	cooking_objs += new /datum/cooking_item(new /obj/item/reagent_containers/cooking_container(src))
	cooking = 0
	selected_option = pick(output_options)

//Mixers cannot-not do combining mode. So the default option is removed from this. A combine target must be chosen
/obj/machinery/appliance/mixer/choose_output()
	set src in oview(1)
	set name = "Choose output"
	set category = "Object"

	if (!isliving(usr))
		return

	if (!usr.IsAdvancedToolUser())
		to_chat(usr, "<span class='notice'>You can't operate [src].</span>")
		return

	if(output_options.len)
		var/choice = input("What specific food do you wish to make with \the [src]?") as null|anything in output_options
		if(!choice)
			return
		else
			selected_option = choice
			to_chat(usr, "<span class='notice'>You prepare \the [src] to make \a [selected_option].</span>")
			var/datum/cooking_item/CI = cooking_objs[1]
			CI.combine_target = selected_option


/obj/machinery/appliance/mixer/has_space(var/obj/item/I)
	var/datum/cooking_item/CI = cooking_objs[1]
	if (!CI || !CI.container)
		return 0

	if (CI.container.can_fit(I))
		return CI

	return 0


/obj/machinery/appliance/mixer/can_remove_items(var/mob/user)
	if (stat)
		return 1
	else
		to_chat(user, span("warning", "You can't remove ingredients while its turned on! Turn it off first or wait for it to finish."))

//Container is not removable
/obj/machinery/appliance/mixer/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			if (CI.container)
				if (!CI.container.check_contents())
					to_chat(user, "There's nothing in the [src] you can remove!")
					return

				for (var/obj/item/I in CI.container)
					menuoptions[I.name] = I

		var/selection = input(user, "Which item would you like to remove? If you want to remove chemicals, use an empty beaker.", "Remove ingredients") as null|anything in menuoptions
		if (selection)
			var/obj/item/I = menuoptions[selection]
			if (!user || !user.put_in_hands(I))
				I.forceMove(get_turf(src))
			update_icon()
		return 1
	return 0


/obj/machinery/appliance/mixer/toggle_power()
	set src in view()
	set name = "Toggle Power"
	set category = "Object"

	var/datum/cooking_item/CI = cooking_objs[1]
	if (!CI.container.check_contents())
		to_chat(usr, "There's nothing in it! Add ingredients before turning [src] on!")
		return

	if (stat & POWEROFF)//Its turned off
		stat &= ~POWEROFF
		if (usr)
			usr.visible_message("[usr] turns the [src] on", "You turn on the [src]")
			get_cooking_work(CI)
			use_power = 2
	else //Its on, turn it off
		stat |= POWEROFF
		use_power = 0
		if (usr)
			usr.visible_message("[usr] turns the [src] off", "You turn off the [src]")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/mixer/can_insert(var/obj/item/I, var/mob/user)
	if (!stat)
		to_chat(user, span("warning","You can't add items while \the [src] is running. Wait for it to finish or turn the power off to abort"))
		return 0
	else
		return ..()

/obj/machinery/appliance/mixer/finish_cooking(var/datum/cooking_item/CI)
	..()
	stat |= POWEROFF
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	use_power = 0
	CI.reset()
	update_icon()

/obj/machinery/appliance/mixer/update_icon()
	if (!stat)
		icon_state = on_icon
	else
		icon_state = off_icon


/obj/machinery/appliance/mixer/machinery_process()
	if (!stat)
		for (var/i in cooking_objs)
			do_cooking_tick(i)
