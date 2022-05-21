// Idris

/datum/gear/uniform/surplusidris
	display_name = "surplus idris security uniform selection"
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	path = /obj/item/clothing/under/surplus/idris
	faction = "Idris Incorporated"

/datum/gear/uniform/surplusidris/New()
	..()
	var/list/surplusidris = list()
	surplusidris["surplus idris security uniform"] = /obj/item/clothing/under/surplus/idris
	surplusidris["surplus idris security uniform, alt"] = /obj/item/clothing/under/surplus/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(surplusidris)

/datum/gear/faction
	display_name = "idris armband"
	path = /obj/item/clothing/accessory/armband/idris
	slot = slot_tie
	sort_category = "Factions"
	cost = 1
	faction = "Idris Incorporated"

/datum/gear/faction/idris_hats
	display_name = "Zavodskoi beret selection"
	description = "A selection of Zavodskoi hats."
	path =  /obj/item/clothing/head/beret/corporate/zavod
	slot = slot_head
	faction = "Idris Incorporated"

/datum/gear/faction/idris_hats/New()
	..()
	var/list/idris_hats = list()
	idris_hats["idris beret"] = /obj/item/clothing/head/beret/corporate/idris
	idris_hats["idris beret, alt"] = /obj/item/clothing/head/beret/corporate/idris/alt
	idris_hats["idris softcap"] = /obj/item/clothing/head/softcap/idris
	idris_hats["idris softcap, alt"] = /obj/item/clothing/head/softcap/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_hats)

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

//Zavodskoi

/datum/gear/uniform/surpluszavod
	display_name = "surplus zavodskoi security uniform selection"
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	path = /obj/item/clothing/under/surplus/zavod
	faction = "Zavodskoi Interstellar"

/datum/gear/uniform/surpluszavod/New()
	..()
	var/list/surpluszavod = list()
	surpluszavod["surplus zavodskoi security uniform"] = /obj/item/clothing/under/surplus/zavod
	surpluszavod["surplus zavodskoi security uniform, alt"] = /obj/item/clothing/under/surplus/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(surpluszavod)

/datum/gear/faction/zavod_hats
	display_name = "Zavodskoi beret selection"
	description = "A selection of Zavodskoi hats."
	path =  /obj/item/clothing/head/beret/corporate/zavod
	slot = slot_head
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavod_hats/New()
	..()
	var/list/zavod_hats = list()
	zavod_hats["zavodskoi beret"] = /obj/item/clothing/head/beret/corporate/zavod
	zavod_hats["zavodskoi beret, alt"] = /obj/item/clothing/head/beret/corporate/zavod/alt
	zavod_hats["zavodskoi softcap"] = /obj/item/clothing/head/softcap/zavod
	zavod_hats["zavodskoi softcap, alt"] = /obj/item/clothing/head/softcap/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavod_hats)

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

// PMCG (formerly EPMC)

/datum/gear/uniform/surpluspmc
	display_name = "surplus PMCG security uniform selection"
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")
	path = /obj/item/clothing/under/surplus/pmc
	faction = "Private Military Contracting Group"

/datum/gear/uniform/surpluspmc/New()
	..()
	var/list/surpluspmc = list()
	surpluspmc["surplus PMCG security uniform"] = /obj/item/clothing/under/surplus/pmc
	surpluspmc["surplus PMCG security uniform, alt"] = /obj/item/clothing/under/surplus/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(surpluspmc)

/datum/gear/faction/pmc_hats
	display_name = "PMCG hat selection"
	description = "A selection of PMCG hats."
	path =  /obj/item/clothing/head/beret/corporate/pmc
	slot = slot_head
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_beret/New()
	..()
	var/list/pmc_berets = list()
	pmc_berets["PMCG beret"] = /obj/item/clothing/head/beret/corporate/pmc
	pmc_berets["PMCG beret, alt"] = /obj/item/clothing/head/beret/corporate/pmc/alt
	pmc_berets["EPMC beret"] = /obj/item/clothing/head/beret/corporate/pmc/epmc
	pmc_berets["PMCG softcap"] = /obj/item/clothing/head/softcap/pmc
	pmc_berets["PMCG softcap, alt"] = /obj/item/clothing/head/softcap/pmc/alt
	pmc_berets["EPMC softcap"] = /obj/item/clothing/head/softcap/pmc/epmc
	gear_tweaks += new /datum/gear_tweak/path(pmc_berets)

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
