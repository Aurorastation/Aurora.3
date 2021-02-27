/obj/item/clothing/under/unathi
	name = "sinta tunic"
	desc = "A tunic common on both Moghes and Ouerea, it's simple and easy to manufacture design makes it universally favorable."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "tunic"
	item_state = "tunic"
	contained_sprite = TRUE

	rolled_down = FALSE
	rolled_sleeves = FALSE

/obj/item/clothing/under/unathi/jizixi
	name = "jizixi dress"
	desc = "A striking, modern dress typically worn by Moghean women of high birth."
	icon_state = "jizixi"
	item_state = "jizixi"

/obj/item/clothing/under/unathi/sashes
	name = "gy'zao sashes"
	gender = PLURAL
	desc = "An androgynous set of sashes worn by Unathi when they want to bask under the sun. Not appropriate to wear outside of that."
	icon_state = "gyzao"
	item_state = "gyzao"

/obj/item/clothing/under/unathi/mogazali
	name = "mogazali attire"
	desc = "A traditional Moghean uniform worn by men of high status whether merchants, priests, or nobility."
	icon_state = "mogazali"
	item_state = "mogazali"

/obj/item/clothing/under/unathi/zazali
	name = "zazali garb"
	desc = "An old fashioned, extremely striking garb for the Unathi man with pointy shoulders. It's typically worn by those in the warrior caste... Or those with something to prove."
	icon_state = "zazali"
	item_state = "zazali"

/obj/item/clothing/under/unathi/huytai
	name = "huytai outfit"
	desc = "Typically worn by Unathi women who engage in a trade. Popular with fisherwomen and others."
	icon_state = "huytai"
	item_state = "huytai"

/obj/item/clothing/under/unathi/zozo
	name = "zo'zo top"
	desc = "A modern blend of Ouerean and Moghean style for the Unathi man on the go. Great for sunbathing."
	icon_state = "zozo"
	item_state = "zozo"

/obj/item/clothing/suit/unathi/mantle/wrapping
	name = "unathi wrappings"
	desc = "Stitched together clothing with bandages covering them, looks tailored for an unathi."
	desc_fluff = "This is a very traditional Sinta wear for Th'akh shamans, most modern Sinta do not wear these."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "thakh_wrappings" //special thanks to Araskael
	item_state = "thakh_wrappings"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE

/obj/item/clothing/mask/gas/wrapping
	name = "unathi head wrappings"
	desc = "A bunch of stitched together bandages with a fibreglass breath mask on it, openings for the eyes. Looks tailored for an unathi."
	desc_fluff = "This is a very traditional Sinta wear for Th'akh shamans, most modern Sinta do not wear these."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "thakh_mask" //special thanks to Araskael
	item_state = "thakh_mask"
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE
