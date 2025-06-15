/datum/ghostspawner/human/himeo_patrol_ship
	short_name = "himeo_patrol_ship_guard"
	name = "Himean Planetary Guardsman"
	desc = "You are a guard of the Himean Planetary Guard. Crew your patrol craft, track down pirates and other infiltrators to Coalition space, and help represent the Syndicates abroad."
	tags = list("External")
	spawnpoints = list("himeo_patrol")
	welcome_message = "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOORAH FOR THE REVOLUTION"

	max_count = 2
	respawn_flag = null
	outfit = /obj/outfit/admin/himeo_patrol_ship

	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Himean Naval Crewman"
	special_role = "Himean Naval Crewman"

	culture_restriction = list(/singleton/origin_item/culture/coalition)
	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/free_council)

/datum/ghostspawner/human/himeo_patrol_ship/engineer
	short_name = "himeo_patrol_ship_engineer"
	name = "Himean Planetary Guard Sapper"
	desc = "You are a sapper of the Himean Planetary Guard. Operate the thrusters and thermoelectric generator of your patrol craft, repair damage to your vessel, and breach your way into sites or vessels of interest to the Syndicates."
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/engineer
	mob_name_prefix = "SPC. "

/datum/ghostspawner/human/himeo_patrol_ship/medic
	short_name = "himeo_patrol_ship_medic"
	name = "Himean Planetary Guard Corpsman"
	desc = "You are a corpsman of the Himean Planetary Guard. Keep your people alive to the very best of your abilities, make do with the rudimentary supplies your vessel affords you, and try not to get shot whilst representing the wishes of the Syndicates."
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/medic
	mob_name_prefix = "SPC. "

/datum/ghostspawner/human/himeo_patrol_ship/pilot
	short_name = "himeo_patrol_ship_pilot"
	name = "Himean Planetary Guard Fighter Pilot"
	desc = "You are a fighter pilot of the Himean Planetary Guard. Take care of your shuttle, "
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/medic
	mob_name_prefix = "SPC. "

/obj/outfit/admin/himeo_patrol_ship
	name = "Himean Planetary Guardsman"
	uniform = /obj/item/clothing/under/himeo
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/ship/coalition_navy
	back = /obj/item/storage/backpack/rucksack/green
	id = /obj/item/card/id/coalition
	l_pocket = /obj/item/device/radio/off
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/tactical = 1,
		/obj/item/material/kitchen/utensil/knife/boot = 1,
		/obj/item/clothing/head/softcap/himeo_naval_cover = 1,
)

/obj/outfit/admin/himeo_patrol_ship/engineer
	name = "Himean Planetary Guard Sapper"
	uniform = /obj/item/clothing/under/himeo/engineer
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/alt = 1,
		/obj/item/clothing/head/softcap/himeo_naval_cover = 1
	)

/obj/outfit/admin/himeo_patrol_ship/medic
	name = "Himean Planetary Guard Corpsman"
	uniform = /obj/item/clothing/under/himeo/medic
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/half = 1
	)

/obj/outfit/admin/himeo_patrol_ship/pilot
	name= "Himean Planetary Guard Fighter Pilot"
	uniform = /obj/item/clothing/under/himeo/pilot
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black_leather
	back = /obj/item/storage/backpack/messenger
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/alt = 1
	)
/obj/outfit/admin/himeo_patrol_ship/officer
	name = "Himean Planetary Guard Commander"
	uniform = /obj/item/clothing/under/himeo/officer
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black_leather
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/half = 1,
		/obj/item/clothing/accessory/badge/passcard/coalition  = 1
	)
