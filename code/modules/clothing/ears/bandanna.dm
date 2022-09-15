/*
	Bandannas and the like
*/

/obj/item/clothing/accessory/bandanna
	name = "red bandanna"
	desc = "A plain red bandanna."
	icon = 'icons/obj/item/clothing/ears.dmi'
	icon_state = "band_r"
	item_state = "band_r"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_MASK | SLOT_EARS | SLOT_TIE

/obj/item/clothing/accessory/bandanna/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "around [user.get_pronoun("his")] neck"

/obj/item/clothing/accessory/bandanna/get_mask_examine_text(var/mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/clothing/accessory/bandanna/blue
	name = "blue bandanna"
	desc = "A plain blue bandanna."
	icon_state = "band_bl"
	item_state = "band_bl"

/obj/item/clothing/accessory/bandanna/black
	name = "black bandanna"
	desc = "A plain black bandanna."
	icon_state = "band_bk"
	item_state = "band_bk"

/obj/item/clothing/accessory/bandanna/colorable
	name = "neck bandanna"
	desc = "A bandanna in 16,777,216 designer colors that goes around the neck."
	icon_state = "band_wh"
	item_state = "band_wh"

/obj/item/clothing/accessory/bandanna/colorable/knitted
	name = "knitted neck bandanna"
	desc = "A hand knitted neck bandanna. It looks quite soft."
