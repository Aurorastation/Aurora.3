ABSTRACT_TYPE(/datum/gear/religion)
	sort_category = "Religion"
	flags = GEAR_HAS_DESC_SELECTION

ABSTRACT_TYPE(/datum/gear/religion/trinary)
	religion = RELIGION_TRINARY

/datum/gear/religion/trinary/mask
	display_name = "trinary perfection mask"
	path = /obj/item/clothing/mask/trinary_mask
	slot = slot_wear_mask

/datum/gear/religion/trinary/coif
	display_name = "trinary perfection coif"
	path = /obj/item/clothing/head/trinary
	slot = slot_head

/datum/gear/religion/trinary/robe
	display_name = "trinary perfection robes selection"
	description = "A selection of robes worn by adherents of the Trinary Perfection."
	path = /obj/item/clothing/suit/trinary_robes
	slot = slot_wear_suit

/datum/gear/religion/trinary/robe/New()
	..()
	var/list/trinaryrobe = list()
	trinaryrobe["trinary perfection robes"] = /obj/item/clothing/suit/trinary_robes
	trinaryrobe["trinary perfection habit"] = /obj/item/clothing/suit/trinary_robes/habit
	trinaryrobe["templeist robes"] = /obj/item/clothing/suit/trinary_robes/templeist
	gear_tweaks += new /datum/gear_tweak/path(trinaryrobe)

/datum/gear/religion/trinary/cape
	display_name = "trinary perfection cape selection"
	description = "A selection of capes worn by adherents to the Trinary Perfection."
	path = /obj/item/clothing/accessory/poncho/trinary
	slot = slot_wear_suit

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
	slot = slot_tie

/datum/gear/religion/trinary/book
	display_name = "The Order"
	description = "The holy text of the Trinary Perfection."
	path = /obj/item/device/versebook/trinary

/datum/gear/religion/trinary/book/temple
	display_name = "The Voice of Temple"
	description = "A supplementary holy text belonging to the Lodge of Temple Architect, an order within the Trinary Perfection."
	path = /obj/item/device/versebook/templeist

/datum/gear/religion/rosary
	display_name = "rosary"
	path = /obj/item/clothing/accessory/rosary
	slot = slot_tie

/datum/gear/religion/scapular
	display_name = "scapular"
	path = /obj/item/clothing/accessory/scapular
	slot = slot_tie

/datum/gear/religion/crucifix
	display_name = "crucifix selection"
	description = "A selection of different crucifixes, commonly associated with Christianity."
	path = /obj/item/clothing/accessory/crucifix
	slot = slot_tie
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_NAME_SELECTION

/datum/gear/religion/crucifix/New()
	..()
	var/list/crucifix = list()
	crucifix["gold crucifix"] = /obj/item/clothing/accessory/crucifix/gold
	crucifix["silver crucifix"] = /obj/item/clothing/accessory/crucifix/silver
	crucifix["gold saint peter crucifix"] = /obj/item/clothing/accessory/crucifix/gold/saint_peter
	crucifix["silver saint peter crucifix"] = /obj/item/clothing/accessory/crucifix/silver/saint_peter
	gear_tweaks += new /datum/gear_tweak/path(crucifix)

/datum/gear/religion/shintorobe
	display_name = "shrine maiden robe"
	path = /obj/item/clothing/under/konyangdresstraditional/red
	slot = slot_w_uniform

/datum/gear/religion/kippah
	display_name = "kippah"
	description = "A head covering commonly worn by those of Jewish faith."
	path = /obj/item/clothing/head/kippah
	slot = slot_head
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/religion/tallit
	display_name = "tallit"
	description = "A prayer shawl commonly worn by those of Jewish faith."
	path = /obj/item/clothing/accessory/tallit
	slot = slot_tie
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

ABSTRACT_TYPE(/datum/gear/religion/dominia)
	religion = RELIGION_MOROZ

/datum/gear/religion/dominia/robe
	display_name = "dominian robe selection"
	description = "A selection of robes belonging to Dominia's Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest
	slot = slot_w_uniform

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
	slot= slot_head

/datum/gear/religion/dominia/beret/New()
	..()
	var/list/beret = list()
	beret["tribunal initiate's beret"] = /obj/item/clothing/head/beret/dominia
	beret["tribunalist's beret"] = /obj/item/clothing/head/beret/dominia/priest
	beret["tribunalist's beret, red"] = /obj/item/clothing/head/beret/dominia/priest/red
	gear_tweaks += new /datum/gear_tweak/path(beret)

/datum/gear/religion/dominia/cape
	display_name = "dominian outerwear selection"
	description = "A selection of capes and outerwear worn by the Moroz Holy Tribunal."
	path = /obj/item/clothing/under/dominia/priest
	slot = slot_wear_suit

/datum/gear/religion/dominia/cape/New()
	..()
	var/list/cape = list()
	cape["tribunalist red cape"] = /obj/item/clothing/accessory/poncho/dominia/red
	cape["tribunalist full cape"] = /obj/item/clothing/accessory/poncho/dominia/red/double
	cape["tribunalist surcoat"] = /obj/item/clothing/accessory/poncho/dominia/red/surcoat
	gear_tweaks += new /datum/gear_tweak/path(cape)

/datum/gear/religion/dominia/accessory
	display_name = "tribunal necklace"
	path = /obj/item/clothing/accessory/dominia
	slot = slot_tie

/datum/gear/religion/dominia/accessory/lyodii
	display_name = "lyodic tribunal necklace"
	path = /obj/item/clothing/accessory/dominia/lyodii
	culture_restriction = list(/singleton/origin_item/culture/dominia)

/datum/gear/religion/dominia/accessory/tic
	display_name = "retired tribunal investigator card selection"
	description = "A selection of cards identifying the user as a retired tribunal investigator."
	path = /obj/item/clothing/accessory/dominia/tic

/datum/gear/religion/dominia/accessory/tic/New()
	..()
	var/list/tic_cards = list()
	tic_cards["retired tribunal investigator card"] = /obj/item/clothing/accessory/dominia/tic/retired
	tic_cards["retired caladius tribunal investigator card"] = /obj/item/clothing/accessory/dominia/tic/retired/caladius
	gear_tweaks += new /datum/gear_tweak/path(tic_cards)

/datum/gear/religion/dominia/medical
	display_name = "tribunalist medical beret"
	path = /obj/item/clothing/head/beret/dominia/medical
	slot = slot_head
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Intern", "Medical Personnel")

/datum/gear/religion/dominia/robe_consular
	display_name = "tribunalist consular uniform"
	description = "The traditional red-black-gold uniform of a priestly member of His Majesty's Diplomatic Service."
	path = /obj/item/clothing/under/dominia/priest/consular
	slot = slot_w_uniform
	allowed_roles = list("Consular Officer")

/datum/gear/religion/dominia/beret_consular
	display_name = "tribunalist consular beret"
	description = "An elegant and well-tailored gold-and-red beret worn by priestly members of His Majesty's Diplomatic Service."
	path = /obj/item/clothing/head/beret/dominia/consular
	slot = slot_head
	allowed_roles = list("Consular Officer")

/datum/gear/religion/dominia/cape_consular
	display_name = "tribunalist cousular cape"
	description = "A truly majestic gold and red cape worn by members of the clergy affiliated with His Majesty's Diplomatic Service."
	path = /obj/item/clothing/accessory/poncho/dominia/consular
	slot = slot_wear_suit
	allowed_roles = list("Consular Officer")

/datum/gear/religion/dominia/codex
	display_name = "tribunal codex"
	path = /obj/item/device/versebook/tribunal

/datum/gear/religion/dominia/icon
	display_name = "tribunal iconography"
	description = "A selection of Dominian religious icons."

/datum/gear/religion/dominia/icon/New()
	..()
	var/list/dominiaicon = list()
	dominiaicon["icon of the goddess, unaspected"] = /obj/item/sign/painting_frame/goddess
	dominiaicon["icon of the goddess, the soldier"] = /obj/item/sign/painting_frame/goddess/soldier
	dominiaicon["icon of the goddess, the artisan"] = /obj/item/sign/painting_frame/goddess/artisan
	dominiaicon["icon of the goddess, the scholar"] = /obj/item/sign/painting_frame/goddess/scholar
	dominiaicon["icon of the martyr, lotte"] = /obj/item/sign/painting_frame/martyr
	dominiaicon["icon of the martyr, matteo"] = /obj/item/sign/painting_frame/martyr/matteo
	dominiaicon["icon of the martyr, valeria"] = /obj/item/sign/painting_frame/martyr/valeria
	gear_tweaks += new /datum/gear_tweak/path(dominiaicon)

/datum/gear/religion/dominia/lyodii_deck
	display_name = "lyodii fatesayer cards"
	description = "A leather box holding a complete deck of Fatesayer cards, used by the people of the Lyod to tell one's fate."
	path = /obj/item/storage/box/lyodii
	culture_restriction = list(/singleton/origin_item/culture/dominia)

ABSTRACT_TYPE(/datum/gear/religion/assunzione)
	religion = RELIGION_LUCEISM

/datum/gear/religion/assunzione/scripture
	display_name = "luceian scripture"
	description = "A collection of texts belonging to Luceism, the dominant religion of Assunzione."
	path = /obj/item/device/versebook/assunzione

/datum/gear/religion/assunzione/cloak
	display_name = "assunzione cloak selection"
	description = "A violet cloak adorned with gold inlays worn by devout adherents of Luceism, the dominant faith of Assunzione."
	path = /obj/item/clothing/accessory/poncho/assunzione
	slot = slot_wear_suit

/datum/gear/religion/assunzione/cassock
	display_name = "assunzione clerical cassock"
	description = "A simple black-and-purple linen cassock worn by clergyfolk of Luceism, the dominant faith of Assunzione."
	path = /obj/item/clothing/under/assunzione/priest
	slot = slot_w_uniform

/datum/gear/religion/assunzione/robe
	display_name = "assunzione clerical robe"
	description = "A violet cloak adorned with gold inlays worn by devout adherents of Luceism, the dominant faith of Assunzione."
	slot = slot_wear_suit

/datum/gear/religion/assunzione/robe/New()
	..()
	var/list/robe = list()
	robe["Pyramidical keeper robe"] = /obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe
	robe["Astructural keeper robe"] = /obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe/alt
	gear_tweaks += new /datum/gear_tweak/path(robe)

/datum/gear/religion/assunzione/accessory
	display_name = "luceian amulet"
	path = /obj/item/clothing/accessory/assunzione
	slot = slot_tie

/datum/gear/religion/assunzione/scripture
	display_name = "luceian scripture"
	path = /obj/item/device/versebook/assunzione

/datum/gear/religion/assunzione/scripture/New()
	..()
	var/list/book = list()
	book["luceian book of scripture"] = /obj/item/device/versebook/assunzione
	book["pocket luceian book of scripture"] = /obj/item/device/versebook/assunzione/pocket
	gear_tweaks += new /datum/gear_tweak/path(book)

/datum/gear/religion/assunzione/orb
	display_name = "assunzione warding sphere"
	description = "A holy religious artifact and a core aspect of worship in Luceism. Comes in a protective case."
	path = /obj/item/storage/assunzionesheath/filled
