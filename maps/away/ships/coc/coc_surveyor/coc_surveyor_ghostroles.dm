/datum/ghostspawner/human/coc_surveyor
	short_name = "coc_surveyor"
	name = "Coalition Surveyor"
	desc = "Crew a Coalition of Colonies survey vessel and survey nearby planets and objects of interest."
	tags = list("External")
	spawnpoints = list("coc_surveyor")
	welcome_message = "You are a crewmember on a pan-Coalition survey vessel. Analyse objects in the sector for potential scientific or mineral significance to the COC, and your member state. Characters should have backgrounds consistent with the Coalition of Colonies."

	max_count = 4
	uses_species_whitelist = TRUE
	respawn_flag = null
	outfit = /obj/outfit/admin/coc_surveyor_crew

	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Coalition Surveyor"
	special_role = "Coalition Surveyor"

/obj/outfit/admin/coc_surveyor_crew
	name = "Coalition Surveyor"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless/dark,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless/dark,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless/dark
	)

/obj/outfit/admin/coc_surveyor_crew/post_equip(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/voidsuit_modkit/himeo/tajara, slot_r_hand)
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()


/obj/outfit/admin/coc_surveyor_crew/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_COALITION)

/datum/ghostspawner/human/coc_surveyor/captain
	name = "Coalition Head Surveyor"
	short_name = "coc_surveyor_captain"
	desc = "Command a Coalition of Colonies survey vessel and survey nearby planets and objects of interest."
	spawnpoints = list("coc_surveyor_captain")
	max_count = 1
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	welcome_message = "You are in command of a Coalition of Colonies survey vessel. Survey the sector for planets and sites of potential interest to the COC and your member-state. Characters should have backgrounds from the Coalition of Colonies."
