/datum/gear/head/goldenchains
	display_name = "golden deep headchains"
	path = /obj/item/clothing/head/headchain
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldenchains/New()
	..()
	var/headchains = list()
	headchains["head chains, cobalt"] = /obj/item/clothing/head/headchain
	headchains["head chains, emerald"] = /obj/item/clothing/head/headchain/emerald
	headchains["head chains, ruby"] = /obj/item/clothing/head/headchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(headchains)

/datum/gear/head/goldencrests
	display_name = "golden deep crests"
	path = /obj/item/clothing/head/crest
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldencrests/New()
	..()
	var/crest = list()
	crest["crest, cobalt"] = /obj/item/clothing/head/crest
	crest["crest, emerald"] = /obj/item/clothing/head/crest/emerald
	crest["crest, ruby"] = /obj/item/clothing/head/crest/ruby
	gear_tweaks += new/datum/gear_tweak/path(crest)

/datum/gear/wrists/armchains
	display_name = "golden deep armchains"
	path = /obj/item/clothing/wrists/armchain
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/armchains/New()
	..()
	var/armchains = list()
	armchains["arm chains, cobalt"] = /obj/item/clothing/wrists/armchain
	armchains["arm chains, emerald"] = /obj/item/clothing/wrists/armchain/emerald
	armchains["arm chains, ruby"] = /obj/item/clothing/wrists/armchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(armchains)

/datum/gear/wrists/bracers
	display_name = "golden deep bracers"
	path = /obj/item/clothing/wrists/goldbracer
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/bracers/New()
	..()
	var/bracers = list()
	bracers["arm chains, cobalt"] = /obj/item/clothing/wrists/goldbracer
	bracers["arm chains, emerald"] = /obj/item/clothing/wrists/goldbracer/emerald
	bracers["arm chains, ruby"] = /obj/item/clothing/wrists/goldbracer/ruby
	gear_tweaks += new/datum/gear_tweak/path(bracers)

/datum/gear/ears/antennae
	display_name = "antennae"
	path = /obj/item/clothing/ears/antenna
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/antennae/New()
	..()
	var/antenna = list()
	antenna["antenna, curved"] = /obj/item/clothing/ears/antenna/curved
	antenna["antenna, straight"] = /obj/item/clothing/ears/antenna/straight
	antenna["antenna, circle"] = /obj/item/clothing/ears/antenna/circle
	antenna["antenna, tusk"] = /obj/item/clothing/ears/antenna/tusk
	antenna["antenna, horn crown"] = /obj/item/clothing/ears/antenna/horncrown
	antenna["antenna, dual horns"] = /obj/item/clothing/ears/antenna/horn
	antenna["antenna, horn"] = /obj/item/clothing/ears/antenna/horn/single
	antenna["antenna, dishes"] = /obj/item/clothing/ears/antenna/dish
	antenna["antenna, dual whips"] = /obj/item/clothing/ears/antenna/whip
	antenna["antenna, whip"] = /obj/item/clothing/ears/antenna/whip/single
	gear_tweaks += new/datum/gear_tweak/path(antenna)

/datum/gear/ears/trinary_halo
	display_name = "trinary perfection antenna"
	path = /obj/item/clothing/ears/antenna/trinary_halo
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/headlights
	display_name = "headlights"
	path = /obj/item/device/flashlight/headlights
	cost = 2
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"

/datum/gear/suit/idris
	display_name = "Idris Unit coats"
	path = /obj/item/clothing/suit/armor/vest/idris
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	allowed_roles = list("Security Officer", "Warden", "Head of Security", "Investigator", "Security Cadet")
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

/datum/gear/uniform/goldendeep
	display_name = "golden deep outfit selection"
	description = "A selection of formal outfits worn by members of the Golden Deep."
	path = /obj/item/clothing/under/goldendeep
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"

/datum/gear/uniform/goldendeep/New()
	..()
	var/goldendeep = list()
	goldendeep["golden deep dress"] = /obj/item/clothing/under/goldendeep
	goldendeep["golden deep wrap"] = /obj/item/clothing/under/goldendeep/wrap
	goldendeep["golden deep vest"] = /obj/item/clothing/under/goldendeep/vest
	goldendeep["golden deep suit"] = /obj/item/clothing/under/goldendeep/suit
	goldendeep["golden deep skirtsuit"] = /obj/item/clothing/under/goldendeep/skirtsuit
	gear_tweaks += new/datum/gear_tweak/path(goldendeep)

/datum/gear/augment/machine/gustatoral
	display_name = "gustatoral centre (tongue)"
	description = "An extremely complex augment, capable of translating taste into binary code, allowing synthetic beings to experience food."
	path = /obj/item/organ/internal/augment/gustatoral
	cost = 1
	whitelisted = list(SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"

/datum/gear/augment/machine/gustatoral/hands
	display_name = "gustatoral centre (hands)"
	description = "An extremely complex augment, capable of translating taste into binary code, allowing synthetic beings to experience food."
	path = /obj/item/organ/internal/augment/gustatoral/hand
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/gear/augment/machine/gustatoral/hands/New()
	..()
	var/list/handies = list()
	handies["gustatoral centre (right hand)"] = /obj/item/organ/internal/augment/gustatoral/hand
	handies["gustatoral centre (left hand)"] = /obj/item/organ/internal/augment/gustatoral/hand/left
	gear_tweaks += new /datum/gear_tweak/path(handies)