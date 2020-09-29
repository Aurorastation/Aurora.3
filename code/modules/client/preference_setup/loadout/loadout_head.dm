/datum/gear/head
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/ushanka_grey
	display_name = "ushanka, grey"
	path = /obj/item/clothing/head/ushanka/grey

/datum/gear/head/bandana
	display_name = "bandana selection"
	description = "A selection of bandanas. Comes in departmental colors."
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["bandana"] = /obj/item/clothing/head/bandana
	bandanas["bandana, red"] = /obj/item/clothing/head/bandana/red
	bandanas["bandana, captain"] = /obj/item/clothing/head/bandana/captain
	bandanas["bandana, security"] = /obj/item/clothing/head/bandana/security
	bandanas["bandana, science"] = /obj/item/clothing/head/bandana/science
	bandanas["bandana, medical"] = /obj/item/clothing/head/bandana/medical
	bandanas["bandana, engineering"] = /obj/item/clothing/head/bandana/engineering
	bandanas["bandana, atmospherics"] = /obj/item/clothing/head/bandana/atmos
	bandanas["bandana, hydroponics"] = /obj/item/clothing/head/bandana/hydro
	bandanas["bandana, cargo"] = /obj/item/clothing/head/bandana/cargo
	bandanas["bandana, mining"] = /obj/item/clothing/head/bandana/miner
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/bandana/colorable
	display_name = "bandana (colorable)"
	path = /obj/item/clothing/head/bandana/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/softcap
	display_name = "softcap selection"
	description = "A selection of softcaps. Comes in departmental colors."
	path = /obj/item/clothing/head/softcap

/datum/gear/head/softcap/New()
	..()
	var/softcaps = list()
	softcaps["softcap"] = /obj/item/clothing/head/softcap
	softcaps["softcap, rainbow"] = /obj/item/clothing/head/softcap/rainbow
	softcaps["softcap, red"] = /obj/item/clothing/head/softcap/red
	softcaps["softcap, captain"] = /obj/item/clothing/head/softcap/captain
	softcaps["softcap, security"] = /obj/item/clothing/head/softcap/security
	softcaps["softcap, science"] = /obj/item/clothing/head/softcap/science
	softcaps["softcap, medical"] = /obj/item/clothing/head/softcap/medical
	softcaps["softcap, engineering"] = /obj/item/clothing/head/softcap/engineering
	softcaps["softcap, atmospherics"] = /obj/item/clothing/head/softcap/atmos
	softcaps["softcap, hydroponics"] = /obj/item/clothing/head/softcap/hydro
	softcaps["softcap, cargo"] = /obj/item/clothing/head/softcap/cargo
	softcaps["softcap, mining"] = /obj/item/clothing/head/softcap/miner

	gear_tweaks += new/datum/gear_tweak/path(softcaps)

/datum/gear/head/softcap/colorable
	display_name = "softcap (colorable)"
	path = /obj/item/clothing/head/softcap/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice")

/datum/gear/head/beret/color
	display_name = "beret (colorable)"
	path = /obj/item/clothing/head/beret/misc
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beret/sec
	display_name = "beret, security"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/head/warden
	display_name = "headwear, security (warden)"
	description = "A selection of warden headwear."
	path = /obj/item/clothing/head
	allowed_roles = list("Head of Security" , "Warden")

/datum/gear/head/warden/New()
	..()
	var/wardenhead = list()
	wardenhead["blue warden hat"] = /obj/item/clothing/head/warden
	wardenhead["black warden hat"] = /obj/item/clothing/head/warden/alt
	wardenhead["commissar's cap"] = /obj/item/clothing/head/warden/commissar
	wardenhead["warden beret"] = /obj/item/clothing/head/beret/sec/warden
	gear_tweaks += new/datum/gear_tweak/path(wardenhead)

/datum/gear/head/hos
	display_name = "headwear, security (head of security)"
	description = "A selection of head of security headwear."
	path = /obj/item/clothing/head
	allowed_roles = list("Head of Security")

/datum/gear/head/hos/New()
	..()
	var/hoshead = list()
	hoshead["blue commander beret"] = /obj/item/clothing/head/beret/sec/hos
	hoshead["black commander beret"] = /obj/item/clothing/head/beret/sec/hos/alt
	hoshead["blue commander hat"] = /obj/item/clothing/head/hos/cap
	hoshead["black commander hat"] = /obj/item/clothing/head/hos/cap/alt
	gear_tweaks += new/datum/gear_tweak/path(hoshead)

/datum/gear/head/beret/medical
	display_name = "beret, medical"
	path = /obj/item/clothing/head/beret/medical
	allowed_roles = list("Physician", "Surgeon", "Medical Resident", "Pharmacist", "Emergency Medical Technician", "Chief Medial Officer", "Psychiatrist")

/datum/gear/head/corp
	display_name = "cap, corporate (security)"
	path = /obj/item/clothing/head/softcap/security/corp
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician",)

/datum/gear/head/sec
	display_name = "cap, security"
	path = /obj/item/clothing/head/softcap/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician",)

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/head/hardhat/New()
	..()
	var/hardhat = list()
	hardhat["hardhat, yellow"] = /obj/item/clothing/head/hardhat
	hardhat["hardhat, blue"] = /obj/item/clothing/head/hardhat/dblue
	hardhat["hardhat, orange"] = /obj/item/clothing/head/hardhat/orange
	hardhat["hardhat, red"] = /obj/item/clothing/head/hardhat/red
	gear_tweaks += new/datum/gear_tweak/path(hardhat)

/datum/gear/head/hairflower
	display_name = "hair flower pin (colorable)"
	path = /obj/item/clothing/head/pin/flower/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/flowercrown
	display_name = "flowercrown selection"
	description = "A set of flowercrowns, perfect for the queen or even the king."
	path = /obj/item/clothing/head

/datum/gear/head/flowercrown/New()
	..()
	var/flowercrown = list()
	flowercrown["crown, sunflower"] = /obj/item/clothing/head/sunflower_crown
	flowercrown["crown, harebell"] = /obj/item/clothing/head/lavender_crown
	flowercrown["crown, poppy"] = /obj/item/clothing/head/poppy_crown
	gear_tweaks += new/datum/gear_tweak/path(flowercrown)

/datum/gear/head/pin
	display_name = "pin selection"
	path = /obj/item/clothing/head/pin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/pin/New()
	..()
	var/list/pins = list()
	for(var/pin in typesof(/obj/item/clothing/head/pin))
		var/obj/item/clothing/head/pin/pin_type = pin
		pins[initial(pin_type.name)] = pin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pins))

/datum/gear/head/hats
	display_name = "hat selection"
	description = "A selection of hats."
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/hats/New()
	..()
	var/hats = list()
	hats["hat, boatsman"] = /obj/item/clothing/head/boaterhat
	hats["hat, bowler"] = /obj/item/clothing/head/bowler
	hats["hat, fez"] = /obj/item/clothing/head/fez
	hats["hat, tophat"] = /obj/item/clothing/head/that
	hats["hat, feather trilby"] = /obj/item/clothing/head/feathertrilby
	hats["hat, black fedora"] = /obj/item/clothing/head/fedora
	hats["hat, brown fedora"] = /obj/item/clothing/head/fedora/brown
	hats["hat, dark brown fedora"] = /obj/item/clothing/head/fedora/brown/dark
	hats["hat, grey fedora"] = /obj/item/clothing/head/fedora/grey
	hats["hat, beaver"] = /obj/item/clothing/head/beaverhat
	hats["hat, cowboy"] = /obj/item/clothing/head/cowboy
	hats["hat, wide-brimmed cowboy"] = /obj/item/clothing/head/cowboy/wide
	hats["hat, sombrero"] = /obj/item/clothing/head/sombrero
	hats["hat, flatcap"] = /obj/item/clothing/head/flatcap
	gear_tweaks += new/datum/gear_tweak/path(hats)

/datum/gear/head/hijab
	display_name = "hijab selection"
	path = /obj/item/clothing/head/hijab

/datum/gear/head/hijab/New()
	..()
	var/hijab = list()
	hijab["black hijab"] = /obj/item/clothing/head/hijab
	hijab["grey hijab"] = /obj/item/clothing/head/hijab/grey
	hijab["red hijab"] = /obj/item/clothing/head/hijab/red
	hijab["brown hijab"] = /obj/item/clothing/head/hijab/brown
	hijab["green hijab"] = /obj/item/clothing/head/hijab/green
	hijab["blue hijab"] = /obj/item/clothing/head/hijab/blue
	hijab["white hijab"] = /obj/item/clothing/head/hijab/white

	gear_tweaks += new/datum/gear_tweak/path(hijab)

/datum/gear/head/turban
	display_name = "turban selection"
	path = /obj/item/clothing/head/turban

/datum/gear/head/turban/New()
	..()
	var/turbans = list()
	turbans["black turban"] = /obj/item/clothing/head/turban
	turbans["blue turban"] = /obj/item/clothing/head/turban/blue
	turbans["green turban"] = /obj/item/clothing/head/turban/green
	turbans["grey turban"] = /obj/item/clothing/head/turban/grey
	turbans["orange turban"] = /obj/item/clothing/head/turban/orange
	turbans["purple turban"] = /obj/item/clothing/head/turban/purple
	turbans["red turban"] = /obj/item/clothing/head/turban/red
	turbans["white turban"] = /obj/item/clothing/head/turban/white
	turbans["yellow turban"] = /obj/item/clothing/head/turban/yellow

	gear_tweaks += new/datum/gear_tweak/path(turbans)

/datum/gear/head/surgical
	display_name = "surgical cap selection"
	path = /obj/item/clothing/head/surgery/blue
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Emergency Medical Technician", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/head/surgical/New()
	..()
	var/surgical = list()
	surgical["surgical cap, purple"] = /obj/item/clothing/head/surgery/purple
	surgical["surgical cap, blue"] = /obj/item/clothing/head/surgery/blue
	surgical["surgical cap, green"] = /obj/item/clothing/head/surgery/green
	surgical["surgical cap, black"] = /obj/item/clothing/head/surgery/black
	gear_tweaks += new/datum/gear_tweak/path(surgical)

/datum/gear/head/headbando
	display_name = "basic headband"
	path = /obj/item/clothing/head/headbando
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beanie
	display_name = "beanie"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/nonla
	display_name = "non la hat"
	path = /obj/item/clothing/head/nonla

/datum/gear/head/iacberet
	display_name = "IAC Beret"
	path = /obj/item/clothing/head/softcap/iacberet
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Emergency Medical Technician", "Medical Resident")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/circuitry
	display_name = "headwear, circuitry (empty)"
	path = /obj/item/clothing/head/circuitry

/datum/gear/head/tcfl
	display_name = "tcfl hat selection"
	path = /obj/item/clothing/head/legion_beret
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/tcfl/New()
	..()
	var/tcfl = list()
	tcfl["tcfl beret, dress"] = /obj/item/clothing/head/legion_beret
	tcfl["tcfl beret, field"] = /obj/item/clothing/head/legion
	gear_tweaks += new/datum/gear_tweak/path(tcfl)

/datum/gear/head/padded_cap
	display_name = "padded cap"
	path = /obj/item/clothing/head/padded
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/himeo
	display_name = "himean cap"
	path = /obj/item/clothing/head/softcap/himeo
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/vysoka
	display_name = "vysokan fur cap"
	path = /obj/item/clothing/head/softcap/vysoka
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/buckethat
	display_name = "bucket hat"
	path = /obj/item/clothing/head/buckethat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/gadpathur
	display_name = "gadpathurian headgear selection"
	description = "A selection of headgear from Gadpathur."
	path = /obj/item/clothing/head/soft/gadpathur
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/gadpathur/New()
	..()
	var/gadpathur = list()
	gadpathur["gadpathurian sidecap"] = /obj/item/clothing/head/soft/gadpathur
	gadpathur["gadpathurian beret"] = /obj/item/clothing/head/soft/gadpathur/beret
	gear_tweaks += new/datum/gear_tweak/path(gadpathur)
