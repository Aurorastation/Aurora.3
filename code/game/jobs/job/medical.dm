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
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	economic_modifier = 10
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
	selection_color = "#ffeef0"
	economic_modifier = 7
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
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 5
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

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
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
	selection_color = "#ffeef0"
	economic_modifier = 4
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
