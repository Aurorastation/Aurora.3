/datum/outfit/admin/lance
	name = "Lancer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/gun/energy/rifle/pulse
	gloves = /obj/item/clothing/gloves/force/basic
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	belt_contents = list(
			/obj/item/plastique = 1,
			/obj/item/grenade/frag = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/empgrenade = 1
	)
	var/id_access = "Lancer"

/datum/outfit/admin/lance/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/lance/engineer
	name = "Lance Engineer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/gun/projectile/shotgun/pump/combat/sol
	gloves = /obj/item/clothing/gloves/yellow
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
			/obj/item/plastique = 3,
			/obj/item/grenade/frag = 1,
			/obj/item/device/flash = 1
	)
	belt_contents = list(
			/obj/item/device/multitool = 1
	)
	id_access = "Lance Engineer"

/datum/outfit/admin/lance/medic
	name = "Lance Medic"

	uniform = /obj/item/clothing/under/lance
	gloves = /obj/item/clothing/gloves/latex/nitrile
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/medical
	mask = /obj/item/clothing/mask/surgical
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	belt_contents = list(
			/obj/item/device/healthanalyzer = 1,
			/obj/item/reagent_containers/hypospray/combat = 1,
			/obj/item/reagent_containers/syringe = 1,
			/obj/item/personal_inhaler/combat = 1,
			/obj/item/reagent_containers/personal_inhaler_cartridge/large = 2,
			/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
			/obj/item/reagent_containers/glass/bottle/norepinephrine = 1,
			/obj/item/reagent_containers/glass/bottle/thetamycin = 1
			)
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)
	id_access = "Lance Medic"

/datum/outfit/admin/lance/operative
	name = "Lance Operative"

	uniform = /obj/item/clothing/under/dress/lance_dress/male
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/syndicate
	suit_store = /obj/item/tank/oxygen
	suit = /obj/item/clothing/suit/space/void/lancer
	head = /obj/item/clothing/head/helmet/space/void/lancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)

	backpack_contents = list(
		/obj/item/device/flash = 1,
		/obj/item/clothing/gloves/yellow = 1
	)
	belt_contents = list(
		/obj/item/device/multitool = 1
	)
	id_access = "Lance Operative"