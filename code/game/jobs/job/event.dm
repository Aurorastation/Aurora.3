//Generic department roles for events where organization may be required.
/datum/job/eventsec
	title = "Security Personnel"
	flag = EVENTSEC
	departments = SIMPLEDEPT(DEPARTMENT_SECURITY)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the head of security"
	selection_color = "#991818"
	economic_modifier = 4

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_SECURITY, ACCESS_EVA, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_WEAPONS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_EVA, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_WEAPONS)
	minimal_player_age = 7
	outfit = /obj/outfit/job/officer/event

	blacklisted_species = list(SPECIES_IPC_ZENGHU, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_XION_REMOTE, SPECIES_VAURCA_BULWARK, SPECIES_DIONA_COEUS, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/officer/event
	name = "Security Personnel"
	suit = /obj/item/clothing/suit/armor/carrier/officer
	head = /obj/item/clothing/head/helmet/security
	glasses = /obj/item/clothing/glasses/hud/security
	species_head = list(
		SPECIES_SKRELL = /obj/item/clothing/head/helmet/security/skrell,
		SPECIES_SKRELL_AXIORI = /obj/item/clothing/head/helmet/security/skrell
	)
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/projectile/sec = 1
	)
	belt = /obj/item/storage/belt/security/full/disruptor


/datum/job/eventmed
	title = "Medical Personnel"
	flag = EVENTMED
	departments = SIMPLEDEPT(DEPARTMENT_MEDICAL)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the chief medical officer"
	selection_color = "#15903a"
	economic_modifier = 4

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_VIROLOGY, ACCESS_EVA, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_PSYCHIATRIST, ACCESS_PARAMEDIC)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_EVA, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_PARAMEDIC)
	outfit = /obj/outfit/job/med_tech/event

	blacklisted_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC_G2, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/med_tech/event
	name = "Medical Personnel"
	belt = /obj/item/storage/belt/medical/paramedic
	belt_contents = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/device/healthanalyzer = 1
	)
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	r_ear = /obj/item/device/flashlight/pen
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/latex/nitrile/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/gloves/latex/nitrile/vaurca,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/gloves/latex/nitrile/vaurca,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/gloves/latex/nitrile/vaurca
	)

/datum/job/eventeng
	title = "Engineering Personnel"
	flag = EVENTENG
	departments = SIMPLEDEPT(DEPARTMENT_ENGINEERING)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the chief engineer"
	selection_color = "#c67519"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_SHIP_WEAPONS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_LEVIATHAN)
	minimal_access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_SHIP_WEAPONS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_LEVIATHAN)
	outfit = /obj/outfit/job/engineer/event

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/engineer/event
	name = "Engineering Personnel"
	glasses = /obj/item/clothing/glasses/welding
	gloves = /obj/item/clothing/gloves/yellow
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu,
		SPECIES_TAJARA = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_VAURCA_WARRIOR = null,
		SPECIES_VAURCA_ATTENDANT = null,
		SPECIES_VAURCA_WORKER = null,
		SPECIES_VAURCA_BULWARK = null
	)
	belt_contents = list(
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1,
		/obj/item/weldingtool/largetank = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/device/multitool = 1,
		/obj/item/hammer = 1
	)

/datum/job/eventsci
	title = "Science Personnel"
	flag = EVENTSCI
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_INTREPID)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_INTREPID)

	minimal_player_age = 14
	outfit = /obj/outfit/job/scientist/event
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/scientist/event
	name = "Research Personnel"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/device/camera = 1,
		/obj/item/device/camera_film = 2,
		/obj/item/device/taperecorder = 1
	)
	belt = /obj/item/storage/belt/archaeology/full

/datum/job/eventops
	title = "Operations Personnel"
	flag = EVENTOPS
	departments = SIMPLEDEPT(DEPARTMENT_CARGO)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the operations manager"
	selection_color = "#7B431C"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_SHIP_WEAPONS, ACCESS_CARGO_BOT, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_ROBOTICS)
	minimal_access = list(ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_SHIP_WEAPONS, ACCESS_MAILSORTING)
	outfit = /obj/outfit/job/hangar_tech/event

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/hangar_tech/event
	name = "Operations Personnel"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/stack/nanopaste = 1,
		/obj/item/modular_computer/handheld/preset/supply/cargo_delivery = 1
	)
	belt = /obj/item/storage/belt/utility/full

/datum/job/eventsrv
	title = "Service Personnel"
	flag = EVENTSRV
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = EVENTDEPT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the executive officer"
	selection_color = "#90524b"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN)
	outfit = /obj/outfit/job/bartender
