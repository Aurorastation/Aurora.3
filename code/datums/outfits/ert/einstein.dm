/obj/outfit/admin/ert/einstein
	name = "Einstein Engines ERT"
	uniform = /obj/item/clothing/under/rank/security/einstein
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/space/void/einstein
	head = /obj/item/clothing/head/helmet/space/void/einstein
	back = /obj/item/tank/jetpack/carbondioxide
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/distress
	id = /obj/item/card/id/zeng_hu
	mask = /obj/item/clothing/mask/gas/tactical
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	suit_store = /obj/item/gun/energy/gun/nuclear
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/projectile/colt = 1
	)
	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2,
			/obj/item/ammo_magazine/c45m = 2
	)
	id_iff = IFF_EE

/obj/outfit/admin/ert/einstein/get_id_access()
	return get_distress_access_lesser()

/obj/outfit/admin/ert/einstein/medic
	name = "Einstein Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	backpack = /obj/item/storage/backpack/satchel/med
	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/gun/projectile/colt = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

/obj/outfit/admin/ert/einstein/engi
	name = "Einstein Engineer"
	uniform = /obj/item/clothing/under/rank/engineer/einstein
	back = /obj/item/storage/backpack/industrial
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow

	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/projectile/colt = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/einstein/leader
	name = "Einstein Squad Leader"
	back = /obj/item/rig/merc/einstein
	l_hand = /obj/item/gun/energy/gun/nuclear
	suit_store = null
	suit = null
	head = null
