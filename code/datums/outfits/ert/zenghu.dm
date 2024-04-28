/obj/outfit/admin/ert/zeng
	name = "Zeng-Hu ERT"
	uniform = /obj/item/clothing/under/rank/security/zeng
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/recharger_backpack/high
	suit = /obj/item/clothing/suit/space/void/zenghu
	head = /obj/item/clothing/head/helmet/space/void/zenghu
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/distress
	id = /obj/item/card/id/zeng_hu
	mask = /obj/item/clothing/mask/gas/tactical
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	suit_store = /obj/item/gun/energy/rifle
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/energy/toxgun = 1
	)
	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/device/flash = 1,
			/obj/item/handcuffs/ziptie = 2,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2
	)
	id_iff = IFF_ZENGHU

/obj/outfit/admin/ert/zeng/get_id_access()
	return get_distress_access()

/obj/outfit/admin/ert/zeng/medic
	name = "Zeng-Hu Medic"
	uniform = /obj/item/clothing/under/rank/medical/first_responder/zeng
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/gun/energy/toxgun = 1
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

/obj/outfit/admin/ert/zeng/engineer
	name = "Zeng-Hu Engineer"
	back = /obj/item/storage/backpack/duffel/zeng
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow

	accessory = /obj/item/clothing/accessory/storage/white_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/energy/toxgun = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/zeng/leader
	name = "Zeng-Hu Squad Leader"
	accessory_contents = list(
		/obj/item/gun/energy/decloner = 1
	)
