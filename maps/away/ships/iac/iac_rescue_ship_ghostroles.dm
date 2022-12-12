//iac volunteers

/datum/ghostspawner/human/iac_volunteer
	short_name = "iac_volunteer"
	name = "IAC Volunteer"
	desc = "Crew the IAC Rescue Ship. Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble."
	tags = list("External")

	spawnpoints = list("iac_volunteer")
	max_count = 2

	outfit = /datum/outfit/admin/freighter_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Volunteer"
	special_role = "IAC Volunteer"
	respawn_flag = null


/datum/outfit/admin/iac_volunteer
	name = "IAC Volunteer"

	uniform = /obj/item/clothing/under/rank/iacjumpsuit
	shoes = /obj/item/clothing/shoes/iac
	back = /obj/item/storage/backpack/satchel
	accessory = /obj/item/clothing/accessory/armband/iac

	id = /obj/item/card/id/iac_rescue_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless
	)

/datum/outfit/admin/iac_volunteer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/iac_volunteer/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/iac_volunteer/technician
	short_name = "iac_technician"
	name = "IAC Technician"
	desc = "Crew the IAC Rescue Ship. Act as one of the ship's engineering or medical personnel. Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble."

	spawnpoints = list("iac_coordinator")
	max_count = 2

	outfit = /datum/outfit/admin/iac_volunteer/technician
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Coordinator"
	special_role = "IAC Coordinator"


/datum/outfit/admin/iac_volunteer/technician
	name = "IAC Coordinator"

	suit= /obj/item/clothing/suit/storage/hazardvest/iac

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/grey
	)

/datum/ghostspawner/human/iac_volunteer/coordinator
	short_name = "iac_coordinator"
	name = "IAC Coordinator"
	desc = "Captain the IAC Rescue Ship. Act as the ship's chief doctor. Train your volunteers. Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble."

	spawnpoints = list("iac_coordinator")
	max_count = 1

	outfit = /datum/outfit/admin/iac_volunteer/coordinator
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Coordinator"
	special_role = "IAC Coordinator"


/datum/outfit/admin/iac_volunteer/coordinator
	name = "IAC Coordinator"

	suit= /obj/item/clothing/suit/storage/toggle/labcoat/iac

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/grey
	)

/obj/item/card/id/iac_rescue_ship
	name = "iac ship id"
	access = list(access_iac_rescue_ship, access_external_airlocks)
