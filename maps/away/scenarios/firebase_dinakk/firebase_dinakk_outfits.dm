// ------------------ base

/obj/outfit/admin/generic/firebase_dinakk_bandit
	name = "Firebase Din'akk Bandit Uniform"
	l_ear = /obj/item/radio/headset/ship/odyssey
	id = /obj/item/card/id/syndicate
	l_pocket = /obj/item/storage/wallet/random_adhomian_knuckle
	r_pocket = /obj/item/key/door_key/firebase_dinakk_armoury

/obj/outfit/admin/generic/firebase_dinakk_bandit/get_id_access()
	return list(
		/datum/access/external_airlocks::id,
		/datum/access/firebase_dinakk_checkpoint::id,
		/datum/access/firebase_dinakk_armoury::id,
		/datum/access/firebase_dinakk_basement::id
	)

// ------------------ generic bandit
/obj/outfit/admin/generic/firebase_dinakk_bandit/generic
	name = "Firebase Din'akk Bandit = Generic Bandit"
	uniform = list(
		/obj/item/clothing/under/dressshirt/tanktop,
		/obj/item/clothing/under/dressshirt/longsleeve_s,
		/obj/item/clothing/under/dressshirt/deepv
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/greatcoat/recolor,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless
	)
	pants = list(
		/obj/item/clothing/pants/cargo,
		/obj/item/clothing/pants/mustang/colourable
	)
	shoes = /obj/item/clothing/shoes/workboots/tajara/dark
	gloves = /obj/item/clothing/gloves/fingerless
	back = /obj/item/storage/backpack/satchel/eng

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/tank/emergency_oxygen/double = 1,
	)

/obj/outfit/admin/generic/firebase_dinakk_bandit/generic/post_equip(mob/living/carbon/human/H)
	. = ..()

	H.w_uniform?.color = get_random_colour(lower = 150)
	H.w_uniform?.update_worn_icon()
	H.wear_suit?.color = get_random_colour(lower = 150)
	H.wear_suit?.accent_color = "#C0C0C0"
	H.wear_suit?.update_worn_icon()
	H.pants?.color = get_random_colour(lower = 150)
	H.pants?.update_worn_icon()

	H.equip_or_collect(new /obj/random/medical, slot_in_backpack)
	if(prob(50))
		H.equip_or_collect(new /obj/random/loot, slot_in_backpack)
	if(prob(55))
		H.equip_or_collect(new /obj/item/crowbar/red, slot_in_backpack)

// ------------------ ala deserter
/obj/outfit/admin/generic/firebase_dinakk_bandit/ala_deserter
	name = "Firebase Din'akk Bandit - ALA Deserter"

	uniform = /obj/item/clothing/under/tajaran/ala
	shoes = /obj/item/clothing/shoes/workboots/tajara/dark
	gloves = /obj/item/clothing/gloves/black_leather/tajara
	back = /obj/item/storage/backpack/satchel/eng
	accessory = null
	glasses = /obj/item/clothing/glasses/sunglasses/aviator

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/tank/emergency_oxygen/double = 1,
		/obj/item/reagent_containers/pill/cyanide = 1
	)
