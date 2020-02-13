/datum/job/rd
	title = "Research Director"
	flag = RD
	head_position = 1
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#FF40FF"
	economic_modifier = 15

	minimum_character_age = 35

	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_player_age = 0
	ideal_character_age = 50
	outfit = /datum/outfit/job/rd

	blacklisted_species = list("M'sai Tajara", "Zhan-Khazan Tajara", "Aut'akh Unathi", "Vaurca Worker", "Vaurca Warrior")

/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/heads/rd
	pda = /obj/item/device/pda/heads/rd
	id = /obj/item/card/id/navy
	l_hand = /obj/item/clipboard

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox


/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#FFAAFF"
	economic_modifier = 7

	minimum_character_age = 30

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	alt_titles = list("Xenoarcheologist", "Anomalist", "Phoron Researcher")

	minimal_player_age = 0
	outfit = /datum/outfit/job/scientist
	alt_outfits = list("Xenoarcheologist"=/datum/outfit/job/scientist/xenoarcheologist)

/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/science
	l_ear = /obj/item/device/radio/headset/headset_sci
	pda = /obj/item/device/pda/science
	id = /obj/item/card/id/white

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox

/datum/outfit/job/scientist/xenoarcheologist
    name = "Xenoarcheologist"
    uniform = /obj/item/clothing/under/rank/xenoarcheologist

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#FFAAFF"
	economic_modifier = 7

	minimum_character_age = 30

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)
	alt_titles = list("Xenobotanist")

	minimal_player_age = 0

	outfit = /datum/outfit/job/scientist/xenobiologist
	alt_outfits = list("Xenobotanist"=/datum/outfit/job/scientist/xenobiologist/xenobotanist)

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	jobtype = /datum/job/xenobiologist
	pda = /obj/item/device/pda/xenobio

/datum/outfit/job/scientist/xenobiologist/xenobotanist
	name = "Xenobotanist"
	uniform = /obj/item/clothing/under/rank/scientist/botany

/datum/job/roboticist
	title = "Mechanic"
	flag = ROBOTICIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 2
	supervisors = "your shop"
	selection_color = "#FFAAFF"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")

	minimal_player_age = 0

	outfit = /datum/outfit/job/roboticist

/datum/outfit/job/roboticist
	name = "Mechanic"
	jobtype = /datum/job/roboticist

	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/roboticist
	id = /obj/item/card/id/white
	belt = /obj/item/storage/belt/utility

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox

	belt_contents = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

/datum/job/intern_sci
	title = "Lab Assistant"
	flag = INTERN_SCI
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#FFAAFF"
	access = list(access_research, access_tox)
	minimal_access = list(access_research, access_tox)
	outfit = /datum/outfit/job/intern_sci

/datum/outfit/job/intern_sci
	name = "Lab Assistant"
	jobtype = /datum/job/intern_sci

	uniform = /obj/item/clothing/under/rank/scientist/intern
	shoes = /obj/item/clothing/shoes/science
	l_ear = /obj/item/device/radio/headset/headset_sci

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox
