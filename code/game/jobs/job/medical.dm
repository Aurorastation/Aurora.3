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

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS,
			ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE, ACCESS_ENGINE, ACCESS_SHIP_WEAPONS, ACCESS_CONSTRUCTION,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING,
			ACCESS_FIRST_RESPONDER, ACCESS_MAINT_TUNNELS, ACCESS_INTREPID, ACCESS_TELEPORTER)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS,
			ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE, ACCESS_ENGINE, ACCESS_SHIP_WEAPONS, ACCESS_CONSTRUCTION,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING,
			ACCESS_FIRST_RESPONDER, ACCESS_MAINT_TUNNELS, ACCESS_INTREPID, ACCESS_TELEPORTER)

	minimal_player_age = 10
	outfit = /obj/outfit/job/cmo

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	suit_store = /obj/item/device/flashlight/pen
	shoes = /obj/item/clothing/shoes/sneakers/brown
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
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_EVA)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_GENETICS, ACCESS_EVA)
	outfit = /obj/outfit/job/doctor
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

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

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_EVA)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_GENETICS, ACCESS_EVA)
	outfit = /obj/outfit/job/doctor/surgeon
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/doctor
	name = "Physician"
	base_name = "Physician"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/sneakers/medsci
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

/obj/outfit/job/doctor/surgeon
	name = "Surgeon"
	jobtype = /datum/job/surgeon

	uniform = /obj/item/clothing/under/rank/medical/surgeon
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/sneakers/medsci

/obj/outfit/job/doctor/surgeon/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!isskrell(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery(H), slot_head)

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

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_PHARMACY, ACCESS_VIROLOGY)
	outfit = /obj/outfit/job/pharmacist
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/medical/pharmacist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/sneakers/medsci
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
	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_PSYCHIATRIST)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_PSYCHIATRIST)
	alt_titles = list("Psychologist")
	outfit = /obj/outfit/job/psychiatrist
	alt_outfits = list("Psychologist" = /obj/outfit/job/psychiatrist/psycho)
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/psychiatrist
	name = "Psychiatrist"
	base_name = "Psychiatrist"
	jobtype = /datum/job/psychiatrist

	uniform = /obj/item/clothing/under/rank/medical/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/sneakers/medsci
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

/obj/outfit/job/psychiatrist/psycho
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
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_EVA, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_PSYCHIATRIST, ACCESS_FIRST_RESPONDER)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_EVA, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_FIRST_RESPONDER)
	outfit = /obj/outfit/job/med_tech

	blacklisted_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC_G2, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/med_tech
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
	alt_titles = list("First Responder Trainee", "Pharmacy Intern", "Resident Physician", "Resident Surgeon", "Resident Psychiatrist")
	alt_outfits = list("First Responder Trainee" = /obj/outfit/job/intern_med/medtech, "Pharmacy Intern" = /obj/outfit/job/intern_med/pharmacist, "Resident Surgeon" = /obj/outfit/job/intern_med/surgeon, "Resident Psychiatrist" = /obj/outfit/job/intern_med/psychiatrist)
	alt_ages = list("Pharmacy Intern" = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	),
	"Resident Physician" = list(
		SPECIES_HUMAN = 28,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	),
	"Resident Surgeon" = list(
		SPECIES_HUMAN = 28,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	),
	"Resident Psychiatrist" = list(
		SPECIES_HUMAN = 28,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	))
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#15903a"
	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP)
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	outfit = /obj/outfit/job/intern_med
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/intern_med
	name = "Medical Intern"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical/intern
	shoes = /obj/item/clothing/shoes/sneakers/medsci
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

/obj/outfit/job/intern_med/medtech
	name = "First Responder Trainee"

	head = /obj/item/clothing/head/softcap/nt
	shoes = /obj/item/clothing/shoes/jackboots

	backpack = /obj/item/storage/backpack/emt
	satchel = /obj/item/storage/backpack/satchel/emt
	dufflebag = /obj/item/storage/backpack/duffel/emt
	messengerbag = /obj/item/storage/backpack/messenger/emt

	backpack_contents = list(
		/obj/item/storage/firstaid = 1
	)

/obj/outfit/job/intern_med/pharmacist
	name = "Pharmacy Intern"

	shoes = /obj/item/clothing/shoes/sneakers/medsci

	backpack = /obj/item/storage/backpack/pharmacy
	satchel = /obj/item/storage/backpack/satchel/pharm
	dufflebag = /obj/item/storage/backpack/duffel/pharm
	messengerbag = /obj/item/storage/backpack/messenger/pharm

/obj/outfit/job/intern_med/surgeon
	name = "Resident Surgeon"

	shoes = /obj/item/clothing/shoes/sneakers/medsci

/obj/outfit/job/intern_med/surgeon/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!isskrell(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery(H), slot_head)

/obj/outfit/job/intern_med/psychiatrist
	name = "Resident Psychiatrist"

	shoes = /obj/item/clothing/shoes/sneakers/medsci

	backpack = /obj/item/storage/backpack/psychiatrist
	satchel = /obj/item/storage/backpack/satchel/psych
	dufflebag = /obj/item/storage/backpack/duffel/psych
	messengerbag = /obj/item/storage/backpack/messenger/psych

	tab_pda = /obj/item/modular_computer/handheld/pda/medical/psych
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych
	tablet = /obj/item/modular_computer/handheld/preset/medical/psych
