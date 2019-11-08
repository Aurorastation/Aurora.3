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
<<<<<<< HEAD
	selection_color = "#FF56B4"
=======
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
>>>>>>> origin
	economic_modifier = 10

	minimum_character_age = 35

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_paramedic, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce, access_engine, access_construction,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_research,
			access_paramedic, access_maint_tunnels)

	minimal_player_age = 10
	ideal_character_age = 50

	bag_type = /obj/item/weapon/storage/backpack/medic
	satchel_type = /obj/item/weapon/storage/backpack/satchel_med
	duffel_type = /obj/item/weapon/storage/backpack/duffel/med
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/med

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/cmo(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/cmo(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return TRUE

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
<<<<<<< HEAD

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
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda = /obj/item/device/pda/medical
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med

/datum/outfit/job/doctor/emergency_physician
	name = "Emergency Physician"
	jobtype = /datum/job/doctor

	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	mask = /obj/item/clothing/mask/surgical
	l_hand = /obj/item/weapon/storage/firstaid/adv

/datum/outfit/job/doctor/surgeon
	name = "Surgeon"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical/blue
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	head = /obj/item/clothing/head/surgery/blue

/datum/outfit/job/doctor/nurse
	name = "Nurse"
	jobtype = /datum/job/doctor

	uniform = /obj/item/clothing/under/rank/medical/purple
	suit = null
	head = /obj/item/clothing/head/nursehat


/datum/job/pharmacist
	title = "Pharmacist"
=======
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology, access_eva)
	alt_titles = list("Surgeon","Emergency Physician","Nurse","Virologist")

	bag_type = /obj/item/weapon/storage/backpack/medic
	satchel_type = /obj/item/weapon/storage/backpack/satchel_med
	duffel_type = /obj/item/weapon/storage/backpack/duffel/med
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/med


/datum/job/doctor/equip_backpack(var/mob/living/carbon/human/H, var/alt_title)
	if(has_alt_title(H, alt_title,"Virologist"))
		bag_type = /obj/item/weapon/storage/backpack/virology
		satchel_type = /obj/item/weapon/storage/backpack/satchel_vir
		duffel_type = /obj/item/weapon/storage/backpack/duffel/med
		messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/viro
		..()
		bag_type = initial(bag_type)
		satchel_type = initial(satchel_type)
		duffel_type = initial(duffel_type)
		messenger_bag_type = initial(messenger_bag_type)
	else
		..()

/datum/job/doctor/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)
		return FALSE
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)

	if(has_alt_title(H, alt_title,"Emergency Physician"))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	else if(has_alt_title(H, alt_title,"Surgeon"))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	else if(has_alt_title(H, alt_title,"Virologist"))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/device/pda/viro(H), slot_belt)
	else if(has_alt_title(H, alt_title,"Nurse"))
		if(H.gender == FEMALE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	else if(has_alt_title(H, alt_title,"Medical Doctor"))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
	return TRUE



//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
>>>>>>> origin
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#FF97D1"
	economic_modifier = 5
<<<<<<< HEAD

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

	backpack = /obj/item/weapon/storage/backpack/pharmacy
	satchel = /obj/item/weapon/storage/backpack/satchel_pharm
	dufflebag = /obj/item/weapon/storage/backpack/duffel/pharm
	messengerbag = /obj/item/weapon/storage/backpack/messenger/pharm

/datum/outfit/job/pharmacist/biochemist
	name = "Biochemist"
	jobtype = /datum/job/pharmacist

	uniform = /obj/item/clothing/under/rank/biochemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/biochemist

	backpack = /obj/item/weapon/storage/backpack/virology
	satchel = /obj/item/weapon/storage/backpack/satchel_vir
	dufflebag = /obj/item/weapon/storage/backpack/duffel/vir
	messengerbag = /obj/item/weapon/storage/backpack/messenger/viro
=======
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	alt_titles = list("Pharmacist")

	bag_type = /obj/item/weapon/storage/backpack/chemistry
	satchel_type = /obj/item/weapon/storage/backpack/satchel_chem
	duffel_type = /obj/item/weapon/storage/backpack/duffel/chem
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/chem

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chemist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/chemist(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(H), slot_wear_suit)
		return TRUE
>>>>>>> origin

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
<<<<<<< HEAD
	selection_color = "#FF97D1"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics, access_psychiatrist)
=======
	selection_color = "#ffeef0"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
>>>>>>> origin
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist")

	equip(var/mob/living/carbon/human/H, var/alt_title)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		if(has_alt_title(H, alt_title,"Psychiatrist"))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/psych(H), slot_w_uniform)
		else if(has_alt_title(H, alt_title,"Psychologist"))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/psych/turtleneck(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)

		return TRUE


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
<<<<<<< HEAD

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
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_hand = /obj/item/weapon/reagent_containers/hypospray
	belt = /obj/item/weapon/storage/belt/medical/emt
	pda =  /obj/item/device/pda/medical

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med

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

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med
=======
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_paramedic)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks, access_paramedic)
	alt_titles = list("Emergency Medical Technician")

	bag_type = /obj/item/weapon/storage/backpack/medic
	satchel_type = /obj/item/weapon/storage/backpack/satchel_med
	duffel_type = /obj/item/weapon/storage/backpack/duffel/med
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/med

	equip(var/mob/living/carbon/human/H, var/alt_title)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		if(has_alt_title(H, alt_title,"Emergency Medical Technician"))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/paramedic(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
		else if(has_alt_title(H, alt_title,"Paramedic"))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/black(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical/emt(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_l_store)
		return TRUE

	equip_survival(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.species.equip_survival_gear(H,1)
		return TRUE
>>>>>>> origin
