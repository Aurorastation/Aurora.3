//biesel peacekeeper ship

/datum/ghostspawner/human/tcfl_peacekeeper
	short_name = "tcfl_peacekeeper"
	name = "TCFL Peacekeeper"
	desc = "Crew the Tau Ceti Foreign Legion Peacekeeping ship. Follow your Prefect's orders."
	tags = list("External")
	mob_name_prefix = "Lgn. "

	spawnpoints = list("tcfl_peacekeeper")
	max_count = 3

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

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/clothing/accessory/storage/pouches/brown = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/jackboots/toeless
	)

/datum/outfit/admin/tcfl_peacekeeper/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/tcfl_peacekeeper/get_id_access()
	return list(access_tcfl_peacekeeper_ship, access_external_airlocks)

/datum/ghostspawner/human/tcfl_peacekeeper/prefect
	short_name = "tcfl_peacekeeper_prefect"
	name = "TCFL Peacekeeper Prefect"
	desc = "Command the Tau Ceti Foreign Legion Peacekeeping ship. Make sure your prisoners are taken care of."
	mob_name_prefix = "Pfct. "

	spawnpoints = list("tcfl_peacekeeper_prefect")
	max_count = 1

	outfit = /datum/outfit/admin/tcfl_peacekeeper/prefect

	assigned_role = "TCFL Peacekeeper Prefect"
	special_role = "TCFL Peacekeeper Prefect"


/datum/outfit/admin/tcfl_peacekeeper/prefect
	name = "TCFL Peacekeeper Prefect"
	accessory = /obj/item/clothing/accessory/legion


/datum/ghostspawner/human/tcfl_peacekeeper/pilot
	short_name = "tcfl_peacekeeper_pilot"
	name = "TCFL Peacekeeper Pilot"
	desc = "Pilot the Tau Ceti Foreign Legion Peacekeeping ship."
	mob_name_prefix = "PL. "

	max_count = 1

	outfit = /datum/outfit/admin/tcfl_peacekeeper/pilot

	assigned_role = "TCFL Peacekeeper Pilot"
	special_role = "TCFL Peacekeeper Pilot"


/datum/outfit/admin/tcfl_peacekeeper/pilot
	name = "TCFL Peacekeeper Pilot"

	uniform = /obj/item/clothing/under/legion/pilot
	head = /obj/item/clothing/head/helmet/pilot/legion
	suit = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion/alt
	accessory = /obj/item/clothing/accessory/storage/webbingharness/pouches/ert

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1)


//items

/obj/item/card/id/tcfl_ship
	name = "tcfl peacekeeper ship id"
	access = list(access_tcfl_peacekeeper_ship, access_external_airlocks)
