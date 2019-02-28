/datum/job/rd
	title = "Research Director"
	flag = RD
	head_position = 1
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_player_age = 14
	ideal_character_age = 50
	outfit = /datum/outfit/job/rd

/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/heads/rd
	pda = /obj/item/device/pda/heads/rd
	id = /obj/item/weapon/card/id/silver
	l_hand = /obj/item/weapon/clipboard

	backpack = /obj/item/weapon/storage/backpack/toxins
	satchel = /obj/item/weapon/storage/backpack/satchel_tox
	dufflebag = /obj/item/weapon/storage/backpack/duffel/tox
	messengerbag = /obj/item/weapon/storage/backpack/messenger/tox


/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	alt_titles = list("Xenoarcheologist", "Anomalist", "Phoron Researcher")

	minimal_player_age = 14
	outfit = /datum/outfit/job/scientist

/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/white
	l_ear = /obj/item/device/radio/headset/headset_sci
	pda = /obj/item/device/pda/science

	backpack = /obj/item/weapon/storage/backpack/toxins
	satchel = /obj/item/weapon/storage/backpack/satchel_tox
	dufflebag = /obj/item/weapon/storage/backpack/duffel/tox
	messengerbag = /obj/item/weapon/storage/backpack/messenger/tox

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#ffeeff"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)
	alt_titles = list("Xenobotanist")

	minimal_player_age = 14

	outfit = /datum/outfit/job/scientist/xenobiologist

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	jobtype = /datum/job/xenobiologist

/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#ffeeff"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")

	minimal_player_age = 7

	outfit = /datum/outfit/job/roboticist

/datum/outfit/job/roboticist
	name = "Roboticist"
	jobtype = /datum/job/roboticist

	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_sci
	pda = /obj/item/device/pda/roboticist
	belt = /obj/item/weapon/storage/belt/utility/full

	backpack = /obj/item/weapon/storage/backpack/toxins
	satchel = /obj/item/weapon/storage/backpack/satchel_tox
	dufflebag = /obj/item/weapon/storage/backpack/duffel/tox
	messengerbag = /obj/item/weapon/storage/backpack/messenger/tox