/datum/gear/head/goldenchains
	display_name = "golden deep headchains"
	path = /obj/item/clothing/head/headchain
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldenchains/New()
	..()
	var/list/headchains = list()
	headchains["head chains, cobalt"] = /obj/item/clothing/head/headchain
	headchains["head chains, emerald"] = /obj/item/clothing/head/headchain/emerald
	headchains["head chains, ruby"] = /obj/item/clothing/head/headchain/ruby
	gear_tweaks += new /datum/gear_tweak/path(headchains)

/datum/gear/head/goldencrests
	display_name = "golden deep crests"
	path = /obj/item/clothing/head/crest
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/goldencrests/New()
	..()
	var/list/crest = list()
	crest["crest, cobalt"] = /obj/item/clothing/head/crest
	crest["crest, emerald"] = /obj/item/clothing/head/crest/emerald
	crest["crest, ruby"] = /obj/item/clothing/head/crest/ruby
	gear_tweaks += new /datum/gear_tweak/path(crest)

/datum/gear/wrists/armchains
	display_name = "golden deep armchains"
	path = /obj/item/clothing/wrists/armchain
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/armchains/New()
	..()
	var/list/armchains = list()
	armchains["arm chains, cobalt"] = /obj/item/clothing/wrists/armchain
	armchains["arm chains, emerald"] = /obj/item/clothing/wrists/armchain/emerald
	armchains["arm chains, ruby"] = /obj/item/clothing/wrists/armchain/ruby
	gear_tweaks += new /datum/gear_tweak/path(armchains)

/datum/gear/wrists/bracers
	display_name = "golden deep bracers"
	path = /obj/item/clothing/wrists/goldbracer
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/bracers/New()
	..()
	var/list/bracers = list()
	bracers["arm chains, cobalt"] = /obj/item/clothing/wrists/goldbracer
	bracers["arm chains, emerald"] = /obj/item/clothing/wrists/goldbracer/emerald
	bracers["arm chains, ruby"] = /obj/item/clothing/wrists/goldbracer/ruby
	gear_tweaks += new /datum/gear_tweak/path(bracers)

/datum/gear/ears/antennae
	display_name = "antennae"
	path = /obj/item/clothing/ears/antenna
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/antennae/New()
	..()
	var/list/antenna = list()
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
	gear_tweaks += new /datum/gear_tweak/path(antenna)

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
	path = /obj/item/clothing/suit/storage/toggle/armor/vest/idris
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"
	allowed_roles = list("Security Officer", "Warden", "Head of Security", "Investigator", "Security Cadet")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/idris/New()
	..()
	var/list/idris = list()
	idris["black Idris Unit coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris
	idris["white Idris Unit coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/white
	idris["brown Idris Unit coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/brown
	idris["black Idris Unit long coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat
	idris["white Idris Unit long coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat/white
	idris["brown Idris Unit long coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat/brown
	idris["black Idris Unit trench coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat
	idris["white Idris Unit trench coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat/white
	idris["brown Idris Unit trench coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat/brown
	idris["black Idris Unit duster coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster
	idris["white Idris Unit duster coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster/white
	idris["brown Idris Unit duster coat"] = /obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster/brown
	gear_tweaks += new /datum/gear_tweak/path(idris)

/datum/gear/uniform/goldendeep
	display_name = "golden deep outfit selection"
	description = "A selection of formal outfits worn by members of the Golden Deep."
	path = /obj/item/clothing/under/goldendeep
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"

/datum/gear/uniform/goldendeep/New()
	..()
	var/list/goldendeep = list()
	goldendeep["golden deep dress"] = /obj/item/clothing/under/goldendeep
	goldendeep["golden deep wrap"] = /obj/item/clothing/under/goldendeep/wrap
	goldendeep["golden deep vest"] = /obj/item/clothing/under/goldendeep/vest
	goldendeep["golden deep suit"] = /obj/item/clothing/under/goldendeep/suit
	goldendeep["golden deep skirtsuit"] = /obj/item/clothing/under/goldendeep/skirtsuit
	gear_tweaks += new /datum/gear_tweak/path(goldendeep)

/datum/gear/augment/machine/gustatorial
	display_name = "gustatorial centre (tongue)"
	description = "An extremely complex augment, capable of translating taste into binary code, allowing synthetic beings to experience food."
	path = /obj/item/organ/internal/augment/gustatorial
	cost = 1
	whitelisted = list(SPECIES_IPC_SHELL)
	sort_category = "Xenowear - IPC"

/datum/gear/augment/machine/gustatorial/hands
	display_name = "gustatorial centre (hands)"
	description = "An extremely complex augment, capable of translating taste into binary code, allowing synthetic beings to experience food."
	path = /obj/item/organ/internal/augment/gustatorial/hand
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/gear/augment/machine/gustatorial/hands/New()
	..()
	var/list/handies = list()
	handies["gustatorial centre (right hand)"] = /obj/item/organ/internal/augment/gustatorial/hand
	handies["gustatorial centre (left hand)"] = /obj/item/organ/internal/augment/gustatorial/hand/left
	gear_tweaks += new /datum/gear_tweak/path(handies)

/datum/gear/augment/drill
	display_name = "integrated drill"
	description = "A mining drill integrated in the hand. The drill is heavy, so only industrial IPCs can use it."
	path = /obj/item/organ/internal/augment/tool/drill
	whitelisted = list(SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	allowed_roles = list("Shaft Miner")
	cost = 5
	sort_category = "Xenowear - IPC"

/datum/gear/augment/drill/New()
	..()
	var/list/augs = list()
	augs["integrated drill, right hand"] = /obj/item/organ/internal/augment/tool/drill
	augs["integrated drill, left hand"] = /obj/item/organ/internal/augment/tool/drill/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/accessory/syntheticcard
	display_name = "synthetic residence card"
	description = "An identification card given to free IPC residents within the Republic of Biesel."
	path = /obj/item/clothing/accessory/badge/passcard/synthetic
	cost = 0
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/gear/accessory/ipcmantle
	display_name = "Burzsian mantle"
	description = "A uniform mantle identifying Hephaestus IPC's from Burzsia. Operation history and specifications are printed underneath the tarp."
	path = /obj/item/clothing/accessory/poncho/ipc_mantle
	sort_category = "Xenowear - IPC"
	cost = 1
	whitelisted = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)