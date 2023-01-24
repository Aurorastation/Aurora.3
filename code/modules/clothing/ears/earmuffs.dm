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

	playsound(src, /singleton/sound_category/button_sound, 10)
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
	desc_extended = "Oh god, they can't hear us! They've got earbuds on!"
	icon_state = "earbuds"
	item_state = "earbuds"

/obj/item/clothing/accessory/ear_warmers
	name = "ear warmers"
	desc = "A pair of fuzzy ear warmers, incase that's the only place you're worried about getting frost bite."
	icon = 'icons/obj/clothing/ears/earmuffs.dmi'
	icon_state = "ear_warmers"
	item_state = "ear_warmers"
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "over"
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	slot = ACCESSORY_SLOT_HEAD 

/obj/item/clothing/accessory/ear_warmers/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_ear != src && H.r_ear != src)
			return ..()

		if(slot_flags & SLOT_TWOEARS)
			var/obj/item/clothing/ears/OE = (H.l_ear == src ? H.r_ear : H.l_ear)
			qdel(OE)

	..()
	
/obj/item/clothing/accessory/ear_warmers/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_l_ear()
		M.update_inv_r_ear()