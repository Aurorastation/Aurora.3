/datum/ghostspawner/human/ee_crewman
	short_name = "ee_crewman"
	name = "Einstein Engines Crewman"
	desc = "Crew the Einstein Engines research (or more accurately, spy) ship. Collect intelligence on the SCCV Horizon, all while maintaining plausible deniability. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")

	spawnpoints = list("ee_crewman")
	max_count = 3

	outfit = /datum/outfit/admin/ee_crewman
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Einstein Engines Crewman"
	special_role = "Einstein Engines Crewman"
	respawn_flag = null


/datum/outfit/admin/ee_crewman
	name = "Einstein Engines Crewman"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	accessory = /obj/item/clothing/accessory/storage/pouches/black

	id = /obj/item/card/id/ee_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/ee_crewman/get_id_access()
	return list(access_ee_spy_ship, access_external_airlocks)

/datum/ghostspawner/human/ee_research_officer
	short_name = "ee_research_officer"
	name = "Einstein Engines Research Officer"
	desc = "Command the Einstein Engines research (or more accurately, spy) ship. Collect intelligence on the SCCV Horizon, all while maintaining plausible deniability. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")

	spawnpoints = list("ee_research_officer")
	max_count = 1

	outfit = /datum/outfit/admin/ee_research_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Einstein Engines Research Officer"
	special_role = "Einstein Engines Research Officer"
	respawn_flag = null


/datum/outfit/admin/ee_research_officer
	name = "Einstein Engines Research Officer"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/leather
	glasses = /obj/item/clothing/glasses/sunglasses
	accessory = /obj/item/clothing/accessory/holster/thigh
	suit = /obj/item/clothing/suit/storage/vest

	id = /obj/item/card/id/ee_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/ee_research_officer/get_id_access()
	return list(access_ee_spy_ship, access_external_airlocks)

//items

/obj/item/card/id/ee_ship
	name = "ee research ship id"
	access = list(access_ee_spy_ship, access_external_airlocks)