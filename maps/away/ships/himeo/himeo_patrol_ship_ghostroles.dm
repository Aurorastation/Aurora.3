/datum/ghostspawner/human/himeo_patrol_ship
	short_name = "himeo_patrol_ship_guard"
	name = "Himean Planetary Guardsman"
	desc = "You are a guard of the Himean Planetary Guard. Crew your patrol craft, track down pirates and other infiltrators to Coalition space, and help represent the Syndicates abroad."
	tags = list("External")
	spawnpoints = list("himeo_patrol")
	welcome_message = "You are a member of the Himean Planetary Guard, Naval Branch. \
	One amongst you has been promoted to the rank of Commander, and you are to follow their orders in any circumstance that does not contravene your service to the Planetary Guard. \
	You are to patrol the sector, ensuring that enemies of the Syndicates do not gain a foothold in the Coalition. \
	Do not simply attack ships of Hephaestus Industries blindly, however... unless they provoke you first. All peoples are welcome in the service of the Syndicates, \
	however if your origin includes the option to use either the Himean or Free Tajara Council accent, using that is suggested. "

	max_count = 2
	respawn_flag = null
	outfit = /obj/outfit/admin/himeo_patrol_ship
	mob_name_prefix = "Mat. "

	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Himean Naval Matruusi"
	special_role = "Himean Naval Matruusi"

	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/free_council)

/datum/ghostspawner/human/himeo_patrol_ship/engineer
	short_name = "himeo_patrol_ship_engineer"
	name = "Himean Planetary Guard Sapper"
	desc = "You are a sapper of the Himean Planetary Guard. Operate the thrusters and thermoelectric generator of your patrol craft, repair damage to your vessel, and breach your way into sites or vessels of interest to the Syndicates."
	welcome_message = "You are a member of the Himean Planetary Guard, Naval Branch. \
	One amongst you has been promoted to the rank of Commander, and you are to follow their orders in any circumstance that does not contravene your service to the Planetary Guard. \
	You have been appointed based upon your merits to serve as a sapper. \
	You have been trusted to prevent the vessel from perishing in the service of the aims of the Syndicates, and failure is not permitted. \
	Your duties include repairing your vessel, removing barricades and otherwise ensuring it does not fall in service to the Syndicates. \
	All peoples are welcome in the service of the Syndicates, \
	however if your origin includes the option to use either the Himean or Free Tajara Council accent, using that is suggested. "
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/engineer
	mob_name_prefix = "Alk. "
	assigned_role = "Himean Naval Alikersantti"
	special_role = "Himean Naval Alikersantti"

/datum/ghostspawner/human/himeo_patrol_ship/medic
	short_name = "himeo_patrol_ship_medic"
	name = "Himean Planetary Guard Corpsman"
	desc = "You are a corpsman of the Himean Planetary Guard. Keep your people alive to the very best of your abilities, make do with the rudimentary supplies your vessel affords you, and try not to get shot whilst representing the wishes of the Syndicates."
	welcome_message = "You are a member of the Himean Planetary Guard, Naval Branch. \
	One amongst you has been promoted to the rank of Commander, and you are to follow their orders in any circumstance that does not contravene your service to the Planetary Guard. \
	You have been appointed based upon your merits to serve as a corpsman. \
	You have been trusted to ensure the safety and survival of your fellow worker, regardless of what the corporate forces of the Spur throw at you. \
	All peoples are welcome in the service of the Syndicates, \
	however if your origin includes the option to use either the Himean or Free Tajara Council accent, using that is suggested."
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/medic
	mob_name_prefix = "Alk. "
	assigned_role = "Himean Naval Alikersantti"
	special_role = "Himean Naval Alikersantti"

/datum/ghostspawner/human/himeo_patrol_ship/pilot
	short_name = "himeo_patrol_ship_pilot"
	name = "Himean Planetary Guard Fighter Pilot"
	desc = "You are a fighter pilot of the Himean Planetary Guard. Pilot and maintain your shuttle, guard it on expeditions, and act as a transport or fighter pilot depending on the needs of your commander. "
	welcome_message = "You are a member of the Himean Planetary Guard, Naval Branch. \
	One amongst you has been promoted to the rank of Commander, and you are to follow their orders in any circumstance that does not contravene your service to the Planetary Guard. \
	You have been appointed based upon your merits to serve as a pilot. \
	You have been granted command of the USPGV Kotka, a Hiirihaukka-class Fighter Shuttle. You are to use it to fend off enemies of the Syndicates, \
	and transport your fellow workers to wherever they must go. All peoples are welcome in the service of the Syndicates, \
	however if your origin includes the option to use either the Himean or Free Tajara Council accent, using that is suggested."
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/pilot
	mob_name_prefix = "Alk. "
	assigned_role = "Himean Naval Alikersantti"
	special_role = "Himean Naval Alikersantti"

/datum/ghostspawner/human/himeo_patrol_ship/officer
	short_name = "himeo_patrol_ship_officer"
	name = "Himean Planetary Guard Commander"
	desc = "You are the commander of a Himean Planetary Guard patrol vessel. Give guidance and leadership to your fellow soldiers, lead expeditions to sites of interest, and act as a representative of the militant arm of revolution.  "
	welcome_message = "You are a member of the Himean Planetary Guard, Naval Branch. \
	You have been elected by your fellow workers to serve as the Commander of a Collier-class patrol corvette. The Syndicates will not sanction failure. \
	If your service is deemed inadequate, your workers may exercise their right to remove you from your position. You do not reign with terror or an iron fist, you reign with reason. \
	Do not disappoint the Syndicates, for you are the shield of the people, the sword of the Revolution. \
	All peoples are welcome in the service of the Syndicates, \
	however if your origin includes the option to use either the Himean or Free Tajara Council accent, using that is suggested."
	max_count = 1
	outfit = /obj/outfit/admin/himeo_patrol_ship/officer
	spawnpoints = list("himeo_patrol_commander")
	mob_name_prefix = "Ylt. "
	possible_species = list(SPECIES_HUMAN)
	assigned_role = "Himean Naval Yliluutnantti"
	special_role = "Himean Naval Yliluutnantti"

/obj/outfit/admin/himeo_patrol_ship
	name = "Himean Planetary Guardsman"
	uniform = /obj/item/clothing/under/himeo/navy
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/workboots/dark
	l_ear = /obj/item/device/radio/headset/ship
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
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara/dark,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara/dark,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara/dark,
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
