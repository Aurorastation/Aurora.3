/datum/ghostspawner/human/freebooter_crew
	short_name = "freebooter_crew"
	name = "Freebooter Crewman"
	desc = "Crew the Freebooter ship. Listen to your captain - you follow no laws but his. You like to think of yourself as an adventurer and a businessman. Others, though, would call you a pirate, a bandit, a smuggler, a thug, a thief and a knave. It doesn't matter to you what they say: you're here to make money, by any means necessary. Just don't let the law catch up to you."
	tags = list("External")

	spawnpoints = list("freebooter_crew")
	max_count = 4

	outfit = /datum/outfit/admin/freebooter_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Freebooter Crewman"
	respawn_flag = null


/datum/outfit/admin/freebooter_crew
	name = "Freebooter Crewman"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/freebooter_crew_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)

/datum/outfit/admin/freebooter_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/surname = splittext(H.name, " ")
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

/datum/outfit/admin/freebooter_crew/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/freebooter_crew/captain
	short_name = "freebooter_crew_captain"
	name = "Freebooter Captain"
	desc = "Captain the freebooter ship. You like to think of yourself as an adventurer and a businessman. Others, though, would call you a pirate, a bandit, a smuggler, a thug, a thief and a knave. It doesn't matter to you what they say: you're here to make money, by any means necessary. Just don't let the law catch up to you."

	spawnpoints = list("freebooter_crew_captain")
	max_count = 1

	outfit = /datum/outfit/admin/freebooter_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Captain"
	special_role = "Freebooter Captain"


/datum/outfit/admin/freebooter_crew/captain
	name = "Freebooter Captain"

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless
	)

/obj/item/card/id/freebooter_crew_ship
	name = "independent ship id"
	access = list(access_external_airlocks)
