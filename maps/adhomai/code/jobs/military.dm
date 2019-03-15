/datum/job/commander
	title = "Commander"
	flag = COMMANDER
	department = "Imperial Army"
	head_position = 1
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the King"
	selection_color = "#ffdddd"
	req_admin_notify = 1
	outfit = /datum/outfit/job/adhomai/military/commander

	species_blacklist = list("Human", "Unathi", "Aut'akh Unathi", "Skrell", "Diona", "Vaurca Worker", "Vaurca Warrior", "Diona", "Baseline Frame", "Zhan-Khazan Tajara", "M'sai Tajara",
							"Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")

/datum/outfit/job/adhomai/military/commander
	name = "Commander"

	uniform = /obj/item/clothing/under/uniform/hand
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	l_pocket = /obj/item/weapon/key/hand
	back = /obj/item/weapon/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/brown/tajara
	backpack_contents = list(
		/obj/item/weapon/key/soldier = 1,
		/obj/item/weapon/key/armory = 1
	)

/datum/job/supply_officer
	title = "Supply Officer"
	flag = SUPPLYOFFICER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commander"
	selection_color = "#ffeeee"

	outfit = /datum/outfit/job/adhomai/military/supply_officer

	species_blacklist = list("Human", "Unathi", "Aut'akh Unathi", "Skrell", "Diona", "Vaurca Worker", "Vaurca Warrior", "Diona", "Baseline Frame",
							"Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")

/datum/outfit/job/adhomai/military/supply_officer
	name = "Quatermaster"

	shoes = /obj/item/clothing/shoes/jackboots/unathi
	l_pocket = /obj/item/weapon/key/armory
	belt = /obj/item/weapon/gun/projectile/colt

/datum/job/levy
	title = "Levy"
	flag = LEVY
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	outfit = /datum/outfit/job/adhomai/military

/datum/outfit/job/adhomai/military
	name = "Levy"

	uniform = /obj/item/clothing/under/uniform
	shoes = /obj/item/clothing/shoes/tajara
	head = /obj/item/clothing/head/nka
	r_pocket = /obj/item/weapon/key/soldier

/datum/job/grenadier
	title = "Royal Grenadier"
	flag = GRENADIER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"

	outfit = /datum/outfit/job/adhomai/military/grenadier

	species_blacklist = list("Human", "Unathi", "Aut'akh Unathi", "Skrell", "Diona", "Vaurca Worker", "Vaurca Warrior", "Diona", "Baseline Frame", "M'sai Tajara",
							"Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")

/datum/outfit/job/adhomai/military/grenadier
	name = "Royal Grenadier"
	allow_backbag_choice = FALSE

	head = /obj/item/clothing/head/helmet/nka
	suit = /obj/item/clothing/suit/armor/nka
	back = /obj/item/weapon/storage/backpack/satchel/grenadier
	suit_store = /obj/item/weapon/gun/projectile/grenadier
	l_pocket = /obj/item/ammo_magazine/boltaction
	gloves = /obj/item/clothing/gloves/brown/tajara
	backpack_contents = list(
							/obj/item/ammo_magazine/boltaction = 2,
							/obj/item/weapon/grenade/frag = 3,
							/obj/item/clothing/accessory/storage/bayonet = 1)

/datum/job/sharpshooter
	title = "Sharpshooter"
	flag = SHARPSHOOTER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	outfit = /datum/outfit/job/adhomai/military/sharpshooter

/datum/outfit/job/adhomai/military/sharpshooter
	name = "Sharpshooter"
	allow_backbag_choice = FALSE

	back = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	l_pocket = /obj/item/ammo_magazine/boltaction

/datum/job/combatengineer
	title = "Combat Engineer"
	flag = COMBATENGINEER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"

	outfit = /datum/outfit/job/adhomai/military/combatengineer

/datum/outfit/job/adhomai/military/combatengineer
	name = "Combat Engineer"


	back = /obj/item/weapon/storage/backpack/satchel/engineer
	l_pocket = /obj/item/device/gps
	belt = /obj/item/weapon/pickaxe
	backpack_contents = list(
							/obj/item/weapon/landmine = 3,
							/obj/item/weapon/landmine/frag = 2,
							/obj/item/weapon/crowbar = 1)