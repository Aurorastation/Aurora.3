/datum/gear/head/goldenchains
	display_name = "golden deep headchains (selection)"
	path = /obj/item/clothing/head/headchain
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldenchains/New()
	..()
	var/headchains = list()
	headchains["cobalt head chains"] = /obj/item/clothing/head/headchain
	headchains["emerald head chains"] = /obj/item/clothing/head/headchain/emerald
	headchains["ruby head chains"] = /obj/item/clothing/head/headchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(headchains)

/datum/gear/head/goldencrests
	display_name = "golden deep crests (selection)"
	path = /obj/item/clothing/head/crest
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldencrests/New()
	..()
	var/crest = list()
	crest["cobalt crest"] = /obj/item/clothing/head/crest
	crest["emerald crest"] = /obj/item/clothing/head/crest/emerald
	crest["ruby crest"] = /obj/item/clothing/head/crest/ruby
	gear_tweaks += new/datum/gear_tweak/path(crest)

/datum/gear/gloves/armchains
	display_name = "golden deep armchains (selection)"
	path = /obj/item/clothing/gloves/armchain
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/gloves/armchains/New()
	..()
	var/armchains = list()
	armchains["cobalt arm chains"] = /obj/item/clothing/gloves/armchain
	armchains["emerald arm chains"] = /obj/item/clothing/gloves/armchain/emerald
	armchains["ruby arm chains"] = /obj/item/clothing/gloves/armchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(armchains)

/datum/gear/gloves/bracers
	display_name = "golden deep bracers (selection)"
	path = /obj/item/clothing/gloves/goldbracer
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/gloves/bracers/New()
	..()
	var/bracers = list()
	bracers["cobalt arm chains"] = /obj/item/clothing/gloves/goldbracer
	bracers["emerald arm chains"] = /obj/item/clothing/gloves/goldbracer/emerald
	bracers["ruby arm chains"] = /obj/item/clothing/gloves/goldbracer/ruby
	gear_tweaks += new/datum/gear_tweak/path(bracers)

/datum/gear/ears/antennae
	display_name = "antennae (selection, colourable)"
	path = /obj/item/clothing/head/antenna
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/antennae/New()
	..()
	var/antenna = list()
	antenna["curved antenna"] = /obj/item/clothing/head/antenna
	antenna["straight antenna"] = /obj/item/clothing/head/antenna/straight
	antenna["spiked antenna"] = /obj/item/clothing/head/antenna/spiked
	antenna["side antenna"] = /obj/item/clothing/head/antenna/side
	antenna["dish antenna"] = /obj/item/clothing/head/antenna/dish
	antenna["double antenna"] = /obj/item/clothing/head/antenna/double
	antenna["left antenna"] = /obj/item/clothing/head/antenna/double/left
	antenna["right antenna"] = /obj/item/clothing/head/antenna/double/right
	gear_tweaks += new/datum/gear_tweak/path(antenna)

/datum/gear/ears/trinary_halo
	display_name = "Trinary Perfection antenna (colourable)"
	path = /obj/item/clothing/head/antenna/trinary_halo
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/headlights
	display_name = "headlights"
	path = /obj/item/device/flashlight/headlights
	cost = 2
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"

/datum/gear/suit/idris
	display_name = "Idris Unit coat (selection)"
	path = /obj/item/clothing/suit/armor/vest/idris
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear - IPC"
	allowed_roles = list("Security Officer", "Warden", "Head of Security","Detective", "Forensic Technician", "Security Cadet")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/idris/New()
	..()
	var/idris = list()
	idris["Black Idris Unit coat"] = /obj/item/clothing/suit/armor/vest/idris
	idris["Brown Idris Unit coat"] = /obj/item/clothing/suit/armor/vest/idris/brown
	idris["Black Idris Unit trench coat"] = /obj/item/clothing/suit/armor/vest/idris/trenchcoat/black
	idris["Brown Idris Unit trench coat"] = /obj/item/clothing/suit/armor/vest/idris/trenchcoat/brown
	idris["Black Idris Unit duster coat"] = /obj/item/clothing/suit/armor/vest/idris/duster/black
	idris["Brown Idris Unit duster coat"] = /obj/item/clothing/suit/armor/vest/idris/duster/brown
	gear_tweaks += new/datum/gear_tweak/path(idris)
