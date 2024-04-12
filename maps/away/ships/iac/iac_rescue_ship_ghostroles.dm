//iac volunteers

/datum/ghostspawner/human/iac_volunteer
	short_name = "iac_volunteer"
	name = "IAC Volunteer"
	desc = "Crew the IAC Rescue Ship. Act as either a physician, surgeon, first responder (not all three), or as a fresh-faced trainee! Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble. Remember, you're a strictly neutral aid worker sworn to offer assistance to anyone who needs it! Don't get involved in interstellar politics."
	tags = list("External")

	spawnpoints = list("iac_volunteer")
	max_count = 2

	outfit = /obj/outfit/admin/iac_volunteer
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Volunteer"
	special_role = "IAC Volunteer"
	respawn_flag = null


/obj/outfit/admin/iac_volunteer
	name = "IAC Volunteer"

	uniform = /obj/item/clothing/under/rank/iacjumpsuit
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc
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

/obj/outfit/admin/iac_volunteer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/list/fullname = splittext(H.name, " ")
		var/surname = fullname[fullname.len]
		switch(surname)
			if("K'lax")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
			if("C'thur")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/iac_volunteer/get_id_access()
	return list(ACCESS_IAC_RESCUE_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/iac_volunteer/technician
	short_name = "iac_technician"
	name = "IAC Technician"
	desc = "Crew the IAC Rescue Ship. Act as the ship's Engineering or Pharmacy personnel (not both). Carry out ship maintenance and service damaged IPCs, or produce medications and drugs for the medical staff. Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble. Remember, you're a strictly neutral aid worker sworn to offer assistance to anyone who needs it! Don't get involved in interstellar politics."

	spawnpoints = list("iac_technician")
	max_count = 2

	outfit = /obj/outfit/admin/iac_volunteer/technician
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Technician"
	special_role = "IAC Technician"


/obj/outfit/admin/iac_volunteer/technician
	name = "IAC Technician"

	suit = /obj/item/clothing/suit/storage/hazardvest/iac

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless
	)

/datum/ghostspawner/human/iac_volunteer/coordinator
	short_name = "iac_coordinator"
	name = "IAC Coordinator"
	desc = "Command the IAC Rescue Ship. Act as the ship's chief doctor. Train your volunteers. Help those in need and respond to medical emergencies or distress calls. Try to raise funds and donations while staying out of trouble. Remember, you're a strictly neutral aid worker sworn to offer assistance to anyone who needs it! Don't get involved in interstellar politics."

	spawnpoints = list("iac_coordinator")
	max_count = 1

	outfit = /obj/outfit/admin/iac_volunteer/coordinator
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "IAC Coordinator"
	special_role = "IAC Coordinator"


/obj/outfit/admin/iac_volunteer/coordinator
	name = "IAC Coordinator"

	suit = /obj/item/clothing/suit/storage/toggle/labcoat/iac

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/grey,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/grey
	)

//items

/obj/item/card/id/iac_rescue_ship
	name = "iac ship id"
	access = list(ACCESS_IAC_RESCUE_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
