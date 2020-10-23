/datum/gear/religion
	display_name = "trinary perfection robes"
	path = /obj/item/clothing/suit/trinary_robes
	sort_category = "Religion"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/religion/trinary/mask
	display_name = "trinary perfection mask"
	path = /obj/item/clothing/mask/trinary_mask

/datum/gear/religion/trinary/cape
	display_name = "trinary perfection cape"
	path = /obj/item/clothing/accessory/poncho/trinary

/datum/gear/religion/trinary/badge
	display_name = "trinary perfection brooch"
	path = /obj/item/clothing/accessory/badge/trinary

/datum/gear/religion/rosary
	display_name = "rosary"
	path = /obj/item/clothing/accessory/rosary

/datum/gear/religion/rosary
	display_name = "rosary"
	path = /obj/item/clothing/accessory/rosary

/datum/gear/religion/dominia/robe
	display_name = "dominian robe selection"
	description = "A selection of robes belonging to Dominia's Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest

/datum/gear/religion/dominia/robe/New()
	..()
	var/robe = list()
	robe["tribunalist's robe"] = /obj/item/clothing/under/dominia/priest
	robe["tribunal initiate's robe"] = /obj/item/clothing/under/dominia/initiate
	gear_tweaks += new/datum/gear_tweak/path(robe)

/datum/gear/religion/dominia/beret
	display_name = "dominian beret selection"
	description = "A selection of modified berets belonging to Dominia's Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest

/datum/gear/religion/dominia/beret/New()
	..()
	var/beret = list()
	beret["tribunal initiate's beret"] = /obj/item/clothing/head/softcap/dominia
	beret["tribunalist's beret"] = /obj/item/clothing/head/softcap/dominia/priest
	gear_tweaks += new/datum/gear_tweak/path(beret)

/datum/gear/religion/dominia/cape
	display_name = "dominian outerwear selection"
	description = "A selection of capes and outerwear worn by the Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest

/datum/gear/religion/dominia/cape/New()
	..()
	var/cape = list()
	cape["tribunalist red cape"] = /obj/item/clothing/accessory/poncho/dominia/red
	cape["tribunalist full cape"] = /obj/item/clothing/accessory/poncho/dominia/red/double
	cape["tribunalist surcoat"] = /obj/item/clothing/accessory/poncho/dominia/red/surcoat
	gear_tweaks += new/datum/gear_tweak/path(cape)

/datum/gear/religion/dominia/accessory
	display_name = "tribunal necklace"
	path = "/obj/item/clothing/accessory/dominia"

/datum/gear/religion/shaman_staff
	display_name = "shaman staff"
	path = /obj/item/cane/shaman
