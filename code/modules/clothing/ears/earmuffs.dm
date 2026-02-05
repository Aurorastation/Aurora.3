/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/clothing/ears/earmuffs.dmi'
	icon_state = "earmuffs"
	item_state = "earmuffs"
	item_flags = ITEM_FLAG_SOUND_PROTECTION
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	contained_sprite = TRUE

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
