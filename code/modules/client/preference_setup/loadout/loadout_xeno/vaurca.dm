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

/datum/gear/mask/filterport
	display_name = "filter port"
	path = /obj/item/clothing/mask/breath/vaurca/filter
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca_expression
	display_name = "human expression mask"
	path = /obj/item/clothing/head/expression
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca_expression/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/vaurca_expression/skrell
	display_name = "skrell expression mask"
	path = /obj/item/clothing/head/expression/skrell

/datum/gear/head/shaper
	display_name = "shaper helmet"
	path = /obj/item/clothing/head/shaper
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/head/shaper/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cape
	display_name = "tunnel cloak"
	path = /obj/item/storage/backpack/cloak
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/vaurca_robe
	display_name = "hive cloak"
	description = "A selection of vaurca colored hive cloaks."
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
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/vaurca
	display_name = "shaper robes"
	path = /obj/item/clothing/suit/vaurca/shaper
	slot = slot_wear_suit
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	cost = 1

/datum/gear/suit/vaurca/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/vaurca
	display_name = "vaurca shoes"
	path = /obj/item/clothing/shoes/vaurca
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/shoes/vaurca/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/vaurca_shroud
	display_name = "vaurcan shroud"
	description = "A selection of vaurca colored shrouds."
	path = /obj/item/clothing/head/shroud
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/suit/vaurca_shroud/New()
	..()
	var/shrouds = list()
	shrouds["vaurcan shroud, blue"] = /obj/item/clothing/head/shroud
	shrouds["vaurcan shroud, red"] = /obj/item/clothing/head/shroud/red
	shrouds["vaurcan shroud, green"] = /obj/item/clothing/head/shroud/green
	shrouds["vaurcan shroud, purple"] = /obj/item/clothing/head/shroud/purple
	shrouds["vaurcan shroud, brown"] = /obj/item/clothing/head/shroud/brown
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

/datum/gear/suit/vaurca_mantle
	display_name = "vaurcan mantle"
	path = /obj/item/clothing/suit/vaurca/mantle
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/suit/vaurca_mantle/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice