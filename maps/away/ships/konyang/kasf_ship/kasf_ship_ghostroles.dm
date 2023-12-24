// kasf crewman
/datum/ghostspawner/human/kasf_crewman
	short_name = "kasf_crewman"
	name = "KASF Crewman"
	desc = "Crew the Konyang Aerospace Forces corvette, and assist in any ship operations as needed. Protect the Haneunim System from pirates and police the influx of refugees from the Human Wildlands in accordance to Konyang's strict immigration laws."
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("kasf_crewman")
	max_count = 3

	outfit = /datum/outfit/admin/kasf_crewman
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_SHELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "KASF Crewman"
	special_role = "KASF Crewman"
	respawn_flag = null


/datum/outfit/admin/kasf_crewman
	name = "KASF Crewman"
	uniform = /obj/item/clothing/under/rank/konyang/space
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/kasf_corvette

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/kasf_crewman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/kasf_crewman/get_id_access()
	return list(access_konyang_police, access_external_airlocks)

// kasf engineer
/datum/ghostspawner/human/kasf_crewman/engineer
	short_name = "kasf_engineer"
	name = "KASF Engineer"
	desc = "Crew the Konyang Aerospace Forces corvette, and maintain the ship. Protect the Haneunim System from pirates and police the influx of refugees from the Human Wildlands in accordance to Konyang's strict immigration laws."
	tags = list("External")
	mob_name_prefix = "PO1. "

	spawnpoints = list("kasf_engineer")
	max_count = 1

	outfit = /datum/outfit/admin/kasf_crewman/engineer

	assigned_role = "KASF Engineer"
	special_role = "KASF Engineer"

/datum/outfit/admin/kasf_crewman/engineer
	name = "KASF Engineer"

// kasf corpsman
/datum/ghostspawner/human/kasf_crewman/corpsman
	short_name = "kasf_corpsman"
	name = "KASF Corpsman"
	desc = "Crew the Konyang Aerospace Forces corvette, and man the ship's medbay. Protect the Haneunim System from pirates and police the influx of refugees from the Human Wildlands in accordance to Konyang's strict immigration laws."
	tags = list("External")
	mob_name_prefix = "PO2. "

	spawnpoints = list("kasf_corpsman")
	max_count = 1

	outfit = /datum/outfit/admin/kasf_crewman/corpsman

	assigned_role = "KASF Corpsman"
	special_role = "KASF Corpsman"

/datum/outfit/admin/kasf_crewman/corpsman
	name = "KASF Corpsman"

// kasf officer
/datum/ghostspawner/human/kasf_crewman/officer
	short_name = "kasf_crewman_officer"
	name = "KASF Officer"
	desc = "Command the Konyang Aerospace Forces corvette. Protect the Haneunim System from pirates and police the influx of refugees from the Human Wildlands in accordance to Konyang's strict immigration laws."
	mob_name_prefix = "LT. "

	spawnpoints = list("kasf_crewman_officer")
	max_count = 1

	outfit = /datum/outfit/admin/kasf_crewman/officer

	assigned_role = "KASF Officer"
	special_role = "KASF Offcier"


/datum/outfit/admin/kasf_crewman/officer
	name = "KASF Officer"

	uniform = /obj/item/clothing/under/rank/konyang/space/officer
	head = /obj/item/clothing/head/konyang/space

/obj/item/card/id/kasf_corvette
	name = "kasf corvette id"
	access = list(access_konyang_police, access_external_airlocks)
