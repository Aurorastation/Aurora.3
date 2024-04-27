
/// General outfit abstraction.
/// To be used for both a mob's outfit (for a ghostspawner, ship/station job, corpse),
/// where the outfit is applied to the mob.
/// But also for "standalone" outfits (just items spawned in a locker, on the floor),
/// where the outfit items are "spilled" onto the floor (not all items, does not spawn IDs for example).
/obj/outfit
	name = "Naked"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "outfit"

	/// If spilling onto the floor, prob chance for the item to spill.
	var/spill_prob = 98
	/// If spilling onto the floor, if true, items to spill will be shuffled.
	var/spill_shuffle = TRUE

	var/collect_not_del = FALSE

	//The following vars can either be a path or a list of paths
	//If a list of paths is supplied a random item from that list is selected
	var/uniform = null
	var/suit = null
	var/back = null // Mutually exclusive with and will override backpack choices below. Use for RIGs, tanks, etc.
	var/belt = null
	var/gloves = null
	var/wrist = null
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
	var/suit_accessory = null

	// species specific item paths, in the form of
	// thing = list(SPECIES_NAME = /type/path/here)
	// if no path is found, the default fallback (var without the species_ prefix) will be used
	var/list/species_head
	var/list/species_suit
	var/list/species_gloves
	var/list/species_shoes

	//The following vars must be paths
	var/l_hand = null
	var/r_hand = null
	var/id = null
	var/pda = null
	var/radio = null

	// Must be paths, used to allow player-pref backpack choice
	var/allow_backbag_choice = FALSE
	var/backpack = /obj/item/storage/backpack
	var/backpack_faction
	var/satchel = /obj/item/storage/backpack/satchel
	var/satchel_faction
	var/satchel_alt = /obj/item/storage/backpack/satchel/leather
	var/satchel_alt_faction
	var/dufflebag = /obj/item/storage/backpack/duffel
	var/dufflebag_faction
	var/messengerbag = /obj/item/storage/backpack/messenger
	var/messengerbag_faction
	var/rucksack = /obj/item/storage/backpack/rucksack
	var/rucksack_faction
	var/pocketbook = /obj/item/storage/backpack/satchel/pocketbook
	var/pocketbook_faction

	var/allow_pda_choice = FALSE
	var/tab_pda = /obj/item/modular_computer/handheld/pda/civilian
	var/tablet = /obj/item/modular_computer/handheld/preset/civilian
	var/wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian

	var/allow_headset_choice = FALSE
	var/headset = /obj/item/device/radio/headset
	var/bowman = /obj/item/device/radio/headset/alt
	var/double_headset = /obj/item/device/radio/headset/alt/double
	var/wrist_radio = /obj/item/device/radio/headset/wrist

	var/id_iff = IFF_DEFAULT // when spawning in, the ID will be set to this iff, preventing friendly fire

	var/internals_slot = null //ID of slot containing a gas tank
	var/list/backpack_contents = list() //In the list(path=count,otherpath=count) format
	var/list/accessory_contents = list()
	var/list/belt_contents = list() //In the list(path=count,otherpath=count) format
	var/list/implants = null //A list of implants that should be implanted
	var/list/spells = list() // A list of spells to grant

/obj/outfit/Initialize(mapload, ...)
	. = ..()
	// if loc is not null, means the outfit was mapped in or spawned manually
	if(loc!=null)
		spill()

/// Spawn the items on the loc turf.
/// Delete self later.
/obj/outfit/proc/spill()
	// get a list of item types to spawn
	var/list/items = list(
		uniform,
		suit,
		back,
		belt,
		gloves,
		wrist,
		shoes,

		head,
		mask,
		l_ear,
		r_ear,
		glasses,

		l_pocket,
		r_pocket,
		suit_store,
		accessory,
		suit_accessory,

		l_hand,
		r_hand,
		pda,
		radio,

		backpack,
	)

	// add contents to the list
	for(var/c in backpack_contents)
		items += c
	for(var/c in accessory_contents)
		items += c
	for(var/c in belt_contents)
		items += c

	// shuffle
	if(spill_shuffle)
		items = shuffle(items)

	// go over each item
	for(var/i in items)
		if(i && prob(spill_prob))
			spill_item(i)

	// and finally delete self
	qdel(src)

/obj/outfit/proc/spill_item(var/path)
	if(islist(path))
		path = pick(path)
	if(path && ispath(path))
		new path(loc)

/obj/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for customization depending on client prefs,species etc
	if(allow_backbag_choice)
		switch(H.backbag)
			if (OUTFIT_NOTHING)
				back = null
			if (OUTFIT_BACKPACK)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = backpack
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack
					if (OUTFIT_FACTIONSPECIFIC)
						back = backpack_faction ? backpack_faction : backpack // some may not have faction specific; fall back on job backpack if needed
			if (OUTFIT_SATCHEL)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = satchel
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel
					if (OUTFIT_FACTIONSPECIFIC)
						back = satchel_faction ? satchel_faction : satchel
			if (OUTFIT_SATCHEL_ALT) // Leather Satchel
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = satchel_alt
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel/leather
					if (OUTFIT_FACTIONSPECIFIC)
						back = satchel_alt_faction ? satchel_alt_faction : satchel_alt
			if (OUTFIT_DUFFELBAG)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = dufflebag
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/duffel
					if (OUTFIT_FACTIONSPECIFIC)
						back = dufflebag_faction ? dufflebag_faction : dufflebag
			if (OUTFIT_MESSENGERBAG)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = messengerbag
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/messenger
					if (OUTFIT_FACTIONSPECIFIC)
						back = messengerbag_faction ? messengerbag_faction : messengerbag
			if (OUTFIT_RUCKSACK)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = rucksack
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/rucksack
					if (OUTFIT_FACTIONSPECIFIC)
						back = rucksack_faction ? rucksack_faction : rucksack
			if (OUTFIT_POCKETBOOK)
				switch(H.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = pocketbook
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel/pocketbook
					if (OUTFIT_FACTIONSPECIFIC)
						back = pocketbook_faction ? pocketbook_faction : pocketbook
			else
				back = backpack //Department backpack

		if (H.backbag_color >= 2) // if theres a color switch em out for a recolorable one
			switch (H.backbag)
				if (OUTFIT_POCKETBOOK)
					back = /obj/item/storage/backpack/satchel/pocketbook/recolorable
				if (OUTFIT_RUCKSACK)
					back = /obj/item/storage/backpack/rucksack/recolorable
				if (OUTFIT_SATCHEL_ALT)
					back = /obj/item/storage/backpack/satchel/leather/recolorable

	if(back)
		if(islist(back))
			back = pick(back)
		var/obj/item/storage/backpack/B = new back(H)
		if (H.backbag == OUTFIT_SATCHEL_ALT || H.backbag == OUTFIT_RUCKSACK || H.backbag == OUTFIT_POCKETBOOK)
			switch (H.backbag_color)
				if (OUTFIT_NOTHING)
					B.color = null
				if (OUTFIT_BLUE)
					B.color  = "#2f4f81"
				if (OUTFIT_GREEN)
					B.color  = "#353727"
				if (OUTFIT_NAVY)
					B.color  = "#2a303b"
				if (OUTFIT_TAN)
					B.color  = "#524a3e"
				if (OUTFIT_KHAKI)
					B.color  = "#baa481"
				if (OUTFIT_BLACK)
					B.color  = "#212121"
				if (OUTFIT_OLIVE)
					B.color  = "#544f3d"
				if (OUTFIT_AUBURN)
					B.color = "#512828"
				if (OUTFIT_BROWN)
					B.color = "#3d2711"
		else
			B.color = null
		switch(H.backbag_strap)
			if(OUTFIT_NOTHING)
				B.alpha_mask = "hidden"
			if(OUTFIT_THIN)
				B.alpha_mask = "thin"
			if(OUTFIT_NORMAL)
				B.alpha_mask = "normal"
			if(OUTFIT_THICK)
				B.alpha_mask = null
		if(isvaurca(H, TRUE))
			H.equip_or_collect(B, slot_r_hand)
		else
			H.equip_or_collect(B, slot_back)

	var/datum/callback/radio_callback
	if(allow_headset_choice)
		switch(H.headset_choice)
			if (OUTFIT_NOTHING)
				l_ear = null
			if (OUTFIT_BOWMAN)
				l_ear = bowman
			if (OUTFIT_DOUBLE)
				l_ear = double_headset
			if (OUTFIT_WRISTRAD, OUTFIT_THIN_WRISTRAD)
				l_ear = null
				wrist = wrist_radio
				if(H.headset_choice == OUTFIT_THIN_WRISTRAD)
					radio_callback = CALLBACK(src, PROC_REF(turn_into_thinset))
			else
				l_ear = headset //Department headset
	if(l_ear)
		equip_item(H, l_ear, slot_l_ear, callback = radio_callback)
	else if (wrist)
		equip_item(H, wrist, slot_wrists, callback = radio_callback)

/obj/outfit/proc/turn_into_thinset(var/obj/item/device/radio/headset/wrist/radio)
	if(istype(radio))
		radio.icon_state = replacetext(radio.icon_state, "wrist", "thin")
		radio.item_state = replacetext(radio.item_state, "wrist", "thin")

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del.
//override_collect temporarily allows equip_or_collect without enabling it for the job. Mostly used to prevent weirdness with hand equips when the player is missing one
/obj/outfit/proc/equip_item(mob/living/carbon/human/H, path, slot, var/override_collect = FALSE, var/item_color, var/datum/callback/callback)
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

	if(I && callback)
		callback.Invoke(I)

	if(collect_not_del || override_collect)
		H.equip_or_collect(I, slot)
	else
		H.equip_to_slot_or_del(I, slot)

/obj/outfit/proc/equip_uniform_accessory(mob/living/carbon/human/H)
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

/obj/outfit/proc/equip_suit_accessory(mob/living/carbon/human/H)
	if(!H)
		return

	var/obj/item/clothing/suit/S = H.get_equipped_item(slot_wear_suit)
	if(S)
		var/obj/item/clothing/accessory/A = new suit_accessory
		S.attach_accessory(H, A)

/**
 * This proc handles actions done after the outfit was equipped,
 * eg. toggling internals, personalizations or similar
 *
 * This process can and does sleep, and should never be waited upon, but only invoked asyncronously (`INVOKE_ASYNC`)
 */
/obj/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for changing items post equip (such as toggeling internals, ...)

/obj/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	//Start with uniform,suit,backpack for additional slots
	if(back)
		equip_item(H, back, slot_back)
	if(uniform)
		equip_item(H, uniform, slot_w_uniform)
		if(accessory)
			equip_uniform_accessory(H)
	var/got_suit = FALSE
	if(length(species_suit))
		var/path = species_suit[H.species.name]
		if(path)
			got_suit = TRUE
			equip_item(H, path, slot_wear_suit)
			if(suit_accessory)
				equip_suit_accessory(H)
	if(suit && !got_suit)
		equip_item(H, suit, slot_wear_suit)
		if(suit_accessory)
			equip_suit_accessory(H)
	if(belt)
		equip_item(H, belt, slot_belt)
	var/got_gloves = FALSE
	if(length(species_gloves))
		var/path = species_gloves[H.species.name]
		if(path)
			got_gloves = TRUE
			equip_item(H, path, slot_gloves)
	if(gloves && !got_gloves)
		equip_item(H, gloves, slot_gloves)
	if(wrist)
		equip_item(H, wrist, slot_wrists)
	var/got_shoes = FALSE
	if(length(species_shoes))
		var/path = species_shoes[H.species.name]
		if(path)
			got_shoes = TRUE
			equip_item(H, path, slot_shoes)
	if(shoes && !got_shoes)
		equip_item(H, shoes, slot_shoes)
	var/got_head = FALSE
	if(length(species_head))
		var/path = species_head[H.species.name]
		if(path)
			got_head = TRUE
			equip_item(H, path, slot_head)
	if(head && !got_head)
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

	//Hand equips. If person is missing an arm or hand it attempts to put it in the other hand.
	//Override_collect should attempt to collect any items that can't be equipped regardless of collect_not_del settings for the outfit.
	if(l_hand)
		var/obj/item/organ/external/O
		O = H.organs_by_name[BP_L_HAND]
		if(!O || !O.is_usable())
			equip_item(H, l_hand, slot_r_hand, override_collect = TRUE)
		else
			equip_item(H, l_hand, slot_l_hand, override_collect = TRUE)
	if(r_hand)
		var/obj/item/organ/external/O
		O = H.organs_by_name[BP_R_HAND]
		if(!O || !O.is_usable())
			equip_item(H, r_hand, slot_l_hand, override_collect = TRUE)
		else
			equip_item(H, r_hand, slot_r_hand, override_collect = TRUE)

	if(allow_pda_choice)
		switch(H.pda_choice)
			if (OUTFIT_NOTHING)
				pda = null
			if (OUTFIT_TABLET)
				pda = tablet
			if (OUTFIT_WRISTBOUND)
				pda = wristbound
			else
				pda = tab_pda

	if(pda && !visualsOnly)
		var/obj/item/I = new pda(H)
		switch(H.pda_choice)
			if(OUTFIT_TAB_PDA)
				I.desc_extended += "For its many years of service, this model has held a virtual monopoly for PDA models for NanoTrasen. The secret? A lapel pin affixed to the back."
			if(OUTFIT_PDA_OLD)
				I.icon = 'icons/obj/pda_old.dmi'
				I.desc_extended += "Nicknamed affectionately as the 'Brick', PDA enthusiasts rejoice with the return of an old favorite, retrofitted to new modular computing standards."
			if(OUTFIT_PDA_RUGGED)
				I.icon = 'icons/obj/pda_rugged.dmi'
				I.desc_extended += "EVA enthusiasts and owners of fat fingers just LOVE the huge tactile buttons provided by this model. Prone to butt-dialing, but don't let that hold you back."
			if(OUTFIT_PDA_SLATE)
				I.icon = 'icons/obj/pda_slate.dmi'
				I.desc_extended += "A bet between an engineer and a disgruntled scientist, it turns out you CAN make a PDA out of an atmospherics scanner. Also, probably don't tell management, just enjoy."
			if(OUTFIT_PDA_SMART)
				I.icon = 'icons/obj/pda_smart.dmi'
				I.desc_extended += "NanoTrasen originally designed this as a portable media player. Unfortunately, Royalty-free and corporate-approved ukulele isn't particularly popular."
		I.update_icon()
		if(!H.wrists && H.pda_choice == OUTFIT_WRISTBOUND)
			H.equip_or_collect(I, slot_wrists)
		else
			H.equip_or_collect(I, slot_wear_id)

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			equip_item(H, l_pocket, slot_l_store)
		if(r_pocket)
			equip_item(H, r_pocket, slot_r_store)

		if(H.back) // you would think, right
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				for(var/i in 1 to number)
					H.equip_or_collect(new path(H), slot_in_backpack)
		else
			var/obj/item/storage/storage_item
			if(!H.l_hand)
				storage_item = new /obj/item/storage/bag/plasticbag(H)
				H.equip_to_slot_or_del(storage_item, slot_l_hand)
			if(!storage_item && !H.r_hand)
				storage_item = new /obj/item/storage/bag/plasticbag(H)
				H.equip_to_slot_or_del(storage_item, slot_r_hand)
			if(storage_item)
				for(var/path in backpack_contents)
					var/number = backpack_contents[path]
					for(var/i in 1 to number)
						storage_item.handle_item_insertion(new path(H.loc), TRUE)
		for(var/path in belt_contents)
			var/number = belt_contents[path]
			for(var/i in 1 to number)
				H.equip_or_collect(new path(H), slot_in_belt)

		if(id)
			var/obj/item/modular_computer/personal_computer
			if(istype(H.wear_id, /obj/item/modular_computer))
				personal_computer = H.wear_id
			else if(istype(H.wrists, /obj/item/modular_computer))
				personal_computer = H.wrists
			var/obj/item/ID = new id(H)
			imprint_idcard(H, ID)
			if(personal_computer?.card_slot)
				addtimer(CALLBACK(src, PROC_REF(register_pda), personal_computer, ID), 2 SECOND)
			else
				H.equip_or_collect(ID, slot_wear_id)

	INVOKE_ASYNC(src, PROC_REF(post_equip), H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)

		if(implants)
			for(var/implant_type in implants)
				var/obj/item/implant/I = new implant_type(H)
				if(I.implanted(H))
					I.forceMove(H)
					I.imp_in = H
					I.implanted = 1
					var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
					affected.implants += I
					I.part = affected

		if(spells)
			for(var/spell in spells)
				var/spell/new_spell = new spell
				H.add_spell(new_spell)
				if(spells[spell] > 1)
					for(var/i = 1 to spells[spell])
						new_spell.empower_spell()

	H.update_body()
	return 1

// this proc takes all the scattered voidsuit pieces and reassembles them into one piece
/obj/outfit/proc/organize_voidsuit(mob/living/carbon/human/H, var/add_magboots = TRUE)
	var/obj/item/tank/T = H.s_store
	H.unEquip(T, TRUE)

	var/obj/item/clothing/suit/space/void/VS = H.wear_suit
	H.unEquip(VS, TRUE)

	var/obj/item/clothing/head/helmet/VH = H.head
	H.unEquip(VH, TRUE, VS)
	VS.helmet = VH

	T.forceMove(VS)
	VS.tank = T

	if(add_magboots)
		var/obj/item/clothing/shoes/magboots/M = new /obj/item/clothing/shoes/magboots(VH)
		VS.boots = M

	H.equip_to_slot_if_possible(VS, slot_wear_suit)

/obj/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
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
	if(H.wrists)
		H.wrists.add_fingerprint(H, 1)
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

/obj/outfit/proc/imprint_idcard(mob/living/carbon/human/H, obj/item/card/id/C)
	if(istype(C))
		C.access = get_id_access(H)
		C.rank = get_id_rank(H)
		C.assignment = get_id_assignment(H)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, set_id_info), C), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		if(H.mind && H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number

/obj/outfit/proc/register_pda(obj/item/modular_computer/P, obj/item/card/id/I)
	if(!P.card_slot)
		return
	P.card_slot.insert_id(I)
	if(P.card_slot.stored_card && !P.hidden)
		P.set_autorun("ntnrc_client")
		P.enable_computer(null, TRUE) // passing null because we don't want the UI to open
		P.minimize_program()

/obj/outfit/proc/get_id_access(mob/living/carbon/human/H)
	return list()

/obj/outfit/proc/get_id_assignment(mob/living/carbon/human/H, var/ignore_suffix = FALSE)
	. = GetAssignment(H)

	if (. && . != "Unassigned" && H?.mind?.selected_faction && !ignore_suffix)
		if (H.mind.selected_faction.title_suffix)
			. += " ([H.mind.selected_faction.title_suffix])"

/obj/outfit/proc/get_id_rank(mob/living/carbon/human/H)
	return GetAssignment(H)
