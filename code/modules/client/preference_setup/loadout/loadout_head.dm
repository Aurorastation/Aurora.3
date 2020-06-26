/datum/gear/head
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/ushanka_grey
	display_name = "ushanka, grey"
	path = /obj/item/clothing/head/ushanka/grey

/datum/gear/head/bandana
	display_name = "bandana (selection)"
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/cap
	display_name = "cap (selection)"
	description = "A selection of colored caps."
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["red cap"] = /obj/item/clothing/head/soft
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["rainbow cap"] = /obj/item/clothing/head/soft/rainbow
	caps["black cap"] = /obj/item/clothing/head/soft/black
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["white cap"] = /obj/item/clothing/head/soft/white
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["mailman cap"] = /obj/item/clothing/head/mailman
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/cap_colour
	display_name = "cap (colourable)"
	path = /obj/item/clothing/head/soft/colour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice")

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/color
	display_name = "beret (colourable)"
	path = /obj/item/clothing/head/beret/misc
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beret/sec
	display_name = "beret, security"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/head/beret/warden
	display_name = "beret, security (warden)"
	path = /obj/item/clothing/head/beret/sec/warden
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/head/beret/hos
	display_name = "beret, security (head of security)"
	path = /obj/item/clothing/head/beret/sec/hos
	allowed_roles = list("Head of Security")

/datum/gear/head/beret/medical
	display_name = "beret, medical"
	path = /obj/item/clothing/head/beret/medical
	allowed_roles = list("Physician", "Surgeon", "Medical Resident", "Pharmacist", "Paramedic", "Chief Medial Officer", "Psychiatrist")

/datum/gear/head/corp
	display_name = "cap, corporate (security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician",)

/datum/gear/head/sec
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician",)

/datum/gear/head/hardhat
	display_name = "hardhat (selection)"
	path = /obj/item/clothing/head/hardhat
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/head/hardhat/New()
	..()
	var/hardhat = list()
	hardhat["yellow hardhat"] = /obj/item/clothing/head/hardhat
	hardhat["blue hardhat"] = /obj/item/clothing/head/hardhat/dblue
	hardhat["orange hardhat"] = /obj/item/clothing/head/hardhat/orange
	hardhat["red hardhat"] = /obj/item/clothing/head/hardhat/red
	gear_tweaks += new/datum/gear_tweak/path(hardhat)

/datum/gear/head/hairbow
	display_name = "hair bow, small (colourable)"
	path = /obj/item/clothing/head/pin/bow
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/hairflower
	display_name = "hair flower pin (colourable)"
	path = /obj/item/clothing/head/pin/flower/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/flowercrown
	display_name = "flowercrown (selection)"
	description = "A set of flowercrowns, perfect for the queen or even the king."
	path = /obj/item/clothing/head

/datum/gear/head/flowercrown/New()
	..()
	var/flowercrown = list()
	flowercrown["sunflower crown"] = /obj/item/clothing/head/sunflower_crown
	flowercrown["harebell crown"] = /obj/item/clothing/head/lavender_crown
	flowercrown["poppy crown"] = /obj/item/clothing/head/poppy_crown
	gear_tweaks += new/datum/gear_tweak/path(flowercrown)

/datum/gear/head/pin
	display_name = "pin (selection)"
	path = /obj/item/clothing/head/pin

/datum/gear/head/pin/New()
	..()
	var/list/pins = list()
	for(var/pin in typesof(/obj/item/clothing/head/pin))
		var/obj/item/clothing/head/pin/pin_type = pin
		pins[initial(pin_type.name)] = pin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pins))

/datum/gear/head/hats
	display_name = "hat (selection)"
	description = "A selection of hats."
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/hats/New()
	..()
	var/hats = list()
	hats["boatsman hat"] = /obj/item/clothing/head/boaterhat
	hats["bowler hat"] = /obj/item/clothing/head/bowler
	hats["fez"] = /obj/item/clothing/head/fez
	hats["tophat"] = /obj/item/clothing/head/that
	hats["feather trilby"] = /obj/item/clothing/head/feathertrilby
	hats["fedora, black"] = /obj/item/clothing/head/fedora
	hats["fedora, brown"] = /obj/item/clothing/head/fedora/brown
	hats["fedora, dark brown"] = /obj/item/clothing/head/fedora/brown/dark
	hats["fedora, grey"] = /obj/item/clothing/head/fedora/grey
	hats["beaver hat"] = /obj/item/clothing/head/beaverhat
	hats["cowboy hat"] = /obj/item/clothing/head/cowboy
	hats["cowboy hat, wide-brimmed"] = /obj/item/clothing/head/cowboy/wide
	hats["cowboy hat, black"] = /obj/item/clothing/head/cowboy/black
	hats["cowboy hat, small"] = /obj/item/clothing/head/cowboy/small
	hats["sombrero"] = /obj/item/clothing/head/sombrero
	gear_tweaks += new/datum/gear_tweak/path(hats)

/datum/gear/head/hats/flatcap_colour
	display_name = "flat cap (colourable)"
	path = /obj/item/clothing/head/flatcap/colour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/hijab
	display_name = "hijab (selection)"
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

/datum/gear/head/hijab/colourable
	display_name = "hijab (colourable)"
	path = /obj/item/clothing/head/hijab/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban (selection)"
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

/datum/gear/head/turban/colourable
	display_name = "turban (colourable)"
	path = /obj/item/clothing/head/turban/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/surgical
	display_name = "surgical cap (selection)"
	path = /obj/item/clothing/head/surgery/blue
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/head/surgical/New()
	..()
	var/surgical = list()
	surgical["purple surgical cap"] = /obj/item/clothing/head/surgery/purple
	surgical["blue surgical cap"] = /obj/item/clothing/head/surgery/blue
	surgical["green surgical cap"] = /obj/item/clothing/head/surgery/green
	surgical["black surgical cap"] = /obj/item/clothing/head/surgery/black
	gear_tweaks += new/datum/gear_tweak/path(surgical)

/datum/gear/head/headbando
	display_name = "basic headband (colourable)"
	path = /obj/item/clothing/head/headbando
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beanie
	display_name = "beanie (colourable)"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/loose_beanie
	display_name = "loose beanie (colourable)"
	path = /obj/item/clothing/head/beanie_loose
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/nonla
	display_name = "non la hat"
	path = /obj/item/clothing/head/nonla

/datum/gear/head/iacberet
	display_name = "IAC beret"
	path = /obj/item/clothing/head/soft/iacberet
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Resident")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/circuitry
	display_name = "headwear, circuitry (empty)"
	path = /obj/item/clothing/head/circuitry

/datum/gear/head/tcfl
	display_name = "TCFL hat (selection)"
	path = /obj/item/clothing/head/legion_beret
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/tcfl/New()
	..()
	var/tcfl = list()
	tcfl["dress TCFL beret, "] = /obj/item/clothing/head/legion_beret
	tcfl["field TCFL beret, "] = /obj/item/clothing/head/legion
	gear_tweaks += new/datum/gear_tweak/path(tcfl)

/datum/gear/head/padded_cap
	display_name = "padded cap (colourable)"
	path = /obj/item/clothing/head/padded
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa (colourable)"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/taqiyah
	display_name = "taqiyah (colourable)"
	path = /obj/item/clothing/head/taqiyah
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/maangtikka
	display_name = "maang tikka"
	path = /obj/item/clothing/head/maangtikka

/datum/gear/head/jingasa
	display_name = "jingasa"
	path = /obj/item/clothing/head/jingasa

/datum/gear/head/wig/philosopher
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/wig
	display_name = "powdered wig"
	path = /obj/item/clothing/head/powdered_wig

/datum/gear/head/welding
	display_name = "welding helmet"
	path = /obj/item/clothing/head/welding
	cost = 2
	allowed_roles = list("Chief Engineer","Station Engineer","Atmospheric Technician","Engineering Apprentice","Research Director","Roboticist")

/datum/gear/head/welding/New()
	..()
	var/weldinghelmets = list()
	weldinghelmets["normal welding helmet"] = /obj/item/clothing/head/welding
	weldinghelmets["demon welding helmet"] = /obj/item/clothing/head/welding/demon
	weldinghelmets["knight welding helmet"] = /obj/item/clothing/head/welding/knight
	weldinghelmets["fancy welding helmet"] = /obj/item/clothing/head/welding/fancy
	weldinghelmets["engie welding helmet"] = /obj/item/clothing/head/welding/engie
	weldinghelmets["carp welding helmet"] = /obj/item/clothing/head/welding/carp
	gear_tweaks += new/datum/gear_tweak/path(weldinghelmets)