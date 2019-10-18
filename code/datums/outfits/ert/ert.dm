/datum/outfit/admin/ert/nanotrasen
	name = "Nanotrasen ERT Responder"

	uniform = /obj/item/clothing/under/ert
	suit = null
	suit_store = null
	belt = /obj/item/weapon/storage/belt/military
	shoes = /obj/item/clothing/shoes/swat
	accessory = /obj/item/clothing/accessory/storage/black_vest
	gloves = null
	id = /obj/item/weapon/card/id/ert
	back = /obj/item/weapon/rig/ert/security

	l_ear = /obj/item/device/radio/headset/ert

	belt_contents = list(
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/shield/riot/tact,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556/ap
	)

/datum/outfit/admin/ert/nanotrasen/specialist
	name = "Nanotrasen ERT Engineer Specialist"

	belt = /obj/item/weapon/storage/belt/utility/full
	back = /obj/item/weapon/rig/ert/engineer

	belt_contents = null

/datum/outfit/admin/ert/nanotrasen/specialist/medical
	name = "Nanotrasen ERT Medical Specialist"

	belt = /obj/item/weapon/storage/belt/medical
	back = /obj/item/weapon/rig/ert/medical
	r_hand = /obj/item/weapon/storage/firstaid/combat

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin
	)

/datum/outfit/admin/ert/nanotrasen/leader
	name = "Nanotrasen ERT Leader"

	back = /obj/item/weapon/rig/ert

	belt_contents = list(
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/shield/riot/tact,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556/ap,
		/obj/item/ammo_magazine/a556/ap
	)

//TCFL
/datum/outfit/admin/ert/legion
	name = "TCFL ERT Responder"

	uniform = /obj/item/clothing/under/legion
	l_ear = /obj/item/device/radio/headset/legion
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	glasses =  /obj/item/clothing/glasses/sunglasses
	back = /obj/item/weapon/storage/backpack/legion
	l_hand = /obj/item/weapon/storage/belt/utility/full

/datum/outfit/admin/ert/legion/specialist
	name = "TCFL ERT Medic"

	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_hand = /obj/item/weapon/storage/firstaid/combat
	belt = /obj/item/weapon/storage/belt/medical

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin
	)

//Mercenary
/datum/outfit/admin/ert/mercenary
	name = "Mercenary ERT Responder"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	belt = /obj/item/weapon/storage/belt/military
	back = /obj/item/weapon/storage/backpack/satchel_syndie
	l_hand = /obj/item/weapon/gun/projectile/automatic/c20r
	suit = /obj/item/clothing/suit/space/void/merc
	head = /obj/item/clothing/head/helmet/space/void/merc
	suit_store = /obj/item/weapon/tank/oxygen

	belt_contents = list(
		/obj/item/ammo_magazine/a10mm,
		/obj/item/ammo_magazine/a10mm,
		/obj/item/ammo_magazine/a10mm,
		/obj/item/weapon/handcuffs/ziptie,
		/obj/item/weapon/handcuffs/ziptie,
		/obj/item/weapon/shield/energy
	)

/datum/outfit/admin/ert/mercenary/specialist
	name = "Mercenary ERT Medic"

	belt = /obj/item/weapon/storage/belt/medical
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_hand = /obj/item/weapon/storage/firstaid/combat

	backpack_contents = list(
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/ammo_magazine/a10mm,
		/obj/item/ammo_magazine/a10mm
	)

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin
	)

/datum/outfit/admin/ert/mercenary/leader
	name = "Mercenary ERT Leader"
	l_hand = /obj/item/weapon/gun/projectile/automatic/rifle
	back = /obj/item/weapon/rig/merc
	suit_store = null
	suit = null
	head = null

	belt_contents = list(
		/obj/item/ammo_magazine/c762,
		/obj/item/ammo_magazine/c762,
		/obj/item/ammo_magazine/c762,
		/obj/item/weapon/handcuffs/ziptie,
		/obj/item/weapon/handcuffs/ziptie,
		/obj/item/weapon/shield/energy
	)
