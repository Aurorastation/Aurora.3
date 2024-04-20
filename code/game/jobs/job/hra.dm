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

	selection_color = "#c9ad12"

	access = list(ACCESS_SEC_DOORS, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_EVA, ACCESS_HEADS, ACCESS_MAINT_TUNNELS,
					ACCESS_CONSTRUCTION, ACCESS_RESEARCH, ACCESS_GATEWAY, ACCESS_WEAPONS, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_CENT_CCIA)

	minimal_access = list(ACCESS_SEC_DOORS, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_EVA, ACCESS_HEADS, ACCESS_MAINT_TUNNELS,
							ACCESS_CONSTRUCTION, ACCESS_RESEARCH, ACCESS_GATEWAY, ACCESS_WEAPONS, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_CENT_CCIA)

	outfit = /obj/outfit/job/hra
	blacklisted_species = list(SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA, SPECIES_DIONA_COEUS)


/obj/outfit/job/hra
	name = "Human Resources Assistant"
	jobtype = /datum/job/hra

	uniform = /obj/item/clothing/under/rank/scc2/ccia
	suit = /obj/item/clothing/suit/storage/toggle/armor/ccia
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	accessory = /obj/item/clothing/accessory/holster/waist
	accessory_contents = list(/obj/item/gun/energy/repeater/pistol = 1)
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	head = /obj/item/clothing/head/beret/scc/alt
	belt = /obj/item/melee/telebaton

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



	backpack_contents = list(
			/obj/item/modular_computer/laptop/preset/command = 1,
	)

/obj/outfit/job/hra/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H && H.w_uniform)
		var/obj/item/clothing/under/U = H.w_uniform
		var/obj/item/clothing/accessory/tie/corporate/scc/alt/tie = new()
		U.attach_accessory(null, tie)

	return TRUE
