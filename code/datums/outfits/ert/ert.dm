/datum/outfit/admin/ert/nanotrasen
	name = "Nanotrasen Responder"

	uniform = /obj/item/clothing/under/ert
	suit = null
	suit_store = null
	belt = /obj/item/weapon/storage/belt/military
	shoes = /obj/item/clothing/shoes/jackboots
	accessory = /obj/item/clothing/accessory/storage/black_vest
	gloves = null
	id = /obj/item/weapon/card/id/ert
	back = /obj/item/weapon/rig/ert

	l_ear = /obj/item/device/radio/headset/ert
	l_hand = /obj/item/weapon/gun/projectile/automatic/rifle/z8

	belt_contents = list(
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/shield/riot/tact,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556/ap
	)
	
/datum/outfit/admin/ert/nanotrasen/specialist
	belt = /obj/item/weapon/storage/belt/utility/full
	back = /obj/item/weapon/rig/ert/engineer

	belt_contents = null

/datum/outfit/admin/ert/nanotrasen/specialist/medical
	belt = /obj/item/weapon/storage/belt/medical
	back = /obj/item/weapon/rig/ert/medical
	r_hand = /obj/item/weapon/storage/firstaid/combat

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment
	)