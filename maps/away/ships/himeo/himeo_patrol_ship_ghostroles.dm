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
	mob_name_prefix = "Mat. "

	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Himean Naval Crewman"
	special_role = "Himean Naval Crewman"

	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/free_council)

/datum/ghostspawner/human/himeo_patrol_ship/engineer
	short_name = "himeo_patrol_ship_engineer"
	name = "Himean Planetary Guard Sapper"
	desc = "You are a sapper of the Himean Planetary Guard. Operate the thrusters and thermoelectric generator of your patrol craft, repair damage to your vessel, and breach your way into sites or vessels of interest to the Syndicates."
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/engineer
	mob_name_prefix = "Alk. "

/datum/ghostspawner/human/himeo_patrol_ship/medic
	short_name = "himeo_patrol_ship_medic"
	name = "Himean Planetary Guard Corpsman"
	desc = "You are a corpsman of the Himean Planetary Guard. Keep your people alive to the very best of your abilities, make do with the rudimentary supplies your vessel affords you, and try not to get shot whilst representing the wishes of the Syndicates."
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/medic
	mob_name_prefix = "Alk. "

/datum/ghostspawner/human/himeo_patrol_ship/pilot
	short_name = "himeo_patrol_ship_pilot"
	name = "Himean Planetary Guard Fighter Pilot"
	desc = "You are a fighter pilot of the Himean Planetary Guard. Pilot and maintain your shuttle, guard it on expeditions, and act as a transport or fighter pilot depending on the needs of your commander. "
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/pilot
	mob_name_prefix = "Alk. "

/datum/ghostspawner/human/himeo_patrol_ship/officer
	short_name = "himeo_patrol_ship_officer"
	name = "Himean Planetary Guard Commander"
	desc = "You are the commander of a Himean Planetary Guard patrol vessel. Give guidance and leadership to your fellow soldiers, lead expeditions to sites of interest, and act as a representative of the militant arm of revolution.  "
	welcome_message = "Placeholder"
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/officer
	spawnpoints = list("himeo_patrol_commander")
	mob_name_prefix = "Ylt. "
	possible_species = list(SPECIES_HUMAN)

/obj/outfit/admin/himeo_patrol_ship
	name = "Himean Planetary Guardsman"
	uniform = /obj/item/clothing/under/himeo/navy
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/workboots/dark
	l_ear = /obj/item/device/radio/headset/ship/coalition_navy
	back = /obj/item/storage/backpack/rucksack/green
	id = /obj/item/card/id/coalition
	l_pocket = /obj/item/device/radio/off
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/tactical = 1,
		/obj/item/material/kitchen/utensil/knife/boot = 1,
		/obj/item/clothing/head/sidecap/himeo_navy_cap = 1
	)
	species_gloves = list(
		SPECIES_TAJARA = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/black_leather/tajara,
	)
	species_shoes = list(
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/dark/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/dark/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/dark/tajara,
	)

/obj/outfit/admin/himeo_patrol_ship/engineer
	name = "Himean Planetary Guard Sapper"
	uniform = /obj/item/clothing/under/himeo/navy/engineer
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/alt = 1,
		/obj/item/clothing/head/sidecap/himeo_navy_cap = 1
	)

/obj/outfit/admin/himeo_patrol_ship/medic
	name = "Himean Planetary Guard Corpsman"
	uniform = /obj/item/clothing/under/himeo/navy/medic
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/half = 1,
		/obj/item/clothing/head/sidecap/himeo_navy_cap = 1
	)

/obj/outfit/admin/himeo_patrol_ship/pilot
	name= "Himean Planetary Guard Fighter Pilot"
	uniform = /obj/item/clothing/under/himeo/navy/pilot
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black_leather
	back = /obj/item/storage/backpack/messenger
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/alt = 1,
		/obj/item/clothing/head/sidecap/himeo_navy_cap = 1
	)
/obj/outfit/admin/himeo_patrol_ship/officer
	name = "Himean Planetary Guard Commander"
	uniform = /obj/item/clothing/under/himeo/navy/officer
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black_leather
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/mask/gas/half = 1,
		/obj/item/clothing/accessory/badge/passcard/coalition  = 1,
		/obj/item/clothing/head/sidecap/himeo_navy_cap = 1
	)

/obj/outfit/admin/himeo_patrol_ship/get_id_access()
	return list(ACCESS_HIMEO_PATROL_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
