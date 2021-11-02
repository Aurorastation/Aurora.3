/datum/gear/faction
	display_name = "idris cap"
	path = /obj/item/clothing/head/softcap/security/idris
	slot = slot_head
	sort_category = "Factions"
	cost = 1
	faction = "Idris Incorporated"

/datum/gear/faction/idris_beret
	display_name = "idris beret"
	path = /obj/item/clothing/head/beret/security/idris
	faction = "Idris Incorporated"

/datum/gear/faction/idris_beret_alt
	display_name = "idris beret (alt)"
	path = /obj/item/clothing/head/beret/security/idris/alt
	faction = "Idris Incorporated"

/datum/gear/faction/idris_uniform_alt
	display_name = "idris service skirt"
	description = "Not for security usage."
	path = /obj/item/clothing/under/rank/idris/service/alt
	slot = slot_w_uniform
	faction = "Idris Incorporated"

/datum/gear/faction/idris_armband
	display_name = "idris armband"
	path = /obj/item/clothing/accessory/armband/idris
	slot = slot_tie
	faction = "Idris Incorporated"

/datum/gear/faction/idris_windbreaker
	display_name = "idris jacket"
	path = /obj/item/clothing/suit/storage/toggle/idris
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/idris_passcard
	display_name = "idris silversun passcard"
	path = /obj/item/clothing/accessory/badge/passcard/sol/silversun
	slot = slot_tie
	faction = "Idris Incorporated"

/datum/gear/faction/idris_rag
	display_name = "idris advanced service cloth"
	path = /obj/item/reagent_containers/glass/rag/advanced/idris
	slot = slot_in_backpack
	faction = "Idris Incorporated"

/datum/gear/faction/idris_sunglasses
	display_name = "idris security HUD selection"
	description = "A selection of Idris security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/idris
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	faction = "Idris Incorporated"

/datum/gear/faction/idris_sunglasses/New()
	..()
	var/list/idris_sunglasses = list()
	idris_sunglasses["HUDsunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/idris
	idris_sunglasses["fat HUDsunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/big/idris
	idris_sunglasses["aviator sunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/idris
	gear_tweaks += new /datum/gear_tweak/path(idris_sunglasses)

/datum/gear/faction/idris_labcoat
	display_name = "idris labcoat selection"
	description = "A selection of Idris labcoats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/idris
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/idris_labcoat/New()
	..()
	var/list/idris_labcoats = list()
	idris_labcoats["labcoat, Idris"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris
	idris_labcoats["labcoat, Idris alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_labcoats)

/datum/gear/faction/zavodskoi_beret
	display_name = "black zavodskoi beret"
	path = /obj/item/clothing/head/beret/security/zavodskoi
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_beret/alt
	display_name = "brown zavodskoi beret"
	path = /obj/item/clothing/head/beret/security/zavodskoi/alt
	sort_category = "Factions"

/datum/gear/faction/zavodskoi_softcap
	display_name = "black zavodskoi cap"
	path = /obj/item/clothing/head/softcap/zavod
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_softcap/alt
	display_name = "brown zavodskoi cap"
	path = /obj/item/clothing/head/softcap/zavod/alt

/datum/gear/faction/zavodskoi_uniform_alt
	display_name = "brown zavodskoi uniform"
	path = /obj/item/clothing/under/rank/security/zavodskoi/alt
	slot = slot_w_uniform
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_research_alt
	display_name = "brown zavodskoi research uniform"
	path = /obj/item/clothing/under/rank/zavodskoi/research/alt
	slot = slot_w_uniform
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_labcoat
	display_name = "zavodskoi labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavod_sunglasses
	display_name = "zavodskoi security HUD selection"
	description = "A selection of Zavodskoi security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavod_sunglasses/New()
	..()
	var/list/zavod_sunglasses = list()
	zavod_sunglasses["HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	zavod_sunglasses["fat HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/big/zavod
	zavod_sunglasses["aviator sunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/zavod
	gear_tweaks += new /datum/gear_tweak/path(zavod_sunglasses)

/datum/gear/faction/eridani_beret
	display_name = "eridani beret"
	path = /obj/item/clothing/head/beret/security/eri
	slot = slot_head
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/eridani_cap
	display_name = "eridani cap"
	path = /obj/item/clothing/head/softcap/eri
	slot = slot_head
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/epmc_sunglasses
	display_name = "EPMC security HUD selection"
	description = "A selection of EPMC security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/epmc
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/epmc_sunglasses/New()
	..()
	var/list/epmc_sunglasses = list()
	epmc_sunglasses["HUDsunglasses, EPMC"] = /obj/item/clothing/glasses/sunglasses/sechud/epmc
	epmc_sunglasses["fat HUDsunglasses, EPMC"] = /obj/item/clothing/glasses/sunglasses/sechud/big/epmc
	epmc_sunglasses["aviator sunglasses, EPMC"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/epmc
	gear_tweaks += new /datum/gear_tweak/path(epmc_sunglasses)

/datum/gear/faction/epmc_labcoat
	display_name = "EPMC labcoat selection"
	description = "A selection of EPMC labcoats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/epmc
	slot = slot_wear_suit
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/epmc_labcoat/New()
	..()
	var/list/epmc_labcoats = list()
	epmc_labcoats["security labcoat, EPMC"] = /obj/item/clothing/suit/storage/toggle/labcoat/epmc
	epmc_labcoats["security labcoat alt, EPMC"] = /obj/item/clothing/suit/storage/toggle/labcoat/epmc/alt
	epmc_labcoats["medical labcoat, EPMC"] = /obj/item/clothing/suit/storage/toggle/labcoat/epmc/med
	gear_tweaks += new /datum/gear_tweak/path(epmc_labcoats)

/datum/gear/faction/zenghu_uniform_alt
	display_name = "zeng-hu white uniform"
	path = /obj/item/clothing/under/rank/zeng/alt
	slot = slot_w_uniform
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_beret
	display_name = "purple zeng-hu beret"
	path = /obj/item/clothing/head/beret/zeng
	slot = slot_head
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_beret_alt
	display_name = "white zeng-hu beret"
	path = /obj/item/clothing/head/beret/zeng/alt
	slot = slot_head
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_labcoat
	display_name = "zeng-hu labcoat selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_labcoat/New()
	..()
	var/list/masks = list()
	masks["zeng-hu labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	masks["zeng-hu labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	gear_tweaks += new /datum/gear_tweak/path(masks)

/datum/gear/faction/zenghu_apron
	display_name = "zeng-hu vinyl apron"
	path = /obj/item/clothing/suit/apron/surgery/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_gloves
	display_name = "zeng-hu vinyl gloves"
	path = /obj/item/clothing/gloves/zeng
	slot = slot_gloves
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zavodskoi_patch
	display_name = "zavodskoi sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/zavodskoi
	slot = slot_tie
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoisec_patch
	display_name = "zavodskoi security sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/zavodskoisec
	slot = slot_tie
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Security Officer","Investigator","Warden")

/datum/gear/faction/erisec_patch
	display_name = "EPMC sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/erisec
	slot = slot_tie
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/idrissec_patch
	display_name = "idris security sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/idrissec
	faction = "Idris Incorporated"
	slot = slot_tie
	allowed_roles = list("Security Officer","Investigator")

/datum/gear/faction/heph_labcoat
	display_name = "hephaestus labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	slot = slot_wear_suit
	faction = "Hephaestus Industries"

/datum/gear/faction/heph_beret
	display_name = "hephaestus beret"
	path = /obj/item/clothing/head/beret/heph
	slot = slot_head
	faction = "Hephaestus Industries"

/datum/gear/faction/heph_passcard
	display_name = "hephaestus burszia passcard"
	path = /obj/item/clothing/accessory/badge/passcard/burszia
	slot = slot_tie
	faction = "Hephaestus Industries"
