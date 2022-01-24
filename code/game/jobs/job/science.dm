/datum/job/rd
	title = "Research Director"
	flag = RD
	departments = list(DEPARTMENT_SCIENCE = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#a44799"
	economic_modifier = 15

	minimum_character_age = 35

	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network,
			            access_maint_tunnels, access_it)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network,
			            access_maint_tunnels, access_it)
	minimal_player_age = 14
	ideal_character_age = 50
	outfit = /datum/outfit/job/rd

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/brown
	id = /obj/item/card/id/navy
	l_hand = /obj/item/clipboard

	headset = /obj/item/device/radio/headset/heads/rd
	bowman = /obj/item/device/radio/headset/heads/rd/alt
	double_headset = /obj/item/device/radio/headset/alt/double/rd
	wrist_radio = /obj/item/device/radio/headset/wrist/rd

	tab_pda = /obj/item/modular_computer/handheld/pda/research/rd
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research/rd
	tablet = /obj/item/modular_computer/handheld/preset/research/rd

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox


/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = 30

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	alt_titles = list("Xenoarcheologist", "Anomalist", "Phoron Researcher")

	minimal_player_age = 14
	outfit = /datum/outfit/job/scientist
	alt_outfits = list("Xenoarcheologist"=/datum/outfit/job/scientist/xenoarcheologist)
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/science
	id = /obj/item/card/id/white

	headset = /obj/item/device/radio/headset/headset_sci
	bowman = /obj/item/device/radio/headset/headset_sci/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sci
	wrist_radio = /obj/item/device/radio/headset/wrist/sci

	tab_pda = /obj/item/modular_computer/handheld/pda/research
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research
	tablet = /obj/item/modular_computer/handheld/preset/research

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
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = 30

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology)
	minimal_access = list(access_research, access_xenobiology, access_tox_storage)
	alt_titles = list("Xenobotanist")

	minimal_player_age = 14

	outfit = /datum/outfit/job/scientist/xenobiologist
	alt_outfits = list("Xenobotanist"=/datum/outfit/job/scientist/xenobiologist/xenobotanist)
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	jobtype = /datum/job/xenobiologist
	tab_pda = /obj/item/modular_computer/handheld/pda/research

/datum/outfit/job/scientist/xenobiologist/xenobotanist
	name = "Xenobotanist"
	uniform = /obj/item/clothing/under/rank/scientist/botany

/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#a44799"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.

	minimal_player_age = 7

	outfit = /datum/outfit/job/roboticist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/roboticist
	name = "Roboticist"
	jobtype = /datum/job/roboticist

	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/black
	id = /obj/item/card/id/white
	belt = /obj/item/storage/belt/utility

	headset = /obj/item/device/radio/headset/headset_sci
	bowman = /obj/item/device/radio/headset/headset_sci/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sci
	wrist_radio = /obj/item/device/radio/headset/wrist/sci

	tab_pda = /obj/item/modular_computer/handheld/pda/research/robotics
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/advanced/research/robotics
	tablet = /obj/item/modular_computer/handheld/preset/research/robotics

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
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Research Director"
	selection_color = "#a44799"
	access = list(access_research, access_tox)
	minimal_access = list(access_research, access_tox)
	outfit = /datum/outfit/job/intern_sci
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/intern_sci
	name = "Lab Assistant"
	jobtype = /datum/job/intern_sci

	uniform = /obj/item/clothing/under/rank/scientist/intern
	shoes = /obj/item/clothing/shoes/science
	headset = /obj/item/device/radio/headset/headset_sci
	bowman = /obj/item/device/radio/headset/headset_sci/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sci
	wrist_radio = /obj/item/device/radio/headset/wrist/sci

	backpack = /obj/item/storage/backpack/toxins
	satchel = /obj/item/storage/backpack/satchel_tox
	dufflebag = /obj/item/storage/backpack/duffel/tox
	messengerbag = /obj/item/storage/backpack/messenger/tox

	tab_pda = /obj/item/modular_computer/handheld/pda/research
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research
	tablet = /obj/item/modular_computer/handheld/preset/research
