/obj/machinery/appliance/cooker/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	appliancetype = GRILL
	food_color = "#a34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	finish_verb = "sizzles to completion!"
	cooked_sound = 'sound/effects/meatsizzle.ogg'
	optimal_temp = 150 + T0C
	temp_settings = 1
	max_contents = 1
	resistance = 500 // assuming it's a fired grill, it shouldn't take very long to heat

	idle_power_usage = 0
	active_power_usage = 0

	starts_with = list(
		/obj/item/reagent_containers/cooking_container/grill_grate
	)

/obj/machinery/appliance/cooker/grill/activation_message(var/mob/user)
	user.visible_message("<b>[user]</b> [stat ? "turns off" : "fires up"] \the [src].", "You [stat ? "turn off" : "fires up"] \the [src].")

/obj/machinery/appliance/cooker/grill/has_space(var/obj/item/I)
	if(istype(I, /obj/item/reagent_containers/cooking_container))
		if(length(cooking_objs) < max_contents)
			return TRUE
	else
		if(length(cooking_objs))
			var/datum/cooking_item/CI = cooking_objs[1]
			var/obj/item/reagent_containers/cooking_container/grill_grate/G = CI.container
			if(G?.can_fit(I))
				return CI
	return FALSE

/obj/machinery/appliance/cooker/grill/update_icon()
	. = ..()
	cut_overlays()
	if(!stat)
		icon_state = on_icon
	else
		icon_state = off_icon
	if(length(cooking_objs))
		var/datum/cooking_item/CI = cooking_objs[1]
		var/obj/item/reagent_containers/cooking_container/grill_grate/G = CI.container
		if(G)
			add_overlay(image('icons/obj/cooking_machines.dmi', "grill"))
			var/contents_len = length(G.contents)
			if(!contents_len)
				return
			for(var/i = 1 to contents_len)
				add_overlay(image('icons/obj/cooking_machines.dmi', "meat[i]"))