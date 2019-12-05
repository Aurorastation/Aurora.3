// Mask
/datum/gear/mask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	slot = slot_mask
	sort_category = "Masks"

/datum/gear/mask/cloth
	display_name = "cloth mask"
	path = /obj/item/clothing/mask/cloth

/datum/gear/mask/cloth/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/dust
	display_name = "dust mask"
	path = /obj/item/clothing/mask/dust
