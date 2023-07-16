//Cyclops Crew
/datum/ghostspawner/human/cyclops_crew
	short_name = "cyclops_crew"
	name = "Hephaestus Cyclops Mining Crew"
	desc = "Crew the Hephaestus Mining Vessel."
	tags = list("External")

	spawnpoints = list("cyclops_crew")
	max_count = 3

	outfit = /datum/outfit/admin/cyclops_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Crew"
	special_role = "Hephaestus Cyclops Crew"
	respawn_flag = null

/datum/outfit/admin/cyclops_crew
	name = "Hephaestus Cyclops Crew"

	uniform = /obj/item/clothing/under/rank/miner/heph
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/hephaestus

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/cyclops_crew/miner/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/cyclops_crew/get_id_access()
	return list(access_hephaestus,access_external_airlocks)

/datum/ghostspawner/human/cyclops_crew/security
	short_name = "cyclops_security"
	name = "Hephaestus Cyclops Security Officer"
	desc = "Act as the Hephaestus Mining Vessels Security Officer."

	spawnpoints = list("cyclops_security")
	max_count = 1

	outfit = /datum/outfit/admin/cyclops_crew/security
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Security Officer"
	special_role = "Hephaestus Security Officer"

/datum/outfit/admin/cyclops_crew/security
	name = "Hephaestus Security Officer"

	uniform = /obj/item/clothing/under/rank/security/heph
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/cyclops_crew/captain
	short_name = "cyclops_captain"
	name = "Hephaestus Cyclops Captain"
	desc = "Act as the Hephaestus Mining Vessels Captain"

	spawnpoints = list("cyclops_captain")
	max_count = 1

	outfit = /datum/outfit/admin/cyclops_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Captain"
	special_role = "Hephaestus Cyclops Captain"

/datum/outfit/admin/cyclops_crew/captain
	name = "Cyclops Crew Captain"

	uniform = /obj/item/clothing/under/rank/captain/hephaestus
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel/leather

/datum/ghostspawner/human/cyclops_crew/engineer
	short_name = "cyclops_engineer"
	name = "Hephaestus Cyclops Engineer"
	desc = "Act as the Hephaestus Mining Vessels sole Engineer."

	spawnpoints = list("cyclops_engineer")
	max_count = 1

	outfit = /datum/outfit/admin/cyclops_crew/engineer
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Engineer"
	special_role = "Hephaestus Cyclops Engineer"

/datum/outfit/admin/cyclops_crew/engineer
	name = "Hephaestus Engineer"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel


