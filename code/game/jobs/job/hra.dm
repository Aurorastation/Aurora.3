/datum/job/hra
	title = "Human Resources Assistant"
	faction = "Station"
	flag = HRA
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 0
	supervisors = "SCC and the Internal Affairs department"
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	selection_color = "#c9ad12"

	access = list(access_sec_doors, access_medical, access_engine, access_eva, access_heads, access_maint_tunnels,
			            access_construction, access_research, access_gateway, access_weapons, access_bridge_crew, access_intrepid, access_cent_ccia)
	minimal_access = list(access_sec_doors, access_medical, access_engine, access_eva, access_heads, access_maint_tunnels,
			            access_construction, access_research, access_gateway, access_weapons, access_bridge_crew, access_intrepid, access_cent_ccia)

	outfit = /datum/outfit/job/hra
	blacklisted_species = list(SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA, SPECIES_DIONA_COEUS)


/datum/outfit/job/hra
	name = "Human Resources Assistant"
	jobtype = /datum/job/hra

	uniform = /obj/item/clothing/under/rank/scc2
	suit = /obj/item/clothing/suit/storage/toggle/armor/vest/scc
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	accessory = /obj/item/clothing/accessory/tie/corporate/scc
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/scc

	headset = /obj/item/device/radio/headset/representative
	bowman = /obj/item/device/radio/headset/representative/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command/representative
	wrist_radio = /obj/item/device/radio/headset/wrist/command/representative

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	tablet = /obj/item/modular_computer/handheld/preset/civilian/lawyer

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa
	id = /obj/item/card/id/gold
