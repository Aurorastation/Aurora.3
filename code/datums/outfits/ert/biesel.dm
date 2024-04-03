/obj/outfit/admin/ert/tcaf
	name = "Republican Fleet Legionary"
	uniform = /obj/item/clothing/under/legion/tcaf
	suit = /obj/item/clothing/suit/space/void/tcaf
	head = /obj/item/clothing/head/helmet/space/void/tcaf
	gloves = /obj/item/clothing/gloves/tcaf
	glasses = /obj/item/clothing/glasses/safety/goggles/tactical/generic
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id
	accessory = /obj/item/clothing/accessory/holster/hip
	l_ear = /obj/item/device/radio/headset/legion
	r_pocket = /obj/item/crowbar/red
	l_pocket = /obj/item/tank/emergency_oxygen/double
	back = /obj/item/storage/backpack/tcaf
	mask = /obj/item/clothing/mask/gas
	suit_store = /obj/item/gun/energy/blaster/tcaf
	accessory_contents = list(/obj/item/gun/energy/blaster/revolver = 1)
	id = /obj/item/card/id/distress/legion/tcaf
	belt = /obj/item/storage/belt/military
	belt_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/shield/energy/legion = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/frag = 1
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/vaurca
	)
	id_iff = IFF_TCFL

/obj/outfit/admin/ert/tcaf/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/tactical(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		var/list/fullname = splittext(H.real_name, " ")
		var/surname = fullname[fullname.len] //prefix bumps it up
		switch(surname)
			if("K'lax")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
			if("C'thur")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
		var/obj/item/organ/B = new /obj/item/organ/internal/augment/hiveshield(H)
		var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
		B.replaced(H, affectedB)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/tcaf/get_id_access(mob/living/carbon/human/H)
	return get_distress_access()

/obj/outfit/admin/ert/tcaf/medic
	name = "Republican Fleet Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/latex/nitrile/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/gloves/latex/nitrile/vaurca,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/gloves/latex/nitrile/vaurca,
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
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/shield/energy/legion = 1
	)

/obj/outfit/admin/ert/tcaf/engi
	name = "Republican Fleet Engineer"
	belt = /obj/item/storage/belt/utility/very_full
	belt_contents = null
	gloves = /obj/item/clothing/gloves/yellow
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu,
		SPECIES_TAJARA = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_VAURCA_WARRIOR = null,
		SPECIES_VAURCA_WORKER = null
	)
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)
	backpack_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/shield/energy/legion = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/energy/blaster/revolver = 1,
		/obj/item/grenade/frag = 2
	)

/obj/outfit/admin/ert/tcaf/officer
	accessory = /obj/item/clothing/accessory/legion
