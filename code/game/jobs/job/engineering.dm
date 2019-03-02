/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	head_position = 1
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	economic_modifier = 10
	exclusivity = 30

	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_research, access_medical,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_research, access_medical,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_player_age = 7
	outfit = /datum/outfit/job/chief_engineer

/datum/outfit/job/chief_engineer
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer

	uniform = /obj/item/clothing/under/rank/chief_engineer
	head = /obj/item/clothing/head/hardhat/white
	belt = /obj/item/weapon/storage/belt/utility/full
	pda = /obj/item/device/pda/heads/ce
	id = /obj/item/weapon/card/id/silver
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/heads/ce

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/duffel/eng
	messengerbag = /obj/item/weapon/storage/backpack/messenger/engi

/datum/outfit/job/chief_engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)

/datum/job/engineer
	title = "Station Engineer"
	flag = ENGINEER
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	alt_titles = list("Maintenance Technician","Engine Technician","Electrician")
	outfit = /datum/outfit/job/engineer
	exclusivity = 90

/datum/outfit/job/engineer
	name = "Engineer"
	jobtype = /datum/job/engineer

	uniform = /obj/item/clothing/under/rank/engineer
	head = /obj/item/clothing/head/hardhat
	belt = /obj/item/weapon/storage/belt/utility/full
	pda = /obj/item/device/pda/engineering
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_eng
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/duffel/eng
	messengerbag = /obj/item/weapon/storage/backpack/messenger/engi

/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)
	outfit = /datum/outfit/job/atmos
	exclusivity = 90

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos

	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/weapon/storage/belt/utility/atmostech
	pda = /obj/item/device/pda/atmos
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_eng

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/duffel/eng
	messengerbag = /obj/item/weapon/storage/backpack/messenger/engi