/obj/item/clothing/ears/skrell
	name = "skrell tentacle wear"
	desc = "Some stuff worn by skrell to adorn their head tentacles."
	icon = 'icons/obj/contained_items/skrell/chains.dmi'
	contained_sprite = TRUE
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_HEAD | SLOT_EARS
	species_restricted = list(BODYTYPE_SKRELL)

/obj/item/clothing/ears/skrell/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "on [user.get_pronoun("his")] headtails"

/obj/item/clothing/ears/skrell/get_head_examine_text(var/mob/user)
	return "on [user.get_pronoun("his")] headtails"

/obj/item/clothing/ears/skrell/chain
	name = "gold headtail chains"
	desc = "A delicate golden chain worn by skrell to decorate their head tails."
	icon = 'icons/obj/contained_items/skrell/chains.dmi'
	icon_state = "skrell_chain"
	item_state = "skrell_chain"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/ears/skrell/chain/silver
	name = "silver headtail chains"
	desc = "A delicate silver chain worn by skrell to decorate their head tails."
	icon_state = "skrell_chain_sil"
	item_state = "skrell_chain_sil"

/obj/item/clothing/ears/skrell/chain/bluejewels
	name = "blue jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with blue jewels worn by skrell to decorate their head tails."
	icon_state = "skrell_chain_bjewel"
	item_state = "skrell_chain_bjewel"

/obj/item/clothing/ears/skrell/chain/redjewels
	name = "red jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with red jewels worn by skrell to decorate their head tails."
	icon_state = "skrell_chain_rjewel"
	item_state = "skrell_chain_rjewel"

/obj/item/clothing/ears/skrell/chain/ebony
	name = "ebony headtail chains"
	desc = "A delicate ebony chain worn by skrell to decorate their head tails."
	icon_state = "skrell_chain_ebony"
	item_state = "skrell_chain_ebony"

/obj/item/clothing/ears/skrell/chain/short
	name = "skrell short gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "male_golddia"

/obj/item/clothing/ears/skrell/chain/average
	name = "skrell average gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "female_golddia"

/obj/item/clothing/ears/skrell/chain/long
	name = "skrell very long gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "verylong_golddia"

/obj/item/clothing/ears/skrell/chain/short
	name = "skrell very short gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "veryshort_golddia"

/obj/item/clothing/ears/skrell/chain/silver/short
	name = "skrell short silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	item_state = "male_silvdia"

/obj/item/clothing/ears/skrell/chain/silver/average
	name = "skrell average silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	item_state = "female_silvdia"

/obj/item/clothing/ears/skrell/chain/silver/long
	name = "skrell very long silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	item_state = "verylong_silvdia"

/obj/item/clothing/ears/skrell/chain/festive
	name = "skrell average festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "female_fest"

/obj/item/clothing/ears/skrell/chain/festive/long
	name = "skrell very long festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "verylong_fest"

/obj/item/clothing/ears/skrell/chain/festive/short
	name = "skrell short festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "male_fest"

/obj/item/clothing/ears/skrell/chain/festive/veryshort
	name = "skrell very short festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	item_state = "veryshort_fest"

/obj/item/clothing/ears/skrell/chain/black/short
	name = "skrell short ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	item_state = "male_blackdia"

/obj/item/clothing/ears/skrell/chain/black/average
	name = "skrell average ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	item_state = "skrell_chain_ebony"

/obj/item/clothing/ears/skrell/chain/black/long
	name = "skrell long ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	item_state = "verylong_blackdia"

/obj/item/clothing/ears/skrell/band
	name = "gold headtail bands"
	desc = "Golden metallic bands worn by skrell to adorn their head tails."
	icon = 'icons/obj/contained_items/skrell/bands.dmi'
	icon_state = "skrell_band"
	item_state = "skrell_band"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/ears/skrell/band/silver
	name = "silver headtail bands"
	desc = "Silver metallic bands worn by skrell to adorn their head tails."
	icon_state = "skrell_band_sil"
	item_state = "skrell_band_sil"

/obj/item/clothing/ears/skrell/band/bluejewels
	name = "blue jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with blue jewels worn by skrell to adorn their head tails."
	icon_state = "skrell_band_bjewel"
	item_state = "skrell_band_bjewel"

/obj/item/clothing/ears/skrell/band/redjewels
	name = "red jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with red jewels worn by skrell to adorn their head tails."
	icon_state = "skrell_band_rjewel"
	item_state = "skrell_band_rjewel"

/obj/item/clothing/ears/skrell/band/ebony
	name = "ebony headtail bands"
	desc = "Ebony bands worn by skrell to adorn their head tails."
	icon_state = "skrell_band_ebony"
	item_state = "skrell_band_ebony"

/obj/item/clothing/ears/skrell/cloth
	name = "headtail cloth"
	desc = "A cloth shawl worn by skrell draped around their head tails."
	icon = 'icons/obj/contained_items/skrell/headtail_cloth.dmi'
	icon_state = "skrell_cloth"
	item_state = "skrell_cloth"

/obj/item/clothing/ears/skrell/cloth/short
	name = "short headtail cloth"
	item_state = "skrell_cloth_short"

/obj/item/clothing/ears/skrell/goop
	name = "glowing algae"
	desc = "A mixture of glowing algae applied by skrell on their head tails."
	icon = 'icons/obj/contained_items/skrell/algae.dmi'
	icon_state = "skrell_dots"
	item_state = "skrell_dots"

/obj/item/clothing/ears/skrell/goop/update_icon()
	..()
	if(color)
		set_light(1.5,1.5,color)
		filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1, x = 0, y = 0)

/obj/item/clothing/ears/skrell/goop/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/ears/skrell/goop/long
	item_state = "skrell_dots_long"

/obj/item/clothing/ears/skrell/goop/stripes
	item_state = "skrell_stripes"

/obj/item/clothing/ears/skrell/goop/stripes/long
	item_state = "skrell_stripes_long"

/obj/item/clothing/ears/skrell/goop/circles
	item_state = "skrell_circles"

/obj/item/clothing/ears/skrell/goop/circles/long
	item_state = "skrell_circles_long"

/obj/item/clothing/ears/skrell/scrunchy
	name = "skrell tentacle tie"
	desc = "A self-powered hard-light 'scrunchy' used to comfortably tie back the tentacles."
	icon = 'icons/obj/contained_items/skrell/scrunchies.dmi'
	icon_state = "skrellhairtie"
	item_state = "scrunchy_seaweed"

/obj/item/clothing/ears/skrell/scrunchy/equipped(mob/user, slot, assisted_equip)
	if((slot in list(slot_head, slot_l_ear, slot_r_ear)) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(hair_styles_list[H.h_style], /datum/sprite_accessory/hair/skr_tentacle_m))
			var/datum/sprite_accessory/hair/skr_tentacle_m/hair_datum = hair_styles_list[H.h_style]
			if(hair_datum.scrunchy_style)
				item_state = "scrunchy_[hair_datum.scrunchy_style]"
	return ..()

/obj/item/clothing/ears/skrell/workcap
	name = "Worker's Cap"
	desc = "A simple clothing item used by Skrell to cover their headtails. It comes with a main sleeve for the middle headtail, with smaller sleeves for the outer headtails to help keep it in place."
	icon = 'icons/obj/contained_items/skrell/nralakk_caps.dmi'
	item_state = "skrell_cap"
	icon_state = "skrell_cap_item"

/obj/item/clothing/ears/skrell/workcap/long
	name = "Long Worker's Cap"
	desc = "A simple clothing item used by Skrell to cover their headtails. It comes with a main sleeve for the middle headtail, with smaller sleeves for the outer headtails to help keep it in place. This one is longer to account for Skrell with longer headtails."
	item_state = "skrell_cap_long"

/obj/item/clothing/ears/skrell/tailband
	name = "ox tailband"
	desc = "A band meant to be worn on a Skrell's main headtail. This one has the ox symbol on it."
	icon = 'icons/obj/contained_items/skrell/tailband.dmi'
	item_state = "ox"
	icon_state = "tailband"

/obj/item/clothing/ears/skrell/tailband/ix
	name = "ix tailband"
	desc = "A band meant to be worn on a Skrell's main headtail. This one has the ix symbol on it."
	item_state = "ix"
	icon_state = "tailband"

/obj/item/clothing/ears/skrell/tailband/oqi
	name = "oqi tailband"
	desc = "A band meant to be worn on a Skrell's main headtail. This one has the oqi symbol on it."
	item_state = "oqi"
	icon_state = "tailband"

/obj/item/clothing/ears/skrell/tailband/iqi
	name = "iqi tailband"
	desc = "A band meant to be worn on a Skrell's main headtail. This one has the iqi symbol on it."
	item_state = "iqi"
	icon_state = "tailband"