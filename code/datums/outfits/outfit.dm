/datum/outfit
	var/name = "Naked"
	var/collect_not_del = FALSE

	//The following vars can either be a path or a list of paths
	//If a list of paths is supplied a random item from that list is selected
	var/uniform = null
	var/suit = null
	var/back = null // Mutually exclusive with and will override backpack choices below. Use for RIGs, tanks, etc.
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/accessory = null

	//The following vars must be paths
	var/l_hand = null
	var/r_hand = null
	var/id = null
	var/pda = null

	// Must be paths, used to allow player-pref backpack choice
	var/allow_backbag_choice = FALSE
	var/backpack = /obj/item/storage/backpack
	var/satchel = /obj/item/storage/backpack/satchel_norm
	var/satchel_alt = /obj/item/storage/backpack/satchel
	var/dufflebag = /obj/item/storage/backpack/duffel
	var/messengerbag = /obj/item/storage/backpack/messenger

	var/internals_slot = null //ID of slot containing a gas tank
	var/list/backpack_contents = list() //In the list(path=count,otherpath=count) format
	var/list/accessory_contents = list()
	var/list/belt_contents = list() //In the list(path=count,otherpath=count) format
	var/list/implants = null //A list of implants that should be implanted

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for customization depending on client prefs,species etc
	if(allow_backbag_choice)
		var/use_job_specific = H.backbag_style == 1
		switch(H.backbag)
			if (1)
				back = null
			if (2)
				back = use_job_specific ? backpack : /obj/item/storage/backpack
			if (3)
				back = use_job_specific ? satchel : /obj/item/storage/backpack/satchel_norm
			if (4)
				back = use_job_specific ? satchel_alt : /obj/item/storage/backpack/satchel
			if (5)
				back = use_job_specific ? dufflebag : /obj/item/storage/backpack/duffel
			if (6)
				back = use_job_specific ? messengerbag : /obj/item/storage/backpack/messenger
			else
				back = backpack //Department backpack
	if(back)
		equip_item(H, back, slot_back)

	if(istype(H.back,/obj/item/storage/backpack))
		var/obj/item/storage/backpack/B = H.back
		B.autodrobe_no_remove = TRUE

	return

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del.
/datum/outfit/proc/equip_item(mob/living/carbon/human/H, path, slot)
	var/obj/item/I

	if(isnum(path))	//Check if parameter is not numeric. Must be a path, list of paths or name of a gear datum
		CRASH("Outfit [name] - Parameter path: [path] is numeric.")

	if(islist(path))	//If its a list, select a random item
		var/itempath = pick(path)
		I = new itempath(H)
	else if(gear_datums[path]) //If its something else, we´ll check if its a gearpath and try to spawn it
		var/datum/gear/G = gear_datums[path]
		I = G.spawn_random()
	else
		I = new path(H) //As fallback treat it as a path

	if(collect_not_del)
		H.equip_or_collect(I, slot)
	else
		H.equip_to_slot_or_del(I, slot)

/datum/outfit/proc/equip_accessory(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return

	var/obj/item/clothing/under/U = H.get_equipped_item(slot_w_uniform)
	if(U)
		var/obj/item/clothing/accessory/A = new accessory
		U.attach_accessory(H, A)
		if(!accessory_contents.len)
			return

		if(istype(A, /obj/item/clothing/accessory/storage))
			var/obj/item/clothing/accessory/storage/S = A
			for(var/v in accessory_contents)
				var/number = accessory_contents[v]
				for(var/i in 1 to number)
					var/obj/item/I = new v
					S.hold.insert_into_storage(I)
		else if(istype(A, /obj/item/clothing/accessory/holster))
			var/obj/item/clothing/accessory/holster/holster = A
			var/w_type = accessory_contents[1]
			var/obj/item/W = new w_type(H.loc)
			if(W)
				holster.holster(W, H)

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for changing items post equip (such as toggeling internals, ...)

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//Start with uniform,suit,backpack for additional slots
	if(back)
		equip_item(H, back, slot_back)
	if(uniform)
		equip_item(H, uniform, slot_w_uniform)
		if(accessory)
			equip_accessory(H)
	if(suit)
		equip_item(H, suit, slot_wear_suit)
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

	if(pda && !visualsOnly) //Dont equip and imprint the PDA in visuals only (preview) to avoid duplicates
		var/obj/item/I = new pda(H)
		imprint_pda(H,I)
		H.equip_or_collect(I, slot_wear_id)

	if(id)
		var/obj/item/device/pda/P = H.wear_id
		var/obj/item/I = new id(H)
		imprint_idcard(H,I)
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
		for(var/path in belt_contents)
			var/number = belt_contents[path]
			for(var/i in 1 to number)
				H.equip_or_collect(new path(H), slot_in_belt)

	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)

		if(implants)
			for(var/implant_type in implants)
				var/obj/item/implant/I = new implant_type(H)
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

/datum/outfit/proc/imprint_idcard(mob/living/carbon/human/H, obj/item/card/id/C)
	if(istype(C))
		C.access = get_id_access(H)
		C.rank = get_id_rank(H)
		C.assignment = get_id_assignment(H)
		addtimer(CALLBACK(H, /mob/.proc/set_id_info, C), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		if(H.mind && H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number

/datum/outfit/proc/imprint_pda(mob/living/carbon/human/H, obj/item/device/pda/PDA)
	var/obj/item/card/id/C = PDA.id
	PDA.owner = H.real_name
	if(istype(PDA) && istype(C))
		PDA.ownjob = C.assignment
		PDA.ownrank = C.rank
	else //As a fallback if the id isnt inside of the PDA
		PDA.ownjob = get_id_assignment(H)
		PDA.ownrank = get_id_rank(H)
	PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"

/datum/outfit/proc/get_id_access(mob/living/carbon/human/H)
	return list()

/datum/outfit/proc/get_id_assignment(mob/living/carbon/human/H)
	. = GetAssignment(H)

	if (. && . != "Unassigned" && H?.mind?.selected_faction)
		if (!H.mind.selected_faction.is_default && H.mind.selected_faction.title_suffix)
			. += " ([H.mind.selected_faction.title_suffix])"

/datum/outfit/proc/get_id_rank(mob/living/carbon/human/H)
	return GetAssignment(H)
