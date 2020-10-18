/datum/outfit/admin/ert/gun_merchant
	name = "Gun Merchant"

	uniform = list(
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/kilt,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/tactical
	)
	suit = /obj/item/clothing/suit/armor/vest
	head = list(
		/obj/item/clothing/head/softcap,
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/cowboy,
		/obj/item/clothing/head/fez,
		/obj/item/clothing/head/nonla,
		/obj/item/clothing/head/that
	)
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	shoes = list(
		/obj/item/clothing/shoes/laceup/all_species,
		/obj/item/clothing/shoes/laceup/brown/all_species
	)
	gloves = /obj/item/clothing/gloves/black
	belt = /obj/item/storage/belt/fannypack/black
	back = /obj/item/storage/backpack/duffel
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/mateba = 1)
	id = /obj/item/storage/wallet/random

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

/datum/outfit/admin/ert/gun_merchant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/storage/wallet/W = H.wear_id
	var/obj/item/card/id/distress/gun_merchant/passport = new(H.loc)
	passport.name = "[H.real_name]'s Passport"
	passport.access = get_id_access()
	if(W)
		W.handle_item_insertion(passport)

/datum/outfit/admin/ert/gun_merchant/get_id_access()
	return get_distress_access()