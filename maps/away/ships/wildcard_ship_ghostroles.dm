//freebooter ship

/datum/ghostspawner/human/freebooter
	short_name = "freebooter"
	name = "Freighter Crewman"
	desc = "Crew the tramp freighter. Be a freebooter - carry legitimate and illegitimate cargo, do legitimate and illegitimate mining and salvage, and don't get caught!"
	tags = list("External")

	spawnpoints = list("freebooter")
	max_count = 3

	outfit = /datum/outfit/admin/freebooter
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Crewman"
	special_role = "Freighter Crewman"
	respawn_flag = null


/datum/outfit/admin/freebooter
	name = "Freighter Crewman"

	uniform = /obj/item/clothing/under/syndicate/tracksuit
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack/satchel_norm

	id = /obj/item/card/id/freebooter_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/freebooter/get_id_access()
	return list(access_freebooter_ship, access_external_airlocks)

/datum/ghostspawner/human/freebooter_captain
	short_name = "freebooter_captain"
	name = "Freighter Captain"
	desc = "Command the tramp freighter. Be a freebooter - carry legitimate and illegitimate cargo, do legitimate and illegitimate mining and salvage, and don't get caught!"
	tags = list("External")
	mob_name_prefix = "Pfct. "

	spawnpoints = list("freebooter_captain")
	max_count = 1

	outfit = /datum/outfit/admin/freebooter_captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Captain"
	special_role = "Freighter Captain"
	respawn_flag = null


/datum/outfit/admin/freebooter_captain
	name = "Freighter Captain"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots/grey
	back = /obj/item/storage/backpack/satchel_norm

	id = /obj/item/card/id/freebooter_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/freebooter_captain/get_id_access()
	return list(access_freebooter_ship, access_external_airlocks)