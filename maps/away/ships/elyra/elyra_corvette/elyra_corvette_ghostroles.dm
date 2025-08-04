// naval infantry
/datum/ghostspawner/human/elyran_navy_crewman
	short_name = "elyran_navy_crewman"
	name = "Elyran Naval Infantryman"
	desc = "Crew the Elyran Corvette, and serve as the frontline in any combat situations. Assist in any ship operations as needed. Ensure the integrity and safety of the Serene Republic of Elyra's borders."
	tags = list("External")
	mob_name_prefix = "RFLMN. "

	spawnpoints = list("elyran_navy_crewman")
	max_count = 2

	outfit = /obj/outfit/admin/elyran_navy_crewman
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Elyran Naval Infantryman"
	special_role = "Elyran Naval Infantryman"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/elyran)


/obj/outfit/admin/elyran_navy_crewman
	name = "Elyran Naval Infantryman"

	uniform = /obj/item/clothing/under/rank/elyran_fatigues
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/elyran_corvette

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)


/obj/outfit/admin/elyran_navy_crewman/get_id_access()
	return list(ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/elyran_navy_crewman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isipc(H)) // All Elyran Navy synthetics are tagged, self-owned, and have Elyran citizenship.
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
			tag.ownership_info = IPC_OWNERSHIP_SELF
			tag.citizenship_info = CITIZENSHIP_ELYRA

// senior crewman
/datum/ghostspawner/human/elyran_navy_crewman/nco
	short_name = "elyran_navy_crewman_nco"
	name = "Elyran Navy Senior Crewman"
	desc = "Crew the Elyran Corvette, and serve as the ship's second-in-command. Keep the rest of the crew in check. Ensure the integrity and safety of the Serene Republic of Elyra's borders."
	mob_name_prefix = "CPO. "

	spawnpoints = list("elyran_navy_crewman_nco")
	max_count = 1

	outfit = /obj/outfit/admin/elyran_navy_crewman/nco

	assigned_role = "Elyran Navy Senior Crewman"
	special_role = "Elyran Navy Senior Crewman"


/obj/outfit/admin/elyran_navy_crewman/nco
	name = "Elyran Navy Senior Crewman"

// engineer
/datum/ghostspawner/human/elyran_navy_crewman/engineer
	short_name = "elyran_navy_crewman_engineer"
	name = "Elyran Naval Engineer"
	desc = "Crew the Elyran Corvette, and maintain the ship. You serve as the ship's engineer, as well as a combat engineer. Ensure the integrity and safety of the Serene Republic of Elyra's borders."
	mob_name_prefix = "PO3. "

	spawnpoints = list("elyran_navy_crewman_engineer")
	max_count = 1

	outfit = /obj/outfit/admin/elyran_navy_crewman/engineer

	assigned_role = "Elyran Naval Engineer"
	special_role = "Elyran Naval Engineer"


/obj/outfit/admin/elyran_navy_crewman/engineer
	name = "Elyran Naval Engineer"

// corpsman
/datum/ghostspawner/human/elyran_navy_crewman/corpsman
	short_name = "elyran_navy_crewman_corpsman"
	name = "Elyran Navy Corpsman"
	desc = "Crew the Elyran Corvette, and man the ship's medbay. You serve as the ship's doctor, as well as a combat medic. Ensure the integrity and safety of the Serene Republic of Elyra's borders."
	mob_name_prefix = "PO2. "

	spawnpoints = list("elyran_navy_crewman_corpsman")
	max_count = 1

	outfit = /obj/outfit/admin/elyran_navy_crewman/corpsman

	assigned_role = "Elyran Navy Corpsman"
	special_role = "Elyran Navy Corpsman"


/obj/outfit/admin/elyran_navy_crewman/corpsman
	name = "Elyran Navy Corpsman"

// officer
/datum/ghostspawner/human/elyran_navy_crewman/officer
	short_name = "elyran_navy_crewman_officer"
	name = "Elyran Navy Officer"
	desc = "Command the Elyran Corvette, and keep the crew on track. Ensure the integrity and safety of the Serene Republic of Elyra's borders."
	mob_name_prefix = "LT. "

	spawnpoints = list("elyran_navy_crewman_officer")
	max_count = 1

	outfit = /obj/outfit/admin/elyran_navy_crewman/officer

	assigned_role = "Elyran Navy Officer"
	special_role = "Elyran Navy Officer"


/obj/outfit/admin/elyran_navy_crewman/officer
	name = "Elyran Navy Officer"
	uniform = /obj/item/clothing/under/rank/elyran_fatigues/commander

//items
/obj/item/card/id/elyran_corvette
	name = "elyran corvette id"
	access = list(ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
