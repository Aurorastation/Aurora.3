/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "A warm fur hat with ear flaps that can be raised and tied to be out of the way."
	icon = 'icons/obj/item/clothing/head/ushanka.dmi'
	icon_state = "ushanka"
	item_state = "ushanka"
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "over"
	flags_inv = HIDEEARS
	var/earsup = 0

/obj/item/clothing/head/ushanka/nyakas
	name = "visegradi nyakas"
	desc = "A type of flap hat that is extremely popular on Visegrad. It is designed to keep one's head and neck dry, and the flap can be pinned to the sides of the hat when not needed."
	contained_sprite = TRUE
	build_from_parts = FALSE
	icon = 'icons/obj/item/clothing/head/nyakas.dmi'
	icon_state = "nyakas"
	item_state = "nyakas"

/obj/item/clothing/head/ushanka/attack_self(mob/user as mob)
	src.earsup = !src.earsup
	if(src.earsup)
		icon_state = "[icon_state]_up"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the ear flaps on the ushanka.")
	item_state = icon_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/head/ushanka/grey
	name = "grey ushanka"

/obj/item/clothing/head/ushanka/grey/Initialize()
	. = ..()
	color = "#5d6363"

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon = 'icons/obj/item/clothing/head/beanie.dmi'
	contained_sprite = TRUE
	icon_state = "beanie"
	item_state = "beanie"

/obj/item/clothing/head/beanie/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/clothing/head/beanie/winter
	name = "winter beanie"
	desc = "A head-hugging brimless winter cap. This one has flaps that cover the ears."
	icon_state = "winterbeanie"
	item_state = "winterbeanie"
	has_accents = TRUE

/obj/item/clothing/head/beanie/submariner
	name = "submariner's beanie"
	desc = "A design of tightly fitting beanie particularly popular among the dock workers of Europa. Favored among anyone who prides a warm head."
	icon_state = "dock_beanie"
	item_state = "dock_beanie"
