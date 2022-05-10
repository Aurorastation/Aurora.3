/datum/gear/faction
	display_name = "idris cap"
	path = /obj/item/clothing/head/softcap/idris
	slot = slot_head
	sort_category = "Factions"
	cost = 1
	faction = "Idris Incorporated"

/datum/gear/faction/idris_beret
	display_name = "idris beret"
	path = /obj/item/clothing/head/beret/corporate/idris
	faction = "Idris Incorporated"

/datum/gear/faction/idris_beret_alt
	display_name = "idris beret (alt)"
	path = /obj/item/clothing/head/beret/corporate/idris/alt
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
	path = /obj/item/clothing/head/beret/corporate/zavod/alt
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_beret/alt
	display_name = "brown zavodskoi beret"
	path = /obj/item/clothing/head/beret/corporate/zavod
	sort_category = "Factions"

/datum/gear/faction/zavodskoi_softcap
	display_name = "black zavodskoi cap"
	path = /obj/item/clothing/head/softcap/zavod/alt
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_softcap/alt
	display_name = "brown zavodskoi cap"
	path = /obj/item/clothing/head/softcap/zavod

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

/datum/gear/faction/pmc_beret
	display_name = "PMCG beret"
	path =  /obj/item/clothing/head/beret/corporate/pmc
	slot = slot_head
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_cap
	display_name = "PCMG cap"
	path = /obj/item/clothing/head/softcap/pmc
	slot = slot_head
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_sunglasses
	display_name = "PMCG security HUD selection"
	description = "A selection of PMCG security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/pmc
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_sunglasses/New()
	..()
	var/list/pmc_sunglasses = list()
	pmc_sunglasses["HUDsunglasses, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/pmc
	pmc_sunglasses["fat HUDsunglasses, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/big/pmc
	pmc_sunglasses["aviator sunglasses, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/pmc
	gear_tweaks += new /datum/gear_tweak/path(pmc_sunglasses)

/datum/gear/faction/pmc_labcoat
	display_name = "PMCG labcoat selection"
	description = "A selection of PMCG labcoats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	slot = slot_wear_suit
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_labcoat/New()
	..()
	var/list/pmc_labcoats = list()
	pmc_labcoats["labcoat, PMCG"] = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	pmc_labcoats["labcoat alt, PMCG"] = /obj/item/clothing/suit/storage/toggle/labcoat/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmc_labcoats)

/datum/gear/faction/zenghu_beret
	display_name = "Zeng-Hu beret selection"
	description = "A selection of Zeng-Hu berets."
	path = /obj/item/clothing/head/beret/corporate/zeng
	slot = slot_head
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_beret/New()
	..()
	var/list/zenghu_berets = list()
	zenghu_berets["beret, zeng-hu"] = /obj/item/clothing/head/beret/corporate/zeng
	zenghu_berets["beret alt, zeng-hu"] = /obj/item/clothing/head/beret/corporate/zeng/alt
	gear_tweaks += new /datum/gear_tweak/path(zenghu_berets)

/datum/gear/faction/zenghu_labcoat
	display_name = "zeng-hu coat selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_labcoat/New()
	..()
	var/list/masks = list()
	masks["zeng-hu labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	masks["zeng-hu labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	masks["zeng-hu first responder jacket"] = /obj/item/clothing/suit/storage/toggle/fr_jacket/zeng
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

/datum/gear/faction/zenghu_cloak
	display_name = "Zeng-Hu Jargon Division cloak"
	path = /obj/item/clothing/accessory/poncho/shouldercape/qeblak/zeng
	slot = slot_wear_suit
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
	display_name = "PMCG sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/erisec
	slot = slot_tie
	faction = "Private Military Contracting Group"

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
	path = /obj/item/clothing/head/beret/corporate/heph
	slot = slot_head
	faction = "Hephaestus Industries"

/datum/gear/faction/heph_passcard
	display_name = "hephaestus burzsia passcard"
	path = /obj/item/clothing/accessory/badge/passcard/burzsia
	slot = slot_tie
	faction = "Hephaestus Industries"
