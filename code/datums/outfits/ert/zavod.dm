/obj/outfit/admin/ert/zavodskoi
	name = "Zavodskoi Asset Protection"
	uniform = /obj/item/clothing/under/rank/security/zavod/zavodsec
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/zavod
	suit = /obj/item/clothing/suit/space/void/zavodskoi
	head = /obj/item/clothing/head/helmet/space/void/zavodskoi
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/distress
	id = /obj/item/card/id/zavodskoi
	mask = /obj/item/clothing/mask/gas/tactical
	glasses = /obj/item/clothing/glasses/safety/goggles/goon/zavod
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	suit_store = /obj/item/gun/projectile/automatic/rifle/z8
	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/pistol)
	belt_contents = list(
			/obj/item/handcuffs/ziptie = 1,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/frag = 2,
			/obj/item/ammo_magazine/mc9mm = 2,
			/obj/item/ammo_magazine/a556 = 2
	)
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/grenade/flashbang = 2
	)
	id_iff = IFF_ZAVOD

/obj/outfit/admin/ert/zavodskoi/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/zavodskoi/get_id_access()
	return get_distress_access()

/obj/outfit/admin/ert/zavodskoi/medic
	name = "Zavodskoi Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/gun/projectile/pistol = 1,
		/obj/item/ammo_magazine/a556 = 2
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

/obj/outfit/admin/ert/zavodskoi/engi
	name = "Zavodskoi Engineer"
	uniform = /obj/item/clothing/under/rank/engineer/zavod
	back = /obj/item/storage/backpack/duffel/zavod
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow

	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/gun/projectile/pistol = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/zavodskoi/lead
	name = "Zavodskoi Squad Leader"
	accessory_contents = list(
		/obj/item/gun/projectile/revolver = 1
	)
	belt_contents = list(
			/obj/item/handcuffs/ziptie = 1,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/frag = 2,
			/obj/item/ammo_magazine/a357 = 2,
			/obj/item/ammo_magazine/a556 = 2
	)
