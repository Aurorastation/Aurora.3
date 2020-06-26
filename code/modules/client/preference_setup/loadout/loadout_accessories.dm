/datum/gear/accessory
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/suspenders
	display_name = "suspenders (colourable)"
	path = /obj/item/clothing/accessory/suspenders
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/waistcoat
	display_name = "waistcoat (selection, colourable)"
	path = /obj/item/clothing/accessory/wcoat_rec
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/waistcoat/New()
	..()
	var/a_waistcoats = list()
	a_waistcoats["waistcoat"] = /obj/item/clothing/accessory/wcoat_rec
	a_waistcoats["elegant waistcoat"] = /obj/item/clothing/accessory/wcoat_rec/elegant
	gear_tweaks += new/datum/gear_tweak/path(a_waistcoats)

/datum/gear/accessory/armband/coloured
	display_name = "armband (colourable)"
	path = /obj/item/clothing/accessory/armband/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/armband
	display_name = "armband (selection)"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["security armband"] = /obj/item/clothing/accessory/armband/sec
	armbands["black brassard"] = /obj/item/clothing/accessory/armband/brassard
	armbands["white brassard"] = /obj/item/clothing/accessory/armband/brassard/white
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["EMT armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["IAC armband"] = /obj/item/clothing/accessory/armband/iac
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/holster
	display_name = "holster (selection)"
	path = /obj/item/clothing/accessory/holster/armpit
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective", "Forensic Technician", "Security Cadet", "Corporate Liaison")

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

/datum/gear/accessory/tie_colourable
	display_name = "tie (colourable)"
	path = /obj/item/clothing/accessory/tie/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie
	display_name = "tie (selection)"
	path = /obj/item/clothing/accessory/blue

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["red tie with a clip"] = /obj/item/clothing/accessory/tie/red_clip
	ties["orange tie"] = /obj/item/clothing/accessory/tie/orange
	ties["yellow tie"] = /obj/item/clothing/accessory/tie/yellow
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["green tie"] = /obj/item/clothing/accessory/tie/green
	ties["dark green tie"] = /obj/item/clothing/accessory/tie/darkgreen
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["blue tie with a clip"] = /obj/item/clothing/accessory/tie/blue_clip
	ties["navy tie"] = /obj/item/clothing/accessory/tie/navy
	ties["purple tie"] = /obj/item/clothing/accessory/tie/purple
	ties["black tie"] = /obj/item/clothing/accessory/tie/black
	ties["white tie"] = /obj/item/clothing/accessory/tie/white
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/bowtie
	display_name = "bowtie (colourable)"
	path = /obj/item/clothing/accessory/tie/bowtie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Security Officer","Head of Security","Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/brown_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/pouches/brown
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/pouches/black
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/pouches/white
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/pouches
	display_name = "drop pouches, simple (colourable)"
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
	display_name = "sweater (selection, colourable)"
	path = /obj/item/clothing/accessory/sweater
	description = "A selection of sweaters and sweater vests."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sweater/New()
	..()
	var/sweater = list()
	sweater["sweater"] = /obj/item/clothing/accessory/sweater
	sweater["loose sweater"] = /obj/item/clothing/accessory/sweaterloose
	sweater["argyle sweater"] = /obj/item/clothing/accessory/sweaterargyle
	sweater["sweater vest"] = /obj/item/clothing/accessory/sweatervest
	sweater["argyle sweater vest"] = /obj/item/clothing/accessory/sweatervestargyle
	sweater["turtleneck sweater"] = /obj/item/clothing/accessory/sweaterturtleneck
	sweater["argyle turtleneck sweater"] = /obj/item/clothing/accessory/sweaterargyleturtleneck
	sweater["tubeneck sweater"] = /obj/item/clothing/accessory/sweatertubeneck
	sweater["argyle tubeneck sweater"] = /obj/item/clothing/accessory/sweaterargyletubeneck
	sweater["flax sweater vest"] = /obj/item/clothing/accessory/sweatervestplain
	sweater["flax turtleneck"] = /obj/item/clothing/accessory/sweaterplainturtleneck
	sweater["keyhole sweater"] = /obj/item/clothing/accessory/sweater/keyhole
	gear_tweaks += new/datum/gear_tweak/path(sweater)

/datum/gear/accessory/sweater/misc
	display_name = "sweater, misc (selection)"
	path = /obj/item/clothing/accessory/sweater/xmasneck
	description = "A selection of sweaters and sweater vests."

/datum/gear/accessory/sweater/misc/New()
	..()
	var/sweatermisc = list()
	sweatermisc["NT sweater"] = /obj/item/clothing/accessory/sweater/nt
	sweatermisc["heart sweater"] = /obj/item/clothing/accessory/sweater/heart
	sweatermisc["xmas sweater"] = /obj/item/clothing/accessory/sweater/xmasneck
	sweatermisc["ugly xmas sweater"] = /obj/item/clothing/accessory/sweater/uglyxmas
	sweatermisc["flower sweater"] = /obj/item/clothing/accessory/sweater/flowersweater
	gear_tweaks += new/datum/gear_tweak/path(sweatermisc)

/datum/gear/accessory/dressshirt
	display_name = "dress shirt (colourable)"
	path = /obj/item/clothing/accessory/dressshirt
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/dressshirt_r
	display_name = "dress shirt, rolled up (colourable)"
	path = /obj/item/clothing/accessory/dressshirt_r
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/longsleeve
	display_name = "long-sleeved shirt (colourable)"
	path = /obj/item/clothing/accessory/longsleeve
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/longsleeve_s
	display_name = "long-sleeved shirt, striped (selection)"
	path = /obj/item/clothing/accessory/longsleeve_s

/datum/gear/accessory/longsleeve_s/New()
	..()
	var/lshirt = list()
	lshirt["black-striped"] = /obj/item/clothing/accessory/longsleeve_s
	lshirt["blue-striped"] = /obj/item/clothing/accessory/longsleeve_sb
	gear_tweaks += new/datum/gear_tweak/path(lshirt)

/datum/gear/accessory/tshirt
	display_name = "t-shirt (colourable)"
	path = /obj/item/clothing/accessory/tshirt
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/silversun
	display_name = "silversun floral shirt (selection)"
	path = /obj/item/clothing/accessory/silversun

/datum/gear/accessory/silversun/New()
	..()
	var/shirts = list()
	shirts["cyan silversun shirt"] = /obj/item/clothing/accessory/silversun
	shirts["red silversun shirt"] = /obj/item/clothing/accessory/silversun/red
	shirts["random colored silversun shirt"] = /obj/item/clothing/accessory/silversun/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf (selection, colourable)"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/scarf/New()
	..()
	var/scarfs = list()
	scarfs["plain scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new/datum/gear_tweak/path(scarfs)

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/dogtags
	display_name = "dogtags"
	path = /obj/item/clothing/accessory/dogtags

/datum/gear/accessory/holobadge
	display_name = "badge, holo (selection)"
	path = /obj/item/clothing/accessory/badge/holo
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet")

/datum/gear/accessory/holobadge/New()
	..()
	var/holobadges = list()
	holobadges["holobadge"] = /obj/item/clothing/accessory/badge/holo
	holobadges["holobadge cord"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new/datum/gear_tweak/path(holobadges)

/datum/gear/accessory/wardenbadge
	display_name = "badge, warden"
	path = /obj/item/clothing/accessory/badge/warden
	allowed_roles = list("Warden")

/datum/gear/accessory/hosbadge
	display_name = "badge, HoS"
	path = /obj/item/clothing/accessory/badge/hos
	allowed_roles = list("Head of Security")

/datum/gear/accessory/detbadge
	display_name = "badge, detective"
	path = /obj/item/clothing/accessory/badge/dia
	allowed_roles = list("Detective")

/datum/gear/accessory/idbadge
	display_name = "badge, identification"
	path = /obj/item/clothing/accessory/badge/idbadge

/datum/gear/accessory/nt_idbadge
	display_name = "badge, NanoTrasen ID"
	path = /obj/item/clothing/accessory/badge/idbadge/nt

/datum/gear/accessory/electronic_idbadge
	display_name = "badge, electronic"
	path = /obj/item/clothing/accessory/badge/idbadge/intel

/datum/gear/accessory/sleeve_patch
	display_name = "shoulder sleeve patch (colourable)"
	path = /obj/item/clothing/accessory/sleevepatch
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/namepin
	display_name = "pin tag (colourable)"
	path = /obj/item/clothing/accessory/badge/namepin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/asym
	display_name = "asymmetric jacket (selection)"
	path = /obj/item/clothing/accessory/asymmetric

/datum/gear/accessory/asym/New()
	..()
	var/asyms = list()
	asyms["blue asymmetric jacket"] = /obj/item/clothing/accessory/asymmetric
	asyms["purple asymmetric jacket"] = /obj/item/clothing/accessory/asymmetric/purple
	asyms["green asymmetric jacket"] = /obj/item/clothing/accessory/asymmetric/green
	gear_tweaks += new/datum/gear_tweak/path(asyms)

/datum/gear/accessory/sash
	display_name = "sash (colourable)"
	path = /obj/item/clothing/accessory/sash
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/cowledvest
	display_name = "cowled vest"
	path = /obj/item/clothing/accessory/cowled_vest

/datum/gear/accessory/halfcape
	display_name = "half cape"
	path = /obj/item/clothing/accessory/halfcape

/datum/gear/accessory/fullcape
	display_name = "full cape"
	path = /obj/item/clothing/accessory/fullcape

/datum/gear/accessory/bracelet
	display_name = "bracelet (colourable)"
	path = /obj/item/clothing/accessory/bracelet
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bracelet/material
	display_name = "bracelet (selection)"
	path = /obj/item/clothing/accessory/bracelet/material/plastic

/datum/gear/accessory/bracelet/material/New()
	..()
	var/bracelettype = list()
	bracelettype["steel bracelet"] = /obj/item/clothing/accessory/bracelet/material/steel
	bracelettype["iron bracelet"] = /obj/item/clothing/accessory/bracelet/material/iron
	bracelettype["silver bracelet"] = /obj/item/clothing/accessory/bracelet/material/silver
	bracelettype["gold bracelet"] = /obj/item/clothing/accessory/bracelet/material/gold
	bracelettype["platinum bracelet"] = /obj/item/clothing/accessory/bracelet/material/platinum
	bracelettype["glass bracelet"] = /obj/item/clothing/accessory/bracelet/material/glass
	bracelettype["wood bracelet"] = /obj/item/clothing/accessory/bracelet/material/wood
	bracelettype["plastic bracelet"] = /obj/item/clothing/accessory/bracelet/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(bracelettype)

/datum/gear/accessory/bracelet/friendship
	display_name = "friendship bracelet"
	path = /obj/item/clothing/accessory/bracelet/friendship

/datum/gear/accessory/suitvest
	display_name = "suit vest"
	path = /obj/item/clothing/accessory/suitvest

/datum/gear/accessory/roles/poncho/cloak/hos
	display_name = "cloak, head of security"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list("Head of Security")

/datum/gear/accessory/roles/poncho/cloak/cmo
	display_name = "cloak, chief medical officer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/accessory/roles/poncho/cloak/ce
	display_name = "cloak, chief engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/accessory/roles/poncho/cloak/rd
	display_name = "cloak, research director"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")

/datum/gear/accessory/roles/poncho/cloak/qm
	display_name = "cloak, quartermaster"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")

/datum/gear/accessory/roles/poncho/cloak/captain
	display_name = "cloak, captain"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Captain")

/datum/gear/accessory/roles/poncho/cloak/hop
	display_name = "cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/accessory/roles/poncho/cloak/cargo
	display_name = "cloak, cargo"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo

/datum/gear/accessory/roles/poncho/cloak/mining
	display_name = "cloak, mining"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mining

/datum/gear/accessory/roles/poncho/cloak/security
	display_name = "cloak, security"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/security

/datum/gear/accessory/roles/poncho/cloak/service
	display_name = "cloak, service"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/service

/datum/gear/accessory/roles/poncho/cloak/engineer
	display_name = "cloak, engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/engineer

/datum/gear/accessory/roles/poncho/cloak/atmos
	display_name = "cloak, atmos"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/atmos

/datum/gear/accessory/roles/poncho/cloak/research
	display_name = "cloak, science"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/research

/datum/gear/accessory/roles/poncho/cloak/medical
	display_name = "cloak, medical"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/medical

/datum/gear/accessory/roles/poncho/cloak/custom //A colorable cloak
	display_name = "cloak (colourable)"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION