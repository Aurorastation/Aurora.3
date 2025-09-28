/datum/ghostspawner/human/Solfrig_crewman
	short_name = "Solfrig_crewman"
	name = "Solarian Frigate Crewman"
	desc = "Crew a Solarian Naval Frigate, under the command of either the Northern or Southern Solarian Reconstruction Mandate. Serve and protect the interests of the Alliance, whever you are. (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and Colettish accents for the North.)"
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("Solfrig_navy_crewman")
	max_count = 3

	outfit = /obj/outfit/admin/ssrm_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Solarian Frigate Crewman"
	special_role = "Solarian Frigate Crewman"
	respawn_flag = null


/obj/outfit/admin/solfrig_navy_crewman
	name = "Solarian Frigate Crewman"

	uniform = /obj/item/clothing/under/rank/sol
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/sol

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/Solfrig_navy_crewman/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/Solfrig_Commander
	short_name = "Solfrig_Commander"
	name = "Solarian Frigate Commander"
	desc = "Command a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. Serve and defend the interests of the Solarian Government, wherever you are assigned to. Praying for a more prestigious command is optional (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish accents for the North.) "
	tags = list("External")
	mob_name_prefix = "CDR. "

	spawnpoints = list("Solfrig_commander")
	max_count = 1

	outfit = /obj/outfit/admin/Solfrig_Commander
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Solarian Frigate Commander"
	special_role = "Solarian Frigate Commander"
	respawn_flag = null


/obj/outfit/admin/Solfrig_Commander
	name = "Solarian Frigate Commander"

	uniform = /obj/item/clothing/under/rank/sol/dress/officer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress/officer
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/Solfrig_Commander/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/Solfrig_XO
	short_name = "Solfrig_XO"
	name = "Solarian Frigate Lieutenant"
	desc = "Serve as the Executive Officer aboard a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. Follow the orders of your Captain, and defend the interests of the Solarian Alliance. No matter where you are. (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish accents for the North.) "
	mob_name_prefix = "LT. "

	spawnpoints = list("Solfrig_XO")
	max_count = 1

	outfit = /obj/outfit/admin/Solfrig_XO
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY


	assigned_role = "Solarian Frigate Executive Officer"
	special_role = "Solarian Frigate Executive Officer"

/obj/outfit/admin/Solfrig_XO
	name = "Solarian Frigate Executive Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

obj/outfit/admin/Solfrig_Commander/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/Solfrig_ipc
	short_name = "Solfrig_ipc"
	name = "Solarian Frigate Synthetic"
	desc = "Serve as a Navy-owned IPC aboard a Solarian Frigate. Remember that you are not a free, enlisted soldier: you are the military's non-combatant property, programmed to rigidly serve the interests of the Solarian government above all else."
	tags = list("External")

	spawnpoints = list("Solfrig_ipc")
	max_count = 1

	outfit = /obj/outfit/admin/solfrig_ipc
	possible_species = list(SPECIES_IPC, SPECIES_IPC_SHELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sol Navy Synthetic"
	special_role = "Sol Navy Synthetic"
	respawn_flag = null


/obj/outfit/admin/solfrig_ipc
	name = "Sol Military Navy Synthetic"

	uniform = /obj/item/clothing/under/rank/sol/ipc
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/ssrm_ipc/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE
		tag.citizenship_info = CITIZENSHIP_NONE

/obj/outfit/admin/solfrig_ipc/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/Solfrig_Intern
	short_name = "Solfrig_Intern"
	name = "Solarian Frigate Midshipman"
	desc = "Serve as an officer-in-training aboard a Solarian Navy Frigate. Learn to lead, and not to be totally incompetent. (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish accents for the North.) "
	mob_name_prefix = "MIDN. "

	spawnpoints = list("Solfrig_Intern")
	max_count = 1

	assigned_role = "Solarian Navy Cadet"
	special_role = "Solarian Navy Cadet"

/obj/outfit/admin/Solfrig_navy_intern
	name = "Solarian Navy Cadet"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress

