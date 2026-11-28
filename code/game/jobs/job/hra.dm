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

	job_access = list(
		/datum/access/horizon/sec_doors::id, /datum/access/horizon/medical::id, /datum/access/horizon/engine::id, /datum/access/horizon/eva::id, /datum/access/horizon/heads::id, /datum/access/horizon/maint_tunnels::id,
		/datum/access/horizon/construction::id, /datum/access/horizon/research::id, /datum/access/horizon/gateway::id, /datum/access/horizon/weapons::id, /datum/access/horizon/bridge_crew::id, /datum/access/horizon/intrepid::id,
		/datum/access/horizon/spark::id, /datum/access/horizon/quark::id, /datum/access/horizon/canary::id, /datum/access/centcomm/cent_ccia::id
	)

	outfit = /obj/outfit/job/hra
	blacklisted_species = list(
		SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN,
		SPECIES_UNATHI, SPECIES_UNATHI_URAWANI, SPECIES_UNATHI_ZIRALIXI,
		SPECIES_DIONA, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA_COEUS
	)


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

	headset = /obj/item/radio/headset/representative
	bowman = /obj/item/radio/headset/representative/alt
	double_headset = /obj/item/radio/headset/alt/double/command/representative
	wrist_radio = /obj/item/radio/headset/wrist/command/representative

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	tablet = /obj/item/modular_computer/handheld/preset/civilian/lawyer

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa
	id = /obj/item/card/id/scc/gold

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
