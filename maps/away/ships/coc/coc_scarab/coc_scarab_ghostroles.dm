/datum/ghostspawner/human/coc_scarab
	short_name = "coc_scarab"
	name = "Scarab Salvager"
	desc = "Crew a salvage ship sent to gather resources for the Scarab Fleet - mine precious minerals, salvage derelict ships, siphon valuable gasses from exoplanets, and care for your crew as your family. Remember, the fleet is always in need of more resources, and you need to make your expedition worth it. (OOC Note: Characters must have names and backgrounds consistent with the Scarab Fleet. This is enforceable by admin action.)"
	tags = list("External")
	spawnpoints = list("coc_scarab")
	welcome_message = "You are a crewmate aboard a small but tightly-knit salvage vessel sent out by the Scarab Fleet, a nomadic group of offworlder humans in the Coalition of Colonies, to retrieve critical resources for the wider fleet. Your people live on the edge of a knife, carefully managing the resources available to them to survive in the hostile void of space, and working tirelessly to make their next day easier than their last. Do everything necessary to survive, for yourself, for your crew, and for your fleet."

	max_count = 4
	respawn_flag = null
	outfit = /datum/outfit/admin/scarab

	possible_species = list(SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Scarab Salvager"
	special_role = "Scarab Salvager"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/coalition)

/datum/outfit/admin/scarab
	name = "Scarab Salvager"
	uniform = /obj/item/clothing/under/offworlder/drab
	mask = /obj/item/clothing/mask/offworlder/drab
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/offworlder/drab
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/industrial
	l_pocket = /obj/item/clothing/accessory/badge/passcard/scarab/gold
	r_pocket = /obj/item/wrench
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/utility/full
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/pill_bottle/rmt = 1, /obj/item/clothing/accessory/offworlder/drab = 1, /obj/item/clothing/accessory/offworlder/bracer/drab = 1, /obj/item/clothing/accessory/offworlder/bracer/neckbrace/drab = 1, )

/datum/outfit/admin/scarab/captain
	name = "Scarab Salvager Captain"
	accessory = /obj/item/clothing/accessory/sash/purple

/datum/outfit/admin/scarab/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/coc_scarab/captain
	name = "Scarab Salvager Captain"
	short_name = "coc_scarab_captain"
	max_count = 1
	assigned_role = "Scarab Salvager Captain"
	special_role = "Scarab Salvager Captain"
	desc = "Command a salvage ship sent to gather resources for the Scarab Fleet - mine precious minerals, salvage derelict ships, siphon valuable gasses from exoplanets, and care for your crew as your family. Remember, the fleet is always in need of more resources, and you need to make your expedition worth it. (OOC Note: Characters must have names and backgrounds consistent with the Scarab Fleet. This is enforceable by admin action.)"
	welcome_message = "You are the captain of a small but tightly-knit salvage vessel sent out by the Scarab Fleet, a nomadic group of offworlder humans in the Coalition of Colonies, to retrieve critical resources for the wider fleet. You inherited your role by familial affilation, and your crew looks up to you for leadership and courage. Your people live on the edge of a knife, carefully managing the resources available to them to survive in the hostile void of space, and working tirelessly to make their next day easier than their last. Do everything necessary to survive, for yourself, for your crew, and for your fleet."
	outfit = /datum/outfit/admin/scarab/captain
