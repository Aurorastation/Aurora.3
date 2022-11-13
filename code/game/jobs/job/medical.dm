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

	minimum_character_age = list(
		SPECIES_HUMAN = 35,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research, access_mining, access_mailsorting,
			access_first_responder, access_maint_tunnels, access_intrepid, access_teleporter)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research, access_mining, access_mailsorting,
			access_first_responder, access_maint_tunnels, access_intrepid, access_teleporter)

	minimal_player_age = 10
	ideal_character_age = list(
		SPECIES_HUMAN = 50,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)
	outfit = /datum/outfit/job/cmo

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	suit_store = /obj/item/device/flashlight/pen
	shoes = /obj/item/clothing/shoes/brown
	id = /obj/item/card/id/navy
	l_hand = /obj/item/storage/firstaid/adv

	headset = /obj/item/device/radio/headset/heads/cmo
	bowman = /obj/item/device/radio/headset/heads/cmo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/cmo
	wrist_radio = /obj/item/device/radio/headset/wrist/cmo

	tab_pda = /obj/item/modular_computer/handheld/pda/medical/cmo
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/cmo
	tablet = /obj/item/modular_computer/handheld/preset/medical/cmo

	backpack = /obj/item/storage/backpack/cmo
	satchel = /obj/item/storage/backpack/satchel/cmo
	dufflebag = /obj/item/storage/backpack/duffel/cmo
	messengerbag = /obj/item/storage/backpack/messenger/cmo

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

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_genetics, access_eva)
	outfit = /datum/outfit/job/doctor
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/doctor
	name = "Physician"
	base_name = "Physician"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/medical
	id = /obj/item/card/id/white
	suit_store = /obj/item/device/flashlight/pen

	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med

	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical

	backpack = /obj/item/storage/backpack/medic
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/med
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/med
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/med
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

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

	minimum_character_age = list(
		SPECIES_HUMAN = 26,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_pharmacy, access_virology)
	outfit = /datum/outfit/job/pharmacist
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/medical/pharmacist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/chemist
	id = /obj/item/card/id/white

	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med

	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical

	backpack = /obj/item/storage/backpack/pharmacy
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/pharm
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/pharm
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/pharm
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist")
	outfit = /datum/outfit/job/psychiatrist
	alt_outfits = list("Psychologist" = /datum/outfit/job/psychiatrist/psycho)
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/psychiatrist
	name = "Psychiatrist"
	base_name = "Psychiatrist"
	jobtype = /datum/job/psychiatrist

	uniform = /obj/item/clothing/under/rank/medical/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/psych
	id = /obj/item/card/id/white

	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med

	tab_pda = /obj/item/modular_computer/handheld/pda/medical/psych
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych
	tablet = /obj/item/modular_computer/handheld/preset/medical/psych

	backpack = /obj/item/storage/backpack/psychiatrist
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/psych
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/psych
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/psych
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

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

	minimum_character_age = list(
		SPECIES_HUMAN = 20,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_eva, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_external_airlocks, access_psychiatrist, access_first_responder)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_eva, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_external_airlocks, access_first_responder)
	outfit = /datum/outfit/job/med_tech

	blacklisted_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC_G2, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/med_tech
	name = "First Responder"
	base_name = "First Responder"
	jobtype = /datum/job/med_tech

	head = /obj/item/clothing/head/softcap/nt
	uniform = /obj/item/clothing/under/rank/medical/first_responder
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/white

	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med

	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical

	backpack = /obj/item/storage/backpack/emt
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/emt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/emt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/emt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	backpack_contents = list(
		/obj/item/storage/firstaid/adv = 1
	)

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
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	outfit = /datum/outfit/job/intern_med
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/intern_med
	name = "Medical Intern"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical/intern
	shoes = /obj/item/clothing/shoes/medical
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med

	backpack = /obj/item/storage/backpack/medic
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/med
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/med
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/med
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	tab_pda = /obj/item/modular_computer/handheld/pda/medical
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	tablet = /obj/item/modular_computer/handheld/preset/medical
