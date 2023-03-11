//Operations
/datum/job/operations_manager
	title = "Operations Manager"
	flag = OPERATIONS_MANAGER
	departments = list(DEPARTMENT_CARGO = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#78430D"
	economic_modifier = 10

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 70,
		SPECIES_SKRELL_AXIORI = 70
	)

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_ship_weapons, access_qm, access_mining, access_mining_station, access_keycard_auth, access_RC_announce, access_heads,
						access_sec_doors, access_research, access_medical, access_robotics, access_engine, access_teleporter, access_eva, access_intrepid)
	minimal_access = list(access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_ship_weapons, access_mining_station, access_keycard_auth, access_RC_announce, access_heads,
						access_sec_doors, access_research, access_medical, access_robotics, access_engine, access_teleporter, access_eva, access_intrepid)

	ideal_character_age = list(
		SPECIES_HUMAN = 40,
		SPECIES_SKRELL = 90,
		SPECIES_SKRELL_AXIORI = 90
	)

	outfit = /datum/outfit/job/operations_manager

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/operations_manager
	name = "Operations Manager"
	jobtype = /datum/job/operations_manager

	uniform = /obj/item/clothing/under/rank/operations_manager
	shoes = /obj/item/clothing/shoes/brown
	id = /obj/item/card/id/navy
	l_hand = /obj/item/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses

	tab_pda = /obj/item/modular_computer/handheld/pda/supply/om
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply/om
	tablet = /obj/item/modular_computer/handheld/preset/supply/om

	headset = /obj/item/device/radio/headset/operations_manager
	bowman = /obj/item/device/radio/headset/operations_manager/alt
	double_headset = /obj/item/device/radio/headset/alt/double/operations_manager
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo/operations_manager

	backpack = /obj/item/storage/backpack/om
	satchel = /obj/item/storage/backpack/satchel/om
	dufflebag = /obj/item/storage/backpack/duffel/om
	messengerbag = /obj/item/storage/backpack/messenger/om


/datum/job/hangar_tech
	title = "Hangar Technician"
	flag = CARGOTECH
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the operations manager"
	selection_color = "#5F350B"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_ship_weapons, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_cargo, access_cargo_bot, access_ship_weapons, access_mailsorting)
	outfit = /datum/outfit/job/hangar_tech

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/hangar_tech
	name = "Hangar Technician"
	jobtype = /datum/job/hangar_tech

	uniform = /obj/item/clothing/under/rank/hangar_technician
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/brown

	tab_pda = /obj/item/modular_computer/handheld/pda/supply
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply
	tablet = /obj/item/modular_computer/handheld/preset/supply

	headset = /obj/item/device/radio/headset/headset_cargo
	bowman = /obj/item/device/radio/headset/headset_cargo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/cargo
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the operations manager"
	selection_color = "#5F350B"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	outfit = /datum/outfit/job/mining

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/mining
	name = "Shaft Miner"
	jobtype = /datum/job/mining

	uniform = /obj/item/clothing/under/rank/miner
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/black
	l_hand = /obj/item/coin/mining

	tab_pda = /obj/item/modular_computer/handheld/pda/supply/miner
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply/miner
	tablet = /obj/item/modular_computer/handheld/preset/civilian

	headset = /obj/item/device/radio/headset/headset_mining
	bowman = /obj/item/device/radio/headset/headset_mining/alt
	double_headset = /obj/item/device/radio/headset/alt/double/mining
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo/mining

	backpack_contents = list(
		/obj/item/storage/bag/ore = 1
	)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi


/datum/job/machinist
	title = "Machinist"
	flag = ROBOTICIST
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the operations manager"
	selection_color = "#5F350B"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(access_robotics, access_tech_storage, access_mailsorting)
	minimal_access = list(access_robotics, access_tech_storage, access_mailsorting)

	minimal_player_age = 7

	outfit = /datum/outfit/job/machinist

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/machinist
	name = "Machinist"
	jobtype = /datum/job/machinist

	uniform = /obj/item/clothing/under/rank/machinist
	suit = /obj/item/clothing/suit/storage/machinist
	shoes = /obj/item/clothing/shoes/black
	id = /obj/item/card/id/silver
	belt = /obj/item/storage/belt/utility

	tab_pda = /obj/item/modular_computer/handheld/pda/supply/machinist
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply/machinist
	tablet = /obj/item/modular_computer/handheld/preset/supply/machinist

	headset = /obj/item/device/radio/headset/headset_cargo
	bowman = /obj/item/device/radio/headset/headset_cargo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/cargo
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo

	belt_contents = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)
