/obj/item/umbrella
	name = "umbrella"
	desc = "A perfect tool to protect you from the elements."
	icon = 'icons/obj/item/umbrellas.dmi'
	icon_state = "umbrella_yellow_closed"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 1000)
	force = 5
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("pokes", "stabs")
	/// If the umbrella is open or not.
	var/is_open = FALSE
	/// Colour of the umbrella. Must be one present in the dmi.
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
			w_class = ITEMSIZE_LARGE
			is_open = TRUE
			force = 1
			sharp = FALSE
			attack_verb = list("taps")
			hitsound = /singleton/sound_category/punchmiss_sound
		else
			to_chat(user, SPAN_NOTICE("You close up \the [src]."))
			item_state = "umbrella_[umbrella_color]_closed"
			w_class = initial(w_class)
			is_open = FALSE
			force = initial(force)
			sharp = initial(sharp)
			attack_verb = initial(attack_verb)
			hitsound = initial(hitsound)

/obj/item/umbrella/gives_weather_protection()
	return is_open ? TRUE : FALSE

/obj/item/umbrella/red
	umbrella_color = "red"
	icon_state = "umbrella_red_closed"

/obj/item/umbrella/black
	umbrella_color = "black"
	icon_state = "umbrella_black_closed"

/obj/item/umbrella/yellow
	umbrella_color = "yellow"
	icon_state = "umbrella_yellow_closed"

/obj/item/umbrella/green
	umbrella_color = "green"
	icon_state = "umbrella_green_closed"
