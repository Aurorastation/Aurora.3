/obj/outfit/admin/ert/kataphract
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/unathi
	head = /obj/item/clothing/head/helmet/space/void/kataphract
	suit = /obj/item/clothing/suit/space/void/kataphract
	suit_store = /obj/item/tank/oxygen/brown
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/sandals/caligae/socks
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)
	gloves = /obj/item/clothing/gloves/black/unathi
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony

	l_ear = /obj/item/device/radio/headset/distress
	l_hand = /obj/item/martial_manual/swordsmanship

	r_pocket = /obj/item/device/radio

	belt_contents = null

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony/kataphract = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/box/donkpockets = 1
	)

	id_iff = IFF_KATAPHRACT

/obj/outfit/admin/ert/kataphract/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
		H.w_uniform.accent_color = H.w_uniform.color
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/kataphract/get_id_access()
	return get_distress_access_lesser()

/obj/outfit/admin/ert/kataphract/klax
	name = "Kataphract-Hopeful Klax"

	uniform = /obj/item/clothing/under/vaurca
	head = /obj/item/clothing/head/helmet/unathi/klax
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	suit = /obj/item/clothing/suit/armor/unathi/klax
	suit_store = /obj/item/gun/launcher/grenade
	shoes = /obj/item/clothing/shoes/vaurca
	gloves = null

	l_hand = /obj/item/martial_manual/vaurca
	l_pocket = /obj/item/melee/energy/sword/hegemony

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony/kataphract = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/box/smokebombs = 1,
		/obj/item/storage/box/anti_photons = 1,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 3
	)

/obj/outfit/admin/ert/kataphract/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/uniform_colour = pick("#42b360", "#b68029", "#5574c2")
	if(H?.w_uniform)
		H.w_uniform.color = uniform_colour
	if(H?.shoes)
		H.shoes.color = uniform_colour
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/obj/outfit/admin/ert/kataphract/specialist
	name = "Kataphract-Hopeful Spec."

	head = /obj/item/clothing/head/helmet/space/void/kataphract/spec
	suit = /obj/item/clothing/suit/space/void/kataphract/spec
	belt = /obj/item/storage/belt/medical/first_responder/combat
	l_hand = /obj/item/melee/hammer/powered/hegemony

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/storage/box/donkpockets = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 1
	)

/obj/outfit/admin/ert/kataphract/specialist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/kataphract/leader
	name = "Kataphract Knight"

	head = /obj/item/clothing/head/helmet/space/void/kataphract/lead
	suit = /obj/item/clothing/suit/space/void/kataphract/lead
	glasses = /obj/item/clothing/glasses/thermal

/obj/outfit/admin/ert/kataphract/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42b360", "#b68029", "#5574c2")
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
