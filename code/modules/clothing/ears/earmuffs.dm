/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/item/clothing/ears.dmi'
	icon_state = "earmuffs"
	item_state = "earmuffs"
	item_flags = SOUNDPROTECTION
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "Unce unce unce unce."
	var/headphones_on = 0
	icon_state = "headphones"
	item_state = "headphones"

/obj/item/clothing/ears/earmuffs/headphones/attack_self(mob/user)
	togglemusic()

/obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(use_check_and_message(usr))
		return

	if(headphones_on)
		icon_state = initial(icon_state)
		headphones_on = 0
		to_chat(usr, SPAN_NOTICE("You turn the music off."))
	else
		icon_state = "[initial(icon_state)]_on"
		headphones_on = 1
		to_chat(usr, SPAN_NOTICE("You turn the music on."))

	update_clothing_icon()

/obj/item/clothing/ears/earmuffs/headphones/earphones
	name = "earphones"
	icon_state = "earphones"
	item_state = "earphones"

/obj/item/clothing/ears/earmuffs/headphones/earphones/blue
	name = "blue earphones"
	icon_state = "earphones_blue"
	item_state = "earphones_blue"
