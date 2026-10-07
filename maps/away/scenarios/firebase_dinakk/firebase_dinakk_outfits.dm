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
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/tank/emergency_oxygen/double = 1,
	)
