/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#90524b"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN)
	minimal_access = list(ACCESS_BAR)
	alt_titles = list("Barista")
	outfit = /obj/outfit/job/bartender
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	head = /obj/item/clothing/head/flatcap/bartender
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/storage/bartender

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/bartender
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/bartender
	tablet = /obj/item/modular_computer/handheld/preset/civilian/bartender

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/chef
	title = "Chef"
	flag = CHEF
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#90524b"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN)
	minimal_access = list(ACCESS_KITCHEN)
	alt_titles = list("Cook")
	outfit = /obj/outfit/job/chef
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/chef
	name = "Chef"
	jobtype = /datum/job/chef

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef_jacket/nt
	head = /obj/item/clothing/head/chefhat/nt
	shoes = /obj/item/clothing/shoes/sneakers/black

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	backpack_contents = list(
		/obj/item/storage/box/produce = 1
	)

/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#90524b"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN)
	minimal_access = list(ACCESS_HYDROPONICS)
	outfit = /obj/outfit/job/hydro
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)
	alt_titles = list("Hydroponicist")

/obj/outfit/job/hydro
	name = "Gardener"
	jobtype = /datum/job/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	head = /obj/item/clothing/head/bandana/hydro/nt
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit_store = /obj/item/device/analyzer/plant_analyzer

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack = /obj/item/storage/backpack/hydroponics
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/hyd
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/hyd
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/hyd
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/obj/outfit/job/hydro/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather/unathi(H), slot_gloves)
	else
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather(H), slot_gloves)

/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#90524b"
	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_JANITOR, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_MEDICAL)
	outfit = /obj/outfit/job/janitor
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)


/obj/outfit/job/janitor
	name = "Janitor"
	jobtype = /datum/job/janitor

	uniform = /obj/item/clothing/under/rank/janitor
	head = /obj/item/clothing/head/softcap/nt/custodian
	shoes = /obj/item/clothing/shoes/sneakers/black

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/janitor
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/janitor
	tablet = /obj/item/modular_computer/handheld/preset/civilian/janitor

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#90524b"
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY)
	alt_titles = list("Curator", "Tech Support")
	alt_outfits = list("Curator" = /obj/outfit/job/librarian/curator, "Tech Support" = /obj/outfit/job/librarian/tech_support)
	title_accesses = list("Tech Support" = ACCESS_IT)
	outfit = /obj/outfit/job/librarian

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/librarian
	name = "Librarian"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/librarian
	shoes = /obj/item/clothing/shoes/sneakers/black
	r_pocket = /obj/item/barcodescanner
	l_hand = /obj/item/storage/bag/books

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/librarian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/librarian
	tablet = /obj/item/modular_computer/handheld/preset/civilian/librarian

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/obj/outfit/job/librarian/curator
	name = "Curator"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/suit_jacket
	r_pocket = /obj/item/device/price_scanner
	l_hand = null

/obj/outfit/job/librarian/tech_support
	name = "Tech Support"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	l_pocket = /obj/item/modular_computer/handheld/preset
	r_pocket = /obj/item/card/tech_support
	r_hand = /obj/item/storage/bag/circuits/basic
	l_hand = /obj/item/modular_computer/laptop/preset
	gloves = /obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian

/obj/outfit/job/librarian/tech_support/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		r_hand = null
	else
		r_hand = initial(r_hand)
	return ..()

/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#90524b"
	access = list(ACCESS_CHAPEL_OFFICE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CHAPEL_OFFICE)
	alt_titles = list("Presbyter", "Rabbi", "Imam", "Priest", "Shaman", "Counselor")
	outfit = /obj/outfit/job/chaplain

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/chaplain
	name = "Chaplain"
	jobtype = /datum/job/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	shoes = /obj/item/clothing/shoes/sneakers/black

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/chaplain
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/chaplain
	tablet = /obj/item/modular_computer/handheld/preset/civilian/chaplain

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/obj/outfit/job/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	if(visualsOnly)
		return

	var/obj/item/storage/bible/B = new /obj/item/storage/bible(get_turf(H)) //BS12 EDIT
	var/obj/item/storage/S = locate() in H.contents
	if(S && istype(S))
		B.forceMove(S)

	var/datum/religion/religion = SSrecords.religions[H.religion]
	if (religion)

		if(religion.name == "None" || religion.name == "Other")
			B.verbs += /obj/item/storage/bible/verb/Set_Religion
			return 1

		B.icon_state = religion.book_sprite
		B.name = religion.book_name
		SSticker.Bible_icon_state = religion.book_sprite
		SSticker.Bible_item_state = religion.book_sprite
		SSticker.Bible_name = religion.book_name
		return 1


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
	selection_color = "#967032"
	economic_modifier = 10

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 70,
		SPECIES_SKRELL_AXIORI = 70
	)

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_SHIP_WEAPONS, ACCESS_QM, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_KEYCARD_AUTH, ACCESS_RC_ANNOUNCE, ACCESS_HEADS,
						ACCESS_SEC_DOORS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_ROBOTICS, ACCESS_ENGINE, ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_INTREPID)
	minimal_access = list(ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING, ACCESS_SHIP_WEAPONS, ACCESS_MINING_STATION, ACCESS_KEYCARD_AUTH, ACCESS_RC_ANNOUNCE, ACCESS_HEADS,
						ACCESS_SEC_DOORS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_ROBOTICS, ACCESS_ENGINE, ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_INTREPID)

	outfit = /obj/outfit/job/operations_manager

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/operations_manager
	name = "Operations Manager"
	jobtype = /datum/job/operations_manager

	uniform = /obj/item/clothing/under/rank/operations_manager
	shoes = /obj/item/clothing/shoes/sneakers/brown
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
	selection_color = "#7B431C"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_SHIP_WEAPONS, ACCESS_CARGO_BOT, ACCESS_MINING, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_SHIP_WEAPONS, ACCESS_MAILSORTING)
	outfit = /obj/outfit/job/hangar_tech

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/hangar_tech
	name = "Hangar Technician"
	jobtype = /datum/job/hangar_tech

	uniform = /obj/item/clothing/under/rank/hangar_technician
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/sneakers/brown

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
	selection_color = "#7B431C"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MINING, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING)
	outfit = /obj/outfit/job/mining

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/mining
	name = "Shaft Miner"
	jobtype = /datum/job/mining

	uniform = /obj/item/clothing/under/rank/miner
	id = /obj/item/card/id/silver
	shoes = /obj/item/clothing/shoes/sneakers/black
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
	selection_color = "#7B431C"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MAILSORTING)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MAILSORTING)

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
