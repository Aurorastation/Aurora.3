/datum/ghostspawner/human/sfa_navy_cruiser_crewman
	short_name = "sfa_navy_cruiser_crewman"
	name = "SFA Navy Crewman"
	desc = "Crew the Southern Fleet Administration light cruiser."
	tags = list("External")
	mob_name_prefix = "PO3. "
	enabled = FALSE

	spawnpoints = list("sfa_navy_cruiser_crewman")
	max_count = 3

	outfit = /datum/outfit/admin/sfa_navy_cruiser_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Navy Crewman"
	special_role = "SFA Navy Crewman"
	respawn_flag = null


/datum/outfit/admin/sfa_navy_cruiser_crewman
	name = "SFA Navy Crewman"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)

	id = /obj/item/card/id/sfa_ship_cruiser

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1, /obj/item/ammo_magazine/mc9mm = 2,)

/datum/outfit/admin/sfa_navy_cruiser_crewman/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/sfa_navy_ensign
	short_name = "sfa_navy_ensign"
	name = "SFA Navy Ensign"
	desc = "Assist your superior officers in the Southern Fleet Administration light cruiser."
	tags = list("External")
	mob_name_prefix = "ENS. "
	enabled = FALSE

	spawnpoints = list("sfa_navy_ensign")
	max_count = 2

	outfit = /datum/outfit/admin/sfa_navy_ensign
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Navy Ensign"
	special_role = "SFA Navy Ensign"
	respawn_flag = null


/datum/outfit/admin/sfa_navy_ensign
	name = "SFA Navy Ensign"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)

	id = /obj/item/card/id/sfa_ship_cruiser

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1, /obj/item/ammo_magazine/mc9mm = 2)


/datum/outfit/admin/sfa_navy_ensign/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

/datum/ghostspawner/human/sfa_cruiser_marine
	short_name = "sfa_cruiser_marine"
	name = "SFA Marine"
	desc = "Protect the Southern Fleet Administration light cruiser."
	tags = list("External")
	mob_name_prefix = "Pfc. "
	enabled = FALSE

	spawnpoints = list("sfa_cruiser_marine")
	max_count = 3

	outfit = /datum/outfit/admin/sfa_cruiser_marine
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SFA Marine"
	special_role = "SFA Marine"
	respawn_flag = null


/datum/outfit/admin/sfa_cruiser_marine
	name = "SFA Marine"

	uniform = /obj/item/clothing/under/rank/sol/marine
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/swat/ert
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/military
	head = /obj/item/clothing/head/helmet/space/void/sol/sfa
	suit = /obj/item/clothing/suit/space/void/sol/sfa
	suit_store = /obj/item/gun/projectile/automatic/rifle/sol
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)

	id = /obj/item/card/id/sfa_ship_cruiser

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

	belt_contents = list(
		/obj/item/ammo_magazine/c762/sol = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/frag = 1
    )

/datum/outfit/admin/sfa_cruiser_marine/get_id_access()
	return list(access_sol_ships, access_external_airlocks)

//id

/obj/item/card/id/sfa_ship_cruiser
	name = "sfa ship id"
	access = list(access_sol_ships, access_external_airlocks)
