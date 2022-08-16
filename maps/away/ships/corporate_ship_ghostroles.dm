//orion express ship

/datum/ghostspawner/human/orion_express_courier
	short_name = "orion_express_courier"
	name = "Orion Express Station Crew"
	desc = "Crew the Orion Express mobile refueling station."
	tags = list("External")

	spawnpoints = list("orion_express_courier")
	max_count = 3

	outfit = /datum/outfit/admin/orion_express_courier
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Orion Express Courier"
	special_role = "Orion Express Courier"
	respawn_flag = null


/datum/outfit/admin/orion_express_courier
	name = "Orion Express Courier"

	uniform = /obj/item/clothing/under/rank/hangar_technician/orion/ship
	shoes = /obj/item/clothing/shoes/brown
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/orion_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/workboots/toeless
	)

/datum/outfit/admin/orion_express_courier/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/orion_express_courier/get_id_access()
	return list(access_orion_express_ship, access_external_airlocks)

/datum/ghostspawner/human/orion_express_courier/captain
	short_name = "orion_express_captain"
	name = "Orion Express Captain"
	desc = "Pilot and command the Orion Express mobile refueling station."
	tags = list("External")

	spawnpoints = list("orion_express_captain")
	max_count = 1

	outfit = /datum/outfit/admin/orion_express_courier/captain

	assigned_role = "Orion Express Captain"
	special_role = "Orion Express Captain"


/datum/outfit/admin/orion_express_courier/captain
	name = "Orion Express Captain"

	uniform = /obj/item/clothing/under/rank/operations_manager/orion_ship
	glasses = /obj/item/clothing/glasses/sunglasses

//items

/obj/item/clothing/under/rank/hangar_technician/orion/ship
	name = "orion express courier uniform"

/obj/item/clothing/under/rank/operations_manager/orion_ship
	name = "orion express captain uniform"

/obj/item/card/id/orion_ship
	name = "orion express ship id"
	access = list(access_orion_express_ship, access_external_airlocks)

//ee ship

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
	back = /obj/item/storage/backpack/satchel/norm
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
	back = /obj/item/storage/backpack/satchel
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
