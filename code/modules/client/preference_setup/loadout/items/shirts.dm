ABSTRACT_TYPE(/datum/gear/shirts)
	sort_category = "Shirts and Tops"
	slot = slot_w_uniform

/datum/gear/shirts/polo_colorable
	display_name = "polo shirts selection (colorable)"
	description = "A selection of colorable polo shirts."
	path = /obj/item/clothing/under/dressshirt/polo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/shirts/polo_colorable/New()
	..()
	var/list/polo_colorable = list()

	polo_colorable["polo shirt"] = /obj/item/clothing/under/dressshirt/polo
	polo_colorable["polo shirt (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_fem

	gear_tweaks += new /datum/gear_tweak/path(polo_colorable)

/datum/gear/shirts/shirt
	display_name = "shirt selection"
	path = /obj/item/clothing/under/dressshirt
	description = "A selection of shirts."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shirts/shirt/New()
	..()
	var/list/shirt = list()
	shirt["dress shirt"] = /obj/item/clothing/under/dressshirt
	shirt["dress shirt, rolled up"] = /obj/item/clothing/under/dressshirt/rolled
	shirt["dress shirt, cropped"] = /obj/item/clothing/under/dressshirt/crop
	shirt["cropped dress shirt, rolled up"] = /obj/item/clothing/under/dressshirt/crop/rolled
	shirt["dress shirt, alt"] = /obj/item/clothing/under/dressshirt/alt
	shirt["dress shirt, alt rolled up"] = /obj/item/clothing/under/dressshirt/alt/rolled
	shirt["dress shirt, v-neck alt"] = /obj/item/clothing/under/dressshirt/alt/vneck
	shirt["dress shirt, v-neck alt rolled up"] = /obj/item/clothing/under/dressshirt/alt/vneck/rolled
	shirt["dress shirt, deep v-neck"] = /obj/item/clothing/under/dressshirt/deepv
	shirt["dress shirt, deep v-neck rolled up"] = /obj/item/clothing/under/dressshirt/deepv/rolled
	shirt["dress shirt, asymmetric"] = /obj/item/clothing/under/dressshirt/asymmetric
	shirt["long-sleeved shirt"] = /obj/item/clothing/under/dressshirt/longsleeve
	shirt["t-shirt"] = /obj/item/clothing/under/dressshirt/tshirt
	shirt["t-shirt, cropped"] = /obj/item/clothing/under/dressshirt/tshirt_crop
	shirt["blouse"] = /obj/item/clothing/under/dressshirt/blouse
	shirt["long-sleeved blouse"] = /obj/item/clothing/under/dressshirt/longblouse
	shirt["puffy blouse"] = /obj/item/clothing/under/dressshirt/puffyblouse
	shirt["halter top"] = /obj/item/clothing/under/dressshirt/haltertop
	shirt["tank top"] = /obj/item/clothing/under/dressshirt/tanktop
	shirt["tank top, feminine"] = /obj/item/clothing/under/dressshirt/tanktop/feminine
	gear_tweaks += new /datum/gear_tweak/path(shirt)

/datum/gear/shirts/stripes
	display_name = "striped shirt selection"
	path = /obj/item/clothing/under/dressshirt
	description = "A selection of shirts."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/shirts/stripes/New()
	..()
	var/list/shirt = list()
	shirt["striped long-sleeved shirt"] = /obj/item/clothing/under/dressshirt/longsleeve_s
	shirt["striped t-shirt"] = /obj/item/clothing/under/dressshirt/tshirt_s
	gear_tweaks += new /datum/gear_tweak/path(shirt)


/datum/gear/shirts/silversun
	display_name = "silversun floral shirt selection"
	path = /obj/item/clothing/under/dressshirt/silversun
	description = "A selection of Silversun floral shirts."
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/shirts/silversun/New()
	..()
	var/list/shirts = list()
	shirts["cyan silversun shirt"] = /obj/item/clothing/under/dressshirt/silversun
	shirts["red silversun shirt"] = /obj/item/clothing/under/dressshirt/silversun/red
	shirts["random colored silversun shirt"] = /obj/item/clothing/under/dressshirt/silversun/random
	gear_tweaks += new /datum/gear_tweak/path(shirts)
