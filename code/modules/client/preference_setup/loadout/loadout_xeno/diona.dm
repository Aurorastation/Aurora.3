/datum/gear/accessory/dionae_sol_passcard
	display_name = "dionae sol passcard"
	description = "A passport issued to Dionae citizens of the Sol Alliance who have completed their assigned contract."
	path = /obj/item/clothing/accessory/badge/passcard/sol_diona
	cost = 0
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/decl/origin_item/culture/diona_sol)

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
	culture_restriction = list(/decl/origin_item/culture/narrows)
	
//skrell shared things

/datum/gear/accessory/capes/diona
	display_name = "dionae shoulder capes"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/accessory/capes/diona/New()
	..()
	var/list/capes = list()
	capes["star cape"] = /obj/item/clothing/accessory/poncho/shouldercape/star
	capes["nebula cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nebula
	capes["nova cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nova
	capes["galaxy cape"] = /obj/item/clothing/accessory/poncho/shouldercape/galaxy
	gear_tweaks += new /datum/gear_tweak/path(capes)

/datum/gear/accessory/qeblak/diona
	display_name = "dionae qeblak mantle"
	path = /obj/item/clothing/accessory/poncho/shouldercape/qeblak
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/accessory/weishii/diona
	display_name = "dionae weishii robe"
	path = /obj/item/clothing/accessory/poncho/shouldercape/weishiirobe
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/skrell_projector/diona
	display_name = "dionae nralakk projector"
	path = /obj/item/skrell_projector
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim)

/datum/gear/homeworld_deck/diona
	display_name = "dionae qweipaqui homeworld deck"
	path = /obj/item/deck/tarot/nralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/colonist_deck/diona // Intentionally separate from homeworld_deck, so that both can be chosen. -Lly
	display_name = "dionae qweipaqui colonist deck"
	path = /obj/item/deck/tarot/nonnralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 
	
/datum/gear/accessory/skrell_passport/diona
	display_name = "dionae nralakk federation passport"
	path = /obj/item/clothing/accessory/badge/passport/nralakk
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 0
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 
	
/datum/gear/accessory/diona/skrell_passport/check_species_whitelist(mob/living/carbon/human/H)
	var/static/list/species_list = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	if(H.species.name in species_list)
		return TRUE
	return FALSE

/datum/gear/accessory/diona/skrell_passport/spawn_item(location, metadata, mob/living/carbon/human/H)
	var/obj/item/clothing/accessory/badge/passport/nralakk/J = ..()
	var/static/list/species_name_to_tag = list(, SPECIES_DIONA = "_d", SPECIES_DIONA_COEUS = "_d")
	var/tag = species_name_to_tag[H.species.name]
	if(tag)
		J.species_tag = tag
	return J
	
/datum/gear/uniform/work/diona
	display_name = "dionae work uniforms"
	path = /obj/item/clothing/under/skrell/nralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 
	
/datum/gear/uniform/work/diona/New()
	..()
	var/list/outfit = list()
	outfit["ox research"] = /obj/item/clothing/under/skrell/nralakk
	outfit["ox security"] = /obj/item/clothing/under/skrell/nralakk/ox
	outfit["ox engineer"] = /obj/item/clothing/under/skrell/nralakk/ox/engineer
	outfit["ox service"] = /obj/item/clothing/under/skrell/nralakk/ox/service
	outfit["ox medical"] = /obj/item/clothing/under/skrell/nralakk/ox/med
	outfit["ix research"] = /obj/item/clothing/under/skrell/nralakk/ix
	outfit["ix security"] = /obj/item/clothing/under/skrell/nralakk/ix/security
	outfit["ix engineer"] = /obj/item/clothing/under/skrell/nralakk/ix/engineer
	outfit["ix service"] = /obj/item/clothing/under/skrell/nralakk/ix/service
	outfit["ix medical"] = /obj/item/clothing/under/skrell/nralakk/ix/med
	outfit["oqi research"] = /obj/item/clothing/under/skrell/nralakk/oqi
	outfit["oqi security"] = /obj/item/clothing/under/skrell/nralakk/oqi/security
	outfit["oqi engineer"] = /obj/item/clothing/under/skrell/nralakk/oqi/engineer
	outfit["oqi service"] = /obj/item/clothing/under/skrell/nralakk/oqi/service
	outfit["oqi medical"] = /obj/item/clothing/under/skrell/nralakk/oqi/med
	outfit["iqi research"] = /obj/item/clothing/under/skrell/nralakk/iqi
	outfit["iqi security"] = /obj/item/clothing/under/skrell/nralakk/iqi/security
	outfit["iqi engineer"] = /obj/item/clothing/under/skrell/nralakk/iqi/engineer
	outfit["iqi service"] = /obj/item/clothing/under/skrell/nralakk/iqi/service
	outfit["iqi medical"] = /obj/item/clothing/under/skrell/nralakk/iqi/med
	gear_tweaks += new /datum/gear_tweak/path(outfit)
	
/datum/gear/suit/jacketdiona/
	display_name = "dionae work jackets"
	path = /obj/item/clothing/suit/storage/toggle/skrell
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/suit/jacket/diona/New()
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
	
/datum/gear/accessory/diona/poncho
	display_name = "dionae skrell poncho"
	path = /obj/item/clothing/accessory/poncho/skrell
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/accessory/diona/poncho/New()
	..()
	var/list/poncho = list()
	poncho["brown"] = /obj/item/clothing/accessory/poncho/skrell/brown
	poncho["tan"] = /obj/item/clothing/accessory/poncho/skrell/tan
	poncho["gray"] = /obj/item/clothing/accessory/poncho/skrell/gray
	poncho["white"] = /obj/item/clothing/accessory/poncho/skrell
	gear_tweaks += new /datum/gear_tweak/path(poncho)

/datum/gear/accessory/diona/workcloak
	display_name = "dionae work cloaks"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_nralakk, /decl/origin_item/culture/eum, /decl/origin_item/culture/xrim) 

/datum/gear/accessory/diona/workcloak/New()
	..()
	var/list/workcloak = list()
	workcloak["ox cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak
	workcloak["ix cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/ix
	workcloak["oqi cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	workcloak["iqi cloak"] = /obj/item/clothing/accessory/poncho/shouldercape/cloak/iqi
	gear_tweaks += new /datum/gear_tweak/path(workcloak)
	
//unathi shared things

/datum/gear/accessory/sinta_hood/diona
	display_name = "dionae clan hood"
	slot = slot_head
	path = /obj/item/clothing/accessory/sinta_hood
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
	
/datum/gear/suit/sash/diona
	display_name = "dionae gyazo belt"
	path = /obj/item/clothing/accessory/unathi
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)

/datum/gear/suit/unathi_mantle/diona
	display_name = "dionae peasant hide mantle selection"
	description = "A selection of hide mantles, one for each of the desert, and mountainous \
	regions of Moghes. The forest mantle is exclusively for nobility these days."
	path = /obj/item/clothing/accessory/poncho/unathimantle
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)

/datum/gear/suit/unathi_mantle/diona/New()
	..()
	var/list/mantles = list()
	mantles["hide mantle, desert"] = /obj/item/clothing/accessory/poncho/unathimantle
	mantles["hide mantle, mountain"] = /obj/item/clothing/accessory/poncho/unathimantle/mountain
	gear_tweaks += new /datum/gear_tweak/path(mantles)
	
/datum/gear/suit/unathi_robe/diona
	display_name = "dionae roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
	
/datum/gear/suit/unathi_robe/kilt/diona
	display_name = "dionae wasteland kilt"
	path = /obj/item/clothing/suit/unathi/robe/kilt
	origin_restriction = list(/decl/origin_item/origin/dionae_wasteland)

/datum/gear/uniform/unathi/diona
	display_name = "dionae sinta tunic"
	path = /obj/item/clothing/under/unathi
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
	
/datum/gear/head/sinta_ronin/diona
	display_name = "dionae straw hat"
	path = /obj/item/clothing/head/unathi
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
	
/datum/gear/suit/robe_coat/diona
	display_name = "dionae tzirzi robe"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
	
/datum/gear/eyes/wasteland_goggles/diona
	display_name = "dionae wasteland goggles"
	path = /obj/item/clothing/glasses/safety/goggles/wasteland
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/decl/origin_item/origin/dionae_wasteland)
	sort_category = "Xenowear - Diona"
	
/datum/gear/uniform/diona/zozo
	display_name = "dionae zozo top"
	path = /obj/item/clothing/under/unathi/zozo
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/decl/origin_item/culture/dionae_moghes)
