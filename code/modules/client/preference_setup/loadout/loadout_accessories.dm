/datum/gear/accessory
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/waistcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat_rec
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/chaps
	display_name = "chaps selection"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/New()
	..()
	var/chaps = list()
	chaps["chaps, brown"] = /obj/item/clothing/accessory/chaps
	chaps["chaps, black"] = /obj/item/clothing/accessory/chaps/black
	gear_tweaks += new/datum/gear_tweak/path(chaps)

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["Stellar Corporate Conglomerate armband"] = /obj/item/clothing/accessory/armband/scc
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["security armband"] = /obj/item/clothing/accessory/armband/sec
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["first responder armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["IAC armband"] = /obj/item/clothing/accessory/armband/iac
	armbands["tau ceti armband"] = /obj/item/clothing/accessory/armband/tauceti
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/armband_coloured
	display_name = "armband (colourable)"
	path = /obj/item/clothing/accessory/armband/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster/armpit
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Investigator", "Security Cadet", "Corporate Liaison", "Consular Officer")

/datum/gear/accessory/holster/New()
	..()
	var/holsters = list()
	holsters["black holster, armpit"] = /obj/item/clothing/accessory/holster/armpit
	holsters["black holster, hip"] = /obj/item/clothing/accessory/holster/hip
	holsters["black holster, waist"] = /obj/item/clothing/accessory/holster/waist
	holsters["black holster, thigh"] = /obj/item/clothing/accessory/holster/thigh
	holsters["brown holster, armpit"] = /obj/item/clothing/accessory/holster/armpit/brown
	holsters["brown holster, hip"] = /obj/item/clothing/accessory/holster/hip/brown
	holsters["brown holster, waist"] = /obj/item/clothing/accessory/holster/waist/brown
	holsters["brown holster, thigh"] = /obj/item/clothing/accessory/holster/thigh/brown
	gear_tweaks += new/datum/gear_tweak/path(holsters)

/datum/gear/accessory/tie
	display_name = "tie selection (colourable)"
	path = /obj/item/clothing/accessory/tie/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["tie"] = /obj/item/clothing/accessory/tie/colourable
	ties["tie, gold clip"] = /obj/item/clothing/accessory/tie/colourable/clip
	ties["tie, silver clip"] = /obj/item/clothing/accessory/tie/colourable/clip/silver
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/horrible_tie
	display_name = "horrible tie"
	path = /obj/item/clothing/accessory/horrible

/datum/gear/accessory/bowtie
	display_name = "bowtie"
	path = /obj/item/clothing/accessory/tie/bowtie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Security Officer","Head of Security","Warden", "Security Cadet", "Investigator")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "First Responder", "Medical Intern")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing/grayscale
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/brown_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/pouches/brown
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/pouches/black
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Investigator")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/pouches/white
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "First Responder", "Medical Intern")

/datum/gear/accessory/pouches
	display_name = "drop pouches, simple"
	path = /obj/item/clothing/accessory/storage/pouches/colour
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/overalls_mining
	display_name = "overalls, mining"
	path = /obj/item/clothing/accessory/storage/overalls/mining
	allowed_roles = list("Shaft Miner")
	cost = 2

/datum/gear/accessory/overalls_engineer
	display_name = "overalls, engineering"
	path = /obj/item/clothing/accessory/storage/overalls/engineer
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")
	cost = 2

/datum/gear/accessory/sweater
	display_name = "sweater selection"
	path = /obj/item/clothing/accessory/sweater
	description = "A selection of sweaters and sweater vests."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sweater/New()
	..()
	var/sweater = list()
	sweater["sweater"] = /obj/item/clothing/accessory/sweater
	sweater["argyle sweater"] = /obj/item/clothing/accessory/sweaterargyle
	sweater["sweater vest"] = /obj/item/clothing/accessory/sweatervest
	sweater["argyle sweater vest"] = /obj/item/clothing/accessory/sweatervestargyle
	sweater["turtleneck sweater"] = /obj/item/clothing/accessory/sweaterturtleneck
	sweater["argyle turtleneck sweater"] = /obj/item/clothing/accessory/sweaterargyleturtleneck
	sweater["tubeneck sweater"] = /obj/item/clothing/accessory/sweatertubeneck
	sweater["argyle tubeneck sweater"] = /obj/item/clothing/accessory/sweaterargyletubeneck
	gear_tweaks += new/datum/gear_tweak/path(sweater)

/datum/gear/accessory/shirt
	display_name = "shirt selection"
	path = /obj/item/clothing/accessory/dressshirt
	description = "A selection of shirts."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/shirt/New()
	..()
	var/shirt = list()
	shirt["dress shirt"] = /obj/item/clothing/accessory/dressshirt
	shirt["dress shirt, rolled up"] = /obj/item/clothing/accessory/dressshirt_r
	shirt["dress shirt, cropped"] = /obj/item/clothing/accessory/dressshirt_crop
	shirt["cropped dress shirt, rolled up"] = /obj/item/clothing/accessory/dressshirt_crop_r
	shirt["long-sleeved shirt"] = /obj/item/clothing/accessory/longsleeve
	shirt["long-sleeved shirt, black striped"] = /obj/item/clothing/accessory/longsleeve_s
	shirt["long-sleeved shirt, blue striped"] = /obj/item/clothing/accessory/longsleeve_sb
	shirt["t-shirt"] = /obj/item/clothing/accessory/tshirt
	shirt["t-shirt, cropped"] = /obj/item/clothing/accessory/tshirt_crop
	shirt["blouse"] = /obj/item/clothing/accessory/blouse
	gear_tweaks += new/datum/gear_tweak/path(shirt)

/datum/gear/accessory/silversun
	display_name = "silversun floral shirt selection"
	path = /obj/item/clothing/accessory/silversun
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/silversun/New()
	..()
	var/shirts = list()
	shirts["cyan silversun shirt"] = /obj/item/clothing/accessory/silversun
	shirts["red silversun shirt"] = /obj/item/clothing/accessory/silversun/red
	shirts["random colored silversun shirt"] = /obj/item/clothing/accessory/silversun/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/scarf/New()
	..()
	var/scarfs = list()
	scarfs["plain scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new/datum/gear_tweak/path(scarfs)

/datum/gear/accessory/dogtags
	display_name = "dogtags"
	path = /obj/item/clothing/accessory/dogtags

/datum/gear/accessory/holobadge
	display_name = "badge, holographic"
	path = /obj/item/clothing/accessory/badge/holo
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet")

/datum/gear/accessory/holobadge/New()
	..()
	var/holobadges = list()
	holobadges["holobadge"] = /obj/item/clothing/accessory/badge/holo
	holobadges["holobadge cord"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new/datum/gear_tweak/path(holobadges)

/datum/gear/accessory/officerbadge
	display_name = "badge, officer"
	path = /obj/item/clothing/accessory/badge/officer
	allowed_roles = list("Security Officer")

/datum/gear/accessory/wardenbadge
	display_name = "badge, warden"
	path = /obj/item/clothing/accessory/badge/warden
	allowed_roles = list("Warden")

/datum/gear/accessory/hosbadge
	display_name = "badge, HoS"
	path = /obj/item/clothing/accessory/badge/hos
	allowed_roles = list("Head of Security")

/datum/gear/accessory/detbadge
	display_name = "badge, investigations"
	path = /obj/item/clothing/accessory/badge/dia
	allowed_roles = list("Investigator")

/datum/gear/accessory/badge
	display_name = "badge selection"
	path = /obj/item/clothing/accessory/badge/idbadge

/datum/gear/accessory/badge/New()
	..()
	var/badge = list()
	badge["badge, identification"] = /obj/item/clothing/accessory/badge/idbadge
	badge["badge, NanoTrasen ID"] = /obj/item/clothing/accessory/badge/idbadge/nt
	badge["badge, electronic"] = /obj/item/clothing/accessory/badge/idbadge/intel
	gear_tweaks += new/datum/gear_tweak/path(badge)

/datum/gear/accessory/namepin
	display_name = "pin tag (colourable)"
	path = /obj/item/clothing/accessory/badge/namepin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sleeve_patch
	display_name = "shoulder sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/scc_patch
	display_name = "Stellar Corporate Conglomerate sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/scc
	flags = 0

/datum/gear/accessory/whalebone
	display_name = "europan bone charm"
	path = /obj/item/clothing/accessory/whalebone
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/gadpathur
	display_name = "gadpathurian cadre brassard selection"
	description = "A selection of cadre brassards from Gadpathur."
	path = /obj/item/clothing/accessory/armband/gadpathur
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/gadpathur/New()
	..()
	var/gadpathur = list()
	gadpathur["cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur
	gadpathur["industrial cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur/ind
	gadpathur["medical cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur/med
	gear_tweaks += new/datum/gear_tweak/path(gadpathur)

/datum/gear/accessory/passcard
	display_name = "human passcard selection"
	path = /obj/item/clothing/accessory/badge/passcard_sol

/datum/gear/accessory/passcard/New()
	..()
	var/passcard = list()
	passcard["passcard, sol"] = /obj/item/clothing/accessory/badge/passcard_sol
	passcard["passcard, pluto"] = /obj/item/clothing/accessory/badge/passcard_pluto
	passcard["passcard, eridani"] = /obj/item/clothing/accessory/badge/passcard_eridani
	passcard["passcard, tau ceti"] = /obj/item/clothing/accessory/badge/passcard_ceti
	passcard["passcard, elyra"] = /obj/item/clothing/accessory/badge/passcard_elyra
	passcard["passcard, dominia"] = /obj/item/clothing/accessory/badge/passcard_dominia
	passcard["passcard, coalition"] = /obj/item/clothing/accessory/badge/passcard_coalition
	passcard["passcard, himeo"] = /obj/item/clothing/accessory/badge/passcard_coalition
	passcard["passcard, vysoka"] = /obj/item/clothing/accessory/badge/passcard_vysoka
	passcard["passcard, gadpathur"] = /obj/item/clothing/accessory/badge/passcard_gad
	passcard["passcard, assunzione"] = /obj/item/clothing/accessory/badge/passcard_assu
	gear_tweaks += new/datum/gear_tweak/path(passcard)

/datum/gear/accessory/passport
	display_name = "human passport selection"
	path = /obj/item/clothing/accessory/badge/passport_sol

/datum/gear/accessory/passport/New()
	..()
	var/passport = list()
	passport["passport, sol"] = /obj/item/clothing/accessory/badge/passport_sol
	passport["passport, elyra"] = /obj/item/clothing/accessory/badge/passport_elyra
	passport["passport, dominia"] = /obj/item/clothing/accessory/badge/passport_dominia
	passport["passport, coalition"] = /obj/item/clothing/accessory/badge/passport_coc
	gear_tweaks += new/datum/gear_tweak/path(passport)
