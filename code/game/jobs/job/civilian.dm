//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	alt_titles = list("Barista")
	outfit = /datum/outfit/job/bartender

/datum/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	uniform = /obj/item/clothing/under/rank/bartender
	pda = /obj/item/device/pda/bar
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service


/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	outfit = /datum/outfit/job/chef

/datum/outfit/job/chef
	name = "Chef"
	jobtype = /datum/job/chef

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	pda = /obj/item/device/pda/chef
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service

	backpack_contents = list(
		/obj/item/weapon/storage/box/produce = 1
	)

/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")
	outfit = /datum/outfit/job/hydro

/datum/outfit/job/hydro
	name = "Gardener"
	jobtype = /datum/job/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/apron
	pda = /obj/item/device/pda/botanist
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service
	suit_store = /obj/item/device/analyzer/plant_analyzer

	backpack = /obj/item/weapon/storage/backpack/hydroponics
	satchel = /obj/item/weapon/storage/backpack/satchel_hyd
	dufflebag = /obj/item/weapon/storage/backpack/duffel/hyd
	messengerbag = /obj/item/weapon/storage/backpack/messenger/hyd

/datum/outfit/job/hydro/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather/unathi(H), slot_gloves)
	else
		H.equip_or_collect(new /obj/item/clothing/gloves/botanic_leather(H), slot_gloves)

//Cargo
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	head_position = 1
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

	ideal_character_age = 40

	outfit = /datum/outfit/job/qm

/datum/outfit/job/qm
	name = "Quartermaster"
	jobtype = /datum/job/qm

	uniform = /obj/item/clothing/under/rank/cargo
	pda = /obj/item/device/pda/quartermaster
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/headset_cargo
	l_hand = /obj/item/weapon/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses


/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	outfit = /datum/outfit/job/cargo_tech

/datum/outfit/job/cargo_tech
	name = "Cargo Technician"
	jobtype = /datum/job/cargo_tech

	uniform = /obj/item/clothing/under/rank/cargotech
	pda = /obj/item/device/pda/cargo
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/headset_cargo


/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	outfit = /datum/outfit/job/mining

/datum/outfit/job/mining
	name = "Shaft Miner"
	jobtype = /datum/job/mining

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_cargo

	backpack_contents = list(
		/obj/item/weapon/crowbar = 1,
		/obj/item/weapon/storage/bag/ore = 1
	)

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/duffel/eng
	messengerbag = /obj/item/weapon/storage/backpack/messenger/engi


//Not engineers, just the mop boys
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical)
	minimal_access = list(access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical)
	outfit = /datum/outfit/job/janitor

/datum/outfit/job/janitor
	name = "Janitor"
	jobtype = /datum/job/janitor

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service

/datum/job/journalist
	title = "Corporate Reporter"
	flag = JOURNALIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_journalist, access_maint_tunnels)
	minimal_access = list(access_journalist, access_maint_tunnels)
	alt_titles = list("Freelance Journalist")
	alt_outfits = list("Freelance Journalist" = /datum/outfit/job/journalistf)
	title_accesses = list("Corporate Reporter" = list(access_medical, access_sec_doors, access_research, access_engine))
	outfit = /datum/outfit/job/journalist

/datum/outfit/job/journalist
	name = "Corporate Reporter"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	pda = /obj/item/device/pda/librarian
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press = 1
	)

/datum/outfit/job/journalistf
	name = "Freelance Journalist"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	pda = /obj/item/device/pda/librarian
	shoes = /obj/item/clothing/shoes/black

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press/independent = 1
	)


/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)
	outfit = /datum/outfit/job/librarian

/datum/outfit/job/librarian
	name = "Librarian"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/suit_jacket/red
	pda = /obj/item/device/pda/librarian
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/headset_service
	r_pocket = /obj/item/weapon/barcodescanner
	l_hand = /obj/item/weapon/storage/bag/books


/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#dddddd"
	economic_modifier = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	outfit = /datum/outfit/job/iaa

/datum/outfit/job/iaa
	name = "Internal Affairs Agent"
	jobtype = /datum/job/lawyer

	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs
	pda = /obj/item/device/pda/lawyer
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_ear = /obj/item/device/radio/headset/ia

	l_hand =  /obj/item/weapon/storage/briefcase

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

/datum/job/comedian
	title = "Entertainer"
	flag = CLOWN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#fe019a"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	alt_titles = list("Clown")
	alt_outfits = list("Clown" = /datum/outfit/job/clown)
	title_accesses = list("Clown" = list(access_clown), "Entertainer" = list(access_medical, access_sec_doors, access_research, access_engine))
	outfit = /datum/outfit/job/entertainer

/datum/outfit/job/entertainer
	name = "Entertainer"
	jobtype = /datum/job/comedian

	uniform = /obj/item/clothing/under/lightblue
	pda = /obj/item/device/pda/mime
	l_ear = /obj/item/device/radio/headset/headset_service

/datum/outfit/job/clown
	name = "Clown"
	jobtype = /datum/job/comedian

	uniform = /obj/item/clothing/under/rank/clown
	pda = /obj/item/device/pda/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	l_ear = /obj/item/device/radio/headset/headset_service
	back = /obj/item/weapon/storage/backpack/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	gloves = /obj/item/clothing/gloves/white

	backpack_contents = list(
		/obj/item/weapon/stamp/clown = 1,
		/obj/item/weapon/bananapeel = 1,
		/obj/item/weapon/bikehorn = 1
	)