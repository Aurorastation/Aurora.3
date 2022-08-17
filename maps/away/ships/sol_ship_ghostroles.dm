//sfa patrol ship

/datum/ghostspawner/human/sfa_navy_crewman
	short_name = "sfa_navy_crewman"
	name = "SFA Navy Crewman"
	desc = "Crew the Southern Fleet Administration corvette. Figure out what to do now that the warlord you serve is dead."
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("sfa_navy_crewman")
	max_count = 2

	outfit = /datum/outfit/admin/sfa_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Navy Crewman"
	special_role = "SFA Navy Crewman"
	respawn_flag = null


/datum/outfit/admin/sfa_navy_crewman
	name = "SFA Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/norm
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest

	id = /obj/item/card/id/sfa_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/sfa_navy_crewman/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/sfa_navy_officer
	short_name = "sfa_navy_officer"
	name = "SFA Navy Officer"
	desc = "Pilot and command a Southern Fleet Administration corvette. Figure out what to do now that the warlord you serve is dead."
	tags = list("External")
	mob_name_prefix = "LT. "

	spawnpoints = list("sfa_navy_officer")
	max_count = 1

	outfit = /datum/outfit/admin/sfa_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Navy Officer"
	special_role = "SFA Navy Officer"
	respawn_flag = null


/datum/outfit/admin/sfa_navy_officer
	name = "SFA Navy Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/sfa_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/sfa_navy_officer/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/sfa_marine
	short_name = "sfa_marine"
	name = "SFA Marine"
	desc = "Protect the Southern Fleet Administration corvette. Figure out what to do now that the warlord you serve is dead."
	tags = list("External")
	mob_name_prefix = "Pfc. "

	spawnpoints = list("sfa_navy_crewman")
	max_count = 2

	outfit = /datum/outfit/admin/sfa_marine
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Marine"
	special_role = "SFA Marine"
	respawn_flag = null


/datum/outfit/admin/sfa_marine
	name = "SFA Marine"

	uniform = /obj/item/clothing/under/rank/sol/marine
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/norm
	belt = /obj/item/storage/belt/military
	head = /obj/item/clothing/head/sol/marine
	accessory = /obj/item/clothing/accessory/storage/pouches/black

	id = /obj/item/card/id/sfa_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/sfa_marine/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

//items

/obj/item/card/id/sfa_ship
	name = "sfa patrol ship id"
	access = list(access_sol_ships, access_external_airlocks)

//fsf patrol ship

/datum/ghostspawner/human/fsf_navy_crewman
	short_name = "fsf_navy_crewman"
	name = "FSF Navy Crewman"
	desc = "Crew the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("fsf_navy_crewman")
	max_count = 3

	outfit = /datum/outfit/admin/fsf_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "FSF Navy Crewman"
	special_role = "FSF Navy Crewman"
	respawn_flag = null


/datum/outfit/admin/fsf_navy_crewman
	name = "FSF Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/norm
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest

	id = /obj/item/card/id/fsf_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/fsf_navy_crewman/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/fsf_navy_officer
	short_name = "fsf_navy_officer"
	name = "FSF Navy Officer"
	desc = "Command the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	tags = list("External")
	mob_name_prefix = "LT. "

	spawnpoints = list("fsf_navy_officer")
	max_count = 1

	outfit = /datum/outfit/admin/fsf_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "FSF Navy Officer"
	special_role = "FSF Navy Officer"
	respawn_flag = null


/datum/outfit/admin/fsf_navy_officer
	name = "FSF Navy Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/fsf_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/datum/outfit/admin/fsf_navy_officer/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/fsf_navy_crewman/senior
	short_name = "fsf_navy_senior_crewman"
	name = "FSF Navy Senior Crewman"
	desc = "Serve as the second-in-command of the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	mob_name_prefix = "PO1. "

	spawnpoints = list("fsf_navy_crewman")
	max_count = 1

	assigned_role = "FSF Navy Senior Crewman"
	special_role = "FSF Navy Senior Crewman"

//items

/obj/item/card/id/fsf_ship
	name = "fsf patrol ship id"
	access = list(access_sol_ships, access_external_airlocks)
