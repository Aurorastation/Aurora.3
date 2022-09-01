/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "earmuffs"
	item_state = "earmuffs"
	item_flags = SOUNDPROTECTION
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "A pair of headphones. Cushioned and sound-cancelling."
	desc_fluff = "Unce unce unce unce."
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

	playsound(src, /decl/sound_category/button_sound, 10)
	if(overlays.len)
		cut_overlays()
		to_chat(usr, SPAN_NOTICE("You turn the music off."))
	else
		add_overlay(overlay_image(icon, "music", flags=RESET_COLOR)) //add the overlay w/o coloration of the original sprite
		to_chat(usr, SPAN_NOTICE("You turn the music on."))

	update_clothing_icon()

/obj/item/clothing/ears/earmuffs/headphones/earphones
	name = "earphones"
	desc = "A pair of wired earphones."
	desc = "Has a tendency to snag itself on whatever furniture it can find at the most inopportune of times."
	icon_state = "earphones"
	item_state = "earphones"

/obj/item/clothing/ears/earmuffs/headphones/earbuds
	name = "earbuds"
	desc = "A pair of wireless earbuds. Don't lose them."
	desc_fluff = "Oh god, he can't hear us! He's got earbuds on!"
	icon_state = "earbuds"
	item_state = "earbuds"
