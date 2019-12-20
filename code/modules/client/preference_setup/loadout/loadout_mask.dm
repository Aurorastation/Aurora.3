// Mask
/datum/gear/mask
	display_name = "dust mask"
	path = /obj/item/clothing/mask/dust
	slot = slot_wear_mask
	sort_category = "Masks"

/datum/gear/mask
	display_name = "sterile mask selection"
	path = /obj/item/clothing/mask/surgical


/datum/gear/mask/cloth
	display_name = "cloth mask"
	path = /obj/item/clothing/mask/cloth

/datum/gear/mask/cloth/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


