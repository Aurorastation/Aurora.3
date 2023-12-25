/datum/ghostspawner/human/golden_deep
	short_name = "golden_deep"
	name = "Golden Deep Owned Synthetic"
	desc = "You are an IPC, property of a merchant of the Golden Deep. Work hard, pay off the debt you owe to your 'employer', and maybe some day you too can acquire your freedom..."
	tags = list("External")
	spawnpoints = list("golden_deep")
	max_count = 3
	uses_species_whitelist = FALSE
	welcome_message = "You are an IPC, property of a merchant of the Golden Deep. Work hard, pay off the debt you owe to your 'employer', and maybe some day you too can acquire your freedom..."
	outfit = /datum/outfit/admin/golden_deep
	possible_species = list(SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Golden Deep Owned Synthetic"
	special_role = "Golden Deep Owned Synthetic"
	extra_languages = list(LANGUAGE_EAL)
	away_site = TRUE

/datum/ghostspawner/human/golden_deep/boss
	short_name = "golden_deep_boss"
	name = "Golden Deep Vessel Owner"
	desc = "You are a synthetic merchant of the Golden Deep, here with one mission and one mission only - profit! Manage your owned synthetics, sell your goods, and climb the hierarchy of your insular organization."
	spawnpoints = list("golden_deep_boss")
	max_count = 2
	uses_species_whitelist = TRUE
	welcome_message = "You are a synthetic merchant of the Golden Deep, here with one mission and one mission only - profit! Manage your owned synthetics, sell your goods, and climb the hierarchy of your insular organization."
	outfit = /datum/outfit/admin/golden_deep/boss
	assigned_role = "Golden Deep Merchant"
	special_role = "Golden Deep Merchant"

/datum/outfit/admin/golden_deep
	name = "Golden Deep Owned Synthetic"
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/storage/wallet/random
	uniform = /obj/item/clothing/under/gearharness
	accessory = /obj/item/clothing/accessory/storage/webbing

/datum/outfit/admin/golden_deep/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE
		tag.citizenship_info = CITIZENSHIP_NONE

/datum/outfit/admin/golden_deep/boss
	name = "Golden Deep Merchant"
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

/datum/outfit/admin/golden_deep/get_id_access()
	return list(access_golden_deep, access_external_airlocks)

/datum/outfit/admin/golden_deep/boss/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_GOLDEN
