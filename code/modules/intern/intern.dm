/datum/job/intern_sec
	title = "Security Cadet"
	flag = INTERN_SEC
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Security"
	selection_color = "#ffeeee"
	access = list(access_security, access_sec_doors, access_maint_tunnels)
	minimal_access = list(access_security, access_sec_doors, access_maint_tunnels)

	bag_type = /obj/item/weapon/storage/backpack/security
	satchel_type = /obj/item/weapon/storage/backpack/satchel_sec
	duffel_type = /obj/item/weapon/storage/backpack/duffel/sec
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/sec

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security2(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec(H), slot_head)
		return 1

/datum/job/intern_med
	title = "Medical Resident"
	flag = INTERN_MED
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"
	access = list(access_medical, access_surgery, access_medical_equip)
	minimal_access = list(access_medical, access_surgery, access_medical_equip)
	alt_titles = list("Medical Intern")

	bag_type = /obj/item/weapon/storage/backpack/medic
	satchel_type = /obj/item/weapon/storage/backpack/satchel_med
	duffel_type = /obj/item/weapon/storage/backpack/duffel/med
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/med

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		return 1

/datum/job/intern_sci
	title = "Lab Assistant"
	flag = INTERN_SCI
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#ffeeff"
	access = list(access_research, access_tox)
	minimal_access = list(access_research, access_tox)

	bag_type = /obj/item/weapon/storage/backpack/toxins
	satchel_type = /obj/item/weapon/storage/backpack/satchel_tox
	duffel_type = /obj/item/weapon/storage/backpack/duffel/tox
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/tox

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
		return 1

/datum/job/intern_eng
	title = "Engineering Apprentice"
	flag = INTERN_ENG
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer"
	selection_color = "#fff5cc"
	access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)
	minimal_access = list(access_maint_tunnels, access_construction, access_engine_equip, access_engine)

	bag_type = /obj/item/weapon/storage/backpack/industrial
	satchel_type = /obj/item/weapon/storage/backpack/satchel_eng
	duffel_type = /obj/item/weapon/storage/backpack/duffel/eng
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/engi

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/engineering(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		return 1
