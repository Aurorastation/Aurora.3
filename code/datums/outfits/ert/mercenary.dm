/datum/outfit/admin/ert/mercenary
	name = "Mercenary Freelancer"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/swat/ert
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel_norm
	l_hand = /obj/item/clothing/suit/space/void/freelancer
	r_hand = /obj/item/clothing/head/helmet/space/void/freelancer
	accessory = /obj/item/clothing/accessory/storage/black_vest
	id = /obj/item/card/id/syndicate

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/gun/projectile/automatic/c20r = 1,
		/obj/item/storage/belt/utility/full = 1,
		/obj/item/tank/oxygen = 1,
		/obj/item/clothing/gloves/yellow = 1,
		/obj/item/material/knife/trench = 1
	)

	belt_contents = list(
		/obj/item/ammo_magazine/a10mm = 3,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy = 1
	)

/datum/outfit/admin/ert/mercenary/get_id_access()
	return get_distress_access_lesser()

/datum/outfit/admin/ert/mercenary/specialist
	name = "Mercenary Freelancer Medic"

	belt = /obj/item/storage/belt/medical
	gloves = /obj/item/clothing/gloves/latex

	backpack_contents = list(
		/obj/item/gun/projectile/automatic/c20r = 1,
		/obj/item/ammo_magazine/a10mm = 2,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/tank/oxygen = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1
	)

/datum/outfit/admin/ert/mercenary/engineer
	name = "Mercenary Freelancer Combat Engineer"

	back = /obj/item/storage/backpack/duffel
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/yellow
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
								/obj/item/plastique = 5
							)

	backpack_contents = list(
		/obj/item/material/knife/trench = 1,
		/obj/item/shield/energy = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/tank/oxygen = 1,
		/obj/item/device/multitool = 1,
		/obj/item/weldingtool/hugetank = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/projectile/shotgun/pump/combat/sol = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/landmine/frag = 1,
		/obj/item/landmine/emp = 1
	)

	belt_contents = null

/datum/outfit/admin/ert/mercenary/leader
	name = "Mercenary Freelancer Leader"
	l_hand = /obj/item/gun/projectile/automatic/rifle/sts35
	r_hand = null
	back = /obj/item/rig/merc/distress
	suit_store = null
	suit = null
	head = null

	backpack_contents = list()

	belt_contents = list(
		/obj/item/ammo_magazine/c762 = 3,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy = 1
	)