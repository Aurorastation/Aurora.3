/datum/gear/head
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["rainbow cap"] = /obj/item/clothing/head/soft/rainbow
	caps["red cap"] = /obj/item/clothing/head/soft/red
	caps["white cap"] = /obj/item/clothing/head/soft/mime
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	caps["mailman cap"] = /obj/item/clothing/head/mailman
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice")

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

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

/datum/gear/head/corp
	display_name = "cap, corporate (security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician",)

/datum/gear/head/sec
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
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

/datum/gear/head/hairflower/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/head/pin
	display_name = "pin selection"
	path = /obj/item/clothing/head/pin

/datum/gear/head/pin/New()
	..()
	var/list/pins = list()
	for(var/pin in typesof(/obj/item/clothing/head/pin))
		var/obj/item/clothing/head/pin/pin_type = pin
		pins[initial(pin_type.name)] = pin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pins))

/datum/gear/head/hats
	display_name = "hat selection"
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
	hats["hat, grey fedora"] = /obj/item/clothing/head/fedora/grey
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
	allowed_roles = list("Scientist", "Chief Medical Officer", "Medical Doctor", "Geneticist", "Pharmacist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

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

/datum/gear/head/headbando/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/head/beanie
	display_name = "beanie"
	path = /obj/item/clothing/head/beanie

/datum/gear/head/beanie/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/head/iacberet
	display_name = "IAC Beret"
	path = /obj/item/clothing/head/soft/iacberet
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Pharmacist", "Paramedic", "Medical Resident")

/datum/gear/head/tcflberet
	display_name = "Tau Ceti Foreign Legion dress beret"
	path = /obj/item/clothing/head/legion_beret
