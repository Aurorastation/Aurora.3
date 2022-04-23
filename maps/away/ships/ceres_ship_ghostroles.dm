//Ceres' Lance Ship

/datum/ghostspawner/human/ceres_lance_squad_member
	short_name = "Ceres' Lance Squad Member"
	name = "Ceres' Lance Squad Member"
	desc = "Crew the Tau Ceti Foreign Legion Peacekeeping ship. Follow your Prefect's orders."
	tags = list("External")
	mob_name_prefix = "Pvt. "

	spawnpoints = list("ceres_squad_member")
	max_count = 3

	outfit = /datum/outfit/admin/ceres_lance_squad_member
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ceres' Lance Squad Member"
	special_role = "Ceres' Lance Squad Member"
	respawn_flag = null


/datum/outfit/admin/ceres_lance_squad_member
	name = "Ceres' Lance Squad Member"

	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel_norm
	belt = /obj/item/storage/belt/military
	accessory = /obj/item/clothing/accessory/storage/pouches/black

	id = /obj/item/card/id/ceres_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/lance = 1, /obj/item/ipc_tag_scanner = 1, /obj/item/melee/baton/stunrod = 1)

/datum/outfit/admin/ceres_lance_squad_member/get_id_access()
	return list(access_ceres_lance_ship, access_external_airlocks)

/datum/ghostspawner/human/ceres_lance_squad_lead
	short_name = "ceres_lance_squad_lead"
	name = "Ceres' Lance Squad Leader"
	desc = "Command the Tau Ceti Foreign Legion Peacekeeping ship. Make sure your prisoners are taken care of."
	tags = list("External")
	mob_name_prefix = "Sgt. "

	spawnpoints = list("ceres_lance_squad_lead")
	max_count = 1

	outfit = /datum/outfit/admin/ceres_lance_squad_lead
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ceres' Lance Squad Leader"
	special_role = "Ceres' Lance Squad Leader"
	respawn_flag = null


/datum/outfit/admin/ceres_lance_squad_lead
	name = "Ceres' Lance Squad Leader"

	uniform = /obj/item/clothing/under/lance
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel_norm
	belt = /obj/item/storage/belt/military
	accessory = /obj/item/clothing/accessory/storage/pouches/black

	id = /obj/item/card/id/ceres_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/lance = 1, /obj/item/ipc_tag_scanner = 1, /obj/item/melee/baton/stunrod = 1)

/datum/outfit/admin/ceres_lance_squad_lead/get_id_access()
	return list(access_ceres_lance_ship, access_external_airlocks)

/obj/item/card/id/ceres_ship
	name = "Ceres' Lance member id"
	access = list(access_ceres_lance_ship, access_external_airlocks)