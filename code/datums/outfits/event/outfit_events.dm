/datum/outfit/admin/event/lance
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

/datum/outfit/admin/event/lance/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/event/lance/engineer
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

/datum/outfit/admin/event/lance/medic
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
			/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
			/obj/item/reagent_containers/glass/bottle/thetamycin = 1
			)
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)
	id_access = "Lance Medic"

/datum/outfit/admin/event/lance/operative
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

/datum/outfit/admin/event/sol_marine
	name = "Solarian Marine"

	uniform = /obj/item/clothing/under/rank/fatigues
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/thermal
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	id = /obj/item/card/id/syndicate
	head = /obj/item/clothing/head/helmet/space/void/sol
	suit = /obj/item/clothing/suit/space/void/sol
	mask = /obj/item/clothing/mask/gas/tactical
	back = /obj/item/tank/jetpack/carbondioxide
	suit_store = /obj/item/gun/projectile/automatic/rifle/sol

	belt = /obj/item/storage/belt/military
	belt_contents = list(
			/obj/item/ammo_magazine/c762/sol = 3,
			/obj/item/ammo_magazine/mc9mm = 2,
			/obj/item/shield/energy = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/grenade/frag = 1,
			/obj/item/grenade/flashbang = 1
	)


	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)

/datum/outfit/admin/event/sol_marine/heavy
	name = "Heavy Solarian Marine"

	head = null
	suit = null
	mask = /obj/item/clothing/mask/gas/tactical
	back = /obj/item/rig/military/equipped
	belt_contents = list(
			/obj/item/gun/projectile/pistol/sol = 1,
			/obj/item/ammo_magazine/mc9mm = 2,
			/obj/item/shield/energy = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/grenade/frag = 2,
			/obj/item/grenade/flashbang = 2
	)

	l_hand = /obj/item/gun/projectile/shotgun/pump/combat/sol

	accessory = /obj/item/clothing/accessory/storage/bandolier
	accessory_contents = list(/obj/item/ammo_casing/shotgun = 8,
							/obj/item/ammo_casing/shotgun/pellet = 8)