/datum/outfit/admin/ert/gun_merchant
	name = "Gun Merchant"

	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/softcap
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	shoes = /obj/item/clothing/shoes/laceup/all_species
	gloves = /obj/item/clothing/gloves/black
	belt = /obj/item/storage/belt/fannypack/black
	back = /obj/item/storage/backpack/duffel
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/mateba = 1)
	id = /obj/item/card/id/distress/gun_merchant

	l_ear = /obj/item/device/radio/headset

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/device/price_scanner = 1
	)

	belt_contents = list(
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/advanced/ointment = 1
	)

/datum/outfit/admin/ert/gun_merchant/get_id_access()
	return get_distress_access()