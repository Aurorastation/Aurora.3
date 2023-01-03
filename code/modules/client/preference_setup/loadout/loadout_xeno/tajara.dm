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
	boots["adhomian boots"] = /obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	gear_tweaks += new /datum/gear_tweak/path(boots)

/datum/gear/gloves/tajara_smithgloves
	display_name = "machinist gloves"
	path = /obj/item/clothing/gloves/black/tajara/smithgloves
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_coat
	display_name = "tajara coat and jacket selection"
	description = "A selection of tajaran native coats and jackets."
	path = /obj/item/clothing/suit/storage/toggle/tajaran/wool
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_coat/New()
	..()
	var/list/coat = list()
	coat["tajaran naval coat"] = /obj/item/clothing/suit/storage/toggle/tajaran
	coat["adhomian wool coat"] = /obj/item/clothing/suit/storage/toggle/tajaran/wool
	coat["raakti shariim coat"] = /obj/item/clothing/suit/storage/toggle/tajaran/raakti_shariim
	coat["hadiist surplus jacket"] = /obj/item/clothing/suit/storage/tajaran/pra_jacket
	coat["al'mariist jacket"] = /obj/item/clothing/suit/storage/tajaran/dpra_jacket
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/tajara_cloak
	display_name = "tajara cloak selection"
	description = "A selection of tajaran native cloaks."
	path = /obj/item/clothing/accessory/poncho/tajarancloak
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	cost = 1

/datum/gear/suit/tajara_cloak/New()
	..()
	var/list/tajarancloak = list()
	tajarancloak["common cloak"] = /obj/item/clothing/accessory/poncho/tajarancloak
	tajarancloak["fancy cloak"] = /obj/item/clothing/accessory/poncho/tajarancloak/fancy
	tajarancloak["gruff cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran
	tajarancloak["amohdan cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran/amohda
	tajarancloak["amohdan cloak, hoodless"] = /obj/item/clothing/accessory/poncho/tajarancloak/amohda
	tajarancloak["adhomian winter cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran/winter
	tajarancloak["adhomian winter cloak, hoodless"] = /obj/item/clothing/accessory/poncho/tajarancloak/winter
	tajarancloak["adhomian royalist cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran/royalist
	tajarancloak["adhomian royalist cloak, hoodless"] = /obj/item/clothing/accessory/poncho/tajarancloak/royalist
	tajarancloak["adhomian maroon cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran/maroon
	tajarancloak["adhomian maroon cloak, hoodless"] = /obj/item/clothing/accessory/poncho/tajarancloak/maroon
	tajarancloak["black fancy adhomian cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran/fancy
	tajarancloak["black fancy adhomian cloak, hoodless"] = /obj/item/clothing/accessory/poncho/tajarancloak/fancyblack
	gear_tweaks += new /datum/gear_tweak/path(tajarancloak)

/datum/gear/suit/tajara_priest
	display_name = "tajaran religious suits selection"
	description = "A selection of tajaran religious robes."
	path = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/tajara_priest/New()
	..()
	var/list/robes = list()
	robes["sun priest robe"] = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	robes["sun sister robe"] = /obj/item/clothing/suit/storage/tajaran/messa
	robes["matake priest mantle"] = /obj/item/clothing/suit/storage/tajaran/matake
	robes["azubarre priest robes"] = /obj/item/clothing/suit/storage/tajaran/azubarre
	gear_tweaks += new /datum/gear_tweak/path(robes)

/datum/gear/suit/tajaran_labcoat
	display_name = "PRA medical coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Chemist", "First Responder", "Medical Intern")
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajaran_surgeon
	display_name = "adhomian surgeon garb"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/surgery
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Xenobiologist", "Roboticist", "Medical Intern")
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara
	display_name = "tajaran uniform selection"
	description = "A selection of tajaran native uniforms."
	path = /obj/item/clothing/under/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara/New()
	..()
	var/list/uniform = list()
	uniform["laborer clothes"] = /obj/item/clothing/under/tajaran
	uniform["fancy uniform"] = /obj/item/clothing/under/tajaran/fancy
	uniform["nanotrasen overalls"] = /obj/item/clothing/under/tajaran/nt
	uniform["matake priest garments"] = /obj/item/clothing/under/tajaran/matake
	uniform["adhomian summerwear"] = /obj/item/clothing/under/tajaran/summer
	uniform["adhomian summer pants"] = /obj/item/clothing/under/pants/tajaran
	uniform["machinist uniform"] = /obj/item/clothing/under/tajaran/mechanic
	uniform["raakti shariim uniform"] = /obj/item/clothing/under/tajaran/raakti_shariim
	uniform["a'lmariist laborer clothes"] = /obj/item/clothing/under/tajaran/dpra
	uniform["a'lmariist laborer clothes, alternate"] = /obj/item/clothing/under/tajaran/dpra/alt
	uniform["fancy royalist jacket"] = /obj/item/clothing/suit/storage/tajaran/fancy
	gear_tweaks += new /datum/gear_tweak/path(uniform)

/datum/gear/uniform/nka_colorable_uniform
	display_name = "new kingdom noble clothes"
	description = "A colorable set of clothes used by the New Kingdom's Tajara."
	path = /obj/item/clothing/under/tajaran/nka_noble
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/nka_colorable_accessory
	display_name = "new kingdom noble accessories clothes"
	description = "A colorable set of accessories used by the New Kingdom's Tajara."
	path = /obj/item/clothing/accessory/tajaran/nka_waistcoat
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/nka_colorable_accessory/New()
	..()
	var/list/accessory = list()
	accessory["noble adhomian waistcoat"] = /obj/item/clothing/accessory/tajaran/nka_waistcoat
	accessory["noble adhomian vest"] = /obj/item/clothing/accessory/tajaran/nka_vest
	gear_tweaks += new /datum/gear_tweak/path(accessory)

/datum/gear/uniform/tajara_dress
	display_name = "tajaran dress selection"
	description = "A selection of tajaran native dresses."
	path = /obj/item/clothing/under/dress/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara_dress/New()
	..()
	var/list/dress = list()
	dress["white fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran
	dress["blue fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/blue
	dress["green fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/green
	dress["red fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/red
	dress["red noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy
	dress["black noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy/black
	dress["black noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy/black
	dress["adhomian summer dress"] = /obj/item/clothing/under/dress/tajaran/summer
	gear_tweaks += new /datum/gear_tweak/path(dress)

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
	gear_tweaks += new /datum/gear_tweak/path(flats)

/datum/gear/accessory/tajara
	display_name = "fur scarf"
	description = "A selection of tajaran colored fur scarfs."
	path = /obj/item/clothing/accessory/tajaran
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajara/New()
	..()
	var/list/scarf = list()
	scarf["brown fur scarf"] = /obj/item/clothing/accessory/tajaran
	scarf["light brown fur scarf"] = /obj/item/clothing/accessory/tajaran/lbrown
	scarf["cinnamon fur scarf"] = /obj/item/clothing/accessory/tajaran/cinnamon
	scarf["blue fur scarf"] = /obj/item/clothing/accessory/tajaran/blue
	scarf["silver fur scarf"] = /obj/item/clothing/accessory/tajaran/silver
	scarf["black fur scarf"] = /obj/item/clothing/accessory/tajaran/black
	scarf["ruddy fur scarf"] = /obj/item/clothing/accessory/tajaran/ruddy
	scarf["orange fur scarf"] = /obj/item/clothing/accessory/tajaran/orange
	scarf["cream fur scarf"] = /obj/item/clothing/accessory/tajaran/cream
	gear_tweaks += new /datum/gear_tweak/path(scarf)

/datum/gear/head/tajara
	display_name = "adhomian headgear selection"
	description = "A selection of tajaran native headgear."
	path = /obj/item/clothing/head/tajaran/circlet
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/head/tajara/New()
	..()
	var/list/circlet = list()
	circlet["golden dress circlet"] = /obj/item/clothing/head/tajaran/circlet
	circlet["silver dress circlet"] = /obj/item/clothing/head/tajaran/circlet/silver
	circlet["fur hat"] = /obj/item/clothing/head/tajaran/fur
	circlet["matake priest hat"] = /obj/item/clothing/head/tajaran/matake
	circlet["raakti shariim beret"] = /obj/item/clothing/head/beret/tajaran/raakti_shariim
	circlet["hadiist army beret"] = /obj/item/clothing/head/beret/tajaran/pra
	circlet["liberation army beret"] = /obj/item/clothing/head/beret/tajaran/dpra
	circlet["liberation army beret, alternative"] = /obj/item/clothing/head/beret/tajaran/dpra/alt
	circlet["new kingdom naval beret"] = /obj/item/clothing/head/beret/tajaran/nka
	circlet["new kingdom naval officer beret"] = /obj/item/clothing/head/beret/tajaran/nka/officer
	gear_tweaks += new /datum/gear_tweak/path(circlet)

/datum/gear/accessory/tajara_wrap
	display_name = "marriage wrap"
	description = "A holy cloth wrap that signifies marriage amongst tajara."
	path = /obj/item/clothing/accessory/tajaran_wrap
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajara_wrap/New()
	..()
	var/list/wrap = list()
	wrap["marriage wrap, male"] = /obj/item/clothing/accessory/tajaran_wrap
	wrap["marriage wrap, female"] = /obj/item/clothing/accessory/tajaran_wrap/female
	gear_tweaks += new /datum/gear_tweak/path(wrap)

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

/datum/gear/shoes/tajara/shoes
	display_name = "tajaran foot-wear"
	path = /obj/item/clothing/shoes/tajara/footwraps
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/datum/gear/shoes/tajara/shoes/New()
	..()
	var/list/shoes = list()
	shoes["native tajaran foot-wear"] = /obj/item/clothing/shoes/tajara/footwraps
	shoes["fancy adhomian shoes"] = /obj/item/clothing/shoes/tajara/fancy
	gear_tweaks += new /datum/gear_tweak/path(shoes)

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
	cost = 2
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajaran_card
	display_name = "tajaran faction cards, badges and pins selection"
	description = "A selection of Tajaran related cards, badges and pins."
	path = /obj/item/clothing/accessory/badge/hadii_card
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajaran_card/New()
	..()
	var/list/card = list()
	card["honorary party member card"] = /obj/item/clothing/accessory/badge/hadii_card
	card["a'lmariist pin"] = /obj/item/clothing/accessory/dpra_badge
	card["royalist badge"] = /obj/item/clothing/accessory/nka_badge
	card["free tajaran council badge"] = /obj/item/clothing/accessory/tajaran/council_badge
	gear_tweaks += new /datum/gear_tweak/path(card)

/datum/gear/accessory/tajaranbooks
	display_name = "tajaran political books"
	description = "Tajaran books on the Adhomian ideologies."
	path = /obj/item/book/manual/pra_manifesto
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajaranbooks/New()
	..()
	var/list/card = list()
	card["hadiist manifesto"] = /obj/item/book/manual/pra_manifesto
	card["in defense of al'mari's legacy"] = /obj/item/book/manual/dpra_manifesto
	card["the new kingdom"] = /obj/item/book/manual/nka_manifesto
	gear_tweaks += new /datum/gear_tweak/path(card)

/datum/gear/tajaran_passports
	display_name = "adhomian passports selection"
	description = "A selection of Adhomian passports."
	path = /obj/item/clothing/accessory/badge/pra_passport
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION
	cost = 0

/datum/gear/tajaran_passports/New()
	..()
	var/list/passports = list()
	passports["people's republic of adhomai passport"] = /obj/item/clothing/accessory/badge/pra_passport
	passports["democratic people's republic of adhomai passport"] = /obj/item/clothing/accessory/badge/dpra_passport
	passports["new kingdom of adhomai passport"] = /obj/item/clothing/accessory/badge/nka_passport
	gear_tweaks += new /datum/gear_tweak/path(passports)

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

/datum/gear/utility/himeo_kit/tajara
	display_name = "tajaran himean voidsuit kit"
	description = "A simple cardboard box containing the requisition forms, permits, and decal kits for a Himean voidsuit fitted for Tajara. Only \
	Tajara connected to Himeo and the Free Tajaran Council would have this."
	path = /obj/item/voidsuit_modkit/himeo/tajara
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	allowed_roles = list("Shaft Miner", "Operations Manager", "Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")
	origin_restriction = list(/decl/origin_item/origin/free_council)

/datum/gear/tajaran_tarot
	display_name = "adhomian divination cards deck"
	path = /obj/item/deck/tarot/adhomai
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajara_charm
	display_name = "charms and talismans"
	description = "Charms and talismans often thought of to bring good luck, or of religious significance."
	path = /obj/item/clothing/accessory/tajaran/charm
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear - Tajara"
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_NAME_SELECTION

/datum/gear/accessory/tajara_charm/New()
	..()
	var/list/charm = list()
	charm["wooden charm"] = /obj/item/clothing/accessory/tajaran/charm
	charm["stone charm"] = /obj/item/clothing/accessory/tajaran/charm/stone
	charm["steel charm"] = /obj/item/clothing/accessory/tajaran/charm/steel
	charm["silver charm"] = /obj/item/clothing/accessory/tajaran/charm/steel/silver
	charm["bone charm"] = /obj/item/clothing/accessory/tajaran/charm/bone
	charm["silver seashell charm"] = /obj/item/clothing/accessory/tajaran/charm/steel/silver/seashell
	charm["tajani charm"] = /obj/item/clothing/accessory/tajaran/charm/tajani
	charm["holy sun rosette"] = /obj/item/clothing/accessory/tajaran/srendarr
	gear_tweaks += new /datum/gear_tweak/path(charm)

/datum/gear/accessory/dpra_party_pin
	display_name = "democratic peoples republic party pins selection"
	description = "A selection of DPRA party pins."
	path = /obj/item/clothing/accessory/tajaran/nawparty_pin
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/dpra_party_pin/New()
	..()
	var/list/card = list()
	card["national adhomai workers party pin"] = /obj/item/clothing/accessory/tajaran/nawparty_pin
	card["free tajaran people party pin"] = /obj/item/clothing/accessory/tajaran/ftpparty_pin
	card["followers of Nated party pin"] = /obj/item/clothing/accessory/tajaran/fonparty_pin
	card["adhomian blue party pin"] = /obj/item/clothing/accessory/tajaran/abparty_pin
	card["amohdan free lodge party pin"] = /obj/item/clothing/accessory/tajaran/aflparty_pin
	gear_tweaks += new /datum/gear_tweak/path(card)

/datum/gear/accessory/tajaran_gen_accessorry
	display_name = "tajaran accessories selection"
	description = "A selection of tajaran related accessories."
	path = /obj/item/clothing/accessory/tajaran/zbrojny_badge
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajaran_gen_accessorry/New()
	..()
	var/list/card = list()
	card["zbrojny badge"] = /obj/item/clothing/accessory/tajaran/zbrojny_badge
	card["golden sun pin"] = /obj/item/clothing/accessory/tajaran/tanker_pin
	gear_tweaks += new /datum/gear_tweak/path(card)

/datum/gear/accessory/tajaran_portraits
	display_name = "tajaran leader portrait selection"
	description = "A selection of tajaran leaders portraits."
	path = /obj/item/sign/painting_frame/hadii
	sort_category = "Xenowear - Tajara"
	whitelisted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/tajaran_portraits/New()
	..()
	var/list/portrait = list()
	portrait["president hadii portrait"] = /obj/item/sign/painting_frame/hadii
	portrait["president almari portrait"] = /obj/item/sign/painting_frame/almari
	portrait["supreme commander nated portrait"] = /obj/item/sign/painting_frame/nated
	portrait["president harrlala portrait"] = /obj/item/sign/painting_frame/harrlala
	portrait["king vahzirthaamro portrait"] = /obj/item/sign/painting_frame/vahzirthaamro
	portrait["queen shumaila portrait"] = /obj/item/sign/painting_frame/shumaila
	gear_tweaks += new /datum/gear_tweak/path(portrait)
