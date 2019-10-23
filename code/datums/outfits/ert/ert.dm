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
		/obj/item/weapon/handcuffs = 2,
		/obj/item/weapon/shield/riot/tact = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/a556/ap = 1
	)

/datum/outfit/admin/ert/nanotrasen/get_id_access()
	return get_all_accesses() | get_centcom_access("Emergency Response Team")

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
		/obj/item/weapon/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin = 1
	)

/datum/outfit/admin/ert/nanotrasen/leader
	name = "Nanotrasen ERT Leader"

	back = /obj/item/weapon/rig/ert

	belt_contents = list(
		/obj/item/weapon/handcuffs = 1,
		/obj/item/weapon/shield/riot/tact = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/a556/ap = 2
	)

//TCFL
/datum/outfit/admin/ert/legion
	name = "TCFL Responder"

	uniform = /obj/item/clothing/under/legion
	l_ear = /obj/item/device/radio/headset/legion
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	glasses =  /obj/item/clothing/glasses/sunglasses
	back = /obj/item/weapon/storage/backpack/legion
	id = /obj/item/weapon/card/id/distress/legion

	backpack_contents = list(
		/obj/item/weapon/storage/belt/utility/full = 1
	)

/datum/outfit/admin/ert/legion/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/legion/specialist
	name = "TCFL Medic"

	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_hand = /obj/item/weapon/storage/firstaid/combat
	belt = /obj/item/weapon/storage/belt/medical

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin = 1
	)

//Mercenary
/datum/outfit/admin/ert/mercenary
	name = "Mercenary Freelancer"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/yellow
	belt = /obj/item/weapon/storage/belt/military
	back = /obj/item/weapon/storage/backpack/satchel_syndie
	suit = /obj/item/clothing/suit/space/void/merc
	head = /obj/item/clothing/head/helmet/space/void/merc
	suit_store = /obj/item/weapon/tank/oxygen
	id = /obj/item/weapon/card/id/distress

	backpack_contents = list(
		/obj/item/weapon/gun/projectile/automatic/c20r = 1,
		/obj/item/weapon/storage/belt/utility/full = 1
	)

	belt_contents = list(
		/obj/item/ammo_magazine/a10mm = 3,
		/obj/item/weapon/handcuffs/ziptie = 2,
		/obj/item/weapon/shield/energy = 1
	)

/datum/outfit/admin/ert/mercenary/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/mercenary/specialist
	name = "Mercenary Freelancer Medic"

	belt = /obj/item/weapon/storage/belt/medical
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_hand = /obj/item/weapon/storage/firstaid/combat

	backpack_contents = list(
		/obj/item/weapon/gun/projectile/automatic/c20r = 1,
		/obj/item/ammo_magazine/a10mm = 2
	)

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin = 1
	)

/datum/outfit/admin/ert/mercenary/leader
	name = "Mercenary Freelancer Leader"
	l_hand = /obj/item/weapon/gun/projectile/automatic/rifle
	back = /obj/item/weapon/rig/merc
	suit_store = null
	suit = null
	head = null

	belt_contents = list(
		/obj/item/ammo_magazine/c762 = 3,
		/obj/item/weapon/handcuffs/ziptie = 2,
		/obj/item/weapon/shield/energy = 1
	)
