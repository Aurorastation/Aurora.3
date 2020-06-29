/datum/gear/eyes/vaurca_blindfold
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
	display_name = "human expression mask (colourable)"
	path = /obj/item/clothing/head/expression
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/mask/vaurca_expression/skrell
	display_name = "skrell expression mask"
	path = /obj/item/clothing/head/expression/skrell

/datum/gear/head/shaper
	display_name = "shaper helmet (colourable)"
	path = /obj/item/clothing/head/shaper
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/cape
	display_name = "tunnel cloak (colourable)"
	path = /obj/item/storage/backpack/cloak
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/vaurca_robe
	display_name = "hive cloak (selection)"
	description = "A selection of vaurca colored hive cloaks."
	path = /obj/item/clothing/suit/vaurca
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/vaurca_robe/New()
	..()
	var/cloaks = list()
	cloaks["red and golden hive cloak"] = /obj/item/clothing/suit/vaurca
	cloaks["red and silver hive cloak"] = /obj/item/clothing/suit/vaurca/silver
	cloaks["brown and silver hive cloak"] = /obj/item/clothing/suit/vaurca/brown
	cloaks["blue and golden hive cloak"] = /obj/item/clothing/suit/vaurca/blue
	gear_tweaks += new/datum/gear_tweak/path(cloaks)

/datum/gear/uniform/vaurca
	display_name = "vaurca clothes (colourable)"
	path = /obj/item/clothing/under/vaurca
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/vaurca
	display_name = "shaper robes (colourable)"
	path = /obj/item/clothing/suit/vaurca/shaper
	slot = slot_wear_suit
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	cost = 1
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/vaurca
	display_name = "vaurca shoes (colourable)"
	path = /obj/item/clothing/shoes/vaurca
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/vaurca_shroud
	display_name = "vaurcan shroud (selection)"
	description = "A selection of vaurca colored shrouds."
	path = /obj/item/clothing/head/shroud
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"

/datum/gear/suit/vaurca_shroud/New()
	..()
	var/shrouds = list()
	shrouds["blue vaurcan shroud"] = /obj/item/clothing/head/shroud
	shrouds["red vaurcan shroud"] = /obj/item/clothing/head/shroud/red
	shrouds["green vaurcan shroud"] = /obj/item/clothing/head/shroud/green
	shrouds["purple vaurcan shroud"] = /obj/item/clothing/head/shroud/purple
	shrouds["brown vaurcan shroud"] = /obj/item/clothing/head/shroud/brown
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

/datum/gear/suit/vaurca_mantle
	display_name = "vaurcan mantle (colourable)"
	path = /obj/item/clothing/suit/vaurca/mantle
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/augment/language_processor
	display_name = "language processor (selection)"
	description = "An augment that allows a vaurca to speak and understand a related language. These are only used by their respective hives."
	path = /obj/item/organ/internal/augment/language/klax
	cost = 2
	sort_category = "Xenowear - Vaurca"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/language_processor/New()
	..()
	var/language_processors = list()
	language_processors["K'laxan [LANGUAGE_UNATHI] language processor"] = /obj/item/organ/internal/augment/language/klax
	language_processors["C'thur [LANGUAGE_SKRELLIAN] language processor"] = /obj/item/organ/internal/augment/language/cthur
	gear_tweaks += new /datum/gear_tweak/path(language_processors)