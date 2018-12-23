/datum/outfit
	var/name = "Naked"
	var/collect_not_del = FALSE

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/l_hand = null
	var/r_hand = null
	var/pda = null
	var/internals_slot = null //ID of slot containing a gas tank
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format
	var/list/implants = null
	var/list/cybernetic_implants = null


/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for customization depending on client prefs,species etc
	return

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del.
/datum/outfit/proc/equip_item(mob/living/carbon/human/H, path, slot)
	var/obj/item/I = new path(H)
	if(collect_not_del)
		H.equip_or_collect(I, slot)
	else
		H.equip_to_slot_or_del(I, slot)

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for toggling internals
	imprint_idcard_pda(H)
	return

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	pre_equip(H, visualsOnly)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		equip_item(H, uniform, slot_w_uniform)
	if(suit)
		equip_item(H, suit, slot_wear_suit)
	if(back)
		equip_item(H, back, slot_back)
	if(belt)
		equip_item(H, belt, slot_belt)
	if(gloves)
		equip_item(H, gloves, slot_gloves)
	if(shoes)
		equip_item(H, shoes, slot_shoes)
	if(head)
		equip_item(H, head, slot_head)
	if(mask)
		equip_item(H, mask, slot_wear_mask)
	if(l_ear)
		equip_item(H, l_ear, slot_l_ear)
	if(r_ear)
		equip_item(H, r_ear, slot_r_ear)
	if(glasses)
		equip_item(H, glasses, slot_glasses)

	if(suit_store)
		equip_item(H, suit_store, slot_s_store)

	if(l_hand)
		H.put_in_l_hand(new l_hand(H))
	if(r_hand)
		H.put_in_r_hand(new r_hand(H))

	if(pda)
		var/obj/item/I = new pda(H)
		H.equip_or_collect(I, slot_wear_id)

	if(id)
		var/obj/item/device/pda/P = H.wear_id
		var/obj/item/I = new id(H)
		if(istype(P))
			I.forceMove(P)
			P.id = I
		else
			H.equip_or_collect(I, slot_wear_id)


	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			equip_item(H, l_pocket, slot_l_store)
		if(r_pocket)
			equip_item(H, r_pocket, slot_r_store)

		for(var/path in backpack_contents)
			var/number = backpack_contents[path]
			for(var/i in 1 to number)
				H.equip_or_collect(new path(H), slot_in_backpack)

	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)

	if(implants)
		for(var/implant_type in implants)
			var/obj/item/weapon/implant/I = new implant_type(H)
			if(I.implanted(H))
				I.forceMove(H)
				I.imp_in = H
				I.implanted = 1
				var/obj/item/organ/external/affected = H.get_organ("head")
				affected.implants += I
				I.part = affected

	H.update_body()
	return 1

/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H, 1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H, 1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H, 1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H, 1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H, 1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H, 1)
	if(H.head)
		H.head.add_fingerprint(H, 1)
	if(H.shoes)
		H.shoes.add_fingerprint(H, 1)
	if(H.gloves)
		H.gloves.add_fingerprint(H, 1)
	if(H.l_ear)
		H.l_ear.add_fingerprint(H, 1)
	if(H.r_ear)
		H.r_ear.add_fingerprint(H, 1)
	if(H.glasses)
		H.glasses.add_fingerprint(H, 1)
	if(H.belt)
		H.belt.add_fingerprint(H, 1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H, 1)
	if(H.s_store)
		H.s_store.add_fingerprint(H, 1)
	if(H.l_store)
		H.l_store.add_fingerprint(H, 1)
	if(H.r_store)
		H.r_store.add_fingerprint(H, 1)
	return 1


/datum/outfit/proc/imprint_idcard_pda(mob/living/carbon/human/H)
	//Check if there is a PDA or a ID in the id slot
	if(istype(H.wear_id,/obj/item/device/pda))
		var/obj/item/device/pda/PDA = H.wear_id
		//Imprint the ID in the PDA
		imprint_idcard(H,PDA.id)

		//Update the PDA with the data from the ID
		imprint_pda(H,PDA)
	else if (istype(H.wear_id,/obj/item/weapon/card/id))
		imprint_idcard(H,H.wear_id)
		

/datum/outfit/proc/imprint_idcard(mob/living/carbon/human/H, obj/item/weapon/card/id/C)
	if(istype(C))
		C.access = get_id_access(H)
		C.rank = get_id_rank(H)
		C.assignment = get_id_assignment(H)
		addtimer(CALLBACK(H, /mob/.proc/set_id_info, C), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		if(H.mind && H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number

/datum/outfit/proc/imprint_pda(mob/living/carbon/human/H, obj/item/device/pda/PDA)
	var/obj/item/weapon/card/id/C = PDA.id
	if(istype(PDA) && istype(C))
		PDA.owner = H.real_name
		PDA.ownjob = C.assignment
		PDA.ownrank = C.rank
		PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"

/datum/outfit/proc/get_id_access(mob/living/carbon/human/H)
	return list()

/datum/outfit/proc/get_id_assignment(mob/living/carbon/human/H)
	return GetAssignment(H)

/datum/outfit/proc/get_id_rank(mob/living/carbon/human/H)
	return GetAssignment(H)