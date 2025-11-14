//orion mining ship

/datum/ghostspawner/human/orion_miner
	short_name = "orion_miner"
	name = "Orion Mining Skiff Crewmember"
	desc = "Crew the Orion Express mining skiff as a crewmate or miner."
	tags = list("External")

	spawnpoints = list("orion_miner")
	max_count = 4

	outfit = /obj/outfit/admin/orion_miner
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Orion Mining Skiff Crewmember"
	special_role = "Orion Mining Skiff Crewmember"
	respawn_flag = null


/obj/outfit/admin/orion_miner
	name = "Orion Mining Skiff Crewmember"

	uniform = /obj/item/clothing/under/rank/miner/orion
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel/eng
	wrist = /obj/item/clothing/wrists/watch

	id = /obj/item/card/id/orion/miner

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/workboots/toeless
	)

/obj/outfit/admin/orion_miner/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()

	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		H.equip_or_collect(new /obj/item/stack/nanopaste, slot_in_backpack)
		if(istype(tag))
			tag.modify_tag_data()
	else
		H.equip_or_collect(new /obj/item/storage/firstaid/sleekstab, slot_in_backpack)

/obj/outfit/admin/orion_miner/get_id_access()
	return list(ACCESS_ORION_EXPRESS_SHIP, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MINING, ACCESS_ENGINE_EQUIP)

/obj/item/card/id/orion/miner
	name = "\improper Orion Express mining identification card"
	access = list(ACCESS_ORION_EXPRESS_SHIP, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MINING, ACCESS_ENGINE_EQUIP)
