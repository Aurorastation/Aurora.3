/obj/machinery/appliance/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	food_color = "#a34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	stat = POWEROFF

/obj/machinery/appliance/grill/attempt_toggle_power(var/mob/user, ranged = FALSE)
	. = ..(user, ranged)
	if(use_power)
		get_cooking_work(cooking_objs[1])

/obj/machinery/appliance/grill/Initialize()
	. = ..()
	cooking_objs += new /datum/cooking_item(new /obj/item/reagent_containers/cooking_container(src))
	cooking = 0

/obj/machinery/appliance/grill/has_space(var/obj/item/I)
	var/datum/cooking_item/CI = cooking_objs[1]
	if (!CI || !CI.container)
		return FALSE

	if (CI.container.can_fit(I))
		return CI

	return FALSE

//Container is not removable
/obj/machinery/appliance/grill/removal_menu(var/mob/user)
	if (!can_remove_items(user))
		return FALSE
	var/list/menuoptions = list()
	for (var/datum/cooking_item/CI in cooking_objs)
		if (CI.container?.check_contents() == CONTAINER_EMPTY)
			to_chat(user, SPAN_WARNING("There's nothing in [src] to remove!"))
			return
		for (var/obj/item/I in CI.container)
			menuoptions[I.name] = I

	var/selection = show_radial_menu(user, src, menuoptions, require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
	if (!selection)
		return FALSE
	var/obj/item/I = menuoptions[selection]
	if (!user?.put_in_hands(I))
		I.forceMove(get_turf(src))
	update_icon()
	return TRUE

/obj/machinery/appliance/grill/update_icon()
	if (!stat)
		icon_state = on_icon
	else
		icon_state = off_icon

/obj/machinery/appliance/grill/machinery_process()
	if (!stat)
		for (var/i in cooking_objs)
			do_cooking_tick(i)
