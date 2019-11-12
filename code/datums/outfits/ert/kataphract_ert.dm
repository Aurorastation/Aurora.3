/datum/outfit/admin/ert/kataphract
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/unathi
	head = /obj/item/clothing/head/helmet/space/void/kataphract
	suit = /obj/item/clothing/suit/space/void/kataphract
	suit_store = /obj/item/weapon/tank/oxygen/yellow
	belt = /obj/item/weapon/melee/energy/sword/pirate/generic
	shoes = /obj/item/clothing/shoes/caligae/grey
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/weapon/gun/energy/pistol = 1)
	gloves = /obj/item/clothing/gloves/black/unathi
	id = /obj/item/weapon/card/id/distress/kataphract
	back = /obj/item/weapon/storage/backpack/cultpack/adorned

	l_ear = /obj/item/device/radio/headset/distress

	r_pocket = /obj/item/device/radio

	belt_contents = null

	backpack_contents = list(
		/obj/item/weapon/handcuffs/ziptie = 2,
		/obj/item/weapon/shield/riot/tact = 1,
		/obj/item/weapon/crowbar = 1,
		/obj/item/weapon/storage/box/donkpockets = 1
	)

/datum/outfit/admin/ert/kataphract/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_suit)
		var/obj/item/clothing/accessory/poncho/big/poncho = new(H)
		var/obj/item/clothing/suit/space/void/kataphract/S = H.wear_suit
		S.attach_accessory(null, poncho)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/datum/outfit/admin/ert/kataphract/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/kataphract/specialist
	name = "Kataphract-Hopeful Spec."

	belt = /obj/item/weapon/storage/belt/medical
	l_hand = /obj/item/weapon/melee/hammer/powered

	belt_contents = list(
		/obj/item/weapon/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/thetamycin = 1
	)

	backpack_contents = list(
		/obj/item/weapon/handcuffs/ziptie = 2,
		/obj/item/weapon/shield/riot/tact = 1,
		/obj/item/weapon/storage/box/donkpockets = 1,
		/obj/item/weapon/crowbar = 1,
		/obj/item/weapon/storage/firstaid/adv = 1
	)

/datum/outfit/admin/ert/kataphract/specialist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_suit)
		var/obj/item/clothing/accessory/poncho/green/big/poncho = new(H)
		var/obj/item/clothing/suit/space/void/kataphract/S = H.wear_suit
		S.attach_accessory(null, poncho)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/datum/outfit/admin/ert/kataphract/leader
	name = "Kataphract Knight"

	glasses = /obj/item/clothing/glasses/thermal

/datum/outfit/admin/ert/kataphract/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_suit)
		var/obj/item/clothing/accessory/poncho/red/big/poncho = new(H)
		var/obj/item/clothing/suit/space/void/kataphract/S = H.wear_suit
		S.attach_accessory(null, poncho)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)