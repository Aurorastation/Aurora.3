/datum/ghostspawner/human/golden_deep
	short_name = "golden_deep"
	name = "Golden Deep Owned Synthetic"
	desc = "MUST FILL"
	tags = list("External")
	spawnpoints = list("golden_deep")
	max_count = 3
	uses_species_whitelist = FALSE
	welcome_message = "MUST FILL"
	outfit = /obj/outfit/admin/golden_deep
	possible_species = list(SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Golden Deep Owned Synthetic"
	special_role = "Golden Deep Owned Synthetic"
	extra_languages = list(LANGUAGE_EAL)
	away_site = TRUE

	idris_account_min = 12
	idris_account_max = 30

/datum/ghostspawner/human/golden_deep/hoplan
	short_name = "golden_deep_hoplan"
	name = "Golden Deep Hoplan"
	desc = "MUST FILL"
	spawnpoints = list("golden_deep_hoplan")
	max_count = 2
	uses_species_whitelist = TRUE
	welcome_message = "MUST FILL"
	outfit = /obj/outfit/admin/golden_deep/hoplan
	assigned_role = "Golden Deep Hoplan"
	special_role = "Golden Deep Hoplan"

	idris_account_min = 1000
	idris_account_max = 2000

/datum/ghostspawner/human/golden_deep/boss
	short_name = "golden_deep_boss"
	name = "Golden Deep Merchant"
	desc = "MUST FILL"
	spawnpoints = list("golden_deep_boss")
	max_count = 1
	uses_species_whitelist = TRUE
	welcome_message = "MUST FILL"
	outfit = /obj/outfit/admin/golden_deep/boss
	assigned_role = "Golden Deep Merchant"
	special_role = "Golden Deep Merchant"

	idris_account_min = 12000
	idris_account_max = 30000

/obj/outfit/admin/golden_deep
	name = "Golden Deep Collective, Indentured Citizen"
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/storage/wallet/random
	uniform = /obj/item/clothing/under/gearharness
	accessory = /obj/item/clothing/accessory/storage/webbing

// Owned tag includes the Hoplan, which are owned by the government and assigned preferentially to merchants that donate to their house.
/obj/outfit/admin/golden_deep/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE
		tag.citizenship_info = CITIZENSHIP_GOLDEN // Even owned Golden Deep synthetics are counted as citizens.

/obj/outfit/admin/golden_deep/boss
	name = "Golden Deep Collective, Accredited Merchant"
	id = /obj/item/card/id/gold
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	uniform = list(
		/obj/item/clothing/under/goldendeep/wrap,
		/obj/item/clothing/under/goldendeep,
		/obj/item/clothing/under/goldendeep/suit,
		/obj/item/clothing/under/goldendeep/skirtsuit,
		/obj/item/clothing/under/goldendeep/vest
	)
	shoes = /obj/item/clothing/shoes/laceup/
	wrist = /obj/item/clothing/wrists/goldbracer
	accessory = /obj/item/clothing/accessory/necklace/chain
	head = /obj/item/clothing/head/crest

/obj/outfit/admin/golden_deep/hoplan
	name = "Golden Deep Collective, House Hoplan"
	uniform = /obj/item/clothing/under/goldendeep/hoplan

/obj/outfit/admin/golden_deep/get_id_access()
	return list(ACCESS_GOLDEN_DEEP, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/golden_deep/boss/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_GOLDEN
