/datum/outfit/admin/ert/ap_eridani
	name = "Eridani Asset Protection Specialist"

	uniform = /obj/item/clothing/under/rank/security/pmc/epmc
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/automatic/x9 = 1)
	suit = /obj/item/clothing/suit/space/void/cruiser
	head = /obj/item/clothing/head/helmet/space/void/cruiser
	mask = /obj/item/clothing/mask/gas/tactical
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/combat
	glasses =  /obj/item/clothing/glasses/sunglasses
	suit_store = /obj/item/gun/energy/rifle
	back = /obj/item/storage/backpack/satchel/sec
	belt = /obj/item/storage/belt/military
	id = /obj/item/card/id/distress/ap_eridani
	l_ear = /obj/item/device/radio/headset/distress
	l_pocket = /obj/item/grenade/chem_grenade/teargas
	r_pocket = /obj/item/tank/emergency_oxygen/double

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/survival = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/clothing/head/softcap/pmc = 1,
		/obj/item/gun/energy/gun/nuclear = 1,
		/obj/item/storage/belt/utility/very_full = 1
	)

	belt_contents = list(
		/obj/item/ammo_magazine/c45m/auto = 3,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/stunrod = 1,
		/obj/item/device/flashlight/maglight = 1,
		/obj/item/shield/riot/tact = 1,
		/obj/item/grenade/flashbang = 1
	)

	id_iff = IFF_ERIDANI

/datum/outfit/admin/ert/ap_eridani/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/ap_eridani/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(H?.w_uniform)
		var/obj/item/clothing/uniform = H.w_uniform
		var/obj/item/clothing/accessory/sleevepatch/erisec/armband = new(src)
		uniform.attach_accessory(null, armband)

	if(!H.shoes)
		var/obj/item/clothing/shoes/jackboots/toeless/shoes = new(src)
		H.equip_to_slot_if_possible(shoes, slot_shoes)

/datum/outfit/admin/ert/ap_eridani/lead
	name = "Eridani Section Leader"

	uniform = /obj/item/clothing/under/rank/security/pmc/epmc/alt
	suit = null
	head =  /obj/item/clothing/head/beret/corporate/pmc/epmc
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	back = /obj/item/rig/strike/distress
	suit_store = null
	l_hand = /obj/item/gun/energy/rifle
	r_hand = /obj/item/flame/lighter/zippo
	l_pocket = /obj/item/clothing/mask/gas/tactical
	r_pocket = /obj/item/storage/box/fancy/cigarettes/cigar

	backpack_contents = list()

	belt_contents = list(
		/obj/item/ammo_magazine/c45m/auto = 3,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/stunrod = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/shield/riot/tact = 1,
		/obj/item/melee/telebaton = 1
	)

/datum/outfit/admin/ert/ap_eridani/doctor
	name = "Eridani Medical Officer"

	uniform = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	suit = /obj/item/clothing/suit/storage/medical_chest_rig
	suit_store = /obj/item/clothing/head/hardhat/first_responder
	head =  /obj/item/clothing/head/beret/corporate/pmc/epmc
	mask = /obj/item/clothing/mask/surgical
	glasses = /obj/item/clothing/glasses/hud/health/aviator
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/latex/nitrile
	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/satchel/med
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/disruptorpistol/magnum = 1)
	r_ear = /obj/item/device/flashlight/pen
	l_pocket = /obj/item/device/healthanalyzer
	r_pocket = /obj/item/melee/telebaton
	l_hand = /obj/item/clothing/head/helmet/space/void/medical
	r_hand = /obj/item/clothing/suit/space/void/medical


	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/surgery = 1,
		/obj/item/device/advanced_healthanalyzer = 1,
		/obj/item/clothing/accessory/storage/pouches/black = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/surgery/scalpel/manager = 1,
		/obj/item/tank/emergency_oxygen/double = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
        /obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
        /obj/item/reagent_containers/glass/bottle/antitoxin = 1,
        /obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
        /obj/item/reagent_containers/glass/bottle/butazoline = 1,
        /obj/item/reagent_containers/glass/bottle/dermaline = 1,
        /obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/storage/pill_bottle/mortaphenyl = 1
	)

/datum/outfit/admin/ert/ap_eridani/corpsman
	name = "Eridani Corpsman"

	uniform = /obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	suit = /obj/item/clothing/suit/storage/medical_chest_rig
	suit_store = /obj/item/clothing/head/hardhat/first_responder
	head = /obj/item/clothing/head/softcap/pmc/epmc
	mask = /obj/item/clothing/mask/surgical
	glasses = /obj/item/clothing/glasses/hud/health/aviator
	gloves = /obj/item/clothing/gloves/latex/nitrile
	shoes = /obj/item/clothing/shoes/swat/ert
	back = /obj/item/storage/backpack/messenger/med
	belt = /obj/item/storage/belt/medical/first_responder/combat
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/disruptorpistol/magnum = 1)
	l_pocket = /obj/item/device/healthanalyzer
	r_pocket = /obj/item/crowbar
	l_hand = /obj/item/storage/firstaid/adv

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/clothing/accessory/storage/pouches/black = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/storage/pill_bottle/mortaphenyl = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
        /obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
        /obj/item/reagent_containers/glass/bottle/antitoxin = 1,
        /obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
        /obj/item/reagent_containers/glass/bottle/butazoline = 1,
        /obj/item/reagent_containers/glass/bottle/dermaline = 1,
        /obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/melee/baton/stunrod = 1
	)
