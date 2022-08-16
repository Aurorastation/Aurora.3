/datum/gear/eyes/blindfold
	display_name = "vaurca blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blinders
	cost = 2
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/mask/vaurca
	display_name = "mandible garment"
	path = /obj/item/clothing/mask/breath/vaurca
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/mask/filterport
	display_name = "filter port"
	path = /obj/item/clothing/mask/breath/vaurca/filter
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"

/datum/gear/mask/vaurca_expression
	display_name = "human expression mask"
	path = /obj/item/clothing/head/expression
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/mask/vaurca_expression/skrell
	display_name = "skrell expression mask"
	path = /obj/item/clothing/head/expression/skrell

/datum/gear/head/shaper
	display_name = "shaper helmet"
	path = /obj/item/clothing/head/shaper
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/cape
	display_name = "tunnel cloak (recolourable)"
	path = /obj/item/storage/backpack/cloak
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/cape_selection
	display_name = "tunnel cloak selection"
	path = /obj/item/storage/backpack/cloak
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/cape_selection/New()
	..()
	var/list/capes = list()
	capes["tunnel cloak, Sedantis"] = /obj/item/storage/backpack/cloak/sedantis
	capes["tunnel cloak, medical"] = /obj/item/storage/backpack/cloak/medical
	capes["tunnel cloak, engineering"] = /obj/item/storage/backpack/cloak/engi
	capes["tunnel cloak, atmospherics"] = /obj/item/storage/backpack/cloak/atmos
	capes["tunnel cloak, cargo"] = /obj/item/storage/backpack/cloak/cargo
	capes["tunnel cloak, science"] = /obj/item/storage/backpack/cloak/sci
	capes["tunnel cloak, security"] = /obj/item/storage/backpack/cloak/sec
	gear_tweaks += new /datum/gear_tweak/path(capes)

/datum/gear/vaurca_robe
	display_name = "hive cloak"
	description = "A selection of vaurca colored hive cloaks."
	path = /obj/item/clothing/suit/vaurca
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"

/datum/gear/vaurca_robe/New()
	..()
	var/list/cloaks = list()
	cloaks["hive cloak, red and golden"] = /obj/item/clothing/suit/vaurca
	cloaks["hive cloak, red and silver"] = /obj/item/clothing/suit/vaurca/silver
	cloaks["hive cloak, brown and silver"] = /obj/item/clothing/suit/vaurca/brown
	cloaks["hive cloak, blue and golden"] = /obj/item/clothing/suit/vaurca/blue
	gear_tweaks += new /datum/gear_tweak/path(cloaks)

/datum/gear/uniform/vaurca
	display_name = "vaurca clothes"
	path = /obj/item/clothing/under/vaurca
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/vaurca_harness
	display_name = "vaurcan gear harness"
	description = "A selection of vaurca colored gear harnesses."
	path = /obj/item/clothing/under/vaurca/gearharness
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/vaurca_harness/New()
	..()
	var/list/harness = list()
	harness["vaurcan gear harness, brown"] = /obj/item/clothing/under/vaurca/gearharness
	harness["vaurcan gear harness, white"] = /obj/item/clothing/under/vaurca/gearharness/white
	harness["vaurcan gear harness, black"] = /obj/item/clothing/under/vaurca/gearharness/black
	gear_tweaks += new /datum/gear_tweak/path(harness)

/datum/gear/uniform/vaurca_harness_colorable
	display_name = "vaurcan gear harness (colorable)"
	description = "A tight-fitting gear harness designed for the Vaurcan form. Mass-produced from equally mass-produced materials."
	path = /obj/item/clothing/under/vaurca/gearharness/colorable
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/vaurca
	display_name = "shaper robes"
	path = /obj/item/clothing/suit/vaurca/shaper
	slot = slot_wear_suit
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	cost = 1
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/vaurca
	display_name = "vaurca shoes"
	path = /obj/item/clothing/shoes/vaurca
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/vaurca_shroud
	display_name = "vaurcan shroud"
	description = "A selection of vaurca colored shrouds."
	path = /obj/item/clothing/head/shroud
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"

/datum/gear/suit/vaurca_shroud/New()
	..()
	var/list/shrouds = list()
	shrouds["vaurcan shroud, blue"] = /obj/item/clothing/head/shroud
	shrouds["vaurcan shroud, red"] = /obj/item/clothing/head/shroud/red
	shrouds["vaurcan shroud, green"] = /obj/item/clothing/head/shroud/green
	shrouds["vaurcan shroud, purple"] = /obj/item/clothing/head/shroud/purple
	shrouds["vaurcan shroud, brown"] = /obj/item/clothing/head/shroud/brown
	gear_tweaks += new /datum/gear_tweak/path(shrouds)

/datum/gear/suit/vaurca_shroud_colorable
	display_name = "vaurcan shroud (colorable)"
	description = "A selection of vaurca colored shrouds."
	path = /obj/item/clothing/head/shroud/colorable
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/vaurca_mantle
	display_name = "vaurcan mantle"
	path = /obj/item/clothing/accessory/poncho/vaurca
	cost = 1
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	sort_category = "Xenowear - Vaurca"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/augment/language_processor
	display_name = "language processor"
	description = "An augment that allows a vaurca to speak and understand a related language. These are only used by their respective hives."
	path = /obj/item/organ/internal/augment/language/klax
	cost = 0
	sort_category = "Xenowear - Vaurca"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_BULWARK)
	flags = GEAR_NO_SELECTION

/datum/gear/augment/language_processor/New()
	..()
	var/list/language_processors = list()
	language_processors["K'laxan [LANGUAGE_UNATHI] language processor"] = /obj/item/organ/internal/augment/language/klax
	language_processors["C'thur [LANGUAGE_SKRELLIAN] language processor"] = /obj/item/organ/internal/augment/language/cthur
	gear_tweaks += new /datum/gear_tweak/path(language_processors)

/datum/gear/vaurca_lunchbox
	display_name = "vaurca lunchbox"
	description = "A lunchbox selection containing various kois products."
	cost = 2
	path = /obj/item/storage/toolbox/lunchbox
	sort_category = "Xenowear - Vaurca"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_BULWARK)

/datum/gear/vaurca_lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/toolbox/lunchbox))
		var/obj/item/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	sortTim(lunchboxes, /proc/cmp_text_asc)
	gear_tweaks += new /datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new /datum/gear_tweak/contents(lunchables_vaurca(), lunchables_vaurca_snack(), lunchables_drinks(), lunchables_utensil())

/datum/gear/ears/vaurca/rings
	display_name = "bulwark horn rings"
	description = "Rings worn by Bulwarks to decorate their horns."
	cost = 1
	path = /obj/item/clothing/ears/bulwark/rings
	sort_category = "Xenowear - Vaurca"
	whitelisted = list(SPECIES_VAURCA_BULWARK)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/skrell_projector/vaurca_projector
	display_name = "virtual reality looking-glass"
	description = "A holographic projector using advanced technology that immerses someone into a scene. It is developed and distributed by Hive Zo'ra and allows the viewer to peer in real-time into virtual reality realms specifically designed for outside viewing such as those belonging to High Queen Vaur."
	cost = 2
	path = /obj/item/skrell_projector/vaurca_projector
	sort_category = "Xenowear - Vaurca"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_BULWARK)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
