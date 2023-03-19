/datum/ghostspawner/human/freighter_crew
	short_name = "freighter_crew"
	name = "Freighter Crewman"
	desc = "Crew the tramp freighter. Be a tramp - carry cargo, do some mining, go salvaging, and try not to get into anything you can't get out of!"
	tags = list("External")

	spawnpoints = list("freighter_crew")
	max_count = 3

	outfit = /datum/outfit/admin/freighter_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Crewman"
	special_role = "Freighter Crewman"
	respawn_flag = null


/datum/outfit/admin/freighter_crew
	name = "Freighter Crewman"

	uniform = /obj/item/clothing/under/syndicate/tracksuit
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/freighter_crew_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless
	)

/datum/outfit/admin/freighter_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/freighter_crew/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/freighter_crew/captain
	short_name = "freighter_crew_captain"
	name = "Freighter Captain"
	desc = "Captain the tramp freighter. Be a tramp - carry cargo, do some mining, go salvaging, and try not to get into anything you can't get out of!"

	spawnpoints = list("freighter_crew_captain")
	max_count = 1

	outfit = /datum/outfit/admin/freighter_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Captain"
	special_role = "Freighter Captain"


/datum/outfit/admin/freighter_crew/captain
	name = "Freighter Captain"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots/grey

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/grey
	)

/obj/item/card/id/freighter_crew_ship
	name = "freight ship id"
	access = list(access_external_airlocks)
