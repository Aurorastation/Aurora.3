/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	head_position = 1
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#FF56B4"
	economic_modifier = 10

	minimum_character_age = 35

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_emt, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_emt, access_maint_tunnels)

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
	l_ear = /obj/item/device/radio/headset/heads/cmo
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
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
	economic_modifier = 7

	minimum_character_age = 25

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_genetics, access_eva)
	outfit = /datum/outfit/job/doctor

/datum/job/surgeon
	title = "Surgeon"
	flag = SURGEON
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
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
	l_ear = /obj/item/device/radio/headset/headset_med
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
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
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
	l_ear = /obj/item/device/radio/headset/headset_med
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
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5

	minimum_character_age = 30

	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
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
	l_ear = /obj/item/device/radio/headset/headset_med
	tab_pda = /obj/item/modular_computer/handheld/pda/medical/psych
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych
	tablet = /obj/item/modular_computer/handheld/preset/medical/psych
	id = /obj/item/card/id/white

/datum/outfit/job/psychiatrist/psycho
	name = "Psychologist"
	jobtype = /datum/job/psychiatrist

/datum/job/med_tech
	title = "Emergency Medical Technician"
	flag = MED_TECH
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
	economic_modifier = 4

	minimum_character_age = 20

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_emt)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_emt)
	outfit = /datum/outfit/job/med_tech
	blacklisted_species = list(SPECIES_DIONA, SPECIES_IPC_G2)

/datum/outfit/job/med_tech
	name = "Emergency Medical Technician"
	base_name = "Emergency Medical Technician"
	jobtype = /datum/job/med_tech

	uniform = /obj/item/clothing/under/rank/medical/emt
	suit = /obj/item/clothing/suit/storage/toggle/emt_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/headset_med
	l_hand = /obj/item/storage/firstaid/adv
	r_hand = /obj/item/reagent_containers/hypospray
	belt = /obj/item/storage/belt/medical/emt
	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical
	id = /obj/item/card/id/white
	head = /obj/item/clothing/head/hardhat/emt

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/job/intern_med
	title = "Medical Intern"
	flag = INTERN_MED
	department = DEPARTMENT_MEDICAL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#FF97D1"
	access = list(access_medical, access_surgery, access_medical_equip)
	minimal_access = list(access_medical, access_surgery, access_medical_equip)
	minimum_character_age = 18
	outfit = /datum/outfit/job/intern_med

/datum/outfit/job/intern_med
	name = "Medical Intern"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical/intern
	shoes = /obj/item/clothing/shoes/medical
	l_ear = /obj/item/device/radio/headset/headset_med

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med
