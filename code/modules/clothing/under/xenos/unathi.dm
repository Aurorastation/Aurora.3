/obj/item/clothing/under/unathi
	name = "sinta tunic"
	desc = "A tunic common on both Moghes and Ouerea. It's simple and easily-manufactured design makes it \
	universally favorable."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "tunic"
	item_state = "tunic"
	contained_sprite = TRUE

/obj/item/clothing/under/unathi/jizixi
	name = "jizixi dress"
	desc = "A striking, modern dress typically worn by Moghean women of high birth."
	icon_state = "jizixi"
	item_state = "jizixi"

/obj/item/clothing/under/unathi/sashes
	name = "gy'zao sashes"
	gender = PLURAL
	desc = "An androgynous set of sashes worn by Unathi when they want to bask under the sun. Not appropriate \
	to wear outside of that."
	icon_state = "gyzao"
	item_state = "gyzao"

/obj/item/clothing/under/unathi/mogazali
	name = "mogazali attire"
	desc = "A traditional Moghean uniform worn by men of high status, whether merchants, priests, or nobility."
	icon_state = "mogazali"
	item_state = "mogazali"

/obj/item/clothing/under/unathi/zazali
	name = "zazali garb"
	desc = "An old fashioned, extremely striking garb for a Unathi man with pointy shoulders. It's typically \
	worn by those in the warrior caste or those with something to prove."
	icon_state = "zazali"
	item_state = "zazali"
	var/additional_color = COLOR_GRAY // The default color.

/obj/item/clothing/under/unathi/zazali/update_icon()
	cut_overlays()
	var/image/top = image(icon, null, "zazali_top")
	top.appearance_flags = RESET_COLOR
	top.color = additional_color
	add_overlay(top)
	var/image/belt = image(icon, null, "zazali_belt")
	belt.appearance_flags = RESET_COLOR
	add_overlay(belt)

/obj/item/clothing/under/unathi/zazali/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/top = image(mob_icon, null, "zazali_un_top")
		top.appearance_flags = RESET_COLOR
		top.color = additional_color
		I.add_overlay(top)
		var/image/belt = image(mob_icon, null, "zazali_un_belt")
		belt.appearance_flags = RESET_COLOR
		I.add_overlay(belt)
	return I

/obj/item/clothing/under/unathi/huytai
	name = "huytai outfit"
	desc = "Typically worn by Unathi women who engage in a trade. Popular with fisherwomen especially!"
	icon_state = "huytai"
	item_state = "huytai"

/obj/item/clothing/under/unathi/zozo
	name = "zo'zo top"
	desc = "A modern blend of Ouerean and Moghean style for anyone on the go. Great for sunbathing!"
	icon_state = "zozo"
	item_state = "zozo"

/obj/item/clothing/under/unathi/himation
	name = "himation cloak"
	desc = "The himation is a staple of Unathi fashion. Whether a commoner in practical clothes or a noble looking \
	for leisure wear, the himation has remained stylish for centuries."
	desc_lore = "The himation while unwrapped is usually a three meter around cloth. Unathi start by putting the \
	front around their waist, bring it over their right shoulder, and then form a sash-like loop by bringing it over \
	their right again. A belt ties it off and drapes a skirt down over their thighs to complete the look. Fashionable \
	for simple noble wear (the cloth can be embroidered), and practical for labor!"
	icon_state = "himation"
	item_state = "himation"
	var/additional_color = COLOR_GRAY

/obj/item/clothing/under/unathi/himation/update_icon()
	cut_overlays()
	var/image/skirt = image(icon, null, "himation_skirt")
	skirt.appearance_flags = RESET_COLOR
	skirt.color = additional_color
	add_overlay(skirt)
	var/image/belt = image(icon, null, "himation_belt")
	belt.appearance_flags = RESET_COLOR
	add_overlay(belt)

/obj/item/clothing/under/unathi/himation/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/skirt = image(mob_icon, null, "himation_un_skirt")
		skirt.appearance_flags = RESET_COLOR
		skirt.color = additional_color
		I.add_overlay(skirt)
		var/image/belt = image(mob_icon, null, "himation_un_belt")
		belt.appearance_flags = RESET_COLOR
		I.add_overlay(belt)
	return I
