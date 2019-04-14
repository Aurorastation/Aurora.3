/datum/gear/eyes/blindfold
	display_name = "vaurca blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blinders
	cost = 2
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca
	display_name = "mandible garment"
	path = /obj/item/clothing/mask/breath/vaurca
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca_expression
	display_name = "human expression mask"
	path = /obj/item/clothing/mask/breath/vaurca/expression
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca_expression/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/mask/vaurca_expression/skrell
	display_name = "skrell expression mask"
	path = /obj/item/clothing/mask/breath/vaurca/expression/skrell

/datum/gear/mask/vaurca_expression/shaper
	display_name = "shaper helmet"
	path = /obj/item/clothing/mask/breath/vaurca/shaper

/datum/gear/cape
	display_name = "tunnel cloak"
	path = /obj/item/weapon/storage/backpack/cloak
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/vaurca_robe
	display_name = "hive cloak"
	path = /obj/item/clothing/suit/vaurca
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/vaurca_robe/New()
	..()
	var/cloaks = list()
	cloaks["hive cloak, red and golden"] = /obj/item/clothing/suit/vaurca
	cloaks["hive cloak, red and silver"] = /obj/item/clothing/suit/vaurca/silver
	cloaks["hive cloak, brown and silver"] = /obj/item/clothing/suit/vaurca/brown
	cloaks["hive cloak, blue and golden"] = /obj/item/clothing/suit/vaurca/blue
	gear_tweaks += new/datum/gear_tweak/path(cloaks)

/datum/gear/uniform/vaurca
	display_name = "vaurca clothes"
	path = /obj/item/clothing/under/vaurca
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/uniform/vaurca/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/vaurca
	display_name = "shaper robes"
	path = /obj/item/clothing/suit/vaurca/shaper
	slot = slot_wear_suit
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	cost = 1

/datum/gear/suit/vaurca/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)