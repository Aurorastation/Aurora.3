/datum/gear/accessory/dionae_sol_passcard
	display_name = "dionae sol passcard"
	description = "A passport issued to Dionae citizens of the Sol Alliance who have completed their assigned contract."
	path = /obj/item/clothing/accessory/badge/passcard/sol_diona
	cost = 0
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/suit/diona/eternal
	display_name = "mesh weave robes"
	description = "A set of mesh weave robes worn almost exclusively by priests of the Orthodox Eternal faith."
	path = /obj/item/clothing/suit/diona/eternal
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/suit/diona/eternal/iron
	display_name = "grey mesh weave robes"
	description = "A set of mesh weave robes worn almost exclusively by priests of the Iron Eternal faith."
	path = /obj/item/clothing/suit/diona/eternal/iron
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/uniform/diona/narrows
	display_name = "antiquated hephaestus prison uniform"
	description = "An old prison uniform, tattered with age. A Hephaestus logo has been haphazardly stitched to the shoulder, and a band of green circles around the middle."
	path = /obj/item/clothing/under/diona/narrows
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	
//skrell shared things

/datum/gear/accessory/capes
	display_name = "shoulder capes"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/accessory/capes/New()
	..()
	var/list/capes = list()
	capes["star cape"] = /obj/item/clothing/accessory/poncho/shouldercape/star
	capes["nebula cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nebula
	capes["nova cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nova
	capes["galaxy cape"] = /obj/item/clothing/accessory/poncho/shouldercape/galaxy
	gear_tweaks += new /datum/gear_tweak/path(capes)

/datum/gear/accessory/qeblak
	display_name = "qeblak mantle"
	path = /obj/item/clothing/accessory/poncho/shouldercape/qeblak
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/accessory/weishii
	display_name = "weishii robe"
	path = /obj/item/clothing/accessory/poncho/shouldercape/weishiirobe
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/skrell_projector
	display_name = "nralakk projector"
	path = /obj/item/skrell_projector
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/homeworld_deck
	display_name = "qweipaqui homeworld deck"
	path = /obj/item/deck/tarot/jargon
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/colonist_deck // Intentionally separate from homeworld_deck, so that both can be chosen. -Lly
	display_name = "qweipaqui colonist deck"
	path = /obj/item/deck/tarot/nonjargon
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	
/datum/gear/accessory/skrell_passport
	display_name = "jargon federation passport"
	path = /obj/item/clothing/accessory/badge/passport/jargon
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 0
	flags = GEAR_NO_SELECTION
	
/datum/gear/accessory/skrell_passport/check_species_whitelist(mob/living/carbon/human/H)
	var/static/list/species_list = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	if(H.species.name in species_list)
		return TRUE
	return FALSE

/datum/gear/accessory/skrell_passport/spawn_item(location, metadata, mob/living/carbon/human/H)
	var/obj/item/clothing/accessory/badge/passport/jargon/J = ..()
	var/static/list/species_name_to_tag = list(, SPECIES_DIONA = "_d", SPECIES_DIONA_COEUS = "_d")
	var/tag = species_name_to_tag[H.species.name]
	if(tag)
		J.species_tag = tag
	return J
	
/datum/gear/uniform/skrell/work
	display_name = "work uniforms"
	path = /obj/item/clothing/under/skrell/jargon
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	flags = GEAR_HAS_DESC_SELECTION
	
/datum/gear/uniform/skrell/work/New()
	..()
	var/list/outfit = list()
	outfit["ox research"] = /obj/item/clothing/under/skrell/jargon
	outfit["ox security"] = /obj/item/clothing/under/skrell/jargon/ox
	outfit["ox engineer"] = /obj/item/clothing/under/skrell/jargon/ox/engineer
	outfit["ox service"] = /obj/item/clothing/under/skrell/jargon/ox/service
	outfit["ox medical"] = /obj/item/clothing/under/skrell/jargon/ox/med
	outfit["ix research"] = /obj/item/clothing/under/skrell/jargon/ix
	outfit["ix security"] = /obj/item/clothing/under/skrell/jargon/ix/security
	outfit["ix engineer"] = /obj/item/clothing/under/skrell/jargon/ix/engineer
	outfit["ix service"] = /obj/item/clothing/under/skrell/jargon/ix/service
	outfit["ix medical"] = /obj/item/clothing/under/skrell/jargon/ix/med
	outfit["oqi research"] = /obj/item/clothing/under/skrell/jargon/oqi
	outfit["oqi security"] = /obj/item/clothing/under/skrell/jargon/oqi/security
	outfit["oqi engineer"] = /obj/item/clothing/under/skrell/jargon/oqi/engineer
	outfit["oqi service"] = /obj/item/clothing/under/skrell/jargon/oqi/service
	outfit["oqi medical"] = /obj/item/clothing/under/skrell/jargon/oqi/med
	outfit["iqi research"] = /obj/item/clothing/under/skrell/jargon/iqi
	outfit["iqi security"] = /obj/item/clothing/under/skrell/jargon/iqi/security
	outfit["iqi engineer"] = /obj/item/clothing/under/skrell/jargon/iqi/engineer
	outfit["iqi service"] = /obj/item/clothing/under/skrell/jargon/iqi/service
	outfit["iqi medical"] = /obj/item/clothing/under/skrell/jargon/iqi/med
	gear_tweaks += new /datum/gear_tweak/path(outfit)
	
/datum/gear/suit/skrell/jacket
	display_name = "work jackets"
	path = /obj/item/clothing/suit/storage/toggle/skrell
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/skrell/jacket/New()
	..()
	var/list/jacket = list()
	jacket["ox research"] = /obj/item/clothing/suit/storage/toggle/skrell
	jacket["ox bridge/security"] = /obj/item/clothing/suit/storage/toggle/skrell/ox/security
	jacket["ox engineer"] = /obj/item/clothing/suit/storage/toggle/skrell/ox/engineer
	jacket["ox cargo/service"] = /obj/item/clothing/suit/storage/toggle/skrell/ox/service
	jacket["ox medical"] = /obj/item/clothing/suit/storage/toggle/skrell/ox/med
	jacket["ix research"] = /obj/item/clothing/suit/storage/toggle/skrell/ix
	jacket["ix bridge/security"] = /obj/item/clothing/suit/storage/toggle/skrell/ix/security
	jacket["ix engineer"] = /obj/item/clothing/suit/storage/toggle/skrell/ix/engineer
	jacket["ix cargo/service"] = /obj/item/clothing/suit/storage/toggle/skrell/ix/service
	jacket["ix medical"] = /obj/item/clothing/suit/storage/toggle/skrell/ix/med
	jacket["oqi research"] = /obj/item/clothing/suit/storage/toggle/skrell/oqi
	jacket["oqi bridge/security"] = /obj/item/clothing/suit/storage/toggle/skrell/oqi/security
	jacket["oqi engineer"] = /obj/item/clothing/suit/storage/toggle/skrell/oqi/engineer
	jacket["oqi cargo/service"] = /obj/item/clothing/suit/storage/toggle/skrell/oqi/service
	jacket["oqi medical"] = /obj/item/clothing/suit/storage/toggle/skrell/oqi/med
	jacket["iqi research"] = /obj/item/clothing/suit/storage/toggle/skrell/iqi
	jacket["iqi bridge/security"] = /obj/item/clothing/suit/storage/toggle/skrell/iqi/security
	jacket["iqi engineer"] = /obj/item/clothing/suit/storage/toggle/skrell/iqi/engineer
	jacket["iqi cargo/service"] = /obj/item/clothing/suit/storage/toggle/skrell/iqi/service
	jacket["iqi medical"] = /obj/item/clothing/suit/storage/toggle/skrell/iqi/med
	gear_tweaks += new /datum/gear_tweak/path(jacket)
	
/datum/gear/accessory/skrell/poncho
	display_name = "skrell poncho"
	path = /obj/item/clothing/accessory/poncho/skrell
	whitelisted = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_BULWARK)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/skrell/poncho/New()
	..()
	var/list/poncho = list()
	poncho["brown"] = /obj/item/clothing/accessory/poncho/skrell/brown
	poncho["tan"] = /obj/item/clothing/accessory/poncho/skrell/tan
	poncho["gray"] = /obj/item/clothing/accessory/poncho/skrell/gray
	poncho["white"] = /obj/item/clothing/accessory/poncho/skrell
	gear_tweaks += new /datum/gear_tweak/path(poncho)

/datum/gear/accessory/skrell/workcloak
	display_name = "work cloaks"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/skrell/workcloak/New()
	..()
	var/list/workcloak = list()
	workcloak["ox cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak
	workcloak["ix cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/ix
	workcloak["oqi cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	workcloak["iqi cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/iqi
	gear_tweaks += new /datum/gear_tweak/path(workcloak)
