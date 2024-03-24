/datum/ghostspawner/human/water_barge
	name = "Water Barge Crew"
	short_name = "water_barge"
	desc = "Crew a PACHROM water transport barge."
	tags = list("External")
	spawnpoints = list("water_barge")
	max_count = 4

	outfit = /obj/outfit/admin/pachrom
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "PACHROM Transport Crew"
	special_role = "PACHROM Transport Crew"
	respawn_flag = null
	away_site = TRUE

/obj/outfit/admin/pachrom
	name = "PACHROM Crew"
	uniform = /obj/item/clothing/under/rank/konyang/pachrom
	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/black
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/pachrom/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_COALITION

