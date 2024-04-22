/datum/ghostspawner/human/pirate
	short_name = "pirate"
	name = "Pirate Gang Member"
	tags = list("External")
	desc = "\
		You are part of a pirate gang residing in your own base, having just scored a hit and captured a hostage, \
		trying to wait out a bounty that was placed on your ship and its crew. \
		Just now a unknown ship has landed outside your asteroid base, they'd best buckle up, they're on your turf now. \
		"
	desc_ooc = "\
		This is an antagonist role.\
		"
	welcome_message = "\
		You awake to the sound of an alarm signifying that a ship has landed nearby! \
		Better gear up and come up with a gameplan for how you're gonna approach this fast before they come kicking the door down. \
		You have a shuttle, but it is completely unpowered. Better deal with the intruders before you go fix your shuttle. \
		There is a secret equipment room, north from the living room, read the note on the floor of your crew quarters on how to access it. \
		"
	welcome_message_ooc = "\
		This is an antagonist role which places typical antagonist expectations on you. \
		You're expected to try to generate an interesting encounter with whoever has docked on the away site. \
		Remember to follow basic escalation rules, and have fun!\
		"

	spawnpoints = list("pirate")
	max_count = 4
	enabled = FALSE

	outfit = /obj/outfit/admin/pirate
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Gang Member"
	respawn_flag = null


/obj/outfit/admin/pirate
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

/obj/outfit/admin/pirate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/obj/outfit/admin/pirate/get_id_access()
	return list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/pirate/boss
	short_name = "pirate_boss"
	name = "Pirate Gang Boss"
	tags = list("External")
	desc = "\
		You are the head honcho of a pirate gang residing in your own base, having just scored a hit and captured a hostage, \
		trying to wait out a bounty that was placed on your ship and its crew. \
		Just now a unknown ship has landed outside your asteroid base, they'd best buckle up, they're on your turf now. \
		"
	welcome_message = "\
		You awake to the sound of an alarm signifying that a ship has landed nearby! \
		Better gear up and come up with a gameplan for how you're gonna approach this fast before they come kicking the door down. \
		You have a shuttle, but it is completely unpowered. Better deal with the intruders before you go fix your shuttle. \
		There is a secret equipment room, north from the living room, read the note on the floor of your crew quarters on how to access it. \
		"
	welcome_message_ooc = "\
		This is an antagonist role which places typical antagonist expectations on you. \
		You're expected to try to generate an interesting encounter with whoever has docked on the away site. \
		Remember to follow basic escalation rules, and have fun!\
		"

	spawnpoints = list("pirate_boss")
	max_count = 1
	enabled = FALSE

	outfit = /obj/outfit/admin/pirate
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Gang Boss"
	respawn_flag = null


/obj/outfit/admin/pirate
	name = "Pirate Gang Boss"

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)

/datum/ghostspawner/human/pirate/prisoner
	short_name = "pirate_prisoner"
	name = "Pirate Gang Captive"
	tags = list("External")
	desc = "\
		Life hasn't been kind to you lately, and now you find yourself a prisoner to a savage pirate gang. \
		Maybe today will finally be the day where your luck turns?\
		"
	welcome_message = "\
		Despite the unfortunate luck that has gotten you in this situation, \
		there's one positive thing: the pirates neglected to fully search you when they first brought you in. \
		It is up to you if you decide it's worth the risk to attempt an escape with what you got, or lie low and hope someone sweeps in and saves you.\
		"

	spawnpoints = list("pirate_prisoner")
	max_count = 1
	enabled = FALSE

	outfit = /obj/outfit/admin/pirate_prisoner
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Independent Spacer"
	respawn_flag = null


/obj/outfit/admin/pirate_prisoner
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
