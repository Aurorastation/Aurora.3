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

	ideal_character_age = list(
		SPECIES_HUMAN = 50,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_research, access_medical, access_mining, access_mailsorting,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_it, access_intrepid)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_research, access_medical, access_mining, access_mailsorting,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_it, access_bridge_crew, access_intrepid)
	minimal_player_age = 7
	outfit = /datum/outfit/job/chief_engineer

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/chief_engineer
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/chief_engineer
	head = /obj/item/clothing/head/hardhat/white
	belt = /obj/item/storage/belt/utility/ce
	id = /obj/item/card/id/navy
	shoes = /obj/item/clothing/shoes/workboots
	r_pocket = /obj/item/device/t_scanner

	headset = /obj/item/device/radio/headset/heads/ce
	bowman = /obj/item/device/radio/headset/heads/ce/alt
	double_headset = /obj/item/device/radio/headset/alt/double/ce
	wrist_radio = /obj/item/device/radio/headset/wrist/ce

	tab_pda = /obj/item/modular_computer/handheld/pda/engineering/ce
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/ce
	tablet = /obj/item/modular_computer/handheld/preset/engineering/ce

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

/datum/outfit/job/chief_engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)

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

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	outfit = /datum/outfit/job/engineer

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/engineer
	name = "Engineer"
	jobtype = /datum/job/engineer
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/engineer
	head = /obj/item/clothing/head/hardhat
	belt = /obj/item/storage/belt/utility
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/workboots
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

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)
	outfit = /datum/outfit/job/atmos
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/storage/belt/utility
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/workboots

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

/datum/job/intern_eng
	title = "Engineering Apprentice"
	flag = INTERN_ENG
	departments = SIMPLEDEPT(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	intro_prefix = "an"
	supervisors = "the Chief Engineer"
	selection_color = "#c67519"
	access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	minimal_access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	outfit = /datum/outfit/job/intern_eng
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

/datum/outfit/job/intern_eng
	name = "Engineering Apprentice"
	jobtype = /datum/job/intern_eng
	box = /obj/item/storage/box/survival/engineer

	uniform = /obj/item/clothing/under/rank/engineer/apprentice
	shoes = /obj/item/clothing/shoes/orange
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
