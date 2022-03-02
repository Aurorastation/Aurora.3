/obj/item/clothing/ears/skrell
	name = "skrell tentacle wear"
	desc = "Some stuff worn by skrell to adorn their head tentacles."
	icon = 'icons/obj/skrell_items.dmi'
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

/obj/item/clothing/ears/skrell/chain/goldshort
	name = "skrell short gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "male_golddia"
	item_state = "male_golddia"

/obj/item/clothing/ears/skrell/chain/goldaverage
	name = "skrell average gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "female_golddia"
	item_state = "female_golddia"

/obj/item/clothing/ears/skrell/chain/goldlong
	name = "skrell very long gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "verylong_golddia"
	item_state = "verylong_golddia"

/obj/item/clothing/ears/skrell/chain/goldshort
	name = "skrell very short gold headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "veryshort_golddia"
	item_state = "veryshort_golddia"

/obj/item/clothing/ears/skrell/chain/silvershort
	name = "skrell short silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	icon_state = "male_silvdia"
	item_state = "male_silvdia"

/obj/item/clothing/ears/skrell/chain/silveraverage
	name = "skrell average silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	icon_state = "female_silvdia"
	item_state = "female_silvdia"

/obj/item/clothing/ears/skrell/chain/silverlong
	name = "skrell very long silver headdress"
	desc = "A jeweled silver headdress worn by skrell around their head tails."
	icon_state = "verylong_silvdia"
	item_state = "verylong_silvdia"

/obj/item/clothing/ears/skrell/chain/festiveaverage
	name = "skrell average festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "female_fest"
	item_state = "female_fest"

/obj/item/clothing/ears/skrell/chain/festivelong
	name = "skrell very long festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "verylong_fest"
	item_state = "verylong_fest"

/obj/item/clothing/ears/skrell/chain/festiveshort
	name = "skrell short festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "male_fest"
	item_state = "male_fest"

/obj/item/clothing/ears/skrell/chain/festiveveryshort
	name = "skrell very short festive headdress"
	desc = "An elaborate golden headdress worn by skrell around their head tails."
	icon_state = "veryshort_fest"
	item_state = "veryshort_fest"

/obj/item/clothing/ears/skrell/chain/blackshort
	name = "skrell short ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	icon_state = "male_blackdia"
	item_state = "male_blackdia"

/obj/item/clothing/ears/skrell/chain/blackaverage
	name = "skrell average ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	icon_state = "female_blackdia"
	item_state = "skrell_chain_ebony"

/obj/item/clothing/ears/skrell/chain/blacklong
	name = "skrell long ebony headdress"
	desc = "An elaborate ebony jeweled headdress worn by skrell around their head tails."
	icon_state = "verylong_blackdia"
	item_state = "verylong_blackdia"

/obj/item/clothing/ears/skrell/band
	name = "gold headtail bands"
	desc = "Golden metallic bands worn by skrell to adorn their head tails."
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

/obj/item/clothing/ears/skrell/cloth_average
	name = "red headtail cloth"
	desc = "A cloth shawl worn by skrell draped around their head tails."
	icon_state = "skrell_cloth_female"
	item_state = "skrell_cloth_female"

/obj/item/clothing/ears/skrell/cloth_average/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_female"
	item_state = "skrell_cloth_black_female"

/obj/item/clothing/ears/skrell/cloth_average/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_female"
	item_state = "skrell_cloth_blue_female"

/obj/item/clothing/ears/skrell/cloth_average/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_female"
	item_state = "skrell_cloth_green_female"

/obj/item/clothing/ears/skrell/cloth_average/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_female"
	item_state = "skrell_cloth_pink_female"

/obj/item/clothing/ears/skrell/cloth_average/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_female"
	item_state = "skrell_cloth_lblue_female"

/obj/item/clothing/ears/skrell/cloth_short
	name = "red headtail cloth"
	desc = "A cloth band worn by skrell around their head tails."
	icon_state = "skrell_cloth_male"
	item_state = "skrell_cloth_male"

/obj/item/clothing/ears/skrell/cloth_short/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_male"
	item_state = "skrell_cloth_black_male"

/obj/item/clothing/ears/skrell/cloth_short/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_male"
	item_state = "skrell_cloth_blue_male"

/obj/item/clothing/ears/skrell/cloth_short/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_male"
	item_state = "skrell_cloth_green_male"

/obj/item/clothing/ears/skrell/cloth_short/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_male"
	item_state = "skrell_cloth_pink_male"

/obj/item/clothing/ears/skrell/cloth_short/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_male"
	item_state = "skrell_cloth_lblue_male"

/obj/item/clothing/ears/skrell/cloth_short/purple
	name = "skrell purple head cloth"
	desc = "A purple cloth band worn by skrell around their head tails."
	icon_state = "skrell_cloth_purple_male"
	item_state = "skrell_cloth_purple_male"

/obj/item/clothing/ears/skrell/goop
	name = "glowing algae"
	desc = "A mixture of glowing algae applied by skrell on their head tails."
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

/obj/item/clothing/ears/skrell/goop/stripes
	icon_state = "skrell_stripes"
	item_state = "skrell_stripes"

/obj/item/clothing/ears/skrell/goop/circles
	icon_state = "skrell_circles"
	item_state = "skrell_circles"

/obj/item/clothing/ears/skrell/scrunchy
	name = "skrell tentacle tie"
	desc = "A self-powered hard-light 'scrunchy' used to comfortably tie back the tentacles."
	icon = 'icons/clothing/head/skrellscrunchies.dmi'
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
	item_state = "skrell_cap"
	icon_state = "skrell_cap_item"

/obj/item/clothing/ears/skrell/workcap/long
	name = "Long Worker's Cap"
	desc = "A simple clothing item used by Skrell to cover their headtails. It comes with a main sleeve for the middle headtail, with smaller sleeves for the outer headtails to help keep it in place. This one is longer to account for Skrell with longer headtails."
	item_state = "skrell_cap_long"
