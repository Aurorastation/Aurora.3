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
	outfit = /datum/outfit/job/intern_sec

/datum/outfit/job/intern_sec
	name = "Security Cadet"
	jobtype = /datum/job/intern_sec

	uniform = /obj/item/clothing/under/rank/security2
	head = /obj/item/clothing/head/beret/sec
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/headset_sec
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/weapon/storage/backpack/security
	satchel = /obj/item/weapon/storage/backpack/satchel_sec
	dufflebag = /obj/item/weapon/storage/backpack/duffel/sec
	messengerbag = /obj/item/weapon/storage/backpack/messenger/sec

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
	outfit = /datum/outfit/job/intern_med

/datum/outfit/job/intern_med
	name = "Medical Resident"
	jobtype = /datum/job/intern_med

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/white
	l_ear = /obj/item/device/radio/headset/headset_med

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med

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
	outfit = /datum/outfit/job/intern_sci

/datum/outfit/job/intern_sci
	name = "Lab Assistant"
	jobtype = /datum/job/intern_sci

	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	l_ear = /obj/item/device/radio/headset/headset_sci

	backpack = /obj/item/weapon/storage/backpack/toxins
	satchel = /obj/item/weapon/storage/backpack/satchel_tox
	dufflebag = /obj/item/weapon/storage/backpack/duffel/tox
	messengerbag = /obj/item/weapon/storage/backpack/messenger/tox

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
