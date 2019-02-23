/datum/gear/uniform/offworlder
	display_name = "CR suit"
	path = /obj/item/clothing/under/offworlder
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/uniform/offworlder/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/offworlder/dress
	display_name = "CR dress"
	path = /obj/item/clothing/under/offworlder

/datum/gear/uniform/offworlder/skirt
	display_name = "CR skirt"
	path = /obj/item/clothing/under/dress/offworlder

/datum/gear/eyes/glasses/offworlder
	display_name = "starshades"
	path = /obj/item/clothing/glasses/spiffygogs/offworlder
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/eyes/glasses/offworlder/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/offworlder
	display_name = "legbrace"
	path = /obj/item/clothing/accessory/offworlder/bracer
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/accessory/offworlder/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/offworlder/venter
	display_name = "venter assembly"
	path = /obj/item/clothing/accessory/offworlder

/datum/gear/accessory/offworlder/neckbrace
	display_name = "neckbrace"
	path = /obj/item/clothing/accessory/offworlder/bracer/neckbrace

/datum/gear/accessory/offworlder_armband
	display_name = "exo-stellar ribbon selection"
	path = /obj/item/clothing/accessory/armband/offworlder
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/accessory/offworlder_armband/New()
	..()
	var/armbands = list()
	armbands["science exo-stellar ribbon"] = /obj/item/clothing/accessory/armband/offworlder
	armbands["engineering exo-stellar ribbon"] = /obj/item/clothing/accessory/armband/offworlder/engineering
	armbands["medical exo-stellar ribbon"] = /obj/item/clothing/accessory/armband/offworlder/medical
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/mask/offworlder
	display_name = "overmask"
	path = /obj/item/clothing/mask/breath/offworlder
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/mask/offworlder/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/mask/offworlder/veil
	display_name = "starveil"
	path = /obj/item/clothing/mask/offworlder/veil

/datum/gear/mask/offworlder/veil/jagmask
	display_name = "jagmask"
	path = /obj/item/clothing/mask/breath/offworlder/jagmask

/datum/gear/gloves/offworlder
	display_name = "starmitts"
	path = /obj/item/clothing/gloves/offworlder
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"

/datum/gear/gloves/offworlder/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/offworlder_pills
	display_name = "bottle of RTM pills"
	path = /obj/item/weapon/storage/pill_bottle/rtm
	whitelisted = list("Off-Worlder Human")
	sort_category = "Xenowear - Human"