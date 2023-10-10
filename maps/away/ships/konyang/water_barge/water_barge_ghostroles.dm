/datum/ghostspawner/human/water_barge
	name = "Water Barge Crew"
	short_name = "water_barge"
	desc = "Crew a PACHROM water transport barge."
	tags = list("External")
	spawnpoints = list("water_barge")
	max_count = 4

	outfit = /datum/outfit/admin/pachrom
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "PACHROM Transport Crew"
	special_role = "PACHROM Transport Crew"
	respawn_flag = null
	away_site = TRUE

/datum/outfit/admin/pachrom
	name = "PACHROM Crew"
	uniform = /obj/item/clothing/under/color/grey //TODO: Pachrom uniforms
	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/black
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random
