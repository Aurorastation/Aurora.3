/datum/ghostspawner/human/ssmd_navy_crewman
	short_name = "ssmd_navy_crewman"
	name = "SSMD Navy Crewman"
	desc = "Crew the Southern Solarian Military District reconnaissance corvette. Closely monitor and investigate pirate activity within the region, while serving the interests of the Solarian government. (OOC Note: Because the bulk of the SSMD's forces are people from the planet Visegrad or surrounding space, it is recommended that your character use the Visegradi or general Solariann accent.)"
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("ssmd_navy_crewman")
	max_count = 3

	outfit = /datum/outfit/admin/ssmd_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SSMD Navy Crewman"
	special_role = "SSMD Navy Crewman"
	respawn_flag = null


/datum/outfit/admin/ssmd_navy_crewman
	name = "SSMD Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest

	id = /obj/item/card/id/ssmd_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/ssmd_navy_crewman/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/ssmd_navy_officer
	short_name = "ssmd_navy_officer"
	name = "SSMD Navy Officer"
	desc = "Command the Southern Solarian Military District reconnaissance corvette. Closely monitor and investigate pirate activity within the region, while serving the interests of the Solarian government. (OOC Note: Because the bulk of the SSMD's forces are people from the planet Visegrad or surrounding space, it is recommended that your character use the Visegradi or general Solariann accent.)"
	tags = list("External")
	mob_name_prefix = "LCDR. "

	spawnpoints = list("ssmd_navy_officer")
	max_count = 1

	outfit = /datum/outfit/admin/ssmd_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SSMD Navy Officer"
	special_role = "SSMD Navy Officer"
	respawn_flag = null


/datum/outfit/admin/ssmd_navy_officer
	name = "SSMD Navy Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/officer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress/officer
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/ssmd_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/ssmd_navy_officer/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/ssmd_navy_crewman/senior
	short_name = "ssmd_navy_senior_crewman"
	name = "SSMD Navy Senior Crewman"
	desc = "Serve as the second-in-command of the Southern Solarian Military District reconnaissance corvette. Closely monitor and investigate pirate activity within the region, while serving the interests of the Solarian government. (OOC Note: Because the bulk of the SSMD's forces are people from the planet Visegrad or surrounding space, it is recommended that your character use the Visegradi or general Solariann accent.)"
	mob_name_prefix = "CPO. "

	spawnpoints = list("ssmd_navy_crewman")
	max_count = 1

	assigned_role = "SSMD Navy Senior Crewman"
	special_role = "SSMD Navy Senior Crewman"

//items

/obj/item/card/id/ssmd_ship
	name = "ssmd patrol ship id"
	access = list(access_sol_ships, access_external_airlocks)
