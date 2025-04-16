/datum/ghostspawner/human/ssrm_navy_crewman
	short_name = "ssrm_navy_crewman"
	name = "Sol Navy Recon Crewman"
	desc = "Crew a Solarian naval recon corvette, under the command of Fleet Admiral Klaudia Szalai's Southern Solarian Reconstruction Mandate. Closely monitor and investigate pirate (especially SFA remnant) activity within the region, while serving the interests of the Solarian government, and the SSRM. (OOC Note: Because the bulk of the SSRM's forces are people from the planet Visegrad or the rest of the Southern Solarian Reconstruction Mandate, it is recommended that your character use the Visegradi or general Solarian accent.)"
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("ssrm_navy_crewman")
	max_count = 3

	outfit = /obj/outfit/admin/ssrm_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sol Navy Recon Crewman"
	special_role = "Sol Navy Recon Crewman"
	respawn_flag = null


/obj/outfit/admin/ssrm_navy_crewman
	name = "Sol Recon Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/sol

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/ssrm_navy_crewman/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/ssrm_navy_officer
	short_name = "ssrm_navy_officer"
	name = "Sol Navy Recon Officer"
	desc = "Command a Solarian naval recon corvette, under the command of Fleet Admiral Klaudia Szalai's Southern Solarian Reconstruction Mandate. Closely monitor and investigate pirate (especially SFA remnant) activity within the region, while serving the interests of the Solarian government, and the SSRM. (OOC Note: Because the bulk of the SSRM's forces are people from the planet Visegrad or the rest of the Southern Solarian Reconstruction Mandate, it is recommended that your character use the Visegradi or general Solarian accent.)"
	tags = list("External")
	mob_name_prefix = "LCDR. "

	spawnpoints = list("ssrm_navy_officer")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sol Navy Recon Officer"
	special_role = "Sol Navy Recon Officer"
	respawn_flag = null


/obj/outfit/admin/ssrm_navy_officer
	name = "Sol Navy Recon Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/officer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress/officer
	accessory = /obj/item/clothing/accessory/sol_pin

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/ssrm_navy_officer/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/ssrm_navy_chief_petty_officer
	short_name = "ssrm_navy_chief_petty_officer"
	name = "Sol Navy Recon Chief Petty Officer"
	desc = "Serve as the second-in-command of a Solarian naval recon corvette, under the command of Fleet Admiral Klaudia Szalai's Southern Solarian Reconstruction Mandate. Closely monitor and investigate pirate (especially SFA remnant) activity within the region, while serving the interests of the Solarian government, and the SSRM. (OOC Note: Because the bulk of the SSRM's forces are people from the planet Visegrad or the rest of the Southern Solarian Reconstruction Mandate, it is recommended that your character use the Visegradi or general Solarian accent.)"
	mob_name_prefix = "CPO. "

	spawnpoints = list("ssrm_navy_chief_petty_officer")
	max_count = 1

	assigned_role = "Sol Navy Recon Chief Petty Officer"
	special_role = "Sol Navy Recon Chief Petty Officer"

/obj/outfit/admin/ssrm_navy_chief_petty_officer
	name = "Sol Navy Recon Chief Petty Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/pettyofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress

/datum/ghostspawner/human/ssrm_marine_pilot
	short_name = "ssrm_marine_pilot"
	name = "Sol Marine Recon Exosuit Pilot"
	desc = "Protect a Solarian naval recon corvette under the commander of the Fleet Admiral Klaudia Szalai's Southern Solarian Reconstruction Mandate, and pilot the gremlin recon exosuit. Closely monitor and investigate pirate (OOC Note: Because the bulk of the SSRM's forces are people from the planet Visegrad or the rest of the Southern Solarian Reconstruction Mandate, it is recommended that your character use the Visegradi or general Solarian accent.)"
	tags = list("External")
	mob_name_prefix = "SGT. "

	spawnpoints = list("ssrm_navy_crewman")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_marine_pilot
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sol Marine Recon Exosuit Pilot"
	special_role = "Sol Marine Recon Exosuit Pilot"
	respawn_flag = null


/obj/outfit/admin/ssrm_marine_pilot
	name = "Sol Marine Recon Exosuit Pilot"

	uniform = /obj/item/clothing/under/rank/sol/marine
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/beret/sol

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/ssrm_marine_pilot/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/ssrm_ipc
	short_name = "ssrm_ipc"
	name = "Sol Military Recon Synthetic"
	desc = "Assist the crew of a Solarian naval recon corvette under the command of Fleet Admiral Klaudia Szalai's Southern Solarian Reconstruction Mandate in whatever capacity necessary. Use your superior reflexes and skills to expertly pilot the ship and assist in reconnaissance operations. Remember that you are not a free, enlisted soldier: you are the military's non-combatant property, programmed to rigidly serve the interests of the Solarian government and the SSRM above all else."
	tags = list("External")

	spawnpoints = list("ssrm_ipc")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_ipc
	possible_species = list(SPECIES_IPC, SPECIES_IPC_SHELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sol Military Recon Synthetic"
	special_role = "Sol Military Recon Synthetic"
	respawn_flag = null


/obj/outfit/admin/ssrm_ipc
	name = "Sol Military Recon Synthetic"

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

/obj/outfit/admin/ssrm_ipc/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

//items

/obj/item/card/id/ssrm_ship
	name = "\improper Sol Navy Recon identification card"
	access = list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)
