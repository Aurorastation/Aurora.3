/datum/ghostspawner/human/goon
	short_name = "goon"
	name = "Pirate Gang Member"
	desc = "You are part of a wanted pirate gang stranded in their own base due to their vessel being broken down. Now that a unknown ship has landed outside your asteroid base, they might prove to be your ticket to being free once more, or they may be the end of the line for your whole crew. Whatever the case, they'd best buckle up; they're on your turf now. (OOC Note: This is an antagonist role.)"
	welcome_message = "You awake to the sound of an alarm signifying that a ship has landed nearby! Given that one of your ex-crew members blew up the SMES of your ship some time ago, these trespassers might actually be a blessing in disguise since they may have the tools and expertise to get it back running again. But be careful, odds are they know about your bounty in the Coalition of Colonies. Better gear up and come up with a gameplan for how you're gonna approach this fast before they come kicking the door down. (OOC Note: This is an antagonist role which places typical antagonist expectations on you. You're expected to try to generate an interesting encounter with whoever has docked on the away site. Remember to follow basic escalation rules, and have fun!)"
	tags = list("External")

	spawnpoints = list("goon")
	max_count = 4
	enabled = FALSE

	outfit = /datum/outfit/admin/goon
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Gang Member"
	respawn_flag = null


/datum/outfit/admin/goon
	name = "Pirate Gang Member"

	uniform = /obj/item/clothing/under/syndicate/tracksuit
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)

/datum/outfit/admin/goon/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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

/datum/outfit/admin/goon/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/goon/boss
	short_name = "goon_boss"
	name = "Pirate Gang Boss"
	desc = "You are the head honcho of a wanted pirate gang stranded in their own base due to their vessel being broken down. Now that a unknown ship has landed outside your asteroid base, they might prove to be your ticket to being free once more, or they may be the end of the line for your whole crew. Whatever the case, they'd best buckle up; they're on your turf now. (OOC Note: This is an antagonist role.)"
	tags = list("External")
	welcome_message = "You awake to the sound of an alarm signifying that a ship has landed nearby! Given that one of your ex-crew members blew up the SMES of your ship some time ago, these trespassers might actually be a blessing in disguise since they may have the tools and expertise to get it back running again. But be careful, odds are they know about your bounty in the Coalition of Colonies. Better gear up and come up with a gameplan for how you're gonna approach this fast before they come kicking the door down.  (OOC Note: This is an antagonist role which places typical antagonist expectations on you. You're expected to try to generate an interesting encounter with whoever has docked on the away site. Remember to follow basic escalation rules, and have fun!)"

	spawnpoints = list("goon_boss")
	max_count = 1
	enabled = FALSE

	outfit = /datum/outfit/admin/goon
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Gang Boss"
	respawn_flag = null


/datum/outfit/admin/goon
	name = "Pirate Gang Boss"

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)

/datum/ghostspawner/human/goon/prisoner
	short_name = "goon_prisoner"
	name = "Pirate Gang Captive"
	desc = "Life hasn't been kind to you lately, and now you find yourself a prisoner to a savage pirate gang. Maybe today will finally be the day where your luck turns?"
	tags = list("External")
	welcome_message = "Despite the unfortunate luck that has gotten you in this situation, there's one positive thing: the pirates neglected to search you when they first brought you in. It is up to you if you decide it's worth the risk to attempt an escape with what you got, or lie low and hope someone sweeps in and saves you."

	spawnpoints = list("goon_prisoner")
	max_count = 1
	enabled = FALSE

	outfit = /datum/outfit/admin/goon_prisoner
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Independent Spacer"
	respawn_flag = null


/datum/outfit/admin/goon_prisoner
	name = "Pirate Gang Captive"

	uniform = /obj/item/clothing/under/color/brown
	shoes = /obj/item/clothing/shoes/sandals
	back = /obj/item/storage/backpack/satchel/leather

	id = null
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/screwdriver = 1, /obj/item/wirecutters = 1, /obj/item/device/radio = 1, /obj/item/device/multitool = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)
