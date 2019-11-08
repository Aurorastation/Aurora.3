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
<<<<<<< HEAD
	selection_color = "#FFD737"
=======
	selection_color = "#ffeeaa"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
>>>>>>> origin
	economic_modifier = 10

	minimum_character_age = 30

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

	bag_type = /obj/item/weapon/storage/backpack/industrial
	satchel_type = /obj/item/weapon/storage/backpack/satchel_eng
	alt_satchel_type = /obj/item/weapon/storage/backpack/satchel
	duffel_type = /obj/item/weapon/storage/backpack/duffel/eng
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/engi


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/ce(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_engineer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/ce(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		if(istajara(H))
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
		else if(isunathi(H))
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		return 1

	equip_survival(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.species.equip_survival_gear(H,1)
		return TRUE


/datum/job/engineer
	title = "Station Engineer"
	flag = ENGINEER
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#FFEA95"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	alt_titles = list("Maintenance Technician","Engine Technician","Electrician")

	bag_type = /obj/item/weapon/storage/backpack/industrial
	satchel_type = /obj/item/weapon/storage/backpack/satchel_eng
	alt_satchel_type = /obj/item/weapon/storage/backpack/satchel
	duffel_type = /obj/item/weapon/storage/backpack/duffel/eng
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/engi

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
			if(5) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/duffel/eng(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/t_scanner(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_l_store)
		return TRUE

	equip_survival(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.species.equip_survival_gear(H,1)
		return TRUE


/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#FFEA95"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)
<<<<<<< HEAD
	outfit = /datum/outfit/job/atmos

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

/datum/job/intern_eng
	title = "Engineering Apprentice"
	flag = INTERN_ENG
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer"
	selection_color = "#FFEA95"
	access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	minimal_access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	outfit = /datum/outfit/job/intern_eng

/datum/outfit/job/intern_eng
	name = "Engineering Apprentice"
	jobtype = /datum/job/intern_eng

	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/orange
	head = /obj/item/clothing/head/beret/engineering
	l_ear = /obj/item/device/radio/headset/headset_eng

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/duffel/eng
	messengerbag = /obj/item/weapon/storage/backpack/messenger/engi
=======

	bag_type = /obj/item/weapon/storage/backpack/industrial
	satchel_type = /obj/item/weapon/storage/backpack/satchel_eng
	duffel_type = /obj/item/weapon/storage/backpack/duffel/eng
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/engi

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/atmospheric_technician(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/atmos(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/atmostech/(H), slot_belt)
		return TRUE

	equip_survival(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.species.equip_survival_gear(H,1)
		return TRUE
>>>>>>> origin
