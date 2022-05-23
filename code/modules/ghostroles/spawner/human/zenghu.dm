/datum/ghostspawner/human/zenghu_survivor
	short_name = "zenghu"
	name = "Zeng-Hu Survivor"
	desc = "Survive whatever might lurk in the Zeng-Hu installation."
	tags = list("External")

	enabled = FALSE
	spawnpoints = list("zenghu")
	req_perms = null
	max_count = 3

	away_site = TRUE

	outfit = /datum/outfit/admin/zenghu_survivor
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Zeng-Hu Survivor"
	special_role = "Zeng-Hu Survivor"
	respawn_flag = null

/datum/outfit/admin/zenghu_survivor
	name = "Zeng-Hu Employee"

	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	belt = /obj/item/storage/belt/utility/full
	id = /obj/item/card/id/zeng_hu
	r_hand = /obj/item/device/flashlight
