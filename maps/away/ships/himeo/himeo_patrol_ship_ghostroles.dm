/datum/ghostspawner/human/himeo_patrol_ship
	short_name = "himeo_patrol_ship_crewman"
	name = "Himean Naval Crewman"
	desc = "Placeholder"
	tags = list("External")
	spawnpoints = list("himeo_patrol")
	welcome_message = "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOORAH FOR THE REVOLUTION"

	max_count = 4
	respawn_flag = null
	outfit = /obj/outfit/admin/himeo_patrol

	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Himean Naval Crewman"
	special_role = "Himean Naval Crewman"

	culture_restriction = list(/singleton/origin_item/culture/coalition)

/obj/outfit/admin/himeo_patrol
	name = "Himean Naval Crewman"
	uniform = /obj/item/clothing/under/himeo
