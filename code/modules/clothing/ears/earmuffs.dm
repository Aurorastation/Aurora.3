/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "Unce unce unce unce."
	var/headphones_on = 0
	icon_state = "headphones_off"
	item_state = "headphones"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

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
		icon_state = "headphones_off"
		headphones_on = 0
		to_chat(usr, "<span class='notice'>You turn the music off.</span>")
	else
		icon_state = "headphones_on"
		headphones_on = 1
		to_chat(usr, "<span class='notice'>You turn the music on.</span>")

	update_clothing_icon()