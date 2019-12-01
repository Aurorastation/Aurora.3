/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	head_position = 1
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#FF56B4"
	economic_modifier = 10

	minimum_character_age = 35

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_paramedic, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_pharmacy, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_paramedic, access_maint_tunnels)

	minimal_player_age = 10
	ideal_character_age = 50
	outfit = /datum/outfit/job/cmo

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	suit_store = /obj/item/device/flashlight/pen
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/heads/cmo
	pda = /obj/item/device/pda/heads/cmo
	id = /obj/item/card/id/navy
	l_hand = /obj/item/storage/firstaid/adv

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/job/doctor
	title = "Medical Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
	economic_modifier = 7

	minimum_character_age = 30

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_genetics, access_eva)
	alt_titles = list("Surgeon","Emergency Physician","Nurse")
	alt_ages = list("Nurse" = 25)
	outfit = /datum/outfit/job/doctor
	alt_outfits = list(
		"Emergency Physician"=/datum/outfit/job/doctor/emergency_physician,
		"Surgeon"=/datum/outfit/job/doctor/surgeon,
		"Nurse"=/datum/outfit/job/doctor/nurse
		)

/datum/outfit/job/doctor
	name = "Medical Doctor"
	base_name = "Medical Doctor"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/medical
	shoes = /obj/item/clothing/shoes/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda = /obj/item/device/pda/medical
	id = /obj/item/card/id/white
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/outfit/job/doctor/emergency_physician
	name = "Emergency Physician"
	jobtype = /datum/job/doctor

	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	mask = /obj/item/clothing/mask/surgical
	l_hand = /obj/item/storage/firstaid/adv

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
	department = "Medical"
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
	alt_titles = list("Biochemist")
	outfit = /datum/outfit/job/pharmacist
	alt_outfits = list(
		"Biochemist"=/datum/outfit/job/pharmacist/biochemist
		)

/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/pharmacist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/pharmacist
	shoes = /obj/item/clothing/shoes/chemist
	l_ear = /obj/item/device/radio/headset/headset_med
	pda =  /obj/item/device/pda/chemist
	id = /obj/item/card/id/white

	backpack = /obj/item/storage/backpack/pharmacy
	satchel = /obj/item/storage/backpack/satchel_pharm
	dufflebag = /obj/item/storage/backpack/duffel/pharm
	messengerbag = /obj/item/storage/backpack/messenger/pharm

/datum/outfit/job/pharmacist/biochemist
	name = "Biochemist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/biochemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/biochemist
	shoes = /obj/item/clothing/shoes/biochem

	backpack = /obj/item/storage/backpack/virology
	satchel = /obj/item/storage/backpack/satchel_vir
	dufflebag = /obj/item/storage/backpack/duffel/vir
	messengerbag = /obj/item/storage/backpack/messenger/viro

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
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
	pda =  /obj/item/device/pda/psych
	id = /obj/item/card/id/white

/datum/outfit/job/psychiatrist/psycho
	name = "Psychologist"
	jobtype = /datum/job/psychiatrist

	uniform = /obj/item/clothing/under/rank/psych/turtleneck


/datum/job/paramedic
	title = "Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
	economic_modifier = 4

	minimum_character_age = 24
	alt_ages = list("Emergency Medical Technician" = 20)

	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_paramedic)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_paramedic)
	alt_titles = list("Emergency Medical Technician")
	outfit = /datum/outfit/job/paramedic
	alt_outfits = list("Emergency Medical Technician"=/datum/outfit/job/paramedic/emt)

/datum/outfit/job/paramedic
	name = "Paramedic"
	base_name = "Paramedic"
	jobtype = /datum/job/paramedic

	uniform = /obj/item/clothing/under/rank/medical/black
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/headset_med
	l_hand = /obj/item/storage/firstaid/adv
	r_hand = /obj/item/reagent_containers/hypospray
	belt = /obj/item/storage/belt/medical/emt
	pda =  /obj/item/device/pda/paramedic
	id = /obj/item/card/id/white
	head = /obj/item/clothing/head/hardhat/emt

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med

/datum/outfit/job/paramedic/emt
	name = "Emergency Medical Technician"
	jobtype = /datum/job/paramedic

	uniform = /obj/item/clothing/under/rank/medical/paramedic

/datum/job/intern_med
	title = "Medical Resident"
	flag = INTERN_MED
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#FF97D1"
	access = list(access_medical, access_surgery, access_medical_equip)
	minimal_access = list(access_medical, access_surgery, access_medical_equip)
	minimum_character_age = 25
	alt_titles = list("Medical Intern")
	alt_ages = list("Medical Intern" = 18)
	outfit = /datum/outfit/job/intern_med

/datum/outfit/job/intern_med
	name = "Medical Resident"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical/intern
	shoes = /obj/item/clothing/shoes/medical
	l_ear = /obj/item/device/radio/headset/headset_med

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel_med
	dufflebag = /obj/item/storage/backpack/duffel/med
	messengerbag = /obj/item/storage/backpack/messenger/med
