/datum/ghostspawner/human/coc_scarab
	short_name = "coc_scarab"
	name = "Scarab Salvager"
	desc = "Crew a salvage ship. Harvest valuable resources to take back to the wider Scarab Fleet. OOC Note: Characters must have names and backgrounds consistent with the Scarab Fleet. This is enforcable by admin action."
	tags = list("External")
	spawnpoints = list("coc_scarab")
	welcome_message = "You are a crewman aboard a small retrofitted salvage vessel sent out by the Scarab Fleet. Harvest resources to keep the fleet moving and keep yourself and your crew alive."
	max_count = 3
	respawn_flag = null
	outfit = /datum/outfit/admin/scarab

	possible_species = list(SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Scarab Salvager"
	special_role = "Scarab Salvager"
	respawn_flag = null

/datum/outfit/admin/scarab
	name = "Scarab Salvager"
	uniform = /obj/item/clothing/under/offworlder
	mask = /obj/item/clothing/mask/offworlder
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/offworlder
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/industrial
	accessory = /obj/item/clothing/accessory/badge/passcard/scarab
	r_pocket = /obj/item/wrench
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/utility/full
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/pill_bottle/rmt = 1)

/datum/outfit/admin/scarab/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/coc_scarab/captain
	name = "Scarab Salvager Captain"
	short_name = "coc_scarab_captain"
	max_count = 1
	assigned_role = "Scarab Salvager Captain"
	special_role = "Scarab Salvager Captain"
	desc = "Command a salvage ship. Harvest valuable resources to take back to the wider Scarab Fleet. OOC Note: Characters must have names and backgrounds consistent with the Scarab Fleet. This is enforcable by admin action."
	welcome_message = "You are the captain of a small retrofitted salvage vessel sent out by the Scarab Fleet. Harvest resources to keep the fleet moving and keep yourself and your crew alive."

