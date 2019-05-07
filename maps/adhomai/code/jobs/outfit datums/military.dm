/datum/outfit/job/adhomai/military/commander
	name = "Commander"

	uniform = /obj/item/clothing/under/uniform/hand
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	r_pocket = /obj/item/weapon/key/hand
	l_pocket = /obj/item/weapon/storage/wallet/rich
	gloves = /obj/item/clothing/gloves/brown/tajara
	backpack_contents = list(
		/obj/item/weapon/key/soldier = 1,
		/obj/item/weapon/key/armory = 1,
		/obj/item/weapon/key/cell = 1,
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1
		)
	backpack = /obj/item/weapon/storage/backpack/satchel/grenadier/levy
	satchel = /obj/item/weapon/storage/backpack/satchel/engineer/levy

/datum/outfit/job/adhomai/military/supply_officer
	name = "Quatermaster"

	uniform = /obj/item/clothing/under/uniform/supply
	r_pocket = /obj/item/weapon/key/armory
	l_pocket = /obj/item/weapon/storage/wallet/medium
	backpack_contents = list(
		/obj/item/weapon/key/soldier = 1,
		/obj/item/weapon/key/cell = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/ammo_magazine/nka/kt_76 = 1,
		/obj/item/weapon/gun/projectile/nka/kt_76 = 1
		)
	backpack = /obj/item/weapon/storage/backpack/satchel/engineer/levy
	satchel = /obj/item/weapon/storage/backpack/satchel/grenadier/levy

/datum/outfit/job/adhomai/military/culinaryservices
	name = "Culinary Services"
	uniform = /obj/item/clothing/under/tajaran/fancy
	suit = /obj/item/clothing/suit/chef/nka
	suit_store = /obj/item/weapon/storage/bag/plants/produce/adhomai
	belt = /obj/item/weapon/storage/belt/apron/nka
	head = /obj/item/clothing/head/chefhat/nka
	l_hand = /obj/item/weapon/material/kitchen/rollingpin
	r_hand = /obj/item/weapon/material/hatchet/butch
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1
		)

/datum/outfit/job/adhomai/military/forwardscouting
	name = "Forward Scouting"
	r_hand = /obj/item/device/binoculars
	l_pocket = /obj/item/device/gps

/datum/outfit/job/adhomai/military/medicalservices
	name = "Medical Services"
	r_hand = /obj/item/weapon/storage/surgicalkit/regular/adhomai
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/ammo_magazine/nka = 1,
		/obj/item/stack/medical/bruise_pack/adhomai = 2,
		/obj/item/stack/medical/ointment/adhomai = 1,
		/obj/item/weapon/gun/projectile/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1
		)

/datum/outfit/job/adhomai/military
	name = "Levy"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/levy
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	head = /obj/item/clothing/head/nka
	r_pocket = /obj/item/weapon/key/soldier
	belt = /obj/item/weapon/storage/belt/security/tactical/nka
	suit = /obj/item/clothing/suit/armor/tactical/nka
	suit_store = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/ammo_magazine/nka = 1,
		/obj/item/ammo_magazine/boltaction/nka = 1,
		/obj/item/weapon/gun/projectile/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1
		)

	backpack = /obj/item/weapon/storage/backpack/satchel/engineer/levy
	satchel = /obj/item/weapon/storage/backpack/satchel/grenadier/levy

/datum/outfit/job/adhomai/military/grenadier
	name = "Royal Grenadier"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/grenadier
	head = /obj/item/clothing/head/helmet/nka/grenadier
	shoes = /obj/item/clothing/shoes/armored_boots/grenadier
	gloves = /obj/item/clothing/gloves/grenadier/armored
	suit = /obj/item/clothing/suit/armor/tactical/nka/grenadier
	suit_store = /obj/item/weapon/gun/projectile/grenadier
	l_pocket = /obj/item/weapon/storage/wallet/medium
	backpack_contents = list(
		/obj/item/ammo_magazine/boltaction/nka/enbloc = 2,
		/obj/item/weapon/grenade/frag/nka = 3,
		/obj/item/weapon/grenade/chem_grenade/incendiary/nka = 2,
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1,
		/obj/item/ammo_magazine/nka/kt_76 = 1,
		/obj/item/weapon/gun/projectile/nka/kt_76 = 1,
		/obj/item/martial_manual/tajara = 1
		)
	backpack = /obj/item/weapon/storage/backpack/satchel/engineer/grenadier
	satchel = /obj/item/weapon/storage/backpack/satchel/grenadier

/datum/outfit/job/adhomai/military/sharpshooter
	name = "Sharpshooter"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/sharpshooter
	l_pocket = /obj/item/weapon/storage/wallet/medium
	suit_store = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1,
		/obj/item/ammo_magazine/boltaction/nka = 1,
		/obj/item/ammo_magazine/nka/kt_76 = 1,
		/obj/item/weapon/gun/projectile/nka/kt_76 = 1,
		/obj/item/device/binoculars/high_power = 1,
		/obj/item/weapon/storage/box/clip_pouch/cartridge = 1,
		/obj/item/weapon/storage/box/clip_pouch = 1
		)
	backpack = /obj/item/weapon/storage/backpack/satchel/grenadier/levy
	satchel = /obj/item/weapon/storage/backpack/satchel/engineer/levy

/datum/outfit/job/adhomai/military/combatengineer
	name = "Combat Engineer"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/uniform/combat_engineer
	l_pocket = /obj/item/weapon/storage/wallet/medium
	belt = /obj/item/weapon/storage/belt/utility/full
	backpack_contents = list(
		/obj/item/weapon/landmine = 3,
		/obj/item/weapon/landmine/frag = 2,
		/obj/item/weapon/pickaxe/drill/mattock = 1,
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1
		)
	satchel = /obj/item/weapon/storage/backpack/satchel/grenadier/engineering
	backpack = /obj/item/weapon/storage/backpack/satchel/engineer

/datum/outfit/job/adhomai/amohdanswordsman
	name = "Amohdan Swordsman"
	allow_backbag_choice = TRUE

	uniform = /obj/item/clothing/under/tajaran/fancy
	suit = /obj/item/clothing/suit/armor/tajara
	head = /obj/item/clothing/head/helmet/tajara
	l_pocket = /obj/item/weapon/storage/wallet/medium
	r_pocket = /obj/item/weapon/key/soldier
	belt = /obj/item/weapon/material/sword/amohdan_sword/meteoric
	backpack_contents = list(
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka = 1,
		/obj/item/weapon/flame/lighter/adhomian/nka = 1,
		/obj/item/martial_manual/tajara = 1
		)
