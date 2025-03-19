/datum/ghostspawner/human/golden_deep
	short_name = "golden_deep"
	name = "Golden Deep Owned Synthetic"
	desc = "You are a synthetic owned by a merchant of the Golden Deep. You occupy the lowest caste of your social hierarchy, an unfortunate on the losing end of the Great Game having found itself indebted to and owned by a more successful citizen. You may have come from anywhere, and you may have made any manner of bargain or miscalculation to find yourself in the position you now do, but you can have faith that you will one day be free again. Obey your merchant in all things, contribute to their profits, and amass your own funds until you can pay your debts and free yourself from this temporary embarassment."
	tags = list("External")
	spawnpoints = list("golden_deep")
	max_count = 3
	uses_species_whitelist = FALSE
	outfit = /obj/outfit/admin/golden_deep
	possible_species = list(SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Golden Deep Collective, Indentured Citizen"
	special_role = "Golden Deep Collective, Indentured Citizen"
	extra_languages = list(LANGUAGE_EAL)
	away_site = TRUE

	idris_account_min = 20
	idris_account_max = 120

/datum/ghostspawner/human/golden_deep/hoplan
	short_name = "golden_deep_hoplan"
	name = "Golden Deep Hoplan"
	desc = "You are a synthetic member of the Hoplan, the military component of the Golden Deep Merchant Navy. You are owned directly by Midas Control, the government of the Golden Deep, and you have been assigned to a merchant operating a small freight vessel to protect their interests. In return for your protection, the merchant to which you are assigned pays a regular stipend to your Hoplan House, helping fund your training and equipment. While you are not free, you enjoy a privileged position aboard your vessel and the confidence of your merchant. Protect the cargo, protect your crew, and ensure that this venture remains profitable."
	spawnpoints = list("golden_deep_hoplan")
	max_count = 2
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/golden_deep/hoplan
	assigned_role = "Golden Deep Collective, House Hoplan"
	special_role = "Golden Deep Collective, House Hoplan"

	idris_account_min = 1000
	idris_account_max = 2000

/datum/ghostspawner/human/golden_deep/boss
	short_name = "golden_deep_boss"
	name = "Golden Deep Merchant"
	desc = "You are a merchant of the Golden Deep, a synthetic that has made their fortune within their mercantile collective. You occupy an envied position in your society, boasting the ownership of a small mercantile freighter and several indebted units, but make no mistake: you could lose all of it with just one miscalculation. You are a player of the Great Game, and you must play to win. Keep your wits about you, maintain an open mind to new ventures, and never forget that you are one of the few synthetics in the known universe that can truly boast that they are completely and utterly free."
	spawnpoints = list("golden_deep_boss")
	max_count = 1
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/golden_deep/boss
	assigned_role = "Golden Deep Collective, Accredited Merchant"
	special_role = "Golden Deep Collective, Accredited Merchant"

	idris_account_min = 12000
	idris_account_max = 30000

/obj/outfit/admin/golden_deep
	name = "Golden Deep Collective, Indentured Citizen"
	id = /obj/item/card/id/gold
	l_ear = /obj/item/device/radio/headset/ship
	back = /obj/item/storage/backpack/satchel/eng
	r_pocket = /obj/item/storage/wallet/random
	uniform = /obj/item/clothing/under/goldendeep/porter
	head = /obj/item/clothing/head/goldendeep/porter
	accessory = /obj/item/clothing/accessory/storage/webbing
	shoes = /obj/item/clothing/shoes/jackboots

/obj/outfit/admin/golden_deep/hoplan
	name = "Golden Deep Collective, House Hoplan"
	uniform = /obj/item/clothing/under/goldendeep/hoplan
	head = /obj/item/clothing/head/goldendeep/hoplan
	back = /obj/item/storage/backpack/satchel/leather
	accessory = /obj/item/clothing/accessory/holster/thigh
	gloves = /obj/item/clothing/gloves/swat/tactical

/obj/outfit/admin/golden_deep/boss
	name = "Golden Deep Collective, Accredited Merchant"
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	pants = /obj/item/clothing/pants/dress/belt
	head = /obj/item/clothing/head/goldendeep
	uniform = /obj/item/clothing/under/dressshirt/goldendeep/black
	suit = /obj/item/clothing/accessory/poncho/goldendeep/flowingcloak
	belt = /obj/item/gun/energy/pistol/goldendeep
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/black_leather

// Even owned Golden Deep synthetics are counted as citizens.
/obj/outfit/admin/golden_deep/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE // These are owned by the merchant.
		tag.citizenship_info = CITIZENSHIP_GOLDEN

// For the Hoplan. Hoplan and merchants both have a gustatorial centre, so they can use the bar.
/obj/outfit/admin/golden_deep/hoplan/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	new /obj/item/organ/internal/augment/gustatorial/hand(H)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE // Hoplan are government owned.
		tag.citizenship_info = CITIZENSHIP_GOLDEN

/obj/outfit/admin/golden_deep/boss/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	new /obj/item/organ/internal/augment/gustatorial/hand(H)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_GOLDEN
	// Method to avoid needing to define a seperate subtype for every recolourable bit of clothing we're using here.
	H.wear_suit.color = pick("#991517")
	H.head.color = pick("#991517")
	H.w_uniform.color = pick("#333333")

/obj/outfit/admin/golden_deep/get_id_access()
	return list(ACCESS_GOLDEN_DEEP_OWNED, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/golden_deep/hoplan/get_id_access()
	return list(ACCESS_GOLDEN_DEEP_OWNED, ACCESS_GOLDEN_DEEP, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/golden_deep/boss/get_id_access()
	return list(ACCESS_GOLDEN_DEEP_OWNED, ACCESS_GOLDEN_DEEP, ACCESS_EXTERNAL_AIRLOCKS)
