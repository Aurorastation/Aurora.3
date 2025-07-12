/datum/ghostspawner/human/etna_clerk
	short_name = "etna_clerk"
	name = "HICS Etna Clerk"
	desc = "Crew the HICS Etna store and reception, and make visitors comfortable!"
	tags = list("External")

	spawnpoints = list("etna_clerk")
	max_count = 2

	outfit = /datum/outfit/admin/etna_clerk
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Clerk (Heph)"
	special_role = "Clerk (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_clerk
	name = "Etna Clerk"
	uniform = /obj/item/clothing/under/rank/hangar_technician/heph
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel/heph
	id = /obj/item/card/id/hephaestus
	suit = /obj/item/clothing/suit/storage/toggle/corp/heph
	l_ear = /obj/item/device/radio/headset/headset_service
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_BULWARK = /obj/item/clothing/shoes/vaurca
	)

/datum/outfit/admin/etna_clerk/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/datum/outfit/admin/etna_clerk/get_id_access()
	return list(ACCESS_BAR)

/datum/ghostspawner/human/etna_bartender
	short_name = "etna_bartender"
	name = "HICS Etna Bartender"
	desc = "Serve drinks at the HICS Etna onboard bar!"
	tags = list("External")

	spawnpoints = list("etna_bartender")
	max_count = 2

	outfit = /datum/outfit/admin/etna_bartender
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Bartender (Heph)"
	special_role = "Bartender (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_bartender
	name = "Etna Bartender"
	uniform = /obj/item/clothing/under/rank/hangar_technician/heph
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel/heph
	id = /obj/item/card/id/hephaestus
	suit = /obj/item/clothing/suit/storage/toggle/corp/heph
	l_ear = /obj/item/device/radio/headset/headset_service
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_BULWARK = /obj/item/clothing/shoes/vaurca
	)

/datum/outfit/admin/etna_clerk/get_id_access()
	return list(ACCESS_BAR)

/datum/outfit/admin/etna_bartender/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/datum/ghostspawner/human/etna_sec
	short_name = "etna_security"
	name = "HICS Etna Security Officer"
	desc = "Keep the HICS Etna safe, through reasonable use of force."
	tags = list("External")

	spawnpoints = list("etna_security")
	max_count = 4

	outfit = /datum/outfit/admin/etna_sec
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_DIONA)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Security Officer (Heph)"
	special_role = "Security Officer (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_sec
	name = "HICS Etna Security Officer"
	uniform = /obj/item/clothing/under/rank/security/heph
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/heph
	id = /obj/item/card/id/hephaestus
	l_ear = /obj/item/device/radio/headset/headset_sec
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	belt = /obj/item/storage/belt/security/full
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sandals/caligae,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca
	)

/datum/outfit/admin/etna_sec/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/datum/outfit/admin/etna_sec/get_id_access()
	return list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG)

/datum/ghostspawner/human/etna_med
	short_name = "etna_med"
	name = "HICS Etna Physician"
	desc = "Treat the crew of the HICS Etna."
	tags = list("External")

	spawnpoints = list("etna_med")
	max_count = 1

	outfit = /datum/outfit/admin/etna_med
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Physician (Heph)"
	special_role = "Physician (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_med
	name = "HICS Etna Physician"
	uniform = /obj/item/clothing/under/rank/medical/generic
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	back = /obj/item/storage/backpack/satchel/heph
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	id = /obj/item/card/id/hephaestus
	l_ear = /obj/item/device/radio/headset/headset_med
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca
	)

/datum/outfit/admin/etna_med/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/datum/outfit/admin/etna_med/get_id_access()
	. = ..()
	return list(ACCESS_MEDICAL)


/datum/ghostspawner/human/etna_machinist
	short_name = "etna_machinist"
	name = "HICS Etna Machinist"
	desc = "Repair the robots and equipment of the HICS Etna."
	tags = list("External")

	spawnpoints = list("etna_machinist")
	max_count = 1

	outfit = /datum/outfit/admin/etna_machinist
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Machinist (Heph)"
	special_role = "Machinist (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_machinist
	name = "HICS Etna Machinist"
	uniform = /obj/item/clothing/under/rank/machinist/heph
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel/heph
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	id = /obj/item/card/id/hephaestus
	l_ear = /obj/item/device/radio/headset/headset_med
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_BULWARK = /obj/item/clothing/shoes/vaurca
	)

/datum/outfit/admin/etna_machinist/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/datum/outfit/admin/etna_machinist/get_id_access()
	. = ..()
	return list(ACCESS_ROBOTICS)

/datum/ghostspawner/human/etna_suit
	name = "Hephaestus Corporate Liaison"
	short_name = "etna_suit"
	desc = "Represent the interests of Hephaestus Industries aboard the HICS Etna."
	tags = list("External")

	spawnpoints = list("etna_suit")
	max_count = 2

	outfit = /datum/outfit/admin/etna_suit
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Corporate Liaison (Heph)"
	special_role = "Corporate Liaison (Heph)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/etna_suit
	name = "HICS Etna Corporate Liaison"
	head = /obj/item/clothing/head/beret/corporate/heph
	uniform = /obj/item/clothing/under/rank/liaison/heph
	suit = /obj/item/clothing/suit/storage/liaison/heph
	shoes = /obj/item/clothing/shoes/laceup
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sandals/caligae/socks,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara
	)
	id = /obj/item/card/id/hephaestus
	accessory = /obj/item/clothing/accessory/tie/corporate/heph
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/heph
	l_ear = /obj/item/device/radio/headset/representative
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/stamp/hephaestus = 1
	)

/datum/outfit/admin/etna_suit/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/ghostspawner/human/scc_goon
	name = "Stellar Corporate Conglomerate Liaison"
	short_name = "scc_goon"
	desc = "Represent the interests of the Stellar Corporate Conglomerate aboard the HICS Etna."
	tags = list("External")

	spawnpoints = list("scc_goon")
	max_count = 1

	outfit = /datum/outfit/admin/scc_goon
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Corporate Representative (SCC)"
	special_role = "Corporate Representative (SCC)"
	respawn_flag = null
	enabled = FALSE

/datum/outfit/admin/scc_goon
	name = "SCC Representative"
	uniform = /obj/item/clothing/under/rank/scc2
	suit = /obj/item/clothing/suit/storage/toggle/armor/vest/scc
	accessory = /obj/item/clothing/accessory/tie/corporate/scc
	head = /obj/item/clothing/head/beret/scc
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/representative
	id = /obj/item/card/id/gold
	gloves = /obj/item/clothing/gloves/white
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/scc_goon/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
