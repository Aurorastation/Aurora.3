// Uniform slot
/datum/gear/uniform
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/bathrobe
	display_name = "bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/croptop
    display_name = "crop top (selection)"
    path = /obj/item/clothing/under/croptop

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(croptops))

/datum/gear/uniform/cuttop
	display_name = "cut top (selection)"
	description = "A selection of cut top shirts."
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/New()
	..()
	var/list/cuttops = list()
	for(var/cuttop in typesof(/obj/item/clothing/under/cuttop))
		var/obj/item/clothing/under/cuttop/cuttop_type = cuttop
		cuttops[initial(cuttop_type.name)] = cuttop_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cuttops))

/datum/gear/uniform/cropdress
    display_name = "crop dress"
    path = /obj/item/clothing/under/cropdress

/datum/gear/uniform/iacjumpsuit
	display_name = "IAC Jumpsuit"
	path = /obj/item/clothing/under/rank/iacjumpsuit
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Resident")

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuit (selection)"
	description = "A selection of generic colored jumpsuits."
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/jumpsuit = list()
	jumpsuit["grey jumpsuit"] = /obj/item/clothing/under/color/grey
	jumpsuit["black jumpsuit"] = /obj/item/clothing/under/color/black
	jumpsuit["blue jumpsuit"] = /obj/item/clothing/under/color/blue
	jumpsuit["green jumpsuit"] = /obj/item/clothing/under/color/green
	jumpsuit["orange jumpsuit"] = /obj/item/clothing/under/color/orange_nonprisoner
	jumpsuit["prisoner jumpsuit"] = /obj/item/clothing/under/color/orange
	jumpsuit["pink jumpsuit"] = /obj/item/clothing/under/color/pink
	jumpsuit["red jumpsuit"] = /obj/item/clothing/under/color/red
	jumpsuit["white jumpsuit"] = /obj/item/clothing/under/color/white
	jumpsuit["yellow jumpsuit"] = /obj/item/clothing/under/color/yellow
	jumpsuit["light blue jumpsuit"] = /obj/item/clothing/under/lightblue
	jumpsuit["aqua jumpsuit"] = /obj/item/clothing/under/aqua
	jumpsuit["purple jumpsuit"] = /obj/item/clothing/under/purple
	jumpsuit["light purple jumpsuit"] = /obj/item/clothing/under/lightpurple
	jumpsuit["light green jumpsuit"] = /obj/item/clothing/under/lightgreen
	jumpsuit["brown jumpsuit"] = /obj/item/clothing/under/brown
	jumpsuit["light brown jumpsuit"] = /obj/item/clothing/under/lightbrown
	jumpsuit["yellow green jumpsuit"] = /obj/item/clothing/under/yellowgreen
	jumpsuit["light red jumpsuit"] = /obj/item/clothing/under/lightred
	jumpsuit["dark red jumpsuit"] = /obj/item/clothing/under/darkred
	jumpsuit["rainbow jumpsuit"] = /obj/item/clothing/under/rainbow
	gear_tweaks += new/datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/skirt
	display_name = "skirt (selection, colourable)"
	description = "A selection of skirts."
	path = /obj/item/clothing/under/skirt
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt/New()
	..()
	var/skirts = list()
	skirts["casual skirt"] = /obj/item/clothing/under/skirt
	skirts["puffy skirt"] = /obj/item/clothing/under/skirt/puffy
	skirts["long skirt"] = /obj/item/clothing/under/skirt/long
	skirts["pencil skirt"] = /obj/item/clothing/under/skirt/pencil
	skirts["swept skirt"] = /obj/item/clothing/under/skirt/swept
	skirts["plaid skirt"] = /obj/item/clothing/under/skirt/plaid
	skirts["pleated skirt"] = /obj/item/clothing/under/skirt/pleated
	skirts["pleated skirt, alt"] = /obj/item/clothing/under/skirt/pleated/alt
	gear_tweaks += new/datum/gear_tweak/path(skirts)

/datum/gear/uniform/skirt/misc
	display_name = "skirt, misc (selection)"
	description = "A selection of non-colourable skirts."
	path = /obj/item/clothing/under/skirt/denim

/datum/gear/uniform/skirt/misc/New()
	..()
	var/misc_skirts = list()
	misc_skirts["denim skirt"] = /obj/item/clothing/under/skirt/denim
	misc_skirts["plaid skirt outfit, blue"] = /obj/item/clothing/under/skirt/outfit/plaid_blue
	misc_skirts["plaid skirt outfit, purple"] =/obj/item/clothing/under/skirt/outfit/plaid_purple
	misc_skirts["plaid skirt outfit, red"] = /obj/item/clothing/under/skirt/outfit/plaid_red
	gear_tweaks += new/datum/gear_tweak/path(misc_skirts)

/datum/gear/uniform/suit
	display_name = "suit (selection)"
	description = "A selection of formal suits."
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["black suit with skirt"] = /obj/item/clothing/under/skirt/outfit
	suits["blue suit"] = /obj/item/clothing/under/lawyer/blue
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["executive skirt"] = /obj/item/clothing/under/suit_jacket/really_black/skirt
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["old man suit"] = /obj/item/clothing/under/oldman
	suits["old woman attire"] = /obj/item/clothing/under/oldwoman
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purple
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["shiny black suit"] = /obj/item/clothing/under/lawyer/black
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/suit_jacket/white
	gear_tweaks += new/datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "scrubs (selection)"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Scientist","Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Geneticist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/uniform/scrubs/New()
	..()
	var/scrubs = list()
	scrubs["scrubs, black"] = /obj/item/clothing/under/rank/medical/black
	scrubs["scrubs, blue"] = /obj/item/clothing/under/rank/medical/blue
	scrubs["scrubs, green"] = /obj/item/clothing/under/rank/medical/green
	scrubs["scrubs, purple"] = /obj/item/clothing/under/rank/medical/purple
	gear_tweaks += new/datum/gear_tweak/path(scrubs)

/datum/gear/uniform/dress
	display_name = "dress (selection)"
	description = "A selection of dresses."
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/dress/New()
	..()
	var/dress = list()
	dress["sundress"] = /obj/item/clothing/under/sundress
	dress["sundress, white"] = /obj/item/clothing/under/sundress_white
	dress["dress, flame"] = /obj/item/clothing/under/dress/dress_fire
	dress["dress, green"] = /obj/item/clothing/under/dress/dress_green
	dress["dress, orange"] = /obj/item/clothing/under/dress/dress_orange
	dress["dress, purple"] = /obj/item/clothing/under/dress/dress_purple
	dress["dress, pink"] = /obj/item/clothing/under/dress/dress_pink
	dress["dress, yellow"] = /obj/item/clothing/under/dress/dress_yellow
	dress["dress, white"] = /obj/item/clothing/under/dress/white
	dress["dress, stripped"] = /obj/item/clothing/under/dress/stripeddress
	dress["dress, sailor"] = /obj/item/clothing/under/dress/sailordress
	dress["dress, red swept"] = /obj/item/clothing/under/dress/red_swept_dress
	dress["dress, black tango"] = /obj/item/clothing/under/dress/blacktango
	dress["dress, black tango alternative"] = /obj/item/clothing/under/dress/blacktango/alt
	dress["dress, blue"] = /obj/item/clothing/under/dress/bluedress
	dress["dress, dark red"] = /obj/item/clothing/under/dress/darkreddress
	dress["dress, festive"] = /obj/item/clothing/under/dress/festivedress
	dress["dress, black and white"] = /obj/item/clothing/under/dress/blackwhite_short
	dress["dress, flamenco"] = /obj/item/clothing/under/dress/flamenco
	dress["dress, saloon"] = /obj/item/clothing/under/dress/saloon_dress
	dress["dress, western bustle"] = /obj/item/clothing/under/dress/westernbustle
	dress["dress, barmaid"] = /obj/item/clothing/under/dress/barmaid
	dress["dress, flower dress"] = /obj/item/clothing/under/dress/flower_dress
	dress["dress, lilac"] = /obj/item/clothing/under/dress/lilacdress
	dress["dress, little black"] = /obj/item/clothing/under/dress/littleblackdress
	dress["dress, nanny"] = /obj/item/clothing/under/dress/maid/janitor
	dress["dress, nanny and tie"] = /obj/item/clothing/under/dress/maid
	dress["dress, polka"] = /obj/item/clothing/under/dress/polka
	dress["dress, twist front"] = /obj/item/clothing/under/dress/twistfront
	dress["dress, v-neck"] = /obj/item/clothing/under/dress/vneck
	dress["corset, black"] = /obj/item/clothing/under/dress/black_corset
	dress["gown, white"] = /obj/item/clothing/under/dress/ballgown
	dress["gown, red"] = /obj/item/clothing/under/dress/ballgown/red
	dress["gown, red evening"] = /obj/item/clothing/under/dress/redeveninggown
	dress["gown, orange"] = /obj/item/clothing/under/dress/ballgown/orange
	dress["gown, purple"] = /obj/item/clothing/under/dress/ballgown/purple
	dress["gown, blue"] = /obj/item/clothing/under/dress/ballgown/blue
	gear_tweaks += new/datum/gear_tweak/path(dress)

/datum/gear/uniform/dress_colour
	display_name = "dress, misc (selection, colourable)"
	description = "A selection of colourable dresses."
	path = /obj/item/clothing/under/dress/white2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/dress_colour/New()
	..()
	var/whitedresses = list()
	whitedresses["short dress"] = /obj/item/clothing/under/dress/white3
	whitedresses["long dress"] = /obj/item/clothing/under/dress/white2
	whitedresses["long flared dress"] = /obj/item/clothing/under/dress/white4
	gear_tweaks += new/datum/gear_tweak/path(whitedresses)

/datum/gear/uniform/cheongsam
	display_name = "cheongsam (selection)"
	description = "A selection of cheongsam."
	path = /obj/item/clothing/under/cheongsam

/datum/gear/uniform/cheongsam/New()
	..()
	var/cheongsam = list()
	cheongsam["white cheongsam"] = /obj/item/clothing/under/cheongsam
	cheongsam["black cheongsam"] = /obj/item/clothing/under/cheongsam/black
	cheongsam["red cheongsam"] = /obj/item/clothing/under/cheongsam/red
	cheongsam["bright red cheongsam"] = /obj/item/clothing/under/cheongsam/brightred
	cheongsam["blue cheongsam"] = /obj/item/clothing/under/cheongsam/blue
	cheongsam["bright blue cheongsam"] = /obj/item/clothing/under/cheongsam/brightblue
	cheongsam["green cheongsam"] = /obj/item/clothing/under/cheongsam/green
	cheongsam["purple cheongsam"] = /obj/item/clothing/under/cheongsam/purple
	gear_tweaks += new/datum/gear_tweak/path(cheongsam)

/datum/gear/uniform/blazer
	display_name = "blue blazer (selection)"
	description = "Choose between trousers or skirt variation."
	path = /obj/item/clothing/under/blazer

/datum/gear/uniform/blazer/New()
	..()
	var/blueblazers = list()
	blueblazers["blue blazer, trousers"] = /obj/item/clothing/under/blazer
	blueblazers["blue blazer, skirt"] =/obj/item/clothing/under/blazer/skirt
	gear_tweaks += new/datum/gear_tweak/path(blueblazers)

/datum/gear/uniform/haltertop
	display_name = "halter top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")
	cost = 0

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")
	cost = 0

/datum/gear/uniform/pants
	display_name = "pants (selection)"
	description = "A selection of pants."
	path = /obj/item/clothing/under/pants

/datum/gear/uniform/pants/New()
	..()
	var/pants = list()
	pants["jeans"] = /obj/item/clothing/under/pants
	pants["jeans, baggy"] = /obj/item/clothing/under/pants/baggy
	pants["jeans, ripped"] = /obj/item/clothing/under/pants/ripped
	pants["jeans, classic"] = /obj/item/clothing/under/pants/classic
	pants["jeans, classic baggy"] = /obj/item/clothing/under/pants/classic/baggy
	pants["jeans, classic ripped"] = /obj/item/clothing/under/pants/classic/ripped
	pants["jeans, must hang"] = /obj/item/clothing/under/pants/musthang
	pants["jeans, must hang baggy"] = /obj/item/clothing/under/pants/musthang/baggy
	pants["jeans, must hang ripped"] = /obj/item/clothing/under/pants/musthang/ripped
	pants["jeans, designer"] = /obj/item/clothing/under/pants/designer
	pants["jeans, black"] = /obj/item/clothing/under/pants/jeansblack
	pants["jeans, black baggy"] = /obj/item/clothing/under/pants/jeansblack/baggy
	pants["jeans, black ripped"] = /obj/item/clothing/under/pants/jeansblack/ripped
	pants["jeans, grey"] = /obj/item/clothing/under/pants/jeansgrey
	pants["jeans, grey baggy"] = /obj/item/clothing/under/pants/jeansgrey/baggy
	pants["jeans, grey ripped"] = /obj/item/clothing/under/pants/jeansgrey/ripped
	pants["jeans, young folks"] = /obj/item/clothing/under/pants/youngfolksjeans
	pants["jeans, young folks baggy"] = /obj/item/clothing/under/pants/youngfolksjeans/baggy
	pants["pants, white"] = /obj/item/clothing/under/pants/white
	pants["pants, white baggy"] = /obj/item/clothing/under/pants/white/baggy
	pants["pants, black"] = /obj/item/clothing/under/pants/black
	pants["pants, black baggy"] = /obj/item/clothing/under/pants/black/baggy
	pants["pants, red"] = /obj/item/clothing/under/pants/red
	pants["pants, red baggy"] = /obj/item/clothing/under/pants/red/baggy
	pants["pants, tan"] = /obj/item/clothing/under/pants/tan
	pants["pants, tan baggy"] = /obj/item/clothing/under/pants/tan/baggy
	pants["pants, khaki"] = /obj/item/clothing/under/pants/khaki
	pants["pants, khaki baggy"] = /obj/item/clothing/under/pants/khaki/baggy
	pants["pants, camo"] = /obj/item/clothing/under/pants/camo
	pants["pants, camo baggy"] = /obj/item/clothing/under/pants/camo/baggy
	pants["pants, tacticool"] = /obj/item/clothing/under/pants/tacticool
	pants["track pants"] = /obj/item/clothing/under/pants/track
	pants["track pants, baggy"] = /obj/item/clothing/under/pants/track/baggy
	pants["track pants, blue"] = /obj/item/clothing/under/pants/track/blue
	pants["track pants, green"] = /obj/item/clothing/under/pants/track/green
	pants["track pants, white"] = /obj/item/clothing/under/pants/track/white
	pants["track pants, red"] = /obj/item/clothing/under/pants/track/red
	pants["utility, orange"] = /obj/item/clothing/under/pants/utility/orange
	pants["utility, blue"] = /obj/item/clothing/under/pants/utility/blue
	pants["utility, green"] = /obj/item/clothing/under/pants/utility
	pants["utility, white"] = /obj/item/clothing/under/pants/utility/white
	pants["utility, red"] = /obj/item/clothing/under/pants/utility/red
	gear_tweaks += new/datum/gear_tweak/path(pants)

/datum/gear/uniform/colorpants
	display_name = "pants (selection, colourable)"
	path = /obj/item/clothing/under/pants/dress
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/colorpants/New()
	..()
	var/colorpants = list()
	colorpants["dress pants"] = /obj/item/clothing/under/pants/dress
	colorpants["dress pants, belt"] = /obj/item/clothing/under/pants/dress/belt
	colorpants["striped pants"] = /obj/item/clothing/under/pants/striped
	colorpants["yoga pants"] = /obj/item/clothing/under/pants/yogapants
	gear_tweaks += new/datum/gear_tweak/path(colorpants)

/datum/gear/uniform/shorts
	display_name = "shorts (selection)"
	description = "A selection of shorts."
	path = /obj/item/clothing/under/shorts

/datum/gear/uniform/shorts/New()
	..()
	var/shorts = list()
	shorts["athletic shorts, black"] = /obj/item/clothing/under/shorts
	shorts["athletic shorts, red"] = /obj/item/clothing/under/shorts/red
	shorts["athletic shorts, green"] = /obj/item/clothing/under/shorts/green
	shorts["athletic shorts, black"] = /obj/item/clothing/under/shorts/black
	shorts["athletic shorts, grey"] = /obj/item/clothing/under/shorts/grey
	shorts["jean shorts"] = /obj/item/clothing/under/shorts/jeans
	shorts["jean short shorts"] = /obj/item/clothing/under/shorts/jeans/female
	shorts["classic jeans shorts"] = /obj/item/clothing/under/shorts/jeans/classic
	shorts["classic jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/classic/female
	shorts["mustang jeans shorts"] = /obj/item/clothing/under/shorts/jeans/mustang
	shorts["mustang jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/mustang/female
	shorts["young folks jeans shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks
	shorts["young folks jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks/female
	shorts["black jeans shorts"] = /obj/item/clothing/under/shorts/jeans/black
	shorts["black jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/black/female
	shorts["grey jeans shorts"] = /obj/item/clothing/under/shorts/jeans/grey
	shorts["grey jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans
	shorts["khaki shorts"] = /obj/item/clothing/under/shorts/khaki
	shorts["khaki shorts shorts"] = /obj/item/clothing/under/shorts/khaki/female
	gear_tweaks += new/datum/gear_tweak/path(shorts)

/datum/gear/uniform/turtleneck
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/dominia
	display_name = "Dominia clothing (selection)"
	description = "A selection of Dominian clothing."
	path = /obj/item/clothing/under/dominia
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/dominia/New()
	..()
	var/suit = list()
	suit["Dominia suit, red"] = /obj/item/clothing/under/dominia
	suit["Dominia suit, black"] = /obj/item/clothing/under/dominia/black
	suit["Dominia sweater"] = /obj/item/clothing/under/dominia/sweater
	suit["lyodsuit"] = /obj/item/clothing/under/dominia/lyodsuit
	suit["hoodied lyodsuit"] = /obj/item/clothing/under/dominia/lyodsuit/hoodie
	gear_tweaks += new/datum/gear_tweak/path(suit)

/datum/gear/uniform/miscellaneous/kimono
	display_name = "kimono (colourable)"
	path = /obj/item/clothing/under/kimono
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/miscellaneous/kimonomisc
	display_name = "kimono (selection)"
	path = /obj/item/clothing/under/kimono/ronin

/datum/gear/uniform/miscellaneous/kimonomisc/New()
	..()
	var/kimonomisc = list()
	kimonomisc["ronin kimono"] = /obj/item/clothing/under/kimono/ronin
	kimonomisc["fancy kimono"] = /obj/item/clothing/under/kimono/fancy

/datum/gear/uniform/miscellaneous/kamishimo
	display_name = "kamishimo"
	path = obj/item/clothing/under/kamishimo

/datum/gear/uniform/officer
	display_name = "uniform, (Security Officer) (selection)"
	description = "A selection of officer uniforms."
	path = /obj/item/clothing/under/rank/security
	allowed_roles = list("Security Officer")
	cost = 0

/datum/gear/uniform/officer/New()
	..()
	var/uniform = list()
	uniform["standard officer uniform"] = /obj/item/clothing/under/rank/security
	uniform["corporate officer uniform"] = /obj/item/clothing/under/rank/security/corp
	uniform["blue officer uniform"] = /obj/item/clothing/under/rank/security/blue
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/detective
	display_name = "uniform, (Investigations) (selection)"
	description = "A selection of Investigations staff uniforms."
	path = /obj/item/clothing/under/det
	allowed_roles = list("Detective", "Forensic Technician")
	cost = 0

/datum/gear/uniform/detective/New()
	..()
	var/uniform = list()
	uniform["tan investigator uniform"] = /obj/item/clothing/under/det
	uniform["grey investigator uniform"] = /obj/item/clothing/under/det/forensics
	uniform["black investigator uniform"] = /obj/item/clothing/under/det/black
	uniform["brown investigator uniform"] = /obj/item/clothing/under/det/classic
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/warden
	display_name = "uniform, (Warden) (selection)"
	description = "A selection of Warden uniforms."
	path = /obj/item/clothing/under/rank/warden
	allowed_roles = list("Warden")
	cost = 0

/datum/gear/uniform/warden/New()
	..()
	var/uniform = list()
	uniform["standard warden uniform"] = /obj/item/clothing/under/rank/warden
	uniform["corporate warden uniform"] = /obj/item/clothing/under/rank/warden/corp
	uniform["dark blue warden uniform"] = /obj/item/clothing/under/rank/warden/dark_blue
	gear_tweaks += new/datum/gear_tweak/path(uniform)


/datum/gear/uniform/hos
	display_name = "uniform, corporate (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")
	cost = 0

/datum/gear/uniform/circuitry
	display_name = "jumpsuit, circuitry (empty)"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/science_alt
	display_name = "scientist, alt"
	path = /obj/item/clothing/under/rank/scientist/science_alt
	allowed_roles = list("Scientist", "Xenobiologist")
	cost = 0

/datum/gear/uniform/cargo_alt
	display_name = "cargo technician, shorts"
	description = "For those that value leg-room."
	path = /obj/item/clothing/under/rank/cargo/alt
	allowed_roles = list("Cargo Technician")
	cost = 0

/datum/gear/uniform/pyjama
	display_name = "pyjamas (selection)"
	path = /obj/item/clothing/under/pj/blue

/datum/gear/uniform/pyjama/New()
	..()
	var/pyjamas = list()
	pyjamas["blue pyjamas"] = /obj/item/clothing/under/pj/blue
	pyjamas["red pyjamas"] = /obj/item/clothing/under/pj/red
	gear_tweaks += new/datum/gear_tweak/path(pyjamas)

/datum/gear/uniform/sari
	display_name = "sari (selection)"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sari/New()
	..()
	var/sari = list()
	sari["red sari"] = /obj/item/clothing/under/dress/sari
	sari["green sari"] = /obj/item/clothing/under/dress/sari/green
	gear_tweaks += new/datum/gear_tweak/path(sari)

/datum/gear/uniform/wrappedcoat
	display_name = "modern wrapped coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "plain ascetic garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pinktutu
	display_name = "pink tutu"
	path = /obj/item/clothing/under/dress/pinktutu

/datum/gear/uniform/overalls_outfit
	display_name = "overalls (selection)"
	path = /obj/item/clothing/under/overalls

/datum/gear/uniform/overalls_outfit/New()
	..()
	var/overalls_outfits = list()
	overalls_outfits["overalls"] = /obj/item/clothing/under/overalls
	overalls_outfits["sleek overalls"] = /obj/item/clothing/under/overalls/sleek
	gear_tweaks += new/datum/gear_tweak/path(overalls_outfits)
