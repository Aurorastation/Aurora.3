//Cyclops Crew
/datum/ghostspawner/human/cyclops_crew
	short_name = "cyclops_crew"
	name = "Hephaestus Cyclops Mining Crew"
	desc = "Crew the Hephaestus Mining Vessel."
	tags = list("External")

	welcome_message = "As a Hephaestus Cyclops Mining Crew, you are tasked with mining this sector's resources for Hephaestus Industries."

	spawnpoints = list("cyclops_crew")
	max_count = 3

	outfit = /obj/outfit/admin/cyclops_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Crew"
	special_role = "Hephaestus Cyclops Crew"
	respawn_flag = null

/obj/outfit/admin/cyclops_crew
	name = "Hephaestus Cyclops Crew"

	uniform = /obj/item/clothing/under/rank/miner/heph
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel/heph

	id = /obj/item/card/id/hephaestus

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_BULWARK = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/vaurca
	)

/obj/outfit/admin/cyclops_crew/miner/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.update_body()
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/cyclops_crew/get_id_access()
	return list(ACCESS_HEPHAESTUS,ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/cyclops_crew/security
	short_name = "cyclops_security"
	name = "Hephaestus Cyclops Security Officer"
	desc = "Act as the Hephaestus Mining Vessels Security Officer."

	welcome_message = "As a Hephaestus Cyclops Security Officer, you are tasked with protecting the Hephaestus crew during their operations."
	spawnpoints = list("cyclops_security")
	max_count = 1

	outfit = /obj/outfit/admin/cyclops_crew/security
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Security Officer"
	special_role = "Hephaestus Security Officer"

/obj/outfit/admin/cyclops_crew/security
	name = "Hephaestus Security Officer"

	uniform = /obj/item/clothing/under/rank/security/heph

/datum/ghostspawner/human/cyclops_crew/captain
	short_name = "cyclops_captain"
	name = "Hephaestus Cyclops Captain"
	desc = "Act as the Hephaestus Mining Vessels Captain"

	welcome_message = "As a Hephaestus Cyclops Captain, you must led the crew of your ship and protect Hephaestus' interests in the region."

	spawnpoints = list("cyclops_captain")
	max_count = 1

	outfit = /obj/outfit/admin/cyclops_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Captain"
	special_role = "Hephaestus Cyclops Captain"

/obj/outfit/admin/cyclops_crew/captain
	name = "Cyclops Crew Captain"

	uniform = /obj/item/clothing/under/rank/captain/hephaestus
	head = /obj/item/clothing/head/caphat/cap/hephaestus
	gloves = /obj/item/clothing/gloves/captain/hephaestus
	back = /obj/item/storage/backpack/satchel/leather

/datum/ghostspawner/human/cyclops_crew/engineer
	short_name = "cyclops_engineer"
	name = "Hephaestus Cyclops Engineer"
	desc = "Act as the Hephaestus Mining Vessels sole Engineer."

	spawnpoints = list("cyclops_engineer")
	max_count = 1

	welcome_message = "As a Hephaestus Cyclops Engineer, you are tasked with ensuring the functioning of the ship and repairing any engineering problem during mining operations."

	outfit = /obj/outfit/admin/cyclops_crew/engineer
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Cyclops Engineer"
	special_role = "Hephaestus Cyclops Engineer"

/obj/outfit/admin/cyclops_crew/engineer
	name = "Hephaestus Engineer"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	gloves = /obj/item/clothing/gloves/yellow
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu,
		SPECIES_TAJARA = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_VAURCA_WARRIOR = null,
		SPECIES_VAURCA_WORKER = null,
		SPECIES_VAURCA_BULWARK = null
	)


