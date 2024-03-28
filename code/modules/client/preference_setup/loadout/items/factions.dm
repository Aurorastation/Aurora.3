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
	idris_headwear["idris woolen hat"] = /obj/item/clothing/head/wool/idris
	idris_headwear["idris woolen hat, alt"] = /obj/item/clothing/head/wool/idris/alt
	gear_tweaks += new /datum/gear_tweak/path(idris_headwear)

/datum/gear/faction/idris_sec_uniforms
	display_name = "idris security uniform selection"
	description = "A selection of idris security uniforms."
	path = /obj/item/clothing/under/rank/security/idris/idrissec
	slot = slot_w_uniform
	faction = "Idris Incorporated"
	allowed_roles = list("Security Cadet", "Security Officer", "Investigator", "Warden", "Security Personnel")

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
	cost = 1
	faction = "Idris Incorporated"
	allowed_roles = list("Janitor")

/datum/gear/faction/idris_sunglasses
	display_name = "idris security HUD selection"
	description = "A selection of Idris security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/idris
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator", "Security Personnel")
	faction = "Idris Incorporated"

/datum/gear/faction/idris_sunglasses/New()
	..()
	var/list/idris_sunglasses = list()
	idris_sunglasses["HUDsunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/idris
	idris_sunglasses["fat HUDsunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/big/idris
	idris_sunglasses["aviator sunglasses, Idris"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/idris
	idris_sunglasses["security HUD, Idris"] = /obj/item/clothing/glasses/hud/security/idris
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
	idris_labcoats["idris corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/idris
	idris_labcoats["idris corporate jacket, alt"] = /obj/item/clothing/suit/storage/toggle/corp/idris/alt
	idris_labcoats["idris winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/idris
	idris_labcoats["idris winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/idris/alt
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
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet", "Security Personnel")

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
	zavodskoi_headwear["zavodskoi woolen hat"] = /obj/item/clothing/head/wool/zavod
	zavodskoi_headwear["zavodskoi woolen hat, alt"] = /obj/item/clothing/head/wool/zavod/alt
	zavodskoi_headwear["zavodskoi pilotka cap"] = /obj/item/clothing/head/sidecap/zavod
	zavodskoi_headwear["zavodskoi pilotka cap, alt"] = /obj/item/clothing/head/sidecap/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavodskoi_headwear)

/datum/gear/faction/zavod_sec_uniforms
	display_name = "zavodskoi security uniform selection"
	description = "A selection of zavodskoi security uniforms."
	path = /obj/item/clothing/under/rank/security/zavod/zavodsec
	slot = slot_w_uniform
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Warden", "Investigator", "Security Officer", "Security Cadet", "Security Personnel")

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
	zavodskoi_labcoats["zavodskoi corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/zavod
	zavodskoi_labcoats["zavodskoi corporate jacket, alt"] = /obj/item/clothing/suit/storage/toggle/corp/zavod/alt
	zavodskoi_labcoats["zavodskoi winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/zavod
	zavodskoi_labcoats["zavodskoi winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavodskoi_labcoats)

/datum/gear/faction/zavod_sec_coat
	display_name = "zavodskoi security coat selection"
	description = "A selection of Zavodskoi security coats."
	path = /obj/item/clothing/suit/storage/security/officer/zav
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet", "Security Personnel")

/datum/gear/faction/zavod_sec_coat/New()
	..()
	var/list/zavod_sec_coat = list()
	zavod_sec_coat["zavodskoi security coat"] = /obj/item/clothing/suit/storage/security/officer/zav
	zavod_sec_coat["zavodskoi security coat, alt"] = /obj/item/clothing/suit/storage/security/officer/zav/alt
	gear_tweaks += new /datum/gear_tweak/path(zavod_sec_coat)

/datum/gear/faction/zavod_warden_coat
	display_name = "zavodskoi warden coat selection"
	description = "A selection of Zavodskoi warden coats."
	path = /obj/item/clothing/suit/storage/toggle/warden/zavod
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Security Personnel")

/datum/gear/faction/zavod_warden_coat/New()
	..()
	var/list/zavod_warden_coat = list()
	zavod_warden_coat["zavodskoi warden coat"] = /obj/item/clothing/suit/storage/toggle/warden/zavod
	zavod_warden_coat["zavodskoi warden coat, alt"] = /obj/item/clothing/suit/storage/toggle/warden/zavod/alt
	gear_tweaks += new /datum/gear_tweak/path(zavod_warden_coat)

/datum/gear/faction/zavod_sunglasses
	display_name = "zavodskoi security HUD selection"
	description = "A selection of Zavodskoi security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	slot = slot_glasses
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet", "Security Personnel")

/datum/gear/faction/zavod_sunglasses/New()
	..()
	var/list/zavod_sunglasses = list()
	zavod_sunglasses["HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/zavod
	zavod_sunglasses["fat HUDsunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/big/zavod
	zavod_sunglasses["aviator sunglasses, Zavodskoi"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/zavod
	zavod_sunglasses["security HUD, Zavodskoi"] = /obj/item/clothing/glasses/hud/security/zavod
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
	allowed_roles = list("Head of Security", "Warden", "Investigator", "Security Officer", "Security Cadet", "Security Personnel")

/datum/gear/faction/zavodskoicape
	display_name = "zavodskoi dominian great house cape selection"
	description = "A selection of Zavodskoi-colored Dominian great house capes."
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"
	culture_restriction = list(/singleton/origin_item/culture/dominia, /singleton/origin_item/culture/dominian_unathi)

/datum/gear/faction/zavodskoicape/New()
	..()
	var/list/zavodskoicape = list()
	zavodskoicape["zavodskoi dominia cape"] = /obj/item/clothing/accessory/poncho/dominia_cape/zavod
	zavodskoicape["zavodskoi dominia cape, strelitz"] = /obj/item/clothing/accessory/poncho/dominia_cape/strelitz/zavod
	zavodskoicape["zavodskoi dominia cape, volvalaad"] = /obj/item/clothing/accessory/poncho/dominia_cape/volvalaad/zavod
	zavodskoicape["zavodskoi dominia cape, kazhkz"] = /obj/item/clothing/accessory/poncho/dominia_cape/kazhkz/zavod
	zavodskoicape["zavodskoi dominia cape, caladius"] = /obj/item/clothing/accessory/poncho/dominia_cape/caladius/zavod
	zavodskoicape["zavodskoi dominia cape, zhao"] = /obj/item/clothing/accessory/poncho/dominia_cape/zhao/zavod
	gear_tweaks += new /datum/gear_tweak/path(zavodskoicape)

// PMCG
/datum/gear/faction/pmc_sunglasses
	display_name = "PMCG security HUD selection"
	description = "A selection of PMCG security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/pmc
	slot = slot_glasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator", "Security Personnel")
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
	pmc_sunglasses["security HUD, PMCG"] = /obj/item/clothing/glasses/hud/security/pmc
	pmc_sunglasses["security HUD, EPMC"] = /obj/item/clothing/glasses/hud/security/pmc/alt
	gear_tweaks += new /datum/gear_tweak/path(pmc_sunglasses)

/datum/gear/faction/pmc_medglasses
	display_name = "PMCG medical HUD selection"
	description = "A selection of PMCG medical HUDs."
	path = /obj/item/clothing/glasses/hud/health/aviator/pmc
	slot = slot_glasses
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "First Responder", "Psychiatrist", "Medical Intern", "Medical Personnel")
	faction = "Private Military Contracting Group"

/datum/gear/faction/pmc_medglasses/New()
	..()
	var/list/pmc_sunglasses = list()
	pmc_sunglasses["aviator sunglasses, PMCG"] = /obj/item/clothing/glasses/hud/health/aviator/pmc
	pmc_sunglasses["medical HUD, PMCG"] = /obj/item/clothing/glasses/hud/health/pmc
	pmc_sunglasses["aviator sunglasses, EPMC"] = /obj/item/clothing/glasses/hud/health/aviator/pmc/alt
	pmc_sunglasses["medical HUD, EPMC"] = /obj/item/clothing/glasses/hud/health/pmc/alt
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
	pmc_labcoats["PMCG corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/pmc
	pmc_labcoats["EPMC corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/pmc/alt
	pmc_labcoats["PMCG winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/pmc
	pmc_labcoats["EPMC winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/pmc/alt
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
	pmcg_headwear["PMCG woolen hat"] = /obj/item/clothing/head/wool/pmc
	pmcg_headwear["EPMC woolen hat"] = /obj/item/clothing/head/wool/pmc/alt
	pmcg_headwear["PMCG garrison cap"] = /obj/item/clothing/head/sidecap/pmcg
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
	allowed_roles = list("Security Cadet", "Security Officer", "Investigator", "Warden", "Security Personnel")

/datum/gear/faction/pmcg_sec_uniforms/New()
	..()
	var/list/pmcg_sec_uniforms = list()
	pmcg_sec_uniforms["PMCG uniform"] = /obj/item/clothing/under/rank/security/pmc/pmcsec
	pmcg_sec_uniforms["PMCG uniform, alt"] = /obj/item/clothing/under/rank/security/pmc/pmcsec/alt
	pmcg_sec_uniforms["EPMC uniform"] = /obj/item/clothing/under/rank/security/pmc/epmc
	pmcg_sec_uniforms["EPMC uniform, alt"] = /obj/item/clothing/under/rank/security/pmc/epmc/alt
	pmcg_sec_uniforms["EPMC detective uniform"] = /obj/item/clothing/under/det/pmc/alt
	pmcg_sec_uniforms["wildlands squadron uniform"] = /obj/item/clothing/under/rank/security/pmc/wildlands_squadron
	pmcg_sec_uniforms["Dagamuir Freewater uniform"] = /obj/item/clothing/under/rank/security/pmc/dagamuir_freewater
	pmcg_sec_uniforms["Ve'katak Phalanx uniform"] = /obj/item/clothing/under/rank/security/pmc/vekatak_phalanx
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
	allowed_roles = list("Physician", "Medical Personnel")

/datum/gear/faction/epmc_uniform_pharm_med
	display_name = "PMCG pharmacist uniform"
	path = /obj/item/clothing/under/rank/medical/pharmacist/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Pharmacist", "Medical Personnel")

/datum/gear/faction/epmc_uniform_psych_med
	display_name = "PMCG psychiatrist uniform"
	path = /obj/item/clothing/under/rank/medical/psych/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Psychiatrist", "Medical Personnel")

/datum/gear/faction/epmc_uniform_intern_med
	display_name = "PMCG medical intern uniform"
	path = /obj/item/clothing/under/rank/medical/intern/pmc/alt
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("Medical Intern", "Medical Personnel")

/datum/gear/faction/epmc_uniform_fr_med
	display_name = "PMCG/EPMC first responder uniform"
	path = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	slot = slot_w_uniform
	faction = "Private Military Contracting Group"
	allowed_roles = list("First Responder", "Medical Personnel")

/datum/gear/faction/epmc_uniform_fr_med/New()
	..()
	var/list/epmc_uniform_fr_med = list()
	epmc_uniform_fr_med["EPMC first responder uniform"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	epmc_uniform_fr_med["PMCG first responder uniform, alt"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/alt
	epmc_uniform_fr_med["Sekhmet Intergalactic first responder uniform"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/sekh
	epmc_uniform_fr_med["Ve'katak Phalanx first responder uniform"] = /obj/item/clothing/under/rank/medical/first_responder/pmc/vekatak_phalanx
	gear_tweaks += new /datum/gear_tweak/path(epmc_uniform_fr_med)

/datum/gear/faction/wildlands_flagpatches
	display_name = "wildlands flagpatch selection"
	description = "A selection of flagpatches from the now defunct groups of the Human Wildlands."
	path = /obj/item/clothing/accessory/flagpatch/fsf
	slot = slot_tie
	faction = "Private Military Contracting Group"
	flags = null

/datum/gear/faction/wildlands_flagpatches/New()
	..()
	var/list/wildlands_flag_patches = list()
	wildlands_flag_patches["flagpatch, free solarian fleets"] = /obj/item/clothing/accessory/flagpatch/fsf
	wildlands_flag_patches["flagpatch, middle ring shield pact"] = /obj/item/clothing/accessory/flagpatch/pact
	wildlands_flag_patches["flagpatch, solarian provisional government"] = /obj/item/clothing/accessory/flagpatch/spg
	wildlands_flag_patches["flagpatch, southern solarian military district"] = /obj/item/clothing/accessory/flagpatch/ssmd
	gear_tweaks += new /datum/gear_tweak/path(wildlands_flag_patches)

/datum/gear/faction/vekatak_rep
	display_name = "ve'katak phalanx representative uniform"
	path = /obj/item/clothing/under/rank/pmc/vekatak_phalanx
	flags = GEAR_HAS_DESC_SELECTION
	allowed_roles = list("Corporate Liaison")
	faction = "Private Military Contracting Group"
	slot = slot_w_uniform

/datum/gear/faction/vekatak_res
	display_name = "ve'katak phalanx reserve uniform"
	path = /obj/item/clothing/under/rank/pmc/vekatak_phalanx/reserve
	flags = GEAR_HAS_DESC_SELECTION
	allowed_roles = list("Assistant", "Off-Duty Crew Member")
	faction = "Private Military Contracting Group"
	slot = slot_w_uniform

//Zeng-Hu
/datum/gear/faction/zenghu_beret
	display_name = "zeng-hu headwear selection"
	description = "A selection of Zeng-Hu headwear."
	path = /obj/item/clothing/head/beret/corporate/zeng
	slot = slot_head
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zenghu_beret/New()
	..()
	var/list/zenghu_headwear = list()
	zenghu_headwear["beret, zeng-hu"] = /obj/item/clothing/head/beret/corporate/zeng
	zenghu_headwear["beret alt, zeng-hu"] = /obj/item/clothing/head/beret/corporate/zeng/alt
	zenghu_headwear["cap, zeng-hu"] = /obj/item/clothing/head/softcap/zeng
	zenghu_headwear["cap alt, zeng-hu"] = /obj/item/clothing/head/softcap/zeng/alt
	zenghu_headwear["zeng-hu woolen hat"] = /obj/item/clothing/head/wool/zeng
	zenghu_headwear["zeng-hu woolen hat, alt"] = /obj/item/clothing/head/wool/zeng/alt
	gear_tweaks += new /datum/gear_tweak/path(zenghu_headwear)

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
	zenghu_labcoats["zeng-hu corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/zeng
	zenghu_labcoats["zeng-hu corporate jacket, alt"] = /obj/item/clothing/suit/storage/toggle/corp/zeng/alt
	zenghu_labcoats["zeng-hu winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/zeng
	zenghu_labcoats["zeng-hu winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/zeng/alt
	gear_tweaks += new /datum/gear_tweak/path(zenghu_labcoats)

/datum/gear/faction/zenghu_apron
	display_name = "zeng-hu vinyl apron"
	path = /obj/item/clothing/accessory/apron/surgery/zeng
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

/datum/gear/faction/zeng_medglasses
	display_name = "Zeng-Hu medical HUD selection"
	description = "A selection of Zeng-Hu medical HUDs."
	path = /obj/item/clothing/glasses/hud/health/aviator/zeng
	slot = slot_glasses
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "First Responder", "Psychiatrist", "Medical Intern", "Medical Personnel")
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zeng_medglasses/New()
	..()
	var/list/zeng_sunglasses = list()
	zeng_sunglasses["aviator sunglasses, Zeng-Hu"] = /obj/item/clothing/glasses/hud/health/aviator/zeng
	zeng_sunglasses["medical HUD, Zeng-Hu"] = /obj/item/clothing/glasses/hud/health/zeng
	gear_tweaks += new /datum/gear_tweak/path(zeng_sunglasses)

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
	heph_labcoats["hephaestus corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/heph
	heph_labcoats["hephaestus winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/heph
	heph_labcoats["hephaestus winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/heph/alt
	gear_tweaks += new /datum/gear_tweak/path(heph_labcoats)

/datum/gear/faction/heph_beret
	display_name = "hephaestus headwear selection"
	description = "A selection of Hephaestus headwear"
	path = /obj/item/clothing/head/beret/corporate/heph
	slot = slot_head
	faction = "Hephaestus Industries"

/datum/gear/faction/heph_beret/New()
	..()
	var/list/heph_headwear = list()
	heph_headwear["beret, hephaestus"] = /obj/item/clothing/head/beret/corporate/heph
	heph_headwear["hephaestus woolen hat"] = /obj/item/clothing/head/wool/heph
	heph_headwear["hephaestus side cap"] = /obj/item/clothing/head/sidecap/heph
	gear_tweaks += new /datum/gear_tweak/path(heph_headwear)

/datum/gear/faction/heph_passcard
	display_name = "hephaestus burzsia passcard"
	path = /obj/item/clothing/accessory/badge/passcard/burzsia
	slot = slot_tie
	faction = "Hephaestus Industries"

//NanoTrasen
/datum/gear/faction/nanotrasen_labcoat
	display_name = "nanotrasen coat selection"
	description = "A selection of NanoTrasen coats"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	slot = slot_wear_suit
	faction = "NanoTrasen"

/datum/gear/faction/nanotrasen_labcoat/New()
	..()
	var/list/nt_labcoats = list()
	nt_labcoats["nanotrasen labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	nt_labcoats["nanotrasen letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/nt/letterman
	nt_labcoats["nanotrasen labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/nt
	nt_labcoats["nanotrasen corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/nt
	nt_labcoats["nanotrasen winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/nt
	nt_labcoats["nanotrasen winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/nt/alt
	gear_tweaks += new /datum/gear_tweak/path(nt_labcoats)

/datum/gear/faction/nt_custodialjumpsuit
	display_name = "nanotrasen custodial jumpsuit, alternative"
	path = /obj/item/clothing/under/rank/janitor/alt
	slot = slot_w_uniform
	cost = 1
	faction = "NanoTrasen"
	allowed_roles = list("Janitor")

/datum/gear/faction/nt_headwear
	display_name = "nanotrasen headwear selection"
	description = "A selection of NanoTrasen headwear"
	path = /obj/item/clothing/head/beret/corporate
	slot = slot_head
	faction = "NanoTrasen"

/datum/gear/faction/nt_headwear/New()
	..()
	var/list/nt_headwear = list()
	nt_headwear["beret, nanotrasen"] = /obj/item/clothing/head/beret/corporate
	nt_headwear["nanotrasen woolen hat"] = /obj/item/clothing/head/wool/nt
	gear_tweaks += new /datum/gear_tweak/path(nt_headwear)

/datum/gear/faction/nt_medglasses
	display_name = "NanoTrasen medical HUD selection"
	description = "A selection of NanoTrasen medical HUDs."
	path = /obj/item/clothing/glasses/hud/health/aviator/nt
	slot = slot_glasses
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "First Responder", "Psychiatrist", "Medical Intern", "Medical Personnel")
	faction = "NanoTrasen"

/datum/gear/faction/nt_medglasses/New()
	..()
	var/list/nt_sunglasses = list()
	nt_sunglasses["aviator sunglasses, NanoTrasen"] = /obj/item/clothing/glasses/hud/health/aviator/nt
	nt_sunglasses["medical HUD, NanoTrasen"] = /obj/item/clothing/glasses/hud/health/nt
	gear_tweaks += new /datum/gear_tweak/path(nt_sunglasses)

//Orion
/datum/gear/faction/orion_coat
	display_name = "orion coat selection"
	description = "A selection of Orion coats"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orion
	slot = slot_wear_suit
	faction = "Orion Express"

/datum/gear/faction/orion_coat/New()
	..()
	var/list/orion_labcoats = list()
	orion_labcoats["orion labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/orion
	orion_labcoats["orion letterman labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/orion/letterman
	orion_labcoats["orion labcoat, long"] = /obj/item/clothing/suit/storage/toggle/longcoat/orion
	orion_labcoats["orion corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/orion
	orion_labcoats["orion corporate jacket, alt"] = /obj/item/clothing/suit/storage/toggle/corp/orion/alt
	orion_labcoats["orion winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/orion
	orion_labcoats["orion winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/orion/alt
	gear_tweaks += new /datum/gear_tweak/path(orion_labcoats)

/datum/gear/faction/orion_headwear
	display_name = "orion headwear selection"
	description = "A selection of Orion headwear"
	path = /obj/item/clothing/head/beret/corporate/orion
	slot = slot_head
	faction = "Orion Express"

/datum/gear/faction/orion_headwear/New()
	..()
	var/list/orion_headwear = list()
	orion_headwear["beret, orion"] = /obj/item/clothing/head/beret/corporate/orion
	orion_headwear["orion woolen hat"] = /obj/item/clothing/head/wool/orion
	orion_headwear["orion woolen hat, alt"] = /obj/item/clothing/head/wool/orion/alt
	gear_tweaks += new /datum/gear_tweak/path(orion_headwear)

//SCC
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
	display_name = "SCC coat selection"
	description = "A selection of SCC coats"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/scc
	slot = slot_wear_suit
	sort_category = "Factions"
	cost = 1
	faction = null

/datum/gear/faction/scc_jacket/New()
	..()
	var/list/scc_jackets = list()
	scc_jackets["SCC jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/scc
	scc_jackets["SCC corporate jacket"] = /obj/item/clothing/suit/storage/toggle/corp/scc
	scc_jackets["SCC corporate jacket, alt"] = /obj/item/clothing/suit/storage/toggle/corp/scc/alt
	scc_jackets["SCC winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/scc
	scc_jackets["SCC winter coat, alt"] = /obj/item/clothing/suit/storage/hooded/wintercoat/scc/alt
	gear_tweaks += new /datum/gear_tweak/path(scc_jackets)

/datum/gear/faction/scc_beret
	display_name = "SCC headwear selection"
	description = "A selection of SCC headwear"
	path = /obj/item/clothing/head/beret/scc
	slot = slot_head
	sort_category = "Factions"
	cost = 1
	faction = null

/datum/gear/faction/scc_beret/New()
	..()
	var/list/scc_headwear = list()
	scc_headwear["beret, SCC"] = /obj/item/clothing/head/beret/scc
	scc_headwear["SCC woolen hat"] = /obj/item/clothing/head/wool/scc
	scc_headwear["SCC woolen hat, alt"] = /obj/item/clothing/head/wool/scc/alt
	gear_tweaks += new /datum/gear_tweak/path(scc_headwear)
