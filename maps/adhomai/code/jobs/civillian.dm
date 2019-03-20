/datum/job/commoner
	title = "Commoner"
	flag = ASSISTANT
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the mayor"
	selection_color = "#ddddff"
	economic_modifier = 1
	alt_titles = list("Lumberjack","Farmer")
	outfit = /datum/outfit/job/adhomai/commoner
	alt_outfits = list(
		"Lumberjack"=/datum/outfit/job/adhomai/commoner/lumberjack,
		"Farmer"=/datum/outfit/job/adhomai/commoner/farmer
		)
	is_assistant = TRUE

/datum/outfit/job/adhomai/commoner
	name = "Civillian"
	allow_backbag_choice = TRUE

/datum/outfit/job/adhomai/commoner/lumberjack
	name = "Lumberjack"

	belt = /obj/item/weapon/material/axe

/datum/outfit/job/adhomai/commoner/farmer
	name = "Farmer"

	belt = /obj/item/weapon/storage/bag/plants
	r_pocket = /obj/item/weapon/material/minihoe
	l_pocket = /obj/item/weapon/material/hatchet
	l_hand = /obj/item/weapon/reagent_containers/glass/bucket

/datum/job/mayor
	title = "Mayor"
	flag = MAYOR
	department = "Village"
	head_position = 1
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the King"
	selection_color = "#dddddd"
	req_admin_notify = 1

	outfit = /datum/outfit/job/adhomai/mayor

	species_blacklist = list("Zhan-Khazan Tajara", "M'sai Tajara", HUMAN_SPECIES, UNATHI_SPECIES, TAJARA_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

/datum/outfit/job/adhomai/mayor
	name = "Civillian"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/tajaran/fancy
	suit = /obj/item/clothing/suit/storage/tajaran/cloak/fancy
	shoes = /obj/item/clothing/shoes/tajara
	gloves = /obj/item/clothing/gloves/white/tajara
	r_pocket = /obj/item/weapon/key/mayor

/datum/job/barkeeper
	title = "Barkeeper"
	flag = BARKEEPER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/barkeeper

/datum/outfit/job/adhomai/barkeeper
	name = "Barkeeper"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/tajaran
	shoes = /obj/item/clothing/shoes/tajara
	r_pocket = /obj/item/weapon/key/bar
	belt = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn/bean
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/messa_mead = 2,
		/obj/item/weapon/storage/box/beanbags = 1
	)

/datum/job/hunter
	title = "Hunter"
	flag = HUNTER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/hunter

/datum/outfit/job/adhomai/hunter
	name = "Hunter"

	uniform = /obj/item/clothing/under/tajaran
	suit = /obj/item/clothing/suit/armor/hunter
	back = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	r_pocket = /obj/item/ammo_magazine/boltaction
	l_pocket = /obj/item/ammo_magazine/boltaction

/datum/job/priest
	title = "Priest"
	flag = PRIEST
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	species_blacklist = list(HUMAN_SPECIES, UNATHI_SPECIES, TAJARA_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	outfit = /datum/outfit/job/adhomai/priest

/datum/outfit/job/adhomai/priest
	name = "Priest"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/color/white
	belt = /obj/item/weapon/nullrod

/datum/outfit/job/adhomai/priest/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		if(H.gender == MALE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/tajaran/priest(H), slot_wear_suit)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/tajaran/messa(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/tajara(H), slot_wear_mask)

	return TRUE

/datum/job/physician
	title = "Physician"
	flag = MEDIC
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/physician

/datum/outfit/job/adhomai/physician
	name = "Physician"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/sandal
	suit_store = /obj/item/device/flashlight/pen
	r_pocket = /obj/item/stack/medical/bruise_pack
	l_pocket = /obj/item/weapon/key/medical

/datum/job/nurse
	title = "Nurse"
	flag = NURSE
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the physician"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/nurse

/datum/outfit/job/adhomai/nurse
	name = "Nurse"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sandal
	r_pocket = /obj/item/stack/medical/bruise_pack
	l_pocket = /obj/item/weapon/key/medical

/datum/outfit/job/adhomai/nurse/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		if(H.gender == FEMALE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(H), head)

	return TRUE

/datum/job/prospector
	title = "Prospector"
	flag = PROSPECTOR
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/prospector

/datum/outfit/job/adhomai/prospector
	name = "Miner"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/tajaran
	shoes = /obj/item/clothing/shoes/footwraps
	r_pocket = /obj/item/weapon/storage/bag/ore
	l_pocket = /obj/item/device/flashlight/lantern
	belt = /obj/item/weapon/pickaxe

/datum/job/blacksmith
	title = "Blacksmith"
	flag = BLACKSMITH
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/blacksmith

/datum/outfit/job/adhomai/blacksmith
	name = "Blacksmith"
	allow_backbag_choice = TRUE

	suit = /obj/item/clothing/suit/apron/brown
	belt = /obj/item/weapon/material/blacksmith_hammer
	r_pocket = /obj/item/weapon/key/blacksmith

/datum/job/archeologist
	title = "Archeologist"
	flag = ARCHEO
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/archeologist

/datum/outfit/job/adhomai/archeologist
	name = "archeologist"
	allow_backbag_choice = TRUE

	head = /obj/item/clothing/head/fedora/archeologist
	uniform = /obj/item/clothing/under/archeologist
	suit = /obj/item/clothing/suit/storage/archeologist
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/device/ano_scanner
	l_pocket = /obj/item/device/flashlight/lantern
	belt = /obj/item/weapon/melee/whip
	backpack_contents = list(
		/obj/item/weapon/storage/box/excavation = 1,
		/obj/item/device/depth_scanner = 1,
		/obj/item/device/core_sampler = 1,
		/obj/item/device/measuring_tape = 1,
		/obj/item/weapon/pickaxe/hand = 1
	)


/datum/job/trader
	title = "Trader"
	flag = TRADER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/trader

/datum/outfit/job/adhomai/trader
	name = "trader"
	allow_backbag_choice = TRUE

	pda = /obj/item/device/pda/merchant
	r_pocket = /obj/item/device/price_scanner
	l_pocket = /obj/item/weapon/key/trader

	backpack_contents = list(
		/obj/item/weapon/storage/box/excavation = 1
	)

/datum/job/chief_constable
	title = "Chief Constable"
	flag = CHIEFCONSTABLE
	department = "Village"
	head_position = 1
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	selection_color = "#dddddd"
	req_admin_notify = 1
	minimal_player_age = 10
	species_blacklist = list("Zhan-Khazan Tajara", HUMAN_SPECIES, UNATHI_SPECIES, TAJARA_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	outfit = /datum/outfit/job/adhomai/chief_constable


/datum/outfit/job/adhomai/chief_constable
	name = "Chief Constable"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/constable
	suit = /obj/item/clothing/suit/armor/constable
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	r_pocket = /obj/item/weapon/key/cell
	l_pocket = /obj/item/weapon/key/chief
	belt = /obj/item/weapon/melee/classic_baton

/datum/job/constable
	title = "Constable"
	flag = CONSTABLE
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief constable"
	selection_color = "#ddddff"
	species_blacklist = list(HUMAN_SPECIES, UNATHI_SPECIES, TAJARA_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)
	outfit = /datum/outfit/job/adhomai/constable


/datum/outfit/job/adhomai/constable
	name = "Constable"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/constable
	shoes = /obj/item/clothing/shoes/tajara
	r_pocket = /obj/item/weapon/key/cell
	l_pocket = /obj/item/device/flashlight/lantern
