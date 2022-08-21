// Uniform slot
/datum/gear/uniform
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/iacjumpsuit
	display_name = "IAC Jumpsuit"
	path = /obj/item/clothing/under/rank/iacjumpsuit
	allowed_roles = list("Chief Medical Officer", "Physician", "Pharmacist", "First Responder", "Medical Intern")

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuits"
	description = "A selection of generic colored jumpsuits."
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpsuit = list()
	jumpsuit["black jumpsuit"] = /obj/item/clothing/under/color/black
	jumpsuit["grey jumpsuit"] = /obj/item/clothing/under/color/grey
	jumpsuit["white jumpsuit"] = /obj/item/clothing/under/color/white
	jumpsuit["dark red jumpsuit"] = /obj/item/clothing/under/color/darkred
	jumpsuit["red jumpsuit"] = /obj/item/clothing/under/color/red
	jumpsuit["light red jumpsuit"] = /obj/item/clothing/under/color/lightred
	jumpsuit["light brown jumpsuit"] = /obj/item/clothing/under/color/lightbrown
	jumpsuit["brown jumpsuit"] = /obj/item/clothing/under/color/brown
	jumpsuit["yellow jumpsuit"] = /obj/item/clothing/under/color/yellow
	jumpsuit["yellow green jumpsuit"] = /obj/item/clothing/under/color/yellowgreen
	jumpsuit["light green jumpsuit"] = /obj/item/clothing/under/color/lightgreen
	jumpsuit["green jumpsuit"] = /obj/item/clothing/under/color/green
	jumpsuit["aqua jumpsuit"] = /obj/item/clothing/under/color/aqua
	jumpsuit["light blue jumpsuit"] = /obj/item/clothing/under/color/lightblue
	jumpsuit["blue jumpsuit"] = /obj/item/clothing/under/color/blue
	jumpsuit["dark blue jumpsuit"] = /obj/item/clothing/under/color/darkblue
	jumpsuit["purple jumpsuit"] = /obj/item/clothing/under/color/purple
	jumpsuit["light purple jumpsuit"] = /obj/item/clothing/under/color/lightpurple
	jumpsuit["pink jumpsuit"] = /obj/item/clothing/under/color/pink
	jumpsuit["orange jumpsuit"] = /obj/item/clothing/under/color/orange
	gear_tweaks += new /datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/colorjumpsuit
	display_name = "jumpsuit (recolorable)"
	path = /obj/item/clothing/under/color/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	description = "A selection of skirts."
	path = /obj/item/clothing/under/skirt
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	skirts["casual skirt"] = /obj/item/clothing/under/skirt
	skirts["puffy skirt"] = /obj/item/clothing/under/skirt/puffy
	skirts["long skirt"] = /obj/item/clothing/under/skirt/long
	skirts["pencil skirt"] = /obj/item/clothing/under/skirt/pencil
	skirts["swept skirt"] = /obj/item/clothing/under/skirt/swept
	skirts["plaid skirt"] = /obj/item/clothing/under/skirt/plaid
	skirts["pleated skirt"] = /obj/item/clothing/under/skirt/pleated
	skirts["high skirt"] = /obj/item/clothing/under/skirt/high
	skirts["skater skirt"] = /obj/item/clothing/under/skirt/skater
	skirts["tube skirt"] = /obj/item/clothing/under/skirt/tube
	skirts["jumper skirt"] = /obj/item/clothing/under/skirt/jumper
	skirts["jumper dress"] = /obj/item/clothing/under/skirt/jumper_highcut
	skirts["long straight skirt"] = /obj/item/clothing/under/skirt/straightlong
	gear_tweaks += new /datum/gear_tweak/path(skirts)

/datum/gear/uniform/suit
	display_name = "suit selection"
	description = "A selection of formal suits."
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/New()
	..()
	var/list/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purple
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/suit_jacket/white
	suits["nt skirtsuit"] = /obj/item/clothing/under/suit_jacket/nt_skirtsuit
	gear_tweaks += new /datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "scrubs selection"
	path = /obj/item/clothing/under/rank/medical/surgeon/zavod
	allowed_roles = list("Scientist","Chief Medical Officer", "Physician", "Pharmacist", "First Responder", "Medical Intern", "Xenobiologist", "Research Director", "Investigator")

/datum/gear/uniform/scrubs/New()
	..()
	var/list/scrubs = list()
	scrubs["scrubs, nanotrasen navy blue"] = /obj/item/clothing/under/rank/medical/surgeon
	scrubs["scrubs, zeng-hu purple"] = /obj/item/clothing/under/rank/medical/surgeon/zeng
	scrubs["scrubs, PMCG blue"] = /obj/item/clothing/under/rank/medical/surgeon/pmc
	scrubs["scrubs, zavodskoi black"] = /obj/item/clothing/under/rank/medical/surgeon/zavod
	scrubs["scrubs, idris green"] = /obj/item/clothing/under/rank/medical/surgeon/idris

	gear_tweaks += new /datum/gear_tweak/path(scrubs)

/datum/gear/uniform/dress
	display_name = "dress selection"
	description = "A selection of dresses."
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/dress/New()
	..()
	var/list/dress = list()
	dress["sundress"] = /obj/item/clothing/under/sundress
	dress["sundress, white"] = /obj/item/clothing/under/sundress_white
	dress["dress, flame"] = /obj/item/clothing/under/dress/dress_fire
	dress["dress, orange"] = /obj/item/clothing/under/dress/dress_orange
	dress["dress, yellow"] = /obj/item/clothing/under/dress/dress_yellow
	dress["dress, white"] = /obj/item/clothing/under/dress/white
	dress["dress, stripped"] = /obj/item/clothing/under/dress/stripeddress
	dress["dress, sailor"] = /obj/item/clothing/under/dress/sailordress
	dress["dress, red swept"] = /obj/item/clothing/under/dress/red_swept_dress
	dress["dress, black tango"] = /obj/item/clothing/under/dress/blacktango
	dress["dress, black tango alternative"] = /obj/item/clothing/under/dress/blacktango/alt
	dress["cheongsam, white"] = /obj/item/clothing/under/cheongsam
	dress["cheongsam, red"] = /obj/item/clothing/under/cheongsam/red
	dress["cheongsam, blue"] = /obj/item/clothing/under/cheongsam/blue
	dress["cheongsam, green"] = /obj/item/clothing/under/cheongsam/green
	dress["cheongsam, purple"] = /obj/item/clothing/under/cheongsam/purple
	gear_tweaks += new /datum/gear_tweak/path(dress)

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")

/datum/gear/uniform/pants
	display_name = "pants selection"
	description = "A selection of pants."
	path = /obj/item/clothing/under/pants

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	pants["jeans"] = /obj/item/clothing/under/pants
	pants["classic jeans"] = /obj/item/clothing/under/pants/classic
	pants["must hang jeans"] = /obj/item/clothing/under/pants/musthang
	pants["black jeans"] = /obj/item/clothing/under/pants/jeansblack
	pants["young folks jeans"] = /obj/item/clothing/under/pants/youngfolksjeans
	pants["white pants"] = /obj/item/clothing/under/pants/white
	pants["black pants"] = /obj/item/clothing/under/pants/black
	pants["red pants"] = /obj/item/clothing/under/pants/red
	pants["tan pants"] = /obj/item/clothing/under/pants/tan
	pants["khaki pants"] = /obj/item/clothing/under/pants/khaki
	pants["track pants"] = /obj/item/clothing/under/pants/track
	pants["blue track pants"] = /obj/item/clothing/under/pants/track/blue
	pants["green track pants"] = /obj/item/clothing/under/pants/track/green
	pants["white track pants"] = /obj/item/clothing/under/pants/track/white
	pants["red track pants"] = /obj/item/clothing/under/pants/track/red
	pants["camo pants"] = /obj/item/clothing/under/pants/camo
	pants["tacticool pants"] = /obj/item/clothing/under/pants/tacticool
	pants["designer jeans"] = /obj/item/clothing/under/pants/designer
	pants["ripped jeans"] = /obj/item/clothing/under/pants/ripped
	pants["black ripped jeans"] = /obj/item/clothing/under/pants/blackripped
	pants["athletic shorts, black"] = /obj/item/clothing/under/shorts
	pants["athletic shorts, red"] = /obj/item/clothing/under/shorts/red
	pants["athletic shorts, green"] = /obj/item/clothing/under/shorts/green
	pants["athletic shorts, black"] = /obj/item/clothing/under/shorts/black
	pants["athletic shorts, grey"] = /obj/item/clothing/under/shorts/grey
	pants["Stellar Corporate Conglomerate shorts"] = /obj/item/clothing/under/shorts/scc
	pants["jean shorts"] = /obj/item/clothing/under/shorts/jeans
	pants["jean short shorts"] = /obj/item/clothing/under/shorts/jeans/female
	pants["classic jeans shorts"] = /obj/item/clothing/under/shorts/jeans/classic
	pants["classic jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/classic/female
	pants["mustang jeans shorts"] = /obj/item/clothing/under/shorts/jeans/mustang
	pants["mustang jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/mustang/female
	pants["young folks jeans shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks
	pants["young folks jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks/female
	pants["black jeans shorts"] = /obj/item/clothing/under/shorts/jeans/black
	pants["black jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/black/female
	pants["grey jeans shorts"] = /obj/item/clothing/under/shorts/jeans/grey
	pants["grey jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/grey/female
	pants["khaki shorts"] = /obj/item/clothing/under/shorts/khaki
	pants["khaki shorts shorts"] = /obj/item/clothing/under/shorts/khaki/female
	gear_tweaks += new /datum/gear_tweak/path(pants)

/datum/gear/uniform/colorpants
	display_name = "pants selection (recolorable)"
	description = "A selection of recolourable pants."
	path = /obj/item/clothing/under/pants/dress
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/colorpants/New()
	..()
	var/list/colorpants = list()
	colorpants["dress pants"] = /obj/item/clothing/under/pants/dress
	colorpants["dress pants, with belt"] = /obj/item/clothing/under/pants/dress/belt
	colorpants["striped pants"] = /obj/item/clothing/under/pants/striped
	colorpants["tailored jeans"] = /obj/item/clothing/under/pants/tailoredjeans
	colorpants["mustang jeans"] = /obj/item/clothing/under/pants/musthangcolour
	colorpants["shorts"] = /obj/item/clothing/under/shorts/color
	colorpants["flared pants"] = /obj/item/clothing/under/pants/flared
	gear_tweaks += new /datum/gear_tweak/path(colorpants)

/datum/gear/uniform/turtleneck
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/dominia
	display_name = "dominian clothing selection"
	description = "A selection of Dominian clothing."
	path = /obj/item/clothing/under/dominia
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dominia, /decl/origin_item/culture/dominian_unathi)

/datum/gear/uniform/dominia/New()
	..()
	var/list/suit = list()
	suit["dominia suit, red"] = /obj/item/clothing/under/dominia
	suit["dominia suit, black"] = /obj/item/clothing/under/dominia/black
	suit["lyodsuit"] = /obj/item/clothing/under/dominia/lyodsuit
	suit["hoodied lyodsuit"] = /obj/item/clothing/under/dominia/lyodsuit/hoodie
	suit["dominia noblewoman dress"] = /obj/item/clothing/under/dominia/dress
	suit["dominia summer dress"] = /obj/item/clothing/under/dominia/dress/summer
	gear_tweaks += new /datum/gear_tweak/path(suit)

/datum/gear/uniform/dominia_dress
	display_name = "dominian dress selection"
	description = "A selection of fancy Dominian dresses."
	path = /obj/item/clothing/under/dominia/dress
	culture_restriction = list(/decl/origin_item/culture/dominia, /decl/origin_item/culture/dominian_unathi)

/datum/gear/uniform/dominia_dress/New()
	..()
	var/list/suit = list()
	for(var/dress in typesof(/obj/item/clothing/under/dominia/dress/fancy))
		var/obj/item/clothing/under/dominia/dress/D = new dress //I'm not typing all this shit manually. Jesus christ.
		suit["[D.name]"] = D.type
	gear_tweaks += new /datum/gear_tweak/path(suit)

/datum/gear/uniform/dominia_consular
	display_name = "dominian consular clothing selection"
	description = "A selection of Dominian clothing belonging to the Diplomatic Service."
	path = /obj/item/clothing/under/dominia/consular
	allowed_roles = list("Consular Officer")
	culture_restriction = list(/decl/origin_item/culture/dominia, /decl/origin_item/culture/dominian_unathi, /decl/origin_item/culture/diona_dominia)

/datum/gear/uniform/dominia_consular/New()
	..()
	var/list/consular = list()
	consular["dominian consular officer's uniform, masculine"] = /obj/item/clothing/under/dominia/consular
	consular["dominian consular officer's uniform, feminine"] = /obj/item/clothing/under/dominia/consular/dress
	gear_tweaks += new /datum/gear_tweak/path(consular)

/datum/gear/uniform/fisanduhian_sweater
	display_name = "fisanduhian sweater"
	path = /obj/item/clothing/under/dominia/sweater
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dominia, /decl/origin_item/culture/dominian_unathi)

/datum/gear/uniform/elyra_holo
	display_name = "elyran holographic suit selection"
	description = "A marvel of Elyran technology, uses hardlight fabric and masks to transform a skin-tight, cozy suit into cultural apparel of your choosing. Has a dial for Midenean, Aemaqii and Persepolis clothes respectively."
	path = /obj/item/clothing/under/elyra_holo
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/elyra_holo/New()
	..()
	var/list/suit = list()
	suit["elyran holographic suit, feminine"] = /obj/item/clothing/under/elyra_holo
	suit["elyran holographic suit, masculine"] = /obj/item/clothing/under/elyra_holo/masc
	gear_tweaks += new /datum/gear_tweak/path(suit)

/datum/gear/uniform/miscellaneous/kimono
	display_name = "kimono"
	path = /obj/item/clothing/under/kimono
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/circuitry
	display_name = "jumpsuit, circuitry (empty)"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/pyjama
	display_name = "pyjamas"
	path = /obj/item/clothing/under/pj/blue

/datum/gear/uniform/pyjama/New()
	..()
	var/list/pyjamas = list()
	pyjamas["blue pyjamas"] = /obj/item/clothing/under/pj/blue
	pyjamas["red pyjamas"] = /obj/item/clothing/under/pj/red
	gear_tweaks += new /datum/gear_tweak/path(pyjamas)

/datum/gear/uniform/miscellaneous/hanbok
	display_name = "hanbok selection"
	description = "A selection of Konyanger formalwear."
	path = /obj/item/clothing/under/konyang

/datum/gear/uniform/miscellaneous/hanbok/New()
	..()
	var/list/hanbok = list()
	hanbok["magenta-blue hanbok"] = /obj/item/clothing/under/konyang
	hanbok["white-pink hanbok"] = /obj/item/clothing/under/konyang/pink
	hanbok["white-blue hanbok"] = /obj/item/clothing/under/konyang/blue
	hanbok["male hanbok"] = /obj/item/clothing/under/konyang/male
	gear_tweaks += new /datum/gear_tweak/path(hanbok)

/datum/gear/uniform/miscellaneous/hanbokcolorable
	display_name = "colorable hanbok selection"
	description = "A selection of Konyanger formalwear."
	path = /obj/item/clothing/under/konyang/male/shortsleeve
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/miscellaneous/hanbokcolorable/New()
	..()
	var/list/hanbokcolorable = list()
	hanbokcolorable["short sleeve hanbok"] = /obj/item/clothing/under/konyang/male/shortsleeve
	hanbokcolorable["sleeveless hanbok"] = /obj/item/clothing/under/konyang/male/sleeveless
	gear_tweaks += new /datum/gear_tweak/path(hanbokcolorable)

/datum/gear/uniform/konyang
	display_name = "konyanger dress"
	path = /obj/item/clothing/under/konyangdress
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/konyangtraditional
	display_name = "traditional konyanger dress selection"
	description = "A selection of traditional Konyanger formal and religious wear."
	path = /obj/item/clothing/under/konyangdresstraditional
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/konyangtraditional/New()
	..()
	var/list/konyangtraditional = list()
	konyangtraditional["pink traditional konyanger dress"] = /obj/item/clothing/under/konyangdresstraditional
	konyangtraditional["green traditional konyanger dress"] = /obj/item/clothing/under/konyangdresstraditional/green
	konyangtraditional["blue traditional konyanger dress"] = /obj/item/clothing/under/konyangdresstraditional/blue
	konyangtraditional["national-colored traditional konyanger dress"] = /obj/item/clothing/under/konyangdresstraditional/national
	konyangtraditional["national-colored traditional konyanger dress with vest"] = /obj/item/clothing/under/konyangdresstraditional/national/vest
	gear_tweaks += new /datum/gear_tweak/path(konyangtraditional)

/datum/gear/uniform/zhongshan
	display_name = "zhongshan suit"
	path = /obj/item/clothing/under/zhongshan
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/gadpathur
	display_name = "gadpathurian fatigues"
	path = /obj/item/clothing/under/uniform/gadpathur
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/decl/origin_item/origin/gadpathur)

/datum/gear/uniform/miscellaneous/qipao
	display_name = "qipao"
	path = /obj/item/clothing/under/qipao
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/miscellaneous/qipao/New()
	..()
	var/list/qipao = list()
	qipao["qipao"] = /obj/item/clothing/under/qipao
	qipao["slim qipao"] = /obj/item/clothing/under/qipao2
	gear_tweaks += new /datum/gear_tweak/path(qipao)
