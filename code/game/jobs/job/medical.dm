/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	departments = list(DEPARTMENT_MEDICAL = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#15903a"
	economic_modifier = 10

	minimum_character_age = 35

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_first_responder, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_first_responder, access_maint_tunnels)

	minimal_player_age = 10
	ideal_character_age = 50
	outfit = /datum/outfit/job/cmo

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	suit_store = /obj/item/device/flashlight/pen
	shoes = /obj/item/clothing/shoes/brown
	headset = /obj/item/device/radio/headset/heads/cmo
	bowman = /obj/item/device/radio/headset/heads/cmo/alt
	tab_pda = /obj/item/modular_computer/handheld/pda/medical/cmo
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/cmo
	tablet = /obj/item/modular_computer/handheld/preset/medical/cmo
	id = /obj/item/card/id/navy
	l_hand = /obj/item/storage/firstaid/adv

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/job/doctor
	title = "Physician"
	flag = DOCTOR
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 7

	minimum_character_age = 25

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_genetics, access_eva)
	outfit = /datum/outfit/job/doctor

/datum/job/surgeon
	title = "Surgeon"
	flag = SURGEON
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 7

	spawn_positions = 2
	total_positions = 2

	minimum_character_age = 30

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_genetics, access_eva)
	outfit = /datum/outfit/job/doctor/surgeon

/datum/outfit/job/doctor
	name = "Physician"
	base_name = "Physician"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/medical
	shoes = /obj/item/clothing/shoes/medical
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical
	id = /obj/item/card/id/white
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/outfit/job/doctor/surgeon
	name = "Surgeon"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical/blue
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/surgeon
	shoes = /obj/item/clothing/shoes/surgeon
	head = /obj/item/clothing/head/surgery/blue

/datum/outfit/job/doctor/nurse
	name = "Nurse"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical/purple
	suit = null
	head = /obj/item/clothing/head/nursehat


/datum/job/pharmacist
	title = "Pharmacist"
	flag = CHEMIST
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 5

	minimum_character_age = 26

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_pharmacy, access_virology)
	outfit = /datum/outfit/job/pharmacist

/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/pharmacist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/pharmacist
	shoes = /obj/item/clothing/shoes/chemist
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical
	id = /obj/item/card/id/white

	backpack = /obj/item/storage/backpack/pharmacy
	satchel = /obj/item/storage/backpack/satchel_pharm
	dufflebag = /obj/item/storage/backpack/duffel/pharm
	messengerbag = /obj/item/storage/backpack/messenger/pharm

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5

	minimum_character_age = 30

	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist")
	outfit = /datum/outfit/job/psychiatrist
	alt_outfits = list("Psychologist" = /datum/outfit/job/psychiatrist/psycho)

/datum/outfit/job/psychiatrist
	name = "Psychiatrist"
	base_name = "Psychiatrist"
	jobtype = /datum/job/psychiatrist

	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/psych
	shoes = /obj/item/clothing/shoes/psych
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	tab_pda = /obj/item/modular_computer/handheld/pda/medical/psych
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych
	tablet = /obj/item/modular_computer/handheld/preset/medical/psych
	id = /obj/item/card/id/white

/datum/outfit/job/psychiatrist/psycho
	name = "Psychologist"
	jobtype = /datum/job/psychiatrist

/datum/job/med_tech
	title = "First Responder"
	flag = MED_TECH
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 4

	minimum_character_age = 20

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_first_responder)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_first_responder)
	outfit = /datum/outfit/job/med_tech
	blacklisted_species = list(SPECIES_DIONA, SPECIES_IPC_G2)

/datum/outfit/job/med_tech
	name = "First Responder"
	base_name = "First Responder"
	jobtype = /datum/job/med_tech

	uniform = /obj/item/clothing/under/rank/medical/first_responder
	suit = /obj/item/clothing/suit/storage/toggle/first_responder_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	l_hand = /obj/item/storage/firstaid/adv
	r_hand = /obj/item/reagent_containers/hypospray
	belt = /obj/item/storage/belt/medical/first_responder
	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical
	id = /obj/item/card/id/white
	head = /obj/item/clothing/head/hardhat/first_responder

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/job/intern_med
	title = "Medical Intern"
	flag = INTERN_MED
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	selection_color = "#15903a"
	access = list(access_medical, access_surgery, access_medical_equip)
	minimal_access = list(access_medical, access_surgery, access_medical_equip)
	minimum_character_age = 18
	outfit = /datum/outfit/job/intern_med

/datum/outfit/job/intern_med
	name = "Medical Intern"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical/intern
	shoes = /obj/item/clothing/shoes/medical
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical