/datum/gear/shoes/tajara/boots
	display_name = "tajaran boots selection"
	description = "A selection of boots fitted for Tajara."
	path = /obj/item/clothing/shoes/tajara
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/shoes/tajara/boots/New()
	..()
	var/list/boots = list()
	boots["black boots, short"] = /obj/item/clothing/shoes/tajara/jackboots
	boots["black boots, knee"] = /obj/item/clothing/shoes/tajara/jackboots/knee
	boots["black boots, thigh"] = /obj/item/clothing/shoes/tajara/jackboots/thigh
	boots["brown workboots"] = /obj/item/clothing/shoes/tajara/workboots
	boots["grey workboots"] = /obj/item/clothing/shoes/tajara/workboots/grey
	boots["dark workboots"] = /obj/item/clothing/shoes/tajara/workboots/dark
	gear_tweaks += new/datum/gear_tweak/path(boots)

/datum/gear/gloves/tajara
	display_name = "tajara gloves selection"
	description = "A selection of tajaran gloves."
	path = /obj/item/clothing/gloves/black/tajara
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/gloves/tajara/New()
	..()
	var/taj_gloves = list()
	taj_gloves["black gloves"] = /obj/item/clothing/gloves/black/tajara
	taj_gloves["red gloves"] = /obj/item/clothing/gloves/red/tajara
	taj_gloves["blue gloves"] = /obj/item/clothing/gloves/blue/tajara
	taj_gloves["orange gloves"] = /obj/item/clothing/gloves/orange/tajara
	taj_gloves["purple gloves"] = /obj/item/clothing/gloves/purple/tajara
	taj_gloves["brown gloves"] = /obj/item/clothing/gloves/brown/tajara
	taj_gloves["light brown gloves"] = /obj/item/clothing/gloves/light_brown/tajara
	taj_gloves["green gloves"] = /obj/item/clothing/gloves/green/tajara
	taj_gloves["grey gloves"] = /obj/item/clothing/gloves/grey/tajara
	taj_gloves["white gloves"] = /obj/item/clothing/gloves/white/tajara
	taj_gloves["rainbow gloves"] = /obj/item/clothing/gloves/rainbow/tajara
	taj_gloves["black leather gloves"] = /obj/item/clothing/gloves/black_leather/tajara
	taj_gloves["machinist gloves"] =  /obj/item/clothing/gloves/black/tajara/smithgloves
	gear_tweaks += new/datum/gear_tweak/path(taj_gloves)

/datum/gear/suit/tajara_coat
	display_name = "tajara coat selection"
	description = "A selection of tajaran native coats."
	path = /obj/item/clothing/suit/storage/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_coat/New()
	..()
	var/coat = list()
	coat["tajaran naval coat"] = /obj/item/clothing/suit/storage/toggle/tajaran
	coat["gruff cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran
	coat["adhomian wool coat"] = /obj/item/clothing/suit/storage/tajaran
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tajara_cloak
	display_name = "tajara cloak selection"
	description = "A selection of tajaran native cloaks."
	path = /obj/item/clothing/accessory/poncho/tajarancloak
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_cloak/New()
	..()
	var/tajarancloak = list()
	tajarancloak["common cloak"] = /obj/item/clothing/accessory/poncho/tajarancloak
	tajarancloak["fancy cloak"] = /obj/item/clothing/accessory/poncho/tajarancloak/fancy
	gear_tweaks += new/datum/gear_tweak/path(tajarancloak)

/datum/gear/suit/tajara_priest
	display_name = "tajaran religious suits selection"
	description = "A selection of tajaran religious robes."
	path = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/tajara_priest/New()
	..()
	var/robes = list()
	robes["sun priest robe"] = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	robes["sun sister robe"] = /obj/item/clothing/suit/storage/tajaran/messa
	robes["matake priest mantle"] = /obj/item/clothing/suit/storage/tajaran/matake
	robes["Azubarre priest robes"] = /obj/item/clothing/suit/storage/tajaran/azubarre
	gear_tweaks += new/datum/gear_tweak/path(robes)

/datum/gear/suit/tajaran_labcoat
	display_name = "PRA medical coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Chemist", "Geneticist", "First Responder", "Medical Intern")
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajaran_surgeon
	display_name = "adhomian surgeon garb"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/surgery
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Xenobiologist", "Roboticist")
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara
	display_name = "tajaran uniform selection"
	description = "A selection of tajaran native uniforms."
	path = /obj/item/clothing/under/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara/New()
	..()
	var/uniform = list()
	uniform["laborers clothes"] = /obj/item/clothing/under/tajaran
	uniform["fancy uniform"] = /obj/item/clothing/under/tajaran/fancy
	uniform["NanoTrasen overalls"] = /obj/item/clothing/under/tajaran/nt
	uniform["matake priest garments"] = /obj/item/clothing/under/tajaran/matake
	uniform["adhomian summerwear"] = /obj/item/clothing/under/tajaran/summer
	uniform["adhomian summer pants"] = /obj/item/clothing/under/pants/tajaran
	uniform["machinist uniform"] = /obj/item/clothing/under/tajaran/mechanic
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/tajara_dress
	display_name = "tajaran dress selection"
	description = "A selection of tajaran native dresses."
	path = /obj/item/clothing/under/dress/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara_dress/New()
	..()
	var/dress = list()
	dress["white fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran
	dress["blue fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/blue
	dress["green fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/green
	dress["red fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/red
	dress["red noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy
	dress["black noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy/black
	dress["black noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy/black
	dress["adhomian summer dress"] = /obj/item/clothing/under/dress/tajaran/summer
	gear_tweaks += new/datum/gear_tweak/path(dress)

/datum/gear/shoes/tajara/flats
	display_name = "tajaran flats selection"
	description = "Dress flats, in a selection of colors. Refitted for Tajara"
	path = /obj/item/clothing/shoes/tajara
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/shoes/tajara/flats/New()
	..()
	var/list/flats = list()
	flats["dress flats, black"] = /obj/item/clothing/shoes/flats/tajara
	flats["dress flats, white"] = /obj/item/clothing/shoes/flats/tajara/white
	flats["dress flats, red"] = /obj/item/clothing/shoes/flats/tajara/red
	flats["dress flats, blue"] = /obj/item/clothing/shoes/flats/tajara/blue
	flats["dress flats, green"] = /obj/item/clothing/shoes/flats/tajara/green
	flats["dress flats, purple"] = /obj/item/clothing/shoes/flats/tajara/purple
	gear_tweaks += new/datum/gear_tweak/path(flats)

/datum/gear/accessory/tajara
	display_name = "fur scarf"
	description = "A selection of tajaran colored fur scarfs."
	path = /obj/item/clothing/accessory/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajara/New()
	..()
	var/scarf = list()
	scarf["brown fur scarf"] = /obj/item/clothing/accessory/tajaran
	scarf["light brown fur scarf"] = /obj/item/clothing/accessory/tajaran/lbrown
	scarf["cinnamon fur scarf"] = /obj/item/clothing/accessory/tajaran/cinnamon
	scarf["blue fur scarf"] = /obj/item/clothing/accessory/tajaran/blue
	scarf["silver fur scarf"] = /obj/item/clothing/accessory/tajaran/silver
	scarf["black fur scarf"] = /obj/item/clothing/accessory/tajaran/black
	scarf["ruddy fur scarf"] = /obj/item/clothing/accessory/tajaran/ruddy
	scarf["orange fur scarf"] = /obj/item/clothing/accessory/tajaran/orange
	scarf["cream fur scarf"] = /obj/item/clothing/accessory/tajaran/cream
	gear_tweaks += new/datum/gear_tweak/path(scarf)

/datum/gear/head/tajara
	display_name = "adhomian headgear selection"
	description = "A selection of tajaran native headgear."
	path = /obj/item/clothing/head/tajaran/circlet
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/head/tajara/New()
	..()
	var/circlet = list()
	circlet["golden dress circlet"] = /obj/item/clothing/head/tajaran/circlet
	circlet["silver dress circlet"] = /obj/item/clothing/head/tajaran/circlet/silver
	circlet["fur hat"] = /obj/item/clothing/head/tajaran/fur
	circlet["matake priest hat"] = /obj/item/clothing/head/tajaran/matake
	gear_tweaks += new/datum/gear_tweak/path(circlet)

/datum/gear/accessory/tajara_wrap
	display_name = "marriage wrap"
	description = "A holy cloth wrap that signifies marriage amongst tajara."
	path = /obj/item/clothing/accessory/tajaran_wrap
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajara_wrap/New()
	..()
	var/wrap = list()
	wrap["marriage wrap, male"] = /obj/item/clothing/accessory/tajaran_wrap
	wrap["marriage wrap, female"] = /obj/item/clothing/accessory/tajaran_wrap/female
	gear_tweaks += new/datum/gear_tweak/path(wrap)

/datum/gear/accessory/tajara_pelt
	display_name = "ceremonial pelt"
	path = /obj/item/clothing/accessory/tajaran_pelt
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/mask/tajara
	display_name = "sun sister veil"
	path = /obj/item/clothing/mask/tajara
	cost = 1
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/shoes/tajara
	display_name = "native tajaran foot-wear"
	path = /obj/item/clothing/shoes/tajara
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/datum/gear/gloves/shumalia_belt
	display_name = "hammer buckle belt"
	description = "A leather belt adorned by a hammer shaped buckle, worn by priesthood and worshippers of Shumaila."
	path = /obj/item/storage/belt/shumaila_buckle
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/augment/tesla_spine
	display_name = "tesla spine"
	description = "A People's Republic of Adhomai made tesla spine issued to disabled veterans and civilians."
	path = /obj/item/organ/internal/augment/tesla
	cost = 4
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajaran_card
	display_name = "tajaran cards, badges and pins selection"
	path = /obj/item/clothing/accessory/badge/hadii_card
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajaran_card/New()
	..()
	var/card = list()
	card["honorary party member card"] = /obj/item/clothing/accessory/badge/hadii_card
	card["almariist pin"] = /obj/item/clothing/accessory/dpra_badge
	card["royalist badge"] = /obj/item/clothing/accessory/nka_badge
	gear_tweaks += new/datum/gear_tweak/path(card)

/datum/gear/tajaran_passports
	display_name = "adhomian passports selection"
	path = /obj/item/clothing/accessory/badge/pra_passport
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/tajaran_passports/New()
	..()
	var/passports = list()
	passports["people's republic of adhomai passport"] = /obj/item/clothing/accessory/badge/pra_passport
	passports["democratic people's republic of adhomai passport"] = /obj/item/clothing/accessory/badge/dpra_passport
	passports["new kingdom of adhomai passport"] = /obj/item/clothing/accessory/badge/nka_passport
	gear_tweaks += new/datum/gear_tweak/path(passports)

/datum/gear/adhomai_zippo
	display_name = "adhomian lighter"
	path = /obj/item/flame/lighter/adhomai
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/adhomai_pocketwatch
	display_name = "adhomian watch"
	path = /obj/item/pocketwatch/adhomai
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/tajaran_dice
	display_name = "bag of adhomian dice"
	path = /obj/item/storage/pill_bottle/dice/tajara
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION
