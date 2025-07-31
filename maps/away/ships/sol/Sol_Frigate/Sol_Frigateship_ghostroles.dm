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

/datum/ghostspawner/human/ssrm_navy_officer
	short_name = "Solfrig_Commander"
	name = "Solarian Frigate Commander"
	desc = "Command a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. Serve and defend the interests of the Solarian Government, wherever you are assigned to. Praying for a more prestigious command is optional (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish accents for the North.) "
	tags = list("External")
	mob_name_prefix = "CDR. "

	spawnpoints = list("Solfrig_commander")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Solarian Frigate Commander"
	special_role = "Solarian Frigate Commander"
	respawn_flag = null


/obj/outfit/admin/ssrm_navy_officer
	name = "Solarian Frigate Commander"

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

/datum/ghostspawner/human/Solfrig_XO
	short_name = "Solfrig_XO"
	name = "Solarian Frigate Lieutenant"
	desc = "Serve as the Executive Officer aboard a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. Follow the orders of your Captain, and defend the interests of the Solarian Alliance. No matter where you are. (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish accents for the North.) "
	mob_name_prefix = "LT. "

	spawnpoints = list("Solfrig_XO")
	max_count = 1

	assigned_role = "Solarian Frigate Executive Officer"
	special_role = "Solarian Frigate Executive Officer"

/obj/outfit/admin/Solfrig_navy_XO
	name = "Solarian Frigate Executive Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

/datum/ghostspawner/human/ssrm_marine_pilot
	short_name = "ssrm_marine_pilot"
	name = "Sol Marine Recon Exosuit Pilot"
	desc = "Serve as the Exosuit Pilot aboard an Solarian Frigate. Under the authority of either the Northern or Southern Solarian Reconstruction Mandate. Defend your ship, the honor of the corps, and the intrests of the Solarian Government. Oorah!"
	tags = list("External")
	mob_name_prefix = "SGT. "

	spawnpoints = list("Solfrig_navy_crewman")
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

