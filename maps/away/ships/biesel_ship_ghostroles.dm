//biesel peacekeeper ship

/datum/ghostspawner/human/tcfl_peacekeeper
	short_name = "tcfl_peacekeeper"
	name = "TCFL Peacekeeper"
	desc = "Crew the Tau Ceti Foreign Legion Peacekeeping ship. Follow your Prefect's orders."
	tags = list("External")
	mob_name_prefix = "Lgn. "

	spawnpoints = list("tcfl_peacekeeper")
	max_count = 2

	outfit = /datum/outfit/admin/tcfl_peacekeeper
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Peacekeeper"
	special_role = "TCFL Peacekeeper"
	respawn_flag = null


/datum/outfit/admin/tcfl_peacekeeper
	name = "TCFL Peacekeeper"

	head = /obj/item/clothing/head/beret/legion/field
	uniform = /obj/item/clothing/under/legion
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/legion
	accessory = /obj/item/clothing/accessory/legion/specialist

	id = /obj/item/card/id/tcfl_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1)

/datum/outfit/admin/tcfl_peacekeeper/get_id_access()
	return list(access_tcfl_peacekeeper_ship, access_external_airlocks)

/datum/ghostspawner/human/tcfl_peacekeeper_prefect
	short_name = "tcfl_peacekeeper_prefect"
	name = "TCFL Peacekeeper Prefect"
	desc = "Command the Tau Ceti Foreign Legion Peacekeeping ship. Make sure your prisoners are taken care of."
	tags = list("External")
	mob_name_prefix = "Pfct. "

	spawnpoints = list("tcfl_peacekeeper_prefect")
	max_count = 1

	outfit = /datum/outfit/admin/tcfl_peacekeeper_prefect
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Peacekeeper Prefect"
	special_role = "TCFL Peacekeeper Prefect"
	respawn_flag = null


/datum/outfit/admin/tcfl_peacekeeper_prefect
	name = "TCFL Peacekeeper Prefect"

	head = /obj/item/clothing/head/beret/legion/field
	uniform = /obj/item/clothing/under/legion
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/legion
	accessory = /obj/item/clothing/accessory/legion

	id = /obj/item/card/id/tcfl_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1)

/datum/outfit/admin/tcfl_peacekeeper_prefect/get_id_access()
	return list(access_tcfl_peacekeeper_ship, access_external_airlocks)

/datum/ghostspawner/human/tcfl_peacekeeper_pilot
	short_name = "tcfl_peacekeeper_pilot"
	name = "TCFL Peacekeeper Pilot"
	desc = "Pilot the Tau Ceti Foreign Legion Peacekeeping ship."
	tags = list("External")
	mob_name_prefix = "PL. "

	spawnpoints = list("tcfl_peacekeeper")
	max_count = 1

	outfit = /datum/outfit/admin/tcfl_peacekeeper_pilot
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Peacekeeper Pilot"
	special_role = "TCFL Peacekeeper Pilot"
	respawn_flag = null


/datum/outfit/admin/tcfl_peacekeeper_pilot
	name = "TCFL Peacekeeper Pilot"

	uniform = /obj/item/clothing/under/legion/pilot
	head = /obj/item/clothing/head/helmet/pilot/legion
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion/alt
	accessory = /obj/item/clothing/accessory/storage/webbingharness/pouches/ert
	back = /obj/item/storage/backpack/legion

	id = /obj/item/card/id/tcfl_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1)

/datum/outfit/admin/tcfl_peacekeeper_pilot/get_id_access()
	return list(access_tcfl_peacekeeper_ship, access_external_airlocks)

//items

/obj/item/card/id/tcfl_ship
	name = "tcfl peacekeeper ship id"
	access = list(access_tcfl_peacekeeper_ship, access_external_airlocks)

/datum/ghostspawner/human/tcfl_detainee
	short_name = "tcfl_detainee"
	name = "TCFL Detainee"
	desc = "Rot in the Tau Ceti Foreign Legion ship's holding cell. Try not to get bored - you're stuck in a room under armed guard."
	tags = list("External")

	spawnpoints = list("tcfl_detainee")
	max_count = 2

	outfit = /datum/outfit/admin/tcfl_detainee
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Detainee"
	special_role = "TCFL Detainee"
	respawn_flag = null


/datum/outfit/admin/tcfl_detainee
	name = "TCFL Detainee"

	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange
