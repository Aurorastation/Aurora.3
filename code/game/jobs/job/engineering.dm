/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	departments = list(DEPARTMENT_ENGINEERING = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#c67519"
	economic_modifier = 10

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
					ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA, ACCESS_LEVIATHAN, ACCESS_SHIP_WEAPONS,
					ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_MINING, ACCESS_MAILSORTING,
					ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD, ACCESS_IT, ACCESS_INTREPID, ACCESS_NETWORK)

	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
							ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA, ACCESS_LEVIATHAN, ACCESS_SHIP_WEAPONS,
							ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_MINING, ACCESS_MAILSORTING,
							ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD, ACCESS_IT, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_NETWORK)

	minimal_player_age = 7
	outfit = /obj/outfit/job/chief_engineer

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/chief_engineer
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/chief_engineer
	head = /obj/item/clothing/head/hardhat/white
	belt = /obj/item/storage/belt/utility/ce
	id = /obj/item/card/id/navy
	shoes = null
	r_pocket = /obj/item/device/t_scanner

	headset = /obj/item/device/radio/headset/heads/ce
	bowman = /obj/item/device/radio/headset/heads/ce/alt
	double_headset = /obj/item/device/radio/headset/alt/double/ce
	wrist_radio = /obj/item/device/radio/headset/wrist/ce

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering/ce
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/ce
	tablet = /obj/item/modular_computer/handheld/preset/engineering/ce

	backpack = /obj/item/storage/backpack/ce
	satchel = /obj/item/storage/backpack/satchel/ce
	dufflebag = /obj/item/storage/backpack/duffel/ce
	messengerbag = /obj/item/storage/backpack/messenger/ce

/obj/outfit/job/chief_engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/specialt(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/specialu(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), slot_gloves)

/datum/job/engineer
	title = "Engineer"
	flag = ENGINEER
	departments = SIMPLEDEPT(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#c67519"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_SHIP_WEAPONS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_LEVIATHAN)
	minimal_access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_SHIP_WEAPONS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_LEVIATHAN)
	outfit = /obj/outfit/job/engineer

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/engineer
	name = "Engineer"
	jobtype = /datum/job/engineer
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/engineer
	head = /obj/item/clothing/head/hardhat
	belt = /obj/item/storage/belt/utility
	id = /obj/item/card/id/silver
	shoes = null
	r_pocket = /obj/item/device/t_scanner

	headset = /obj/item/device/radio/headset/headset_eng
	bowman = /obj/item/device/radio/headset/headset_eng/alt
	double_headset = /obj/item/device/radio/headset/alt/double/eng
	wrist_radio = /obj/item/device/radio/headset/wrist/eng

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering
	tablet = /obj/item/modular_computer/handheld/preset/engineering

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

	belt_contents = list(
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

/obj/outfit/job/engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)

/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	departments = SIMPLEDEPT(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	intro_prefix = "an"
	supervisors = "the chief engineer"
	selection_color = "#c67519"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_LEVIATHAN)
	minimal_access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_LEVIATHAN)
	outfit = /obj/outfit/job/atmos
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/storage/belt/utility
	id = /obj/item/card/id/silver
	shoes = null

	headset = /obj/item/device/radio/headset/headset_eng
	bowman = /obj/item/device/radio/headset/headset_eng/alt
	double_headset = /obj/item/device/radio/headset/alt/double/eng
	wrist_radio = /obj/item/device/radio/headset/wrist/eng

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering/atmos
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/atmos
	tablet = /obj/item/modular_computer/handheld/preset/engineering/atmos

	belt_contents = list(
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/device/t_scanner = 1,
		/obj/item/device/analyzer = 1,
		/obj/item/pipewrench = 1,
		/obj/item/powerdrill = 1
	)

/obj/outfit/job/atmos/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots/toeless(H), slot_shoes)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)

/datum/job/intern_eng
	title = "Engineering Apprentice"
	flag = INTERN_ENG
	departments = SIMPLEDEPT(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	alt_titles = list("Atmospherics Apprentice")
	alt_outfits = list("Atmospherics Apprentice" = /obj/outfit/job/intern_atmos)
	total_positions = 3
	spawn_positions = 3
	intro_prefix = "an"
	supervisors = "the Chief Engineer"
	selection_color = "#c67519"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION, ACCESS_ENGINE_EQUIP, ACCESS_ENGINE)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION, ACCESS_ENGINE_EQUIP, ACCESS_ENGINE)
	outfit = /obj/outfit/job/intern_eng
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

	minimum_character_age = list(
		SPECIES_HUMAN = 24,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	)

/obj/outfit/job/intern_eng
	name = "Engineering Apprentice"
	jobtype = /datum/job/intern_eng
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/engineer/apprentice
	shoes = /obj/item/clothing/shoes/sneakers/orange
	head = /obj/item/clothing/head/beret/engineering
	belt = /obj/item/storage/belt/utility

	belt_contents = list(
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

	headset = /obj/item/device/radio/headset/headset_eng
	bowman = /obj/item/device/radio/headset/headset_eng/alt
	double_headset = /obj/item/device/radio/headset/alt/double/eng
	wrist_radio = /obj/item/device/radio/headset/wrist/eng

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering
	tablet = /obj/item/modular_computer/handheld/preset/engineering

/obj/outfit/job/intern_atmos
	name = "Atmospherics Apprentice"
	jobtype = /datum/job/intern_eng
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/engineer/apprentice
	shoes = /obj/item/clothing/shoes/sneakers/orange
	head = /obj/item/clothing/head/beret/engineering
	belt = /obj/item/storage/belt/utility

	belt_contents = list(
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/device/t_scanner = 1,
		/obj/item/device/analyzer = 1,
		/obj/item/pipewrench = 1,
		/obj/item/powerdrill = 1
	)

	headset = /obj/item/device/radio/headset/headset_eng
	bowman = /obj/item/device/radio/headset/headset_eng/alt
	double_headset = /obj/item/device/radio/headset/alt/double/eng
	wrist_radio = /obj/item/device/radio/headset/wrist/eng

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering/atmos
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/atmos
	tablet = /obj/item/modular_computer/handheld/preset/engineering/atmos
