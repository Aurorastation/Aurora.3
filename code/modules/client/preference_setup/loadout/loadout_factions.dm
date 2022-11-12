/datum/gear/faction
	display_name = "idris advanced service cloth"
	path = /obj/item/reagent_containers/glass/rag/advanced/idris
	slot = slot_in_backpack
	sort_category = "Factions"
	cost = 1
	faction = "Idris Incorporated"

/datum/gear/faction/idris_headwear
	display_name = "idris headwear selection"
	description = "A selection of idris headwear."
	path = /obj/item/clothing/head/softcap/idris
	slot = slot_head
	faction = "Idris Incorporated"

/datum/gear/faction/idris_headwear/New()
	..()
	var/list/idris_headwear = list()
	idris_headwear["idris cap"] = /obj/item/clothing/head/softcap/idris
	idris_headwear["idris cap, alt"] = /obj/item/clothing/head/softcap/idris/alt
	idris_headwear["idris beret"] = /obj/item/clothing/head/beret/corporate/idris
	idris_headwear["idris beret, alt"] = /obj/item/clothing/head/beret/corporate/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_headwear)

/datum/gear/faction/idris_sec_uniforms
	display_name = "idris security uniform selection"
	description = "A selection of idris security uniforms."
	path = /obj/item/clothing/under/rank/security/idris/idrissec
	slot = slot_w_uniform
	faction = "Idris Incorporated"
	allowed_roles = list("Security Cadet", "Security Officer", "Investigator", "Warden")

/datum/gear/faction/idris_sec_uniforms/New()
	..()
	var/list/idris_sec_uniforms = list()
	idris_sec_uniforms["idris uniform"] = /obj/item/clothing/under/rank/security/idris/idrissec
	idris_sec_uniforms["idris uniform, alt"] = /obj/item/clothing/under/rank/security/idris/idrissec/alt
	idris_sec_uniforms["idris detective uniform"] = /obj/item/clothing/under/det/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_sec_uniforms)

/datum/gear/faction/idris_armband
	display_name = "idris armband"
	path = /obj/item/clothing/accessory/armband/idris
	slot = slot_tie
	faction = "Idris Incorporated"

/datum/gear/faction/idris_passcard
	display_name = "idris silversun passcard"
	path = /obj/item/clothing/accessory/badge/passcard/sol/silversun
	slot = slot_tie
	faction = "Idris Incorporated"

/datum/gear/faction/idris_custodialjumpsuit
	display_name = "idris custodial jumpsuit, alternative"
	path = /obj/item/clothing/under/rank/janitor/idris/alt
	slot = slot_w_uniform
	cost = 0
	faction = "Idris Incorporated"
	allowed_roles = list("Janitor")

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
	display_name = "idris coat selection"
	description = "A selection of Idris coats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/idris
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/idris_labcoat/New()
	..()
	var/list/idris_labcoats = list()
	idris_labcoats["idris labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris
	idris_labcoats["idris labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris/alt
	idris_labcoats["idris letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman
	idris_labcoats["idris letterman labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman/alt
	idris_labcoats["idris labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/idris
	idris_labcoats["idris windbreaker"] = /obj/item/clothing/suit/storage/toggle/idris
	gear_tweaks += new /datum/gear_tweak/path(idris_labcoats)

/datum/gear/faction/idris_sec_coat
	display_name = "idris security coat selection"
	description = "A selection of Idris security coats."
	path = /obj/item/clothing/suit/storage/security/officer/idris
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/idris_sec_coat/New()
	..()
	var/list/idris_sec_coat = list()
	idris_sec_coat["idris security coat"] = /obj/item/clothing/suit/storage/security/officer/idris
	idris_sec_coat["idris security coat, alt"] = /obj/item/clothing/suit/storage/security/officer/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_sec_coat)

/datum/gear/faction/idrissec_patch
	display_name = "idris security sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/idrissec
	faction = "Idris Incorporated"
	slot = slot_tie
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet")

//Zavodskoi
/datum/gear/faction/zavodskoi_headwear
	display_name = "zavodskoi headwear selection"
	description = "A selection of zavodskoi headwear."
	path = /obj/item/clothing/head/softcap/zavod
	slot = slot_head
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_headwear/New()
	..()
	var/list/zavodskoi_headwear = list()
	zavodskoi_headwear["zavodskoi beret"] = /obj/item/clothing/head/beret/corporate/zavod
	zavodskoi_headwear["zavodskoi beret, alt"] = /obj/item/clothing/head/beret/corporate/zavod/alt
	zavodskoi_headwear["zavodskoi cap"] = /obj/item/clothing/head/softcap/zavod
	zavodskoi_headwear["zavodskoi cap, alt"] = /obj/item/clothing/head/softcap/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavodskoi_headwear)

/datum/gear/faction/zavod_sec_uniforms
	display_name = "zavodskoi security uniform selection"
	description = "A selection of zavodskoi security uniforms."
	path = /obj/item/clothing/under/rank/security/zavod/zavodsec
	slot = slot_w_uniform
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet")

/datum/gear/faction/zavod_sec_uniforms/New()
	..()
	var/list/zavod_sec_uniforms = list()
	zavod_sec_uniforms["zavodskoi uniform"] = /obj/item/clothing/under/rank/security/zavod/zavodsec
	zavod_sec_uniforms["zavodskoi uniform, alt"] = /obj/item/clothing/under/rank/security/zavod/zavodsec/alt
	zavod_sec_uniforms["zavodskoi detective uniform"] = /obj/item/clothing/under/det/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavod_sec_uniforms)

/datum/gear/faction/zavodskoi_labcoat
	display_name = "zavodskoi coat selection"
	description = "A selection of Zavodskoi coats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavodskoi_labcoat/New()
	..()
	var/list/zavodskoi_labcoats = list()
	zavodskoi_labcoats["zavodskoi labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	zavodskoi_labcoats["zavodskoi labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/alt
	zavodskoi_labcoats["zavodskoi letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman
	zavodskoi_labcoats["zavodskoi letterman labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman/alt
	zavodskoi_labcoats["zavodskoi labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/zavodskoi
	gear_tweaks += new /datum/gear_tweak/path(zavodskoi_labcoats)

/datum/gear/faction/zavod_sec_coat
	display_name = "zavodskoi security coat selection"
	description = "A selection of Zavodskoi security coats."
	path = /obj/item/clothing/suit/storage/security/officer/zav
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet")

/datum/gear/faction/zavod_sec_coat/New()
	..()
	var/list/zavod_sec_coat = list()
	zavod_sec_coat["zavodskoi security coat"] = /obj/item/clothing/suit/storage/security/officer/zav
	zavod_sec_coat["zavodskoi security coat, alt"] = /obj/item/clothing/suit/storage/security/officer/zav/alt
	gear_tweaks += new /datum/gear_tweak/path(zavod_sec_coat)

/datum/gear/faction/zavod_sunglasses
	display_name = "zavodskoi security HUD selection"
	description = "A selection of Zavodskoi security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	slot = slot_glasses
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet")

/datum/gear/faction/zavod_sunglasses/New()
	..()
	var/list/zavod_sunglasses = list()
	zavod_sunglasses["HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	zavod_sunglasses["fat HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/big/zavod
	zavod_sunglasses["aviator sunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/zavod
	gear_tweaks += new /datum/gear_tweak/path(zavod_sunglasses)

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
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet")

// PMCG
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
	pmc_sunglasses["HUDsunglasses alt, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/pmc/alt
	pmc_sunglasses["fat HUDsunglasses alt, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/big/pmc/alt
	pmc_sunglasses["aviator sunglasses alt, PMCG"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmc_sunglasses)

/datum/gear/faction/pmc_labcoat
	display_name = "PMCG/EPMC labcoat selection"
	description = "A selection of PMCG/EPMC labcoats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	slot = slot_wear_suit
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_labcoat/New()
	..()
	var/list/pmc_labcoats = list()
	pmc_labcoats["PMCG labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	pmc_labcoats["PMCG labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/pmc/alt
	pmc_labcoats["PMCG labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/pmc
	pmc_labcoats["EPMC labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/epmc
	gear_tweaks += new /datum/gear_tweak/path(pmc_labcoats)

/datum/gear/faction/pmc_sec_coat
	display_name = "PMCG security coat selection"
	description = "A selection of PMCG security coats."
	path = /obj/item/clothing/suit/storage/security/officer/pmc
	slot = slot_wear_suit
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_sec_coat/New()
	..()
	var/list/pmc_sec_coat = list()
	pmc_sec_coat["PMCG security coat"] = /obj/item/clothing/suit/storage/security/officer/pmc
	pmc_sec_coat["PMCG security coat, alt"] = /obj/item/clothing/suit/storage/security/officer/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmc_sec_coat)

/datum/gear/faction/pmcg_headwear
	display_name = "PMCG and EPMC headwear selection"
	description = "A selection of PMCG and EPMC headwear."
	path = /obj/item/clothing/head/softcap/pmc
	slot = slot_head
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmcg_headwear/New()
	..()
	var/list/pmcg_headwear = list()
	pmcg_headwear["PMCG beret"] = /obj/item/clothing/head/beret/corporate/pmc
	pmcg_headwear["PMCG softcap"] = /obj/item/clothing/head/softcap/pmc
	pmcg_headwear["PMCG softcap, alt"] = /obj/item/clothing/head/softcap/pmc/alt
	pmcg_headwear["EPMC beret"] = /obj/item/clothing/head/beret/corporate/pmc/epmc
	pmcg_headwear["EPMC softcap"] = /obj/item/clothing/head/softcap/pmc/epmc
	gear_tweaks += new /datum/gear_tweak/path(pmcg_headwear)

/datum/gear/faction/pmc_modsuit
	display_name = "PMCG modsuit"
	description = "A modular PMCG fatigue jumpsuit."
	path = /obj/item/clothing/under/pmc_modsuit
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmcg_sec_uniforms
	display_name = "PMCG/EPMC security uniform selection"
	description = "A selection of PMCG and EPMC security uniforms."
	path = /obj/item/clothing/under/rank/security/pmc/epmc
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Security Cadet", "Security Officer", "Investigator", "Warden")

/datum/gear/faction/pmcg_sec_uniforms/New()
	..()
	var/list/pmcg_sec_uniforms = list()
	pmcg_sec_uniforms["PMCG uniform"] = /obj/item/clothing/under/rank/security/pmc/pmcsec
	pmcg_sec_uniforms["PMCG uniform, alt"] = /obj/item/clothing/under/rank/security/pmc/pmcsec/alt
	pmcg_sec_uniforms["EPMC uniform"] = /obj/item/clothing/under/rank/security/pmc/epmc
	pmcg_sec_uniforms["EPMC uniform, alt"] = /obj/item/clothing/under/rank/security/pmc/epmc/alt
	pmcg_sec_uniforms["EPMC detective uniform"] = /obj/item/clothing/under/det/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmcg_sec_uniforms)

/datum/gear/faction/erisec_patch
	display_name = "EPMC sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/erisec
	slot = slot_tie
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_patch
	display_name = "PMCG armband"
	path = /obj/item/clothing/accessory/armband/pmc
	slot = slot_tie
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_patch/New()
	..()
	var/list/pmc_patch = list()
	pmc_patch["PMCG armband"] = /obj/item/clothing/accessory/armband/pmc
	pmc_patch["PMCG armband, alt"] = /obj/item/clothing/accessory/armband/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmc_patch)

/datum/gear/faction/epmc_uniform_phys_med
	display_name = "PMCG physician uniform"
	path = /obj/item/clothing/under/rank/medical/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Physician")

/datum/gear/faction/epmc_uniform_pharm_med
	display_name = "PMCG pharmacist uniform"
	path = /obj/item/clothing/under/rank/medical/pharmacist/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Pharmacist")

/datum/gear/faction/epmc_uniform_psych_med
	display_name = "PMCG psychiatrist uniform"
	path = /obj/item/clothing/under/rank/medical/psych/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Psychiatrist")

/datum/gear/faction/epmc_uniform_intern_med
	display_name = "PMCG medical intern uniform"
	path = /obj/item/clothing/under/rank/medical/intern/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Medical Intern")

/datum/gear/faction/epmc_uniform_fr_med
	display_name = "PMCG/EPMC first responder uniform"
	path = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("First Responder")

/datum/gear/faction/epmc_uniform_fr_med/New()
	..()
	var/list/epmc_uniform_fr_med = list()
	epmc_uniform_fr_med["EPMC first responder uniform"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	epmc_uniform_fr_med["PMCG first responder uniform, alt"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/alt
	epmc_uniform_fr_med["Sekhmet Intergalactic first responder uniform"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/sekh
	gear_tweaks += new /datum/gear_tweak/path(epmc_uniform_fr_med)

//Zeng-Hu
/datum/gear/faction/zenghu_beret
	display_name = "zeng-hu beret selection"
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
	var/list/zenghu_labcoats = list()
	zenghu_labcoats["zeng-hu labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	zenghu_labcoats["zeng-hu labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	zenghu_labcoats["zeng-hu labcoat, classic"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt2
	zenghu_labcoats["zeng-hu letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/letterman
	zenghu_labcoats["zeng-hu letterman labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/letterman/alt
	zenghu_labcoats["zeng-hu letterman labcoat, classic"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/letterman/alt2
	zenghu_labcoats["zeng-hu labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/zeng
	zenghu_labcoats["zeng-hu first responder jacket"] = /obj/item/clothing/suit/storage/toggle/fr_jacket/zeng
	gear_tweaks += new /datum/gear_tweak/path(zenghu_labcoats)

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
	display_name = "Zeng-Hu Nralakk Division cloak"
	path = /obj/item/clothing/accessory/poncho/shouldercape/qeblak/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

//Hephaestus
/datum/gear/faction/heph_labcoat
	display_name = "hephaestus coat selection"
	description = "A selection of Hephaestus coats."
	path = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	slot = slot_wear_suit
	faction = "Hephaestus Industries"

/datum/gear/faction/heph_labcoat/New()
	..()
	var/list/heph_labcoats = list()
	heph_labcoats["hephaestus labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	heph_labcoats["hephaestus letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/heph/letterman
	heph_labcoats["hephaestus labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/heph
	gear_tweaks += new /datum/gear_tweak/path(heph_labcoats)

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

//NanoTrasen
/datum/gear/faction/nanotrasen_labcoat
	display_name = "nanotrasen labcoat, long"
	path = /obj/item/clothing/suit/storage/toggle/longcoat/nt
	slot = slot_wear_suit
	faction = "NanoTrasen"

/datum/gear/faction/nt_custodialjumpsuit
	display_name = "nanotrasen custodial jumpsuit, alternative"
	path = /obj/item/clothing/under/rank/janitor/alt
	slot = slot_w_uniform
	cost = 0
	faction = "NanoTrasen"
	allowed_roles = list("Janitor")

/datum/gear/faction/scc_armband
	display_name = "SCC armband"
	path = /obj/item/clothing/accessory/armband/scc
	slot = slot_tie
	sort_category = "Factions"
	cost = 1
	faction = null

/datum/gear/faction/scc_sleevepatch
	display_name = "SCC sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/scc
	slot = slot_tie
	sort_category = "Factions"
	cost = 1
	faction = null

/datum/gear/faction/scc_jacket
	display_name = "SCC jacket"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/scc
	slot = slot_wear_suit
	sort_category = "Factions"
	cost = 1
	faction = null

/datum/gear/faction/scc_beret
	display_name = "SCC beret"
	path = /obj/item/clothing/head/beret/scc
	slot = slot_head
	sort_category = "Factions"
	cost = 1
	faction = null
