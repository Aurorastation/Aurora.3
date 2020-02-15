/datum/outfit/admin/deathsquad/syndicate
	name = "Syndicate Commando"

	uniform = /obj/item/clothing/under/syndicate
	belt = /obj/item/storage/belt/military/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	l_ear = /obj/item/device/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/thermal
	id = /obj/item/card/id/syndicate_ert
	l_pocket = /obj/item/ammo_magazine/c45m
	l_hand = /obj/item/gun/projectile/automatic/rifle/sts35

	belt_contents = list(
		/obj/item/ammo_magazine/c762 = 3,
		/obj/item/pinpointer = 1,
		/obj/item/shield/energy = 1,
		/obj/item/handcuffs = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/grenade/frag = 1,
		/obj/item/plastique = 1
	)

	syndie = TRUE

/datum/outfit/admin/deathsquad/syndicate/leader
	name = "Syndicate Commando Lead"

	l_pocket = /obj/item/pinpointer