/datum/ghostspawner/human/fsf_navy_crewman
	short_name = "fsf_navy_crewman"
	name = "FSF Navy Crewman"
	desc = "Crew the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	tags = list("External")
	mob_name_prefix = "PO3. "

	spawnpoints = list("fsf_navy_crewman")
	max_count = 3

	outfit = /obj/outfit/admin/fsf_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "FSF Navy Crewman"
	special_role = "FSF Navy Crewman"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/solarian)

/obj/outfit/admin/fsf_navy_crewman
	name = "FSF Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest

	id = /obj/item/card/id/fsf_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/fsf_navy_crewman/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/fsf_navy_officer
	short_name = "fsf_navy_officer"
	name = "FSF Navy Officer"
	desc = "Command the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	tags = list("External")
	mob_name_prefix = "LT. "

	spawnpoints = list("fsf_navy_officer")
	max_count = 1

	outfit = /obj/outfit/admin/fsf_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "FSF Navy Officer"
	special_role = "FSF Navy Officer"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/solarian)

/obj/outfit/admin/fsf_navy_officer
	name = "FSF Navy Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/fsf_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/fsf_navy_officer/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/fsf_navy_crewman/senior
	short_name = "fsf_navy_senior_crewman"
	name = "FSF Navy Senior Crewman"
	desc = "Serve as the second-in-command of the Free Solarian Fleets patrol corvette. Look for work, or some other source of income."
	mob_name_prefix = "PO1. "

	spawnpoints = list("fsf_navy_crewman")
	max_count = 1

	assigned_role = "FSF Navy Senior Crewman"
	special_role = "FSF Navy Senior Crewman"

	culture_restriction = list(/singleton/origin_item/culture/solarian)

//items

/obj/item/card/id/fsf_ship
	name = "fsf patrol ship id"
	access = list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)
