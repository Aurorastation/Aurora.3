/datum/outfit/admin/megacorp/hephaestus_trooper
	name = "Hephaestus Asset Protection"

	uniform = /obj/item/clothing/under/rank/engineer/apprentice/heph
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/syndicate
	suit_store = /obj/item/gun/energy/laser
	suit = /obj/item/clothing/suit/space/void/hephaestus
	head = /obj/item/clothing/head/helmet/space/void/hephaestus
	id = /obj/item/card/id/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/energy/stunrevolver = 1)

	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2
	)
	id_iff = IFF_HEPH

/datum/outfit/admin/megacorp/hephaestus_trooper/heavy
	name = "Hephaestus Heavy Asset Protection"

	back = /obj/item/gun/projectile/shotgun/pump/combat
	gloves = /obj/item/clothing/gloves/force
	glasses = /obj/item/clothing/glasses/thermal

	accessory = /obj/item/clothing/accessory/storage/bandolier
	accessory_contents = list(
			/obj/item/ammo_casing/shotgun = 8,
			/obj/item/ammo_casing/shotgun/pellet = 8
	)

/datum/outfit/admin/megacorp/zenghu_trooper
	name = "Zeng Hu Pharmaceuticals Asset Protection"

	uniform = /obj/item/clothing/under/rank/medical/first_responder/zeng
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/syndicate
	suit_store = /obj/item/gun/energy/laser
	suit = /obj/item/clothing/suit/space/void/zenghu
	head = /obj/item/clothing/head/helmet/space/void/zenghu
	id = /obj/item/card/id/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/energy/toxgun = 1)

	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2
	)
	id_iff = IFF_ZENGHU

/datum/outfit/admin/megacorp/zenghu_trooper/heavy
	name = "Zeng Hu Pharmaceuticals Heavy Asset Protection"

	gloves = /obj/item/clothing/gloves/force
	glasses = /obj/item/clothing/glasses/thermal

	accessory_contents = list(/obj/item/gun/energy/decloner = 1)

/datum/outfit/admin/megacorp/zavodskoi_trooper
	name = "Zavodskoi Interstellar Asset Protection"

	uniform = /obj/item/clothing/under/rank/security/zavod
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/magboots
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/syndicate
	suit_store = /obj/item/gun/projectile/automatic/wt550
	suit = /obj/item/clothing/suit/space/void/zavodskoi
	head = /obj/item/clothing/head/helmet/space/void/zavodskoi
	id = /obj/item/card/id/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/pistol = 1)

	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2
	)

	backpack_contents = list(
			/obj/item/ammo_magazine/mc9mmt/rubber = 3,
			/obj/item/ammo_magazine/mc9mmt = 2,
			/obj/item/ammo_magazine/mc9mm = 3
	)
	id_iff = IFF_ZAVOD

/datum/outfit/admin/megacorp/zavodskoi_trooper/heavy
	name = "Zavodskoi Interstellar Heavy Asset Protection"

	gloves = /obj/item/clothing/gloves/force
	glasses = /obj/item/clothing/glasses/thermal

	accessory_contents = list(/obj/item/gun/projectile/revolver = 1)

	suit_store = /obj/item/gun/projectile/automatic/rifle/sol

	backpack_contents = list(
			/obj/item/ammo_magazine/a357 = 3,
			/obj/item/ammo_magazine/c762/sol = 2
	)

/datum/outfit/admin/megacorp/einstein_trooper/heavy
	name = "Einstein Engines Asset Protection"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	back = /obj/item/rig/ert/assetprotection/einstein
	belt = /obj/item/storage/belt/security/tactical
	shoes = null
	gloves = null
	mask = /obj/item/clothing/mask/gas/swat
	l_ear = /obj/item/device/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	id = /obj/item/card/id/syndicate
	l_pocket = /obj/item/plastique
	r_pocket = /obj/item/melee/energy/sword
	l_hand = /obj/item/gun/energy/rifle/pulse
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/mateba = 1)

	belt_contents = list(
		/obj/item/ammo_magazine/a454 = 2,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/grenade/flashbang = 2,
		/obj/item/handcuffs = 2,
		/obj/item/grenade/frag = 1
	)
	id_iff = IFF_EE
