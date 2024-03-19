//Zo'ra
/obj/outfit/admin/ert/zora
	name = "Zo'ra Warrior"
	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	suit = /obj/item/clothing/suit/space/void/commando
	head = /obj/item/clothing/head/helmet/space/void/commando
	mask = /obj/item/clothing/mask/gas/vaurca/tactical
	glasses = /obj/item/clothing/glasses/sunglasses/blinders
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/distress
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/energy/vaurca/blaster = 1
	)
	suit_store = /obj/item/gun/energy/rifle/laser/tachyon
	back = /obj/item/storage/backpack/cloak/zora
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1
	)
	belt = /obj/item/storage/belt/military
	belt_contents = list(
		/obj/item/melee/energy/vaurca = 1,
		/obj/item/grenade/anti_photon = 1,
		/obj/item/crowbar/red = 1,
		/obj/item/handcuffs/ziptie = 2
	)

/obj/outfit/admin/ert/zora/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
	H.internal = preserve
	H.internals.icon_state = "internal1"
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/hiveshield/warfare(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/external/hand/right/vaurca/security(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()
	if(H?.shoes)
		H.shoes.color = "#391610"
		var/obj/item/clothing/shoes/magboots/vaurca/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
	if(H?.w_uniform)
		H.w_uniform.color = "#391610"
	if(H?.glasses)
		H.glasses.color = "#391610"

/obj/outfit/admin/ert/zora/get_id_access()
	return get_distress_access_lesser()

/obj/outfit/admin/ert/zora/medic
	name = "Zo'ra Field Biotechnician"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	gloves = /obj/item/clothing/gloves/latex/nitrile/vaurca

	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/energy/vaurca = 1,
		/obj/item/roller = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/phoron = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

/obj/outfit/admin/ert/zora/medic/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
	H.internal = preserve
	H.internals.icon_state = "internal1"
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/hiveshield(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/external/hand/right/vaurca/medical(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	var/obj/item/organ/C = new /obj/item/organ/internal/augment/eye_sensors/medical(H)
	var/obj/item/organ/external/affectedC = H.get_organ(C.parent_organ)
	C.replaced(H, affectedC)
	H.update_body()
	if(H?.shoes)
		H.shoes.color = "#391610"
		var/obj/item/clothing/shoes/magboots/vaurca/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
	if(H?.w_uniform)
		H.w_uniform.color = "#391610"
	if(H?.glasses)
		H.glasses.color = "#391610"
	var/obj/item/card/id/I = H.wear_id
	I.access += (ACCESS_MEDICAL) //so the hud works

/obj/outfit/admin/ert/zora/engi
	name = "Zo'ra Sapper"
	belt = /obj/item/storage/belt/utility/very_full
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/melee/energy/vaurca = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/gun/energy/vaurca/blaster = 1,
		/obj/item/grenade/anti_photon= 1,
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/zora/engi/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/organ/C = new /obj/item/organ/internal/augment/tool/correctivelens/glare_dampener(H)
	var/obj/item/organ/external/affectedC = H.get_organ(C.parent_organ)
	C.replaced(H, affectedC)
	var/obj/item/organ/D = new /obj/item/organ/internal/augment/tool/combitool/vaurca/left(H)
	var/obj/item/organ/external/affectedD = H.get_organ(D.parent_organ)
	D.replaced(H, affectedD)
	H.update_body()

/obj/outfit/admin/ert/zora/heavy
	name = "Zo'ra Heavy"
	r_hand = /obj/item/gun/energy/vaurca/gatlinglaser
	back = /obj/item/rig/vaurca
	suit_store = null
	suit = null
	head = null

	backpack_contents = list()

//K'lax
/obj/outfit/admin/ert/klax
	name = "K'lax Warrior"
	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	suit = /obj/item/clothing/suit/armor/unathi/klax
	head = /obj/item/clothing/head/helmet/unathi/klax
	mask = /obj/item/clothing/mask/gas/vaurca/tactical
	glasses = /obj/item/clothing/glasses/sunglasses/blinders
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/distress
	r_pocket = /obj/item/crowbar/red
	accessory = /obj/item/clothing/accessory/holster/hip
	r_hand = /obj/item/recharger_backpack/high //so they can charge the hegemony weapons
	accessory_contents = list(
		/obj/item/gun/energy/pistol/hegemony = 1
	)
	suit_store = /obj/item/gun/energy/rifle/hegemony
	back = /obj/item/storage/backpack/cloak/klax
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1
	)
	belt = /obj/item/storage/belt/military
	belt_contents = list(
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/handcuffs/ziptie = 2
	)

/obj/outfit/admin/ert/klax/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
	H.internal = preserve
	H.internals.icon_state = "internal1"
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/hiveshield/warfare(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/external/hand/right/vaurca/security(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	var/obj/item/organ/C = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/affectedC = H.get_organ(C.parent_organ)
	C.replaced(H, affectedC)
	H.update_body()
	if(H?.shoes)
		H.shoes.color = "#0e3a11"
		var/obj/item/clothing/shoes/magboots/vaurca/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
	if(H?.w_uniform)
		H.w_uniform.color = "#0e3a11"
	if(H?.glasses)
		H.glasses.color = "#0e3a11"

/obj/outfit/admin/ert/klax/get_id_access()
	return get_distress_access_lesser()

/obj/outfit/admin/ert/klax/medic
	name = "K'lax Field Biotechnician"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	gloves = /obj/item/clothing/gloves/latex/nitrile/vaurca
	r_hand = null

	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/shield/energy/hegemony = 1,
		/obj/item/roller = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/phoron = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

/obj/outfit/admin/ert/klax/medic/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/organ/grasper = new /obj/item/organ/external/hand/right/vaurca/medical(H)
	var/obj/item/organ/external/arm = H.get_organ(grasper.parent_organ)
	grasper.replaced(H, arm)
	var/obj/item/organ/med = new /obj/item/organ/internal/augment/eye_sensors/medical(H)
	var/obj/item/organ/external/head = H.get_organ(med.parent_organ)
	med.replaced(H, head)
	H.update_body()
	var/obj/item/card/id/I = H.wear_id
	I.access += (ACCESS_MEDICAL) //so the hud works

/obj/outfit/admin/ert/klax/engi
	name = "K'lax Sapper"
	belt = /obj/item/storage/belt/utility/very_full
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	r_hand = null
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/melee/hammer/powered/hegemony = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/gun/energy/pistol/hegemony = 1,
		/obj/item/grenade/anti_photon= 1,
		/obj/item/reagent_containers/food/snacks/koisbar = 3,
		/obj/item/reagent_containers/inhaler/phoron_special = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/klax/engi/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/organ/weld = new /obj/item/organ/internal/augment/tool/correctivelens/glare_dampener(H)
	var/obj/item/organ/external/head = H.get_organ(weld.parent_organ)
	weld.replaced(H, head)
	var/obj/item/organ/tool = new /obj/item/organ/internal/augment/tool/combitool/vaurca/left(H)
	var/obj/item/organ/external/hand = H.get_organ(tool.parent_organ)
	tool.replaced(H, hand)
	H.update_body()

/obj/outfit/admin/ert/klax/heavy
	name = "K'lax Heavy"
	r_hand = /obj/item/melee/energy/vaurca_zweihander
	back = /obj/item/rig/vaurca
	suit_store = null
	suit = null
	head = null

	backpack_contents = list()
