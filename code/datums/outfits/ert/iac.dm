/datum/outfit/admin/ert/iac
	name = "IAC Doctor"

	uniform = /obj/item/clothing/under/rank/iacjumpsuit
	suit = /obj/item/clothing/suit/storage/iacvest
	head = /obj/item/clothing/head/soft/iacberet
	mask = /obj/item/clothing/mask/surgical
	glasses = /obj/item/clothing/glasses/hud/health/aviator
	shoes = /obj/item/clothing/shoes/iac
	gloves = /obj/item/clothing/gloves/white
	belt = /obj/item/storage/belt/medical
	back = /obj/item/storage/backpack/satchel_med
	accessory = /obj/item/clothing/accessory/storage/white_vest
	accessory_contents = list(/obj/item/reagent_containers/hypospray/cmo = 1, /obj/item/storage/pill_bottle/dexalin_plus = 1, /obj/item/storage/pill_bottle/tramadol = 1)
	id = /obj/item/card/id/distress/iac

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/regular = 2,
		/obj/item/storage/firstaid/surgery = 1,
		/obj/item/storage/box/gloves = 1,
		/obj/item/storage/box/syringes = 1,
		/obj/item/device/flashlight/pen = 1
	)

	belt_contents = list(
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/reagent_containers/glass/bottle/norepinephrine = 1
	)

/datum/outfit/admin/ert/iac/get_id_access()
	return get_distress_access()

/datum/outfit/admin/iac/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(H?.w_uniform)
		var/obj/item/clothing/uniform = H.w_uniform
		var/obj/item/clothing/accessory/armband/iac/armband = new(src)
		uniform.attach_accessory(null, armband)

	if(!H.shoes)
		var/obj/item/clothing/shoes/footwraps = new(src)
		H.equip_to_slot_if_possible(footwraps, slot_shoes)

/datum/outfit/admin/ert/iac/bodyguard
	name = "IAC Bodyguard"

	accessory = /obj/item/clothing/accessory/storage/black_vest
	accessory_contents = list(/obj/item/reagent_containers/hypospray/autoinjector/norepinephrine = 2, /obj/item/reagent_containers/hypospray/autoinjector/survival = 1)
	suit = /obj/item/clothing/suit/storage/vest/heavy
	head = /obj/item/clothing/head/helmet/iachelmet
	mask = /obj/item/clothing/mask/gas/alt
	glasses =  /obj/item/clothing/glasses/sunglasses
	suit_store = /obj/item/gun/energy/gun
	back = /obj/item/storage/backpack/ert/medical
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/security

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/gun/projectile/automatic/x9 = 1
	)

	belt_contents = list(
		/obj/item/ammo_magazine/c45x = 2,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/device/flashlight/flare = 1
	)

/datum/outfit/admin/ert/iac/paramedic
	name = "IAC Paramedic"

	head = /obj/item/clothing/head/helmet/iachelmet
	mask = /obj/item/clothing/mask/balaclava/iac
	back = /obj/item/storage/backpack/messenger/med
	glasses = /obj/item/clothing/glasses/hud/health

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/storage/firstaid/adv = 2,
		/obj/item/storage/firstaid/o2 = 1,
		/obj/item/storage/box/syringes = 1
	)
