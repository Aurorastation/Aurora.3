ABSTRACT_TYPE(/datum/gear/shirts)
	sort_category = "Shirts and Tops"
	slot = slot_w_uniform

/datum/gear/shirts/polo
	display_name = "polo shirts selection"
	description = "A selection of polo shirts."
	path = /obj/item/clothing/under/dressshirt/polo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/shirts/polo/New()
	..()
	var/list/polo = list()

	polo["blue polo shirt"] = /obj/item/clothing/under/dressshirt/polo/polo_blue
	polo["blue polo shirt (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_blue_fem
	polo["red polo shirt"] = /obj/item/clothing/under/dressshirt/polo/polo_red
	polo["red polo shirt (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_red_fem
	polo["tan polo shirt"] = /obj/item/clothing/under/dressshirt/polo/polo_grayyellow
	polo["tan polo shirt (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_grayyellow_fem
	polo["polo shirt, green strip"] = /obj/item/clothing/under/dressshirt/polo/polo_greenstrip
	polo["polo shirt, green strip (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_greenstrip_fem
	polo["polo shirt, blue strip"] = /obj/item/clothing/under/dressshirt/polo/polo_bluestrip
	polo["polo shirt, blue strip (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_bluestrip_fem
	polo["polo shirt, red strip"] = /obj/item/clothing/under/dressshirt/polo/polo_redstrip
	polo["polo shirt, red strip (waist fitted)"] = /obj/item/clothing/under/dressshirt/polo/polo_redstrip_fem

	gear_tweaks += new /datum/gear_tweak/path(polo)

/datum/gear/shirts/polo_colorable
	display_name = "polo shirts selection (colorable)"
	description = "A selection of colorable polo shirts."
	path = /obj/item/clothing/under/dressshirt/polo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

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
	shirt["long-sleeved shirt, black striped"] = /obj/item/clothing/under/dressshirt/longsleeve_s
	shirt["long-sleeved shirt, blue striped"] = /obj/item/clothing/under/dressshirt/longsleeve_sb
	shirt["t-shirt"] = /obj/item/clothing/under/dressshirt/tshirt
	shirt["t-shirt, cropped"] = /obj/item/clothing/under/dressshirt/tshirt_crop
	shirt["blouse"] = /obj/item/clothing/under/dressshirt/blouse
	shirt["long-sleeved blouse"] = /obj/item/clothing/under/dressshirt/longblouse
	shirt["puffy blouse"] = /obj/item/clothing/under/dressshirt/puffyblouse
	shirt["halter top"] = /obj/item/clothing/under/dressshirt/haltertop
	shirt["tank top"] = /obj/item/clothing/under/dressshirt/tanktop
	shirt["tank top, feminine"] = /obj/item/clothing/under/dressshirt/tanktop/feminine
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
