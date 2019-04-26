/datum/job/commoner
	title = "Commoner"
	flag = ASSISTANT
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Lumberjack","Farmer", "Farmhand", "Migrant", "Tourist", "Steward", "Laborer", "Entertainer", "Herbalist", "Sculptor")
	outfit = /datum/outfit/job/adhomai/commoner
	alt_outfits = list(
		"Lumberjack"=/datum/outfit/job/adhomai/commoner/lumberjack,
		"Farmer"=/datum/outfit/job/adhomai/commoner/farmer,
		"Sculptor"=/datum/outfit/job/adhomai/commoner/sculptor,
		"Herbalist"=/datum/outfit/job/adhomai/commoner/herbalist
		)
	is_assistant = TRUE

	account_allowed = FALSE

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
	l_hand = /obj/item/weapon/reagent_containers/glass/bucket

/datum/outfit/job/adhomai/commoner/herbalist
	name = "Herbalist"

	belt = /obj/item/weapon/storage/bag/plants
	r_pocket = /obj/item/weapon/material/minihoe
	l_hand = /obj/item/weapon/reagent_containers/glass/bucket
	r_hand = /obj/item/weapon/wirecutters/clippers

/datum/outfit/job/adhomai/commoner/sculptor
	name = "Sculptor"
	backpack_contents = list(
	/obj/item/weapon/storage/box/excavation = 1,
	/obj/item/weapon/autochisel/chisel = 1
	)


/datum/job/mayor
	title = "Governor"
	flag = MAYOR
	department = "Village"
	head_position = TRUE
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the King"
	selection_color = "#dddddd"
	req_admin_notify = TRUE
	alt_titles = list("Mayor")

	outfit = /datum/outfit/job/adhomai/mayor

	species_blacklist = list("Zhan-Khazan Tajara", "M'sai Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	account_allowed = FALSE

/datum/outfit/job/adhomai/mayor
	name = "Civillian"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/tajaran/fancy
	suit = /obj/item/clothing/suit/storage/tajaran/cloak/fancy
	gloves = /obj/item/clothing/gloves/white/tajara
	r_pocket = /obj/item/weapon/key/mayor
	l_pocket = /obj/item/weapon/storage/wallet/rich

/datum/job/barkeeper
	title = "Barkeeper"
	flag = BARKEEPER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Innkeeper")

	outfit = /datum/outfit/job/adhomai/barkeeper

	account_allowed = FALSE
	alt_outfits = list(
		"Innkeeper"=/datum/outfit/job/adhomai/bartender/innkeeper
		)

/datum/outfit/job/adhomai/barkeeper
	name = "Barkeeper"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/bartender
	r_pocket = /obj/item/weapon/key/bar
	belt = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn/bean
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/messa_mead = 2,
		/obj/item/weapon/storage/box/beanbags = 1
	)
	l_pocket = /obj/item/weapon/storage/wallet/medium

/datum/outfit/job/adhomai/bartender/innkeeper
	name = "Innkeeper"
	allow_backbag_choice = TRUE

	r_pocket = /obj/item/weapon/key/inn
	belt = /obj/item/weapon/gun/projectile/revolver/derringer
	backpack_contents = list(
		/obj/item/ammo_magazine/a357 = 2
	)
	l_pocket = /obj/item/weapon/storage/wallet/medium

/datum/job/hunter
	title = "Hunter"
	flag = HUNTER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Outdoorsman", "Tanner", "Furrier")

	outfit = /datum/outfit/job/adhomai/hunter

	account_allowed = FALSE

/datum/outfit/job/adhomai/hunter
	name = "Hunter"

	suit = /obj/item/clothing/suit/armor/hunter
	l_hand = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	r_pocket = /obj/item/ammo_magazine/boltaction
	l_pocket = /obj/item/weapon/storage/wallet/medium

/datum/job/priest
	title = "Priest"
	flag = PRIEST
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the laws of the Gods and Men"
	selection_color = "#ddddff"

	alt_titles = list("Missionary", "Investigator", "Sun Sister", "Sun Daughter", "Priest of S'rrendar", "Sapling", "Mistling", "Suns Penitent")
	outfit = /datum/outfit/job/adhomai/priest

	account_allowed = FALSE

/datum/outfit/job/adhomai/priest
	name = "Priest"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/color/white
	l_pocket = /obj/item/weapon/storage/wallet/medium
	backpack_contents = list(/obj/item/weapon/nullrod/itembox = 1)

/datum/outfit/job/adhomai/priest/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H && istajara(H))
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
	supervisors = "the laws of the land, and possibly an ethical code"
	selection_color = "#ddddff"
	alt_titles = list("IAC Field Doctor")

	outfit = /datum/outfit/job/adhomai/physician

	account_allowed = FALSE
	alt_outfits = list(
		"IAC Field Doctor"=/datum/outfit/job/adhomai/physician/iacfielddoctor
		)

/datum/outfit/job/adhomai/physician
	name = "Physician"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/sandal
	suit_store = /obj/item/device/flashlight/pen
	r_pocket = /obj/item/weapon/key/medical
	l_pocket = /obj/item/weapon/storage/wallet/rich

/datum/outfit/job/adhomai/physician/iacfielddoctor
	name = "IAC Field Doctor"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/iacjumpsuit
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/iac
	shoes = /obj/item/clothing/shoes/winter
	head = /obj/item/clothing/head/soft/iacberet
	suit_store = /obj/item/device/healthanalyzer
	r_pocket = /obj/item/weapon/key/medical
	l_pocket = /obj/item/weapon/storage/wallet/rich
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/hypospray = 1,
		/obj/item/weapon/storage/firstaid/adv = 1,
		/obj/item/clothing/glasses/hud/health = 1,
		/obj/item/weapon/storage/firstaid/regular = 1,
		/obj/item/weapon/storage/box/gloves = 1
		)
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med

/datum/job/nurse
	title = "Nurse"
	flag = NURSE
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the attending doctor or physician"
	selection_color = "#ddddff"
	alt_titles = list("IAC Volunteer")
	alt_outfits = list(
		"IAC Volunteer"=/datum/outfit/job/adhomai/nurse/iacvolunteer
		)


	outfit = /datum/outfit/job/adhomai/nurse

	account_allowed = FALSE

/datum/outfit/job/adhomai/nurse
	name = "Nurse"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sandal
	r_pocket = /obj/item/weapon/key/medical
	l_pocket = /obj/item/weapon/storage/wallet/medium

/datum/outfit/job/adhomai/nurse/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		if(H.gender == FEMALE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(H), head)

	return TRUE

/datum/outfit/job/adhomai/nurse/iacvolunteer
	name = "IAC Volunteer"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/rank/iacjumpsuit
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/iac
	head = /obj/item/clothing/head/soft/iacberet
	shoes = /obj/item/clothing/shoes/winter
	r_pocket = /obj/item/weapon/key/medical
	l_pocket = /obj/item/weapon/storage/wallet/medium
	backpack_contents = list(
		/obj/item/weapon/storage/firstaid/regular = 1,
		/obj/item/weapon/storage/box/gloves = 1)

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/duffel/med
	messengerbag = /obj/item/weapon/storage/backpack/messenger/med


/datum/job/prospector
	title = "Prospector"
	flag = PROSPECTOR
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Miner", "Surveyor", "Drill Technician", "Geological Specialist", "Spelunker")

	outfit = /datum/outfit/job/adhomai/prospector

	account_allowed = FALSE

/datum/outfit/job/adhomai/prospector
	name = "Miner"
	allow_backbag_choice = TRUE

	shoes = /obj/item/clothing/shoes/footwraps
	r_pocket = /obj/item/weapon/storage/bag/ore
	l_hand = /obj/item/device/flashlight/lantern
	belt = /obj/item/weapon/pickaxe

/datum/job/blacksmith
	title = "Blacksmith"
	flag = BLACKSMITH
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Craftsman", "Architect")

	outfit = /datum/outfit/job/adhomai/blacksmith

	account_allowed = FALSE

/datum/outfit/job/adhomai/blacksmith
	name = "Blacksmith"
	allow_backbag_choice = TRUE

	suit = /obj/item/clothing/suit/apron/brown
	belt = /obj/item/weapon/material/blacksmith_hammer
	r_pocket = /obj/item/weapon/key/blacksmith
	l_pocket = /obj/item/weapon/storage/wallet/medium

/datum/job/archeologist
	title = "Archeologist"
	flag = ARCHEO
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land, and whatever institution or code drives you"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/archeologist

	account_allowed = FALSE

/datum/outfit/job/adhomai/archeologist
	name = "archeologist"
	allow_backbag_choice = TRUE

	head = /obj/item/clothing/head/fedora/archeologist
	uniform = /obj/item/clothing/under/archeologist
	suit = /obj/item/clothing/suit/storage/archeologist
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/device/ano_scanner
	l_pocket = /obj/item/weapon/storage/wallet/medium
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
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Shopkeep")

	outfit = /datum/outfit/job/adhomai/trader

	account_allowed = FALSE

/datum/outfit/job/adhomai/trader
	name = "trader"
	allow_backbag_choice = TRUE

	pda = /obj/item/weapon/card/id/merchant
	l_pocket = /obj/item/weapon/storage/wallet/poor
	r_pocket = /obj/item/weapon/key/trader

	backpack_contents = list(
		/obj/item/device/price_scanner = 1
	)

/datum/job/chief_constable
	title = "Chief Constable"
	flag = CHIEFCONSTABLE
	department = "Village"
	head_position = TRUE
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the city governance"
	selection_color = "#dddddd"
	req_admin_notify = TRUE
	species_blacklist = list("Zhan-Khazan Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	outfit = /datum/outfit/job/adhomai/chief_constable

	account_allowed = FALSE

/datum/outfit/job/adhomai/chief_constable
	name = "Chief Constable"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/constable
	suit = /obj/item/clothing/suit/armor/constable
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	r_pocket = /obj/item/weapon/key/chief
	l_pocket = /obj/item/weapon/storage/wallet/rich
	belt = /obj/item/weapon/melee/classic_baton
	backpack_contents = list(
		/obj/item/weapon/key/cell = 2
	)

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
	species_blacklist = list(HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)
	outfit = /datum/outfit/job/adhomai/constable

	account_allowed = FALSE

/datum/outfit/job/adhomai/constable
	name = "Constable"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/constable
	shoes = /obj/item/clothing/shoes/tajara
	r_pocket = /obj/item/weapon/key/cell
	l_pocket = /obj/item/weapon/storage/wallet/medium
