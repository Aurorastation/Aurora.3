/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/clothing/ears/earmuffs.dmi'
	icon_state = "earmuffs"
	item_state = "earmuffs"
	item_flags = SOUNDPROTECTION
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	contained_sprite = TRUE
	var/on = FALSE

/obj/item/clothing/ears/earmuffs/earphones
	name = "earphones"
	desc = "A pair of wired earphones. Good luck trying to find a headphone jack."
	desc_extended = "Has a tendency to snag itself on whatever furniture it can find at the most inopportune of times."
	icon_state = "earphones"
	item_state = "earphones"
	build_from_parts = TRUE

/obj/item/clothing/ears/earmuffs/earphones/attack_self(mob/user)
	togglemusic()

/obj/item/clothing/ears/earmuffs/earphones/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(use_check_and_message(usr))
		return

	playsound(src, /decl/sound_category/button_sound, 10)
	if(on)
		cut_overlays()
		worn_overlay = null
		to_chat(usr, SPAN_NOTICE("You turn the music off."))
	else
		worn_overlay = "music" // this is rather annoying but prevents the music notes on getting colored
		to_chat(usr, SPAN_NOTICE("You turn the music on."))
	on = !on

	update_icon()
	update_clothing_icon()

/obj/item/clothing/ears/earmuffs/earphones/headphones
	name = "headphones"
	desc = "A pair of headphones. Cushioned and sound-cancelling."
	desc_extended = "Unce unce unce unce."
	icon_state = "headphones"
	item_state = "headphones"

/obj/item/clothing/ears/earmuffs/earphones/headphones/update_icon()
	..()
	add_overlay(overlay_image(icon, "[icon_state]_overlay", flags=RESET_COLOR))

/obj/item/clothing/ears/earmuffs/earphones/earbuds
	name = "earbuds"
	desc = "A pair of wireless earbuds. Don't lose them."
	desc_extended = "Oh god, he can't hear us! He's got earbuds on!"
	icon_state = "earbuds"
	item_state = "earbuds"
