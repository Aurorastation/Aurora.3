/datum/job/xo
	title = "Executive Officer"
	flag = XO
	departments = list(DEPARTMENT_SERVICE = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#90BA58"
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = list(
		SPECIES_HUMAN = 50,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	outfit = /datum/outfit/job/xo

	access = list(access_sec_doors, access_medical, access_engine, access_ship_weapons, access_change_ids, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction,
			            access_crematorium, access_kitchen, access_hydroponics,access_chapel_office, access_library, access_research, access_mining, access_mailsorting,
			            access_janitor, access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_weapons, access_journalist, access_bridge_crew, access_intrepid, access_teleporter)
	minimal_access = list(access_sec_doors, access_medical, access_ship_weapons, access_engine, access_change_ids, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction,
			            access_crematorium, access_kitchen, access_hydroponics, access_chapel_office, access_library, access_research, access_mining, access_mailsorting,
			            access_janitor,   access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_weapons, access_journalist, access_bridge_crew, access_intrepid, access_teleporter)

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/xo
	name = "Executive Officer"
	jobtype = /datum/job/xo

	head = /obj/item/clothing/head/caphat/xo
	uniform = /obj/item/clothing/under/rank/xo
	shoes = /obj/item/clothing/shoes/laceup/brown
	id = /obj/item/card/id/navy

	headset = /obj/item/device/radio/headset/heads/xo
	bowman = /obj/item/device/radio/headset/heads/xo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/xo
	wrist_radio = /obj/item/device/radio/headset/wrist/xo

	tab_pda = /obj/item/modular_computer/handheld/pda/command/xo
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/command/xo
	tablet = /obj/item/modular_computer/handheld/preset/command/xo

	backpack_contents = list(
		/obj/item/storage/box/ids = 1
	)

	messengerbag = /obj/item/storage/backpack/messenger/com

/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#83A35D"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	alt_titles = list("Barista")
	outfit = /datum/outfit/job/bartender
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	head = /obj/item/clothing/head/flatcap/bartender
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/black
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
	selection_color = "#83A35D"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	outfit = /datum/outfit/job/chef
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/chef
	name = "Chef"
	jobtype = /datum/job/chef

	uniform = /obj/item/clothing/under/rank/chef/nt
	suit = /obj/item/clothing/suit/chef_jacket/nt
	head = /obj/item/clothing/head/chefhat/nt
	shoes = /obj/item/clothing/shoes/black

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
	selection_color = "#83A35D"

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	outfit = /datum/outfit/job/hydro
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)
	alt_titles = list("Hydroponicist")

/datum/outfit/job/hydro
	name = "Gardener"
	jobtype = /datum/job/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	head = /obj/item/clothing/head/bandana/hydro/nt
	shoes = /obj/item/clothing/shoes/black
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

/datum/outfit/job/hydro/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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
	selection_color = "#83A35D"
	access = list(access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical)
	minimal_access = list(access_janitor, access_engine, access_research, access_sec_doors, access_medical)
	outfit = /datum/outfit/job/janitor
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)


/datum/outfit/job/janitor
	name = "Janitor"
	jobtype = /datum/job/janitor

	uniform = /obj/item/clothing/under/rank/janitor
	head = /obj/item/clothing/head/softcap/nt/custodian
	shoes = /obj/item/clothing/shoes/black

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

/datum/job/journalist
	title = "Corporate Reporter"
	flag = JOURNALIST
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#83A35D"

	minimum_character_age = list(
		SPECIES_HUMAN = 20,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_journalist, access_maint_tunnels)
	minimal_access = list(access_journalist, access_maint_tunnels)
	alt_titles = list("Freelance Journalist")
	alt_outfits = list("Freelance Journalist" = /datum/outfit/job/journalistf)
	title_accesses = list("Corporate Reporter" = list(access_medical, access_sec_doors, access_research, access_engine))
	outfit = /datum/outfit/job/journalist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/journalist
	name = "Corporate Reporter"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	shoes = /obj/item/clothing/shoes/black

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

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press = 1
	)

/datum/outfit/job/journalistf
	name = "Freelance Journalist"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	shoes = /obj/item/clothing/shoes/black

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/librarian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/librarian
	tablet = /obj/item/modular_computer/handheld/preset/civilian/librarian

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press/independent = 1
	)


/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	departments = SIMPLEDEPT(DEPARTMENT_SERVICE)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#83A35D"
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)
	alt_titles = list("Curator", "Tech Support")
	alt_outfits = list("Curator" = /datum/outfit/job/librarian/curator, "Tech Support" = /datum/outfit/job/librarian/tech_support)
	title_accesses = list("Tech Support" = access_it)
	outfit = /datum/outfit/job/librarian

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/librarian
	name = "Librarian"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/librarian
	shoes = /obj/item/clothing/shoes/black
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

/datum/outfit/job/librarian/curator
	name = "Curator"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/suit_jacket
	r_pocket = /obj/item/device/price_scanner
	l_hand = null

/datum/outfit/job/librarian/tech_support
	name = "Tech Support"
	jobtype = /datum/job/librarian

	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	l_pocket = /obj/item/modular_computer/handheld/preset
	r_pocket = /obj/item/card/tech_support
	r_hand = /obj/item/storage/bag/circuits/basic
	l_hand = /obj/item/modular_computer/laptop/preset
	gloves = /obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian

/datum/outfit/job/librarian/tech_support/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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
	selection_color = "#83A35D"
	access = list(access_chapel_office, access_maint_tunnels)
	minimal_access = list(access_chapel_office)
	alt_titles = list("Presbyter", "Rabbi", "Imam", "Priest", "Shaman", "Counselor")
	outfit = /datum/outfit/job/chaplain

	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/outfit/job/chaplain
	name = "Chaplain"
	jobtype = /datum/job/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	shoes = /obj/item/clothing/shoes/black

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

/datum/outfit/job/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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
			B.verbs += /obj/item/storage/bible/proc/Set_Religion
			return 1

		B.icon_state = religion.book_sprite
		B.name = religion.book_name
		SSticker.Bible_icon_state = religion.book_sprite
		SSticker.Bible_item_state = religion.book_sprite
		SSticker.Bible_name = religion.book_name
		return 1
