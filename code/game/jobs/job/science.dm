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

	minimum_character_age = list(
		SPECIES_HUMAN = 35,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(
		access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks, access_tox_storage,
		access_teleporter, access_sec_doors, access_medical, access_engine, access_ship_weapons, access_construction, access_mining, access_mailsorting, access_research,
		access_xenobiology, access_xenobotany, access_ai_upload, access_tech_storage, access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway,
		access_xenoarch, access_network, access_maint_tunnels, access_it, access_intrepid
	)
	minimal_access = list(
		access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks, access_tox_storage,
		access_teleporter, access_sec_doors, access_medical, access_engine, access_ship_weapons, access_construction, access_mining, access_mailsorting, access_research,
		access_xenobiology, access_xenobotany, access_ai_upload, access_tech_storage, access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway,
		access_xenoarch, access_network, access_maint_tunnels, access_it, access_intrepid
	)
	minimal_player_age = 14
	ideal_character_age = list(
		SPECIES_HUMAN = 50,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)
	outfit = /datum/outfit/job/rd

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK)

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

	backpack = /obj/item/storage/backpack/rd
	satchel = /obj/item/storage/backpack/satchel/rd
	dufflebag = /obj/item/storage/backpack/duffel/rd
	messengerbag = /obj/item/storage/backpack/messenger/rd

/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_tox, access_tox_storage, access_research, access_intrepid)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_intrepid)

	minimal_player_age = 14
	outfit = /datum/outfit/job/scientist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
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
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/tox
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/tox
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/tox
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/xenoarchaeologist
	title = "Xenoarchaeologist"
	flag = XENOARCHEOLOGIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_intrepid)
	minimal_access = list(access_research, access_xenoarch, access_tox, access_tox_storage, access_intrepid)

	minimal_player_age = 14
	outfit = /datum/outfit/job/scientist/xenoarchaeologist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/scientist/xenoarchaeologist
	name = "Xenoarchaeologist"
	jobtype = /datum/job/xenoarchaeologist

	uniform = /obj/item/clothing/under/rank/scientist/xenoarchaeologist

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_tox, access_tox_storage, access_research, access_xenobiology)
	minimal_access = list(access_research, access_xenobiology, access_tox_storage)

	minimal_player_age = 14

	outfit = /datum/outfit/job/scientist/xenobiologist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	jobtype = /datum/job/xenobiologist

	uniform = /obj/item/clothing/under/rank/scientist/xenobio

/datum/job/xenobotanist
	title = "Xenobotanist"
	flag = XENOBOTANIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_tox_storage, access_research, access_xenobotany, access_tox)
	minimal_access = list(access_tox_storage, access_research, access_xenobotany)

	minimal_player_age = 14

	outfit = /datum/outfit/job/scientist/xenobotanist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)


/datum/outfit/job/scientist/xenobotanist
	name = "Xenobotanist"
	jobtype = /datum/job/xenobotanist

	uniform = /obj/item/clothing/under/rank/scientist/botany

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
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/tox
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/tox
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/tox
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	tab_pda = /obj/item/modular_computer/handheld/pda/research
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research
	tablet = /obj/item/modular_computer/handheld/preset/research