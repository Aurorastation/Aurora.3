/datum/gear/accessory/dionae_sol_passcard
	display_name = "dionae sol passcard"
	description = "A passport issued to Dionae citizens of the Sol Alliance who have completed their assigned contract."
	path = /obj/item/clothing/accessory/badge/passcard/sol_diona
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_sol)

ABSTRACT_TYPE(/datum/gear/suit/diona)

/datum/gear/suit/diona/eternal
	display_name = "mesh weave robes"
	description = "A set of mesh weave robes worn almost exclusively by priests of the Orthodox Eternal faith."
	path = /obj/item/clothing/suit/diona/eternal
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/suit/diona/eternal/refined
	display_name = "eternal ceremonial robes"
	description = "A set of ceremonial robes used by various branches of the eternal faith."
	path = /obj/item/clothing/suit/diona/eternal/refined
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/suit/diona/eternal/iron
	display_name = "grey mesh weave robes"
	description = "A set of mesh weave robes worn almost exclusively by priests of the Iron Eternal faith."
	path = /obj/item/clothing/suit/diona/eternal/iron
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION

/datum/gear/suit/diona/eternal/blood
	display_name = "red mesh weave robes"
	description = "A set of red mesh weave robes worn almost exclusively by priests of the Blood Eternal faith."
	path = /obj/item/clothing/suit/diona/eternal/blood
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
	culture_restriction = list(/singleton/origin_item/culture/narrows)

/datum/gear/suit/narrows
	display_name = "antiquated hephaestus prison suit"
	description = "An old prison uniform decorated with colorful cloth dictating one's position within the narrows."
	path = /obj/item/clothing/suit/diona/narrows
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/narrows)

/datum/gear/head/narrows
	display_name = "narrows hardhat"
	description = "An old hard hat painted in Hephaestus colors, fabric hanging off the sides to protect the wearer's ears."
	path = /obj/item/clothing/head/hardhat/narrows
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/narrows)

/datum/gear/uniform/diona/hieroaetherian_tunic
	display_name = "traditional hieroaetherian tunic"
	description = "A traditional tunic worn on Hieroaetheria, made up of several colorful fabrics and adorned with a seemingly still-living, bioluminescent Starvine."
	path = /obj/item/clothing/under/diona/hieroaetherian_tunic
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/uniform/diona/ekane
	display_name = "woven ekane dress"
	description = "A blue, seemingly high-quality dress with a colorful strap of fabric running along it, typically seen by Dionae hailing from the Hieroaetherian Ekane."
	path = /obj/item/clothing/under/diona/ekane
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/head/ekane
	display_name = "feather cap"
	description = "A simple hat adorned with colorful feathers across its surface. Despite the design, wearers will feel the heat of the sun greater than without."
	path = /obj/item/clothing/head/diona/ekane
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/head/ekane/decorated
	display_name = "decorated feather cap"
	description = "A decorated hat adorned with colorful feathers across its surface. Despite the design, wearers will feel the heat of the sun greater than without."
	path = /obj/item/clothing/head/diona/ekane/decorated
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/suit/ekane
	display_name = "ekane feathered jacket"
	description = "A blue set of clothing mimicking a jacket, adorned with feathers along the jacket's collar, sleeves, and chest. While not exclusive, the jacket is typically worn by Ekane Dionae in more laborious positions."
	path = /obj/item/clothing/suit/diona/ekane
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/suit/ekane_cloak
	display_name = "ekane feathered cloak"
	description = "A colorful cloak featuring a myriad of feathers adorned across its surface. While not exclusive, the cloak is typically worn by Ekane Dionae in more higher-end & skilled positions."
	path = /obj/item/clothing/accessory/poncho/ekane_cloak
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/suit/hieroaetherian_poncho
	display_name = "hieroaetherian poncho"
	description = "A Hieroaetherian poncho made of some sort of mesh weave material, adorned by a piece of colored fabric wrapped around it that denotes their home nation."
	path = /obj/item/clothing/accessory/poncho/hieroaetherian_poncho
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/hieroaetheria)

/datum/gear/suit/diona/carp
	display_name = "carp hide poncho"
	description = "A poncho made up of carp hide."
	path = /obj/item/clothing/suit/diona/carp
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/head/diona/voidtamer
	display_name = "closed voidtamer hood"
	description = "A hood made of aged and tanned carp hide and gold, worn by various Voidtamer factions."
	path = /obj/item/clothing/head/diona/voidtamer
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_voidtamer)

/datum/gear/head/diona/voidtamer/open
	display_name = "open voidtamer hood"
	description = "A hood made of aged and tanned carp hide and gold, worn by various Voidtamer factions. This one is open, exposing the face."
	path = /obj/item/clothing/head/diona/voidtamer/open
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/voidtamer
	display_name = "voidtamer jacket"
	description = "A jacket made of woven carp hide and adorned with gold, typically worn by various voidtamer-aligned factions."
	path = /obj/item/clothing/accessory/poncho/voidtamer
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/voidtamer/apron
	display_name = "voidtamer apron"
	description = "A apron made of woven carp hide and adorned with gold, typically worn by various voidtamer-aligned factions."
	path = /obj/item/clothing/accessory/poncho/voidtamer/apron
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/voidtamer/vest
	display_name = "voidtamer vest"
	description = "A vest made of woven carp hide and adorned with gold, typically worn by various voidtamer-aligned factions."
	path = /obj/item/clothing/accessory/poncho/voidtamer/vest
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/diona_voidtamer)

//skrell shared things

/datum/gear/accessory/capes/diona
	display_name = "dionae shoulder capes"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

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
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/hieroaetheria, /singleton/origin_item/culture/xrim)

/datum/gear/accessory/weishii/diona
	display_name = "dionae weishii robe"
	path = /obj/item/clothing/accessory/poncho/shouldercape/weishiirobe
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/hieroaetheria, /singleton/origin_item/culture/xrim)

/datum/gear/skrell_projector/diona
	display_name = "dionae nralakk projector"
	path = /obj/item/skrell_projector
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

/datum/gear/homeworld_deck/diona
	display_name = "dionae qweipaqui homeworld deck"
	path = /obj/item/deck/tarot/nralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

/datum/gear/colonist_deck/diona // Intentionally separate from homeworld_deck, so that both can be chosen. -Lly
	display_name = "dionae qweipaqui colonist deck"
	path = /obj/item/deck/tarot/nonnralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

ABSTRACT_TYPE(/datum/gear/accessory/diona)

/datum/gear/accessory/diona/skrell_passport
	display_name = "dionae nralakk federation passport"
	path = /obj/item/clothing/accessory/badge/passport/nralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	cost = 1
	flags = GEAR_NO_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

/datum/gear/accessory/diona/skrell_passport/New()
	. = ..()
	gear_tweaks += list(GLOB.compat_index_tweak)

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

/datum/gear/uniform/diona/work
	display_name = "dionae work uniforms"
	path = /obj/item/clothing/under/skrell/nralakk
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

/datum/gear/uniform/diona/work/New()
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

/datum/gear/suit/diona/jacket
	display_name = "dionae work jackets"
	path = /obj/item/clothing/suit/storage/toggle/skrell
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

/datum/gear/suit/diona/jacket/New()
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
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

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
	culture_restriction = list(/singleton/origin_item/culture/dionae_nralakk, /singleton/origin_item/culture/xrim)

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
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/sash/diona
	display_name = "dionae gyazo belt"
	path = /obj/item/clothing/accessory/unathi
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/unathi_mantle/diona
	display_name = "dionae peasant hide mantle selection"
	description = "A selection of hide mantles, one for each of the desert, and mountainous \
	regions of Moghes. The forest mantle is exclusively for nobility these days."
	path = /obj/item/clothing/accessory/poncho/unathimantle
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

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
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/unathi_robe/kilt/diona
	display_name = "dionae wasteland kilt"
	path = /obj/item/clothing/suit/unathi/robe/kilt
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	origin_restriction = list(/singleton/origin_item/origin/dionae_wasteland, /singleton/origin_item/origin/rokz, /singleton/origin_item/origin/serz)

/datum/gear/head/sinta_ronin/diona
	display_name = "dionae straw hat"
	path = /obj/item/clothing/head/unathi
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/suit/robe_coat/diona
	display_name = "dionae tzirzi robe"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/eyes/wasteland_goggles/diona
	display_name = "dionae wasteland goggles"
	path = /obj/item/clothing/glasses/safety/goggles/wasteland
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/singleton/origin_item/origin/dionae_wasteland, /singleton/origin_item/origin/rokz, /singleton/origin_item/origin/serz)
	sort_category = "Xenowear - Diona"

/datum/gear/uniform/diona/zozo
	display_name = "dionae zozo top"
	path = /obj/item/clothing/under/unathi/zozo
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dionae_moghes, /singleton/origin_item/culture/diona_voidtamer)

/datum/gear/uniform/diona/rockstone
	display_name = "dionae rockstone cape"
	path = /obj/item/clothing/accessory/poncho/rockstone
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/singleton/origin_item/origin/viridis_noble)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/suit/diona/noble_vest
	display_name = "dionae jokfar vest"
	path = /obj/item/clothing/suit/unathi/jokfar
	cost = 1
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/singleton/origin_item/origin/viridis_noble)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/diona/maxtlatl
	display_name = "diona Thakhist headgear"
	path = /obj/item/clothing/head/unathi/maxtlatl
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allowed_roles = list("Chaplain")
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/diona/mogazali
	display_name = "diona mogazali attire"
	path = /obj/item/clothing/under/unathi/mogazali
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/singleton/origin_item/origin/viridis_noble)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/diona/mogazali/New()
	..()
	var/list/mogazali = list()
	mogazali["mogazali attire, red"] = /obj/item/clothing/under/unathi/mogazali
	mogazali["mogazali attire, blue"] = /obj/item/clothing/under/unathi/mogazali/blue
	mogazali["mogazali attire, green"] = /obj/item/clothing/under/unathi/mogazali/green
	mogazali["mogazali attire, orange"] = /obj/item/clothing/under/unathi/mogazali/orange
	gear_tweaks += new /datum/gear_tweak/path(mogazali)

/datum/gear/uniform/diona/jizixi
	display_name = "dionae jizixi dress"
	path = /obj/item/clothing/under/unathi/jizixi
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	origin_restriction = list(/singleton/origin_item/origin/viridis_noble)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/diona/jizixi/New()
	..()
	var/list/jizixi = list()
	jizixi["jizixi dress, red"] = /obj/item/clothing/under/unathi/jizixi
	jizixi["jizixi dress, green"] = /obj/item/clothing/under/unathi/jizixi/green
	jizixi["jizixi dress, blue"] = /obj/item/clothing/under/unathi/jizixi/blue
	jizixi["jizixi dress, white"] = /obj/item/clothing/under/unathi/jizixi/white
	jizixi["jizixi dress, orange"] = /obj/item/clothing/under/unathi/jizixi/orange
	jizixi["jizixi dress, black"] = /obj/item/clothing/under/unathi/jizixi/black
	gear_tweaks += new /datum/gear_tweak/path(jizixi)

/datum/gear/uniform/diona/jizixi_colorable
	display_name = "jizixi dress (colorable)"
	path = /obj/item/clothing/under/unathi/jizixi/colorable
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/uniform/diona/jizixi_colorable/New()
	..()
	var/list/jizixi_colorable = list()
	jizixi_colorable["jizixi dress, colorable"] = /obj/item/clothing/under/unathi/jizixi/colorable
	jizixi_colorable["jizixi dress, pattern 1"] = /obj/item/clothing/under/unathi/jizixi/colorable/accent1
	jizixi_colorable["jizixi dress, pattern 2"] = /obj/item/clothing/under/unathi/jizixi/colorable/accent2
	jizixi_colorable["jizixi dress, pattern 3"] = /obj/item/clothing/under/unathi/jizixi/colorable/accent3
	jizixi_colorable["jizixi dress, pattern 4"] = /obj/item/clothing/under/unathi/jizixi/colorable/accent4
	jizixi_colorable["jizixi dress, pattern 5"] = /obj/item/clothing/under/unathi/jizixi/colorable/accent5
	gear_tweaks += new /datum/gear_tweak/path(jizixi_colorable)

/datum/gear/accessory/consortium_passport
	display_name = "consortium of hieroaetheria passport"
	path = /obj/item/clothing/accessory/badge/passport/consortium
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	sort_category = "Xenowear - Diona"

/datum/gear/accessory/alt_consortium_passport
	display_name = "non-consortium hieroaetherian passport selection"
	path = /obj/item/clothing/accessory/badge/passport/dionaunion
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"

/datum/gear/accessory/alt_consortium_passport/New()
	..()
	var/list/diona_passport = list()
	diona_passport["union of gla'orr passport"] = /obj/item/clothing/accessory/badge/passport/dionaunion
	diona_passport["eternal republic of the ekane passport"] = /obj/item/clothing/accessory/badge/passport/eternalrepublic
	gear_tweaks += new /datum/gear_tweak/path(diona_passport)

/datum/gear/diet_diesel
	display_name = "diet diesel jar"
	path = /obj/item/reagent_containers/food/condiment/diet_diesel
	whitelisted = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	sort_category = "Xenowear - Diona"
