/datum/job/machinist
	title = "Machinist"
	flag = ROBOTICIST
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials"
	selection_color = "#949494"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE)

	minimal_player_age = 7

	outfit = /obj/outfit/job/machinist

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/machinist
	name = "Machinist"
	jobtype = /datum/job/machinist

	uniform = /obj/item/clothing/under/rank/machinist
	suit = /obj/item/clothing/suit/storage/machinist
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id/silver
	belt = /obj/item/storage/belt/utility

	tab_pda = /obj/item/modular_computer/handheld/pda/supply/machinist
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/supply/machinist
	tablet = /obj/item/modular_computer/handheld/preset/supply/machinist

	headset = /obj/item/device/radio/headset/headset_medsci
	bowman = /obj/item/device/radio/headset/headset_medsci/alt
	double_headset = /obj/item/device/radio/headset/alt/double/medsci
	wrist_radio = /obj/item/device/radio/headset/wrist/medsci
	clipon_radio = /obj/item/device/radio/headset/wrist/clip/medsci

	belt_contents = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/powerdrill = 1
	)

/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	intro_prefix = "an"
	supervisors = "absolutely everyone"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /obj/outfit/job/assistant
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/job/assistant/get_access(selected_title)
	if(GLOB.config.assistant_maint && selected_title == "Assistant")
		return list(ACCESS_MAINT_TUNNELS)
	else
		return list()

/obj/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/visitor
	title = "Off-Duty Crew Member"
	flag = VISITOR
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /obj/outfit/job/visitor
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/visitor
	name = "Off-Duty Crew Member"
	jobtype = /datum/job/visitor

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/sneakers/black

/obj/outfit/job/visitor/passenger
	name = "Passenger"
	jobtype = /datum/job/passenger

/datum/job/passenger
	title = "Passenger"
	flag = PASSENGER
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /obj/outfit/job/visitor/passenger
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)
