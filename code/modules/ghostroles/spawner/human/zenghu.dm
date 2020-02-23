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
	possible_species = list(SPECIES_HUMAN, SPECIES_OFFWORLDER_HUMAN, SPECIES_SKRELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC)
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Zeng-Hu Survivor"
	special_role = "Zeng-Hu Survivor"
	respawn_flag = null
	uses_species_whitelist = TRUE

/datum/outfit/admin/zenghu_survivor
	name = "Zeng-Hu Employee"

	uniform = /obj/item/clothing/under/rank/zeng
	shoes = /obj/item/clothing/shoes/white
	belt = /obj/item/storage/belt/utility/full
	id = /obj/item/card/id/zeng_hu
	r_hand = /obj/item/device/flashlight

