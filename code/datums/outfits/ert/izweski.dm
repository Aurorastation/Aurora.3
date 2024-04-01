/obj/outfit/admin/ert/izweski
	name = "Izweski Navy Crewman"
	uniform = /obj/item/clothing/under/unathi/izweski
	head = /obj/item/clothing/head/helmet/space/void/hegemony
	suit = /obj/item/clothing/suit/space/void/hegemony
	suit_store = /obj/item/gun/energy/rifle/hegemony
	belt = /obj/item/storage/belt/military
	shoes = /obj/item/clothing/shoes/sandals/caligae/socks
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)
	gloves = /obj/item/clothing/gloves/black/unathi
	back = /obj/item/recharger_backpack/high
	l_ear = /obj/item/device/radio/headset/distress
	l_pocket = /obj/item/tank/emergency_oxygen/double
	belt_contents = list(
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/flashbang = 2,
		/obj/item/crowbar = 1
	)
	id = /obj/item/card/id

/obj/outfit/admin/ert/izweski/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/izweski/get_id_access()
	return get_distress_access_lesser()

/obj/outfit/admin/ert/izweski/medic
	name = "Izweski Navy Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/satchel/hegemony
	head = /obj/item/clothing/head/helmet/space/void/hegemony/specialist
	suit = /obj/item/clothing/suit/space/void/hegemony/specialist
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
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/crowbar = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/handcuffs/ziptie = 2
	)
	gloves = /obj/item/clothing/gloves/latex/nitrile/unathi
	r_pocket = /obj/item/melee/energy/sword/hegemony

/obj/outfit/admin/ert/izweski/klax
	name = "Izweski Navy K'lax"
	uniform = /obj/item/clothing/under/vaurca
	head = /obj/item/clothing/head/helmet/unathi/klax
	mask = /obj/item/clothing/mask/gas/vaurca/tactical
	suit = /obj/item/clothing/suit/armor/unathi/klax
	shoes = /obj/item/clothing/shoes/vaurca
	gloves = null
	l_hand = /obj/item/martial_manual/vaurca
	suit_store = /obj/item/gun/projectile/heavysniper/unathi
	back = /obj/item/storage/backpack/satchel/hegemony
	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/ammo_casing/slugger = 5
	)

/obj/outfit/admin/ert/izweski/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/hegemony/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/obj/outfit/admin/ert/izweski/leader
	name = "Izweski Navy Squad Leader"
	uniform = /obj/item/clothing/under/unathi/izweski/officer
	l_hand = /obj/item/melee/hammer/powered/hegemony
	r_hand = /obj/item/gun/energy/rifle/hegemony
	back = /obj/item/rig/unathi/fancy/equipped
	suit_store = null
	suit = null
	head = null

	backpack_contents = list()

	belt_contents = list(
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/handcuffs/ziptie = 2
	)

/obj/outfit/admin/ert/izweski/leader/post_equip(mob/living/carbon/human/H, visualsOnly)
