// Mask
/datum/gear/mask
	display_name = "dust mask"
	path = /obj/item/clothing/mask/dust
	slot = slot_wear_mask
	sort_category = "Masks"

/datum/gear/mask/surgical
	display_name = "surgical mask selection"
	path = /obj/item/clothing/mask/surgical

/datum/gear/mask/surgical/New()
	..()
	var/masks = list()
	masks["surgical mask"] = /obj/item/clothing/mask/surgical
	masks["surgical mask, white"] = /obj/item/clothing/mask/surgical/w
	gear_tweaks += new/datum/gear_tweak/path(masks)

/datum/gear/mask/cloth
	display_name = "cloth mask"
	path = /obj/item/clothing/mask/cloth
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
