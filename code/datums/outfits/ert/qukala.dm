/obj/outfit/admin/ert/qukala
	name = "Qukala Emergency Responder"
	uniform = /obj/item/clothing/under/skrell/qukala
	shoes = /obj/item/clothing/shoes/jackboots/kala
	gloves = /obj/item/clothing/gloves/kala
	accessory = /obj/item/clothing/accessory/holster/hip
	suit = /obj/item/clothing/suit/space/void/kala
	head = /obj/item/clothing/head/helmet/space/void/kala
	back = /obj/item/storage/backpack/kala
	suit_store = /obj/item/gun/energy/gun/qukala
	l_ear = /obj/item/device/radio/headset/distress
	l_pocket = /obj/item/tank/emergency_oxygen/double
	id = /obj/item/card/id
	backpack_contents = list(
		/obj/item/storage/box/survival = 1
	)
	belt = /obj/item/storage/belt/military
	species_suit = list( //bugs and trees can't use the skroidsuits
		SPECIES_VAURCA_WORKER = /obj/item/clothing/suit/storage/vest/kala,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/suit/storage/vest/kala,
		SPECIES_DIONA = /obj/item/clothing/suit/storage/vest/kala
	)
	species_head = list( //until we get non-skrell kala helmets
		SPECIES_VAURCA_WORKER = /obj/item/clothing/head/helmet/tactical,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/head/helmet/tactical,
		SPECIES_DIONA = /obj/item/clothing/head/helmet/tactical
	)
	species_shoes = list(
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca,
		SPECIES_DIONA = null
	)
	belt_contents = list(
		/obj/item/melee/telebaton/nlom = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/empgrenade = 1,
		/obj/item/crowbar/red = 1
	)

/obj/outfit/admin/ert/qukala/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/tactical(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		var/obj/item/organ/B = new /obj/item/organ/internal/augment/hiveshield/warfare(H)
		var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
		B.replaced(H, affectedB)
		H.update_body()
	if(H.is_diona())
		H.equip_or_collect(new /obj/item/device/uv_light(src), slot_in_backpack)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/advance/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
	if(isskrell(H))
		H.equip_or_collect(new /obj/item/gun/energy/fedpistol(src), slot_in_backpack)
	else
		H.equip_or_collect(new /obj/item/gun/energy/fedpistol/nopsi(src), slot_in_backpack)

/obj/outfit/admin/ert/qukala/get_id_access()
	return list(ACCESS_DISTRESS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SKRELL)

/obj/outfit/admin/ert/qukala/medic
	name = "Qukala Medic"
	suit = /obj/item/clothing/suit/space/void/kala/med
	head = /obj/item/clothing/head/helmet/space/void/kala/med
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	species_gloves = list(
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/gloves/latex/nitrile/vaurca,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/gloves/latex/nitrile/vaurca,
		SPECIES_DIONA = null
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/telebaton/nlom = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/crowbar/red = 1,
		/obj/item/roller/hover = 1
	)

/obj/outfit/admin/ert/qukala/engi
	name = "Qukala Engineer"
	suit = /obj/item/clothing/suit/space/void/kala/engineering
	head = /obj/item/clothing/head/helmet/space/void/kala/engineering
	gloves = /obj/item/clothing/gloves/yellow
	belt = /obj/item/storage/belt/utility/very_full
	glasses = /obj/item/clothing/glasses/welding/superior
	species_gloves = list(
		SPECIES_VAURCA_WARRIOR = null,
		SPECIES_VAURCA_WORKER = null,
		SPECIES_DIONA = null
	)
	accessory = /obj/item/clothing/accessory/storage/white_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/energy/blaster/revolver = 1,
		/obj/item/melee/telebaton/nlom = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/empgrenade = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/qukala/heavy
	name = "Qukala Heavy Trooper"
	suit = null
	head = null
	suit_store = null
	back = /obj/item/rig/skrell/equipped
	backpack_contents = list()
	mask = /obj/item/clothing/mask/gas/tactical
	r_hand = /obj/item/gun/energy/rifle/laser/qukala
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/energy/fedpistol = 1
	)

/obj/outfit/admin/ert/qukala/heavy/post_equip(mob/living/carbon/human/H, visualsOnly)

/obj/outfit/admin/ert/qukala/officer
	suit = /obj/item/clothing/suit/space/void/kala/leader
	head = /obj/item/clothing/head/helmet/space/void/kala/leader
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/energy/fedpistol = 1
	)

/obj/outfit/admin/ert/qukala/officer/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/advance/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)
