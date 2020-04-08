/datum/outfit/admin/ert/kataphract
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/unathi
	head = /obj/item/clothing/head/helmet/space/void/kataphract
	suit = /obj/item/clothing/suit/space/void/kataphract
	suit_store = /obj/item/tank/oxygen/brown
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/caligae/grey
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)
	gloves = /obj/item/clothing/gloves/black/unathi
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony

	l_ear = /obj/item/device/radio/headset/distress

	r_pocket = /obj/item/device/radio

	belt_contents = null

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/box/donkpockets = 1
	)

/datum/outfit/admin/ert/kataphract/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/datum/outfit/admin/ert/kataphract/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/kataphract/klax
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/vaurca
	head = /obj/item/clothing/head/helmet/unathi/klax
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	suit = /obj/item/clothing/suit/armor/unathi/klax
	suit_store = /obj/item/gun/launcher/grenade
	shoes = /obj/item/clothing/shoes/vaurca
	gloves = null

	l_hand = /obj/item/martial_manual/vaurca

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/box/smokebombs = 1,
		/obj/item/storage/box/anti_photons = 1,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 3
	)

/datum/outfit/admin/ert/kataphract/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ["phoron reserve tank"])
		var/obj/item/organ/vaurca/preserve/preserve = H.internal_organs_by_name["phoron reserve tank"]
		H.internals = preserve

	var/uniform_colour = pick("#42b360", "#b68029", "#5574c2")
	if(H?.w_uniform)
		H.w_uniform.color = uniform_colour
	if(H?.shoes)
		H.shoes.color = uniform_colour
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/datum/outfit/admin/ert/kataphract/specialist
	name = "Kataphract-Hopeful Spec."

	head = /obj/item/clothing/head/helmet/space/void/kataphract/spec
	suit = /obj/item/clothing/suit/space/void/kataphract/spec
	belt = /obj/item/storage/belt/medical
	l_hand = /obj/item/melee/hammer/powered/hegemony

	belt_contents = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1
	)

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/storage/box/donkpockets = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/firstaid/adv = 1
	)

/datum/outfit/admin/ert/kataphract/specialist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/datum/outfit/admin/ert/kataphract/leader
	name = "Kataphract Knight"

	head = /obj/item/clothing/head/helmet/space/void/kataphract/lead
	suit = /obj/item/clothing/suit/space/void/kataphract/lead
	glasses = /obj/item/clothing/glasses/thermal

/datum/outfit/admin/ert/kataphract/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)