/datum/gear/faction //headwear
	display_name = "hephaestus beret"
	path = /obj/item/clothing/head/beret/heph
	slot = slot_head
	sort_category = "Factions"
	cost = 1
	faction = "Hephaestus Industries"

/datum/gear/faction/idris_hats
	display_name = "idris headwear selection"
	path = /obj/item/clothing/head/beret/security/eri
	description = "A selection of Idris Incorporated headwear."
	slot = slot_head
	faction = "Idris Incorporated"

/datum/gear/faction/idris_hats/New()
	..()
	var/idris_hats = list()
	idris_hats["beret, idris"] = /obj/item/clothing/head/beret/security/idris
	idris_hats["cap, idris"] = /obj/item/clothing/head/softcap/security/idris
	gear_tweaks += new/datum/gear_tweak/path(idris_hats)

/datum/gear/faction/zavod_hats
	display_name = "zavodskoi beret selection"
	path = /obj/item/clothing/head/beret/security/zavodskoi
	description = "A selection of Zavodskoi berets."
	slot = slot_head
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/zavod_hats/New()
	..()
	var/zavod_hats = list()
	zavod_hats["zavodskoi beret, black"] = /obj/item/clothing/head/beret/security/zavodskoi
	zavod_hats["zavodskoi beret, brown"] = /obj/item/clothing/head/beret/security/zavodskoi/alt
	gear_tweaks += new/datum/gear_tweak/path(zavod_hats)

/datum/gear/faction/zeng_hats
	display_name = "zeng-hu beret selection"
	path = /obj/item/clothing/head/beret/zeng
	description = "A selection of Zeng-Hu berets."
	slot = slot_head
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/zeng_hats/New()
	..()
	var/zeng_hats = list()
	zeng_hats["zeng-hu beret, purple"] = /obj/item/clothing/head/beret/zeng
	zeng_hats["zeng-hu beret, white"] = /obj/item/clothing/head/beret/zeng/alt
	gear_tweaks += new/datum/gear_tweak/path(zeng_hats)

/datum/gear/faction/eridani_hats
	display_name = "eridani headwear selection"
	path = /obj/item/clothing/head/beret/security/eri
	description = "A selection of EPMC headwear."
	slot = slot_head
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/eridani_hats/New()
	..()
	var/eridani_hats = list()
	eridani_hats["beret, epmc"] = /obj/item/clothing/head/beret/security/eri
	eridani_hats["softcap, epmc"] = /obj/item/clothing/head/softcap/eri
	gear_tweaks += new/datum/gear_tweak/path(eridani_hats)

 // alt uniforms

/datum/gear/faction/uniform
	display_name = "idris service skirt"
	description = "Not for security usage."
	path = /obj/item/clothing/under/rank/idris/service/alt
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/uniform/zavodskoi_uniform_alt
	display_name = "brown zavodskoi uniform"
	path = /obj/item/clothing/under/rank/security/zavodskoi/alt
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/uniform/zavodskoi_research_alt
	display_name = "brown zavodskoi research uniform"
	path = /obj/item/clothing/under/rank/zavodskoi/research/alt
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/uniform/zenghu_uniform_alt
	display_name = "zeng-hu white uniform"
	path = /obj/item/clothing/under/rank/zeng/alt
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

 // alt outerwear

/datum/gear/faction/outer
	display_name = "idris jacket"
	path = /obj/item/clothing/suit/storage/toggle/idris
	slot = slot_wear_suit
	faction = "Idris Incorporated"

/datum/gear/faction/outer/zavodskoi_labcoat
	display_name = "zavodskoi labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	slot = slot_wear_suit
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/outer/zenghu_labcoat
	display_name = "zeng-hu labcoat selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/outer/zenghu_labcoat/New()
	..()
	var/masks = list()
	masks["zeng-hu labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	masks["zeng-hu labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	gear_tweaks += new/datum/gear_tweak/path(masks)

/datum/gear/faction/outer/zenghu_apron
	display_name = "zeng-hu vinyl apron"
	path = /obj/item/clothing/suit/apron/surgery/zeng
	slot = slot_wear_suit
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/outer/heph_labcoat
	display_name = "hephaestus labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	slot = slot_wear_suit
	faction = "Hephaestus Industries"

// accessories & misc. items

/datum/gear/faction/misc
	display_name = "idris armband"
	path = /obj/item/clothing/accessory/armband/idris
	cost = 0
	faction = "Idris Incorporated"

/datum/gear/faction/misc/idris_passcard
	display_name = "idris silversun passcard"
	path = /obj/item/clothing/accessory/badge/passcard/sol/silversun
	faction = "Idris Incorporated"

/datum/gear/faction/misc/zenghu_gloves
	display_name = "zeng-hu vinyl gloves"
	path = /obj/item/clothing/gloves/zeng
	slot = slot_gloves
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/faction/misc/zavodskoi_patch
	display_name = "zavodskoi sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/zavodskoi
	slot = slot_tie
	faction = "Zavodskoi Interstellar"

/datum/gear/faction/misc/zavodskoisec_patch
	display_name = "zavodskoi security sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/zavodskoisec
	slot = slot_tie
	faction = "Zavodskoi Interstellar"
	allowed_roles = list("Security Officer","Investigator","Warden")

/datum/gear/faction/misc/erisec_patch
	display_name = "EPMC sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/erisec
	slot = slot_tie
	faction = "Eridani Private Military Contractors"

/datum/gear/faction/misc/idrissec_patch
	display_name = "idris security sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch/idrissec
	faction = "Idris Incorporated"
	allowed_roles = list("Security Officer","Investigator")

/datum/gear/faction/misc/heph_passcard
	display_name = "hephaestus burszia passcard"
	path = /obj/item/clothing/accessory/badge/passcard/burszia
	faction = "Hephaestus Industries"
