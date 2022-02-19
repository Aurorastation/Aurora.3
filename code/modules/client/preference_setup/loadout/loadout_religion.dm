/datum/gear/religion
	display_name = "trinary perfection robes"
	path = /obj/item/clothing/suit/trinary_robes
	sort_category = "Religion"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/religion/trinary/mask
	display_name = "trinary perfection mask"
	path = /obj/item/clothing/mask/trinary_mask

/datum/gear/religion/trinary/cape
	display_name = "trinary perfection cape selection"
	description = "A selection of capes worn by adherents to the Trinary Perfection."
	path = /obj/item/clothing/accessory/poncho/trinary

/datum/gear/religion/trinary/cape/New()
	..()
	var/list/trinarycape = list()
	trinarycape["trinary perfection cape"] = /obj/item/clothing/accessory/poncho/trinary
	trinarycape["trinary perfection shoulder cape"] = /obj/item/clothing/accessory/poncho/trinary/shouldercape
	trinarycape["trinary perfection pellegrina"] = /obj/item/clothing/accessory/poncho/trinary/pellegrina
	gear_tweaks += new /datum/gear_tweak/path(trinarycape)

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
	var/list/robe = list()
	robe["tribunalist's robe"] = /obj/item/clothing/under/dominia/priest
	robe["tribunal initiate's robe"] = /obj/item/clothing/under/dominia/initiate
	gear_tweaks += new /datum/gear_tweak/path(robe)

/datum/gear/religion/dominia/beret
	display_name = "dominian beret selection"
	description = "A selection of modified berets belonging to Dominia's Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest

/datum/gear/religion/dominia/beret/New()
	..()
	var/list/beret = list()
	beret["tribunal initiate's beret"] = /obj/item/clothing/head/beret/dominia
	beret["tribunalist's beret"] = /obj/item/clothing/head/beret/dominia/priest
	gear_tweaks += new /datum/gear_tweak/path(beret)

/datum/gear/religion/dominia/cape
	display_name = "dominian outerwear selection"
	description = "A selection of capes and outerwear worn by the Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest

/datum/gear/religion/dominia/cape/New()
	..()
	var/list/cape = list()
	cape["tribunalist red cape"] = /obj/item/clothing/accessory/poncho/dominia/red
	cape["tribunalist full cape"] = /obj/item/clothing/accessory/poncho/dominia/red/double
	cape["tribunalist surcoat"] = /obj/item/clothing/accessory/poncho/dominia/red/surcoat
	gear_tweaks += new /datum/gear_tweak/path(cape)

/datum/gear/religion/assunzione/robe
	display_name = "assunzione robe selection"
	description = "A selection of robes worn by adherents to Luceism."
	path = /obj/item/clothing/accessory/poncho/assunzione

/datum/gear/religion/assunzione/robe/New()
	..()
	var/list/assunzionerobe = list()
	assunzionerobe["assunzione robe"] = /obj/item/clothing/accessory/poncho/assunzione
	assunzionerobe["assunzione vine-inlaid robe"] = /obj/item/clothing/accessory/poncho/assunzione/vine
	assunzionerobe["assunzione gold-inlaid robe"] = /obj/item/clothing/accessory/poncho/assunzione/gold
	gear_tweaks += new /datum/gear_tweak/path(assunzionerobe)

/datum/gear/religion/dominia/accessory
	display_name = "tribunal necklace"
	path = /obj/item/clothing/accessory/dominia

/datum/gear/religion/dominia/medical
	display_name = "tribunalist medical beret"
	path = /obj/item/clothing/head/beret/dominia/medical
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern")

/datum/gear/religion/shaman_staff
	display_name = "shaman staff"
	path = /obj/item/cane/shaman

/datum/gear/religion/dominia/robe_consular
	display_name = "tribunalist consular uniform"
	description = "The traditional red-black-gold uniform of a priestly member of His Majesty's Diplomatic Service."
	path = /obj/item/clothing/under/dominia/priest/consular
	allowed_roles = list("Consular Officer")

/datum/gear/religion/dominia/beret_consular
	display_name = "tribunalist consular beret"
	description = "A n elegant and well-tailored gold-and-red beret worn by priestly members of His Majesty's Diplomatic Service."
	path = /obj/item/clothing/head/beret/dominia/consular
	allowed_roles = list("Consular Officer")

/datum/gear/religion/dominia/cape_consular
	display_name = "tribunalist cousular cape"
	description = "A truly majestic gold and red cape worn by members of the clergy affiliated with His Majesty's Diplomatic Service."
	path = /obj/item/clothing/accessory/poncho/dominia/consular
	allowed_roles = list("Consular Officer")

/datum/gear/religion/assunzione/accessory
	display_name = "luceian amulet"
	path = /obj/item/clothing/accessory/assunzione

/datum/gear/religion/assunzioneorb
	display_name = "assunzione warding sphere"
	description = "A religious artefact commonly associated with Luceism."
	path = /obj/item/assunzioneorb

/datum/gear/religion/assunzionesheath
	display_name = "assunzione warding sphere sheath"
	description = "A small metal shell designed to hold a warding sphere."
	path = /obj/item/storage/assunzionesheath

/datum/gear/religion/dominia/codex
	display_name = "tribunal codex"
	path = /obj/item/device/litanybook