/datum/outfit/admin/event/lance
	name = "Lancer"

	uniform = /obj/item/clothing/under/lance
	back = /obj/item/gun/energy/rifle/pulse
	gloves = /obj/item/clothing/gloves/force/basic
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/ert

	head = /obj/item/clothing/head/helmet/space/void/lancer
	species_head = list(
		SPECIES_UNATHI = /obj/item/clothing/head/helmet/space/void/lancer/unathi
	)

	suit = /obj/item/clothing/suit/space/void/lancer
	species_suit = list(
		SPECIES_UNATHI = /obj/item/clothing/suit/space/void/lancer/unathi
	)
	suit_store = /obj/item/tank/oxygen

	shoes = /obj/item/clothing/shoes/jackboots
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless
	)

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

	id = /obj/item/card/id/syndicate
	id_iff = IFF_LANCER
	var/id_access = "Lancer"

/datum/outfit/admin/event/lance/post_equip(mob/living/carbon/human/H, visualsOnly)
	organize_voidsuit(H)

/datum/outfit/admin/event/lance/get_id_access()
	return get_syndicate_access(id_access)

/datum/outfit/admin/event/lance/engineer
	name = "Lance Engineer"

	back = /obj/item/gun/projectile/shotgun/pump/combat/sol

	gloves = /obj/item/clothing/gloves/yellow
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu
	)

	belt = /obj/item/storage/belt/utility/very_full
	belt_contents = null

	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
			/obj/item/plastique = 3,
			/obj/item/grenade/frag = 1,
			/obj/item/device/flash = 1
	)
	id_access = "Lance Engineer"

/datum/outfit/admin/event/lance/medic
	name = "Lance Medic"

	gloves = /obj/item/clothing/gloves/latex/nitrile
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/latex/nitrile/unathi
	)

	belt = /obj/item/storage/belt/medical
	mask = /obj/item/clothing/mask/surgical

	l_pocket = /obj/item/reagent_containers/glass/bottle/inaprovaline
	r_pocket = /obj/item/reagent_containers/glass/bottle/thetamycin

	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)
	belt_contents = list(
			/obj/item/device/healthanalyzer = 1,
			/obj/item/reagent_containers/hypospray/combat = 1,
			/obj/item/reagent_containers/syringe = 1,
			/obj/item/personal_inhaler/combat = 1,
			/obj/item/reagent_containers/personal_inhaler_cartridge/large = 2,
			/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1
			)
	id_access = "Lance Medic"

/datum/outfit/admin/event/lance/operative
	name = "Lance Operative"

	uniform = /obj/item/clothing/under/dress/lance_dress/male
	back = /obj/item/storage/backpack/satchel/leather
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/storage/belt/utility/very_full
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pulse/pistol = 1)

	backpack_contents = list(
		/obj/item/device/flash = 1,
		/obj/item/clothing/gloves/yellow = 1
	)
	id_access = "Lance Operative"

/datum/outfit/admin/event/lance/operative/post_equip(mob/living/carbon/human/H, visualsOnly)
	return

/datum/outfit/admin/event/sol_marine
	name = "Solarian Marine"

	uniform = /obj/item/clothing/under/rank/sol
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

	id_iff = IFF_SOL

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
