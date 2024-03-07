/obj/item/umbrella
	name = "umbrella"
	desc = "A perfect tool to protect you from the elements."
	icon = 'icons/obj/item/umbrellas.dmi'
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	var/is_open = FALSE
	var/umbrella_color

/obj/item/umbrella/Initialize(mapload, ...)
	. = ..()
	if(!umbrella_color)
		umbrella_color = pick("black", "red", "yellow", "green")
	icon_state = "umbrella_[umbrella_color]"
	item_state = icon_state + "_closed"
	update_icon()

/obj/item/umbrella/attack_self(mob/user)
	. = ..()
	if(!user.incapacitated())
		if(!is_open)
			to_chat(user, SPAN_NOTICE("You unfurl \the [src]."))
			item_state = "umbrella_[umbrella_color]_open"
			w_class = ITEMSIZE_SMALL
			is_open = TRUE
		else
			to_chat(user, SPAN_NOTICE("You close up \the [src]."))
			item_state = "umbrella_[umbrella_color]_closed"
			w_class = ITEMSIZE_LARGE
			is_open = FALSE

/obj/item/umbrella/red
	umbrella_color = "red"

/obj/item/umbrella/black
	umbrella_color = "black"

/obj/item/umbrella/yellow
	umbrella_color = "yellow"

/obj/item/umbrella/green
	umbrella_color = "green"
