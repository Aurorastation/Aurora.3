/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	head_position = TRUE
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#FFD737"
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
	outfit = /datum/outfit/job/chief_engineer

	blacklisted_species = list("M'sai Tajara", "Zhan-Khazan Tajara", "Vaurca Worker", "Vaurca Warrior")

/datum/outfit/job/chief_engineer
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer

	uniform = /obj/item/clothing/under/rank/chief_engineer
	head = /obj/item/clothing/head/hardhat/white
	belt = /obj/item/storage/belt/utility
	pda = /obj/item/device/pda/heads/ce
	id = /obj/item/card/id/navy
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/heads/ce
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel_eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

	belt_contents = list(
		/obj/item/weldingtool/largetank = 1, // industrial welding tool
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

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
	selection_color = "#FFEA95"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	outfit = /datum/outfit/job/engineer

/datum/outfit/job/engineer
	name = "Engineer"
	jobtype = /datum/job/engineer

	uniform = /obj/item/clothing/under/rank/engineer
	head = /obj/item/clothing/head/hardhat
	belt = /obj/item/storage/belt/utility
	pda = /obj/item/device/pda/engineering
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_eng
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel_eng
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
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	intro_prefix = "an"
	supervisors = "the chief engineer"
	selection_color = "#FFEA95"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)
	outfit = /datum/outfit/job/atmos

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos

	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/storage/belt/utility
	pda = /obj/item/device/pda/atmos
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_eng

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel_eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi

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
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	intro_prefix = "an"
	supervisors = "the Chief Engineer"
	selection_color = "#FFEA95"
	access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	minimal_access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	outfit = /datum/outfit/job/intern_eng

	minimum_character_age = 18

/datum/outfit/job/intern_eng
	name = "Engineering Apprentice"
	jobtype = /datum/job/intern_eng

	uniform = /obj/item/clothing/under/rank/engineer/apprentice
	shoes = /obj/item/clothing/shoes/orange
	head = /obj/item/clothing/head/beret/engineering
	belt = /obj/item/storage/belt/utility
	l_ear = /obj/item/device/radio/headset/headset_eng

	belt_contents = list(
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel_eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi