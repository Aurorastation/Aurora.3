/datum/job/supply_manager
	title = "Supply Manager"
	flag = SUPPLY_MANAGER
	departments = list(DEPARTMENT_CARGO = JOBROLE_SUPERVISOR)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#90524b"
	economic_modifier = 5

	minimum_character_age = 22

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_keycard_auth,
					access_heads, access_eva, access_teleporter)
	minimal_access = list(access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_keycard_auth,
					access_heads)

	ideal_character_age = 40

	outfit = /datum/outfit/job/supply_manager

/datum/outfit/job/supply_manager
	name = "Supply Manager"
	jobtype = /datum/job/supply_manager

	uniform = /obj/item/clothing/under/rank/quartermaster
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses

	tab_pda = /obj/item/modular_computer/handheld/pda/supply/qm
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply/qm
	tablet = /obj/item/modular_computer/handheld/preset/supply/qm

	headset = /obj/item/device/radio/headset/qm
	bowman = /obj/item/device/radio/headset/qm/alt
	double_headset = /obj/item/device/radio/headset/alt/double/qm
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo/qm


/datum/job/supply_tech
	title = "Supply Technician"
	flag = SUPPLY_TECH
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the supply manager"
	selection_color = "#90524b"

	minimum_character_age = 18

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_cargo, access_cargo_bot, access_mailsorting)
	outfit = /datum/outfit/job/supply_tech

/datum/outfit/job/supply_tech
	name = "Supply Technician"
	jobtype = /datum/job/supply_tech

	uniform = /obj/item/clothing/under/rank/cargo
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/brown

	tab_pda = /obj/item/modular_computer/handheld/pda/supply
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply
	tablet = /obj/item/modular_computer/handheld/preset/supply

	headset = /obj/item/device/radio/headset/headset_cargo
	bowman = /obj/item/device/radio/headset/headset_cargo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/cargo
	wrist_radio = /obj/item/device/radio/headset/wrist/cargo


/datum/job/prospector
	title = "Prospector"
	flag = PROSPECTOR
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the supply manager"
	selection_color = "#90524b"
	economic_modifier = 5

	minimum_character_age = 18

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	outfit = /datum/outfit/job/prospector

/datum/outfit/job/prospector
	name = "Prospector"
	jobtype = /datum/job/prospector

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
	satchel = /obj/item/storage/backpack/satchel_eng
	dufflebag = /obj/item/storage/backpack/duffel/eng
	messengerbag = /obj/item/storage/backpack/messenger/engi


/datum/job/manufacturing_tech
	title = "Manufacturing Technician"
	flag = MANUFACTURING_TECH
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the supply manager"
	selection_color = "#a44799"
	economic_modifier = 5

	minimum_character_age = 25

	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue)
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research)

	minimal_player_age = 7

	outfit = /datum/outfit/job/roboticist

/datum/outfit/job/roboticist
	name = "Manufacturing Technician"
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
