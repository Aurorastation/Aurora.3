/**
 * # Outfit datums
 *
 * This is a clean system of applying outfits to mobs, if you need to equip someone in a uniform
 * this is the way to do it cleanly and properly.
 *
 * You can also specify an outfit datum on a job to have it auto equipped to the mob on join
 *
 * /mob/living/carbon/human/proc/equipOutfit(outfit) is the mob level proc to equip an outfit
 * and you pass it the relevant datum outfit
 *
 * outfits can also be saved as json blobs downloadable by a client and then can be uploaded
 * by that user to recreate the outfit, this is used by admins to allow for custom event outfits
 * that can be restored at a later date
 */
/datum/outfit
	///Name of the outfit (shows up in the equip admin verb)
	var/name = "Naked"

	/// Type path of item to go in the idcard slot
	var/id = null

	/// Type path of item to go in uniform slot
	var/uniform = null

	/// Type path of item to go in suit slot
	var/suit = null

	/**
	 * Type path of item to go in suit storage slot
	 *
	 * (make sure it's valid for that suit)
	 */
	var/suit_store = null

	/// Type path of item to go in back slot, mutually exclusive with and will override backpack choices. Use for RIGs, tanks, etc.
	var/back = null

	/**
	 * list of items that should go in the backpack of the user
	 *
	 * Format of this list should be: list(path=count,otherpath=count)
	 */
	var/list/backpack_contents = null


	/// Type path of item to go in belt slot
	var/belt = null

	/**
	 * list of items that should go in the belt of the user
	 *
	 * Format of this list should be: list(path=count,otherpath=count)
	 */
	var/list/belt_contents = null

	/// Type path of item to go in the glasses slot
	var/glasses = null

	/// Type path of item to go in gloves slot
	var/gloves = null

	/// Type path of item to go in head slot
	var/head = null

	/// Type path of item to go in mask slot
	var/mask = null

	/// Type path of item to go in shoes slot
	var/shoes = null

	/// Type path of item for left pocket slot
	var/l_pocket = null

	/// Type path of item for right pocket slot
	var/r_pocket = null

	///Type path of item to go in the right hand
	var/l_hand = null

	//Type path of item to go in left hand
	var/r_hand = null

	/// Any clothing accessory item
	var/accessory = null

	/**
	 * Any implants the mob should start implanted with
	 *
	 * Format of this list is (typepath, typepath, typepath)
	 */
	var/list/implants = null


	/*###########################
		AURORA SNOWFLAKE VARS
	###########################*/

	var/collect_not_del = FALSE

	var/wrist = null

	var/l_ear = null
	var/r_ear = null

	var/suit_accessory = null

	// species specific item paths, in the form of
	// thing = list(SPECIES_NAME = /type/path/here)
	// if no path is found, the default fallback (var without the species_ prefix) will be used
	var/list/species_head
	var/list/species_suit
	var/list/species_gloves
	var/list/species_shoes

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
	var/clipon_radio = /obj/item/device/radio/headset/wrist/clip

	var/id_iff = IFF_DEFAULT // when spawning in, the ID will be set to this iff, preventing friendly fire

	var/list/accessory_contents = list()

	var/list/spells = list() // A list of spells to grant


/**
 * Called at the start of the equip proc
 *
 * Override to change the value of the slots depending on client prefs, species and
 * other such sources of change
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/pre_equip(mob/living/carbon/human/user, visualsOnly = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	//to be overriden for customization depending on client prefs,species etc
	if(allow_backbag_choice)
		switch(user.backbag)
			if (OUTFIT_NOTHING)
				back = null
			if (OUTFIT_BACKPACK)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = backpack
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack
					if (OUTFIT_FACTIONSPECIFIC)
						back = backpack_faction ? backpack_faction : backpack // some may not have faction specific; fall back on job backpack if needed
			if (OUTFIT_SATCHEL)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = satchel
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel
					if (OUTFIT_FACTIONSPECIFIC)
						back = satchel_faction ? satchel_faction : satchel
			if (OUTFIT_SATCHEL_ALT) // Leather Satchel
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = satchel_alt
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel/leather
					if (OUTFIT_FACTIONSPECIFIC)
						back = satchel_alt_faction ? satchel_alt_faction : satchel_alt
			if (OUTFIT_DUFFELBAG)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = dufflebag
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/duffel
					if (OUTFIT_FACTIONSPECIFIC)
						back = dufflebag_faction ? dufflebag_faction : dufflebag
			if (OUTFIT_MESSENGERBAG)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = messengerbag
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/messenger
					if (OUTFIT_FACTIONSPECIFIC)
						back = messengerbag_faction ? messengerbag_faction : messengerbag
			if (OUTFIT_RUCKSACK)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = rucksack
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/rucksack
					if (OUTFIT_FACTIONSPECIFIC)
						back = rucksack_faction ? rucksack_faction : rucksack
			if (OUTFIT_POCKETBOOK)
				switch(user.backbag_style)
					if (OUTFIT_JOBSPECIFIC)
						back = pocketbook
					if (OUTFIT_GENERIC)
						back = /obj/item/storage/backpack/satchel/pocketbook
					if (OUTFIT_FACTIONSPECIFIC)
						back = pocketbook_faction ? pocketbook_faction : pocketbook
			else
				back = backpack //Department backpack

		if (user.backbag_color >= 2) // if theres a color switch em out for a recolorable one
			switch (user.backbag)
				if (OUTFIT_POCKETBOOK)
					back = /obj/item/storage/backpack/satchel/pocketbook/recolorable
				if (OUTFIT_RUCKSACK)
					back = /obj/item/storage/backpack/rucksack/recolorable
				if (OUTFIT_SATCHEL_ALT)
					back = /obj/item/storage/backpack/satchel/leather/recolorable

	if(back)
		if(islist(back))
			back = pick(back)
		var/obj/item/storage/backpack/B = new back(user)
		if (user.backbag == OUTFIT_SATCHEL_ALT || user.backbag == OUTFIT_RUCKSACK || user.backbag == OUTFIT_POCKETBOOK)
			switch (user.backbag_color)
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
		switch(user.backbag_strap)
			if(OUTFIT_NOTHING)
				B.alpha_mask = "hidden"
			if(OUTFIT_THIN)
				B.alpha_mask = "thin"
			if(OUTFIT_NORMAL)
				B.alpha_mask = "normal"
			if(OUTFIT_THICK)
				B.alpha_mask = null
		if(isvaurca(user, TRUE))
			user.equip_or_collect(B, slot_r_hand)
		else
			user.equip_or_collect(B, slot_back)

	var/datum/callback/radio_callback
	if(allow_headset_choice)
		switch(user.headset_choice)
			if (OUTFIT_NOTHING)
				l_ear = null
			if (OUTFIT_BOWMAN)
				l_ear = bowman
			if (OUTFIT_DOUBLE)
				l_ear = double_headset
			if (OUTFIT_WRISTRAD, OUTFIT_THIN_WRISTRAD)
				l_ear = null
				wrist = wrist_radio
				if(user.headset_choice == OUTFIT_THIN_WRISTRAD)
					radio_callback = CALLBACK(src, PROC_REF(turn_into_thinset))
			if(OUTFIT_CLIPON)
				l_ear = null
				wrist = clipon_radio
			else
				l_ear = headset //Department headset
	if(l_ear)
		equip_item(user, l_ear, slot_l_ear, callback = radio_callback)
	else if (wrist)
		equip_item(user, wrist, slot_wrists, callback = radio_callback)

/**
 * Called after the equip proc has finished
 *
 * All items are on the mob at this point, use this proc to toggle internals
 * fiddle with id bindings and accesses etc
 *
 * **This process can and does sleep, and should never be waited upon, but only invoked asyncronously (`INVOKE_ASYNC`)**
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/post_equip(mob/living/carbon/human/user, visualsOnly = FALSE)
	//to be overridden for toggling internals, id binding, access etc
	return

/datum/outfit/proc/turn_into_thinset(var/obj/item/device/radio/headset/wrist/radio)
	if(istype(radio))
		radio.icon_state = replacetext(radio.icon_state, "wrist", "thin")
		radio.item_state = replacetext(radio.item_state, "wrist", "thin")

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del.
//override_collect temporarily allows equip_or_collect without enabling it for the job. Mostly used to prevent weirdness with hand equips when the player is missing one
/datum/outfit/proc/equip_item(mob/living/carbon/human/user, path, slot, override_collect = FALSE, item_color, datum/callback/callback)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/item/I

	if(isnum(path))	//Check if parameter is not numeric. Must be a path, list of paths or name of a gear datum
		CRASH("Outfit [name] - Parameter path: [path] is numeric.")

	if(islist(path))	//If its a list, select a random item
		var/itempath = pick(path)
		I = new itempath(user)
	else if(gear_datums[path]) //If its something else, we´ll check if its a gearpath and try to spawn it
		var/datum/gear/G = gear_datums[path]
		I = G.spawn_random()
	else
		I = new path(user) //As fallback treat it as a path

	if(I && callback)
		callback.Invoke(I)

	if(collect_not_del || override_collect)
		user.equip_or_collect(I, slot)
	else
		user.equip_to_slot_or_del(I, slot)

/datum/outfit/proc/equip_uniform_accessory(mob/living/carbon/human/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!user)
		return

	if(islist(accessory))
		accessory = pick(accessory)

	var/obj/item/clothing/under/U = user.get_equipped_item(slot_w_uniform)
	if(U)
		var/obj/item/clothing/accessory/A = new accessory
		U.attach_accessory(user, A)
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
			var/obj/item/W = new w_type(user.loc)
			if(W)
				holster.holster(W, user)

/datum/outfit/proc/equip_suit_accessory(mob/living/carbon/human/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!user)
		return

	var/obj/item/clothing/suit/S = user.get_equipped_item(slot_wear_suit)
	if(S)
		var/obj/item/clothing/accessory/A = new suit_accessory
		S.attach_accessory(user, A)

/**
 * Equips all defined types and paths to the mob passed in
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/equip(mob/living/carbon/human/user, visualsOnly = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	pre_equip(user, visualsOnly)

	//Start with uniform,suit,backpack for additional slots
	if(back)
		equip_item(user, back, slot_back)

	if(uniform)
		equip_item(user, uniform, slot_w_uniform)
		if(accessory)
			equip_uniform_accessory(user)

	var/got_suit = FALSE
	if(length(species_suit))
		var/path = species_suit[user.species.name]
		if(path)
			got_suit = TRUE
			equip_item(user, path, slot_wear_suit)
			if(suit_accessory)
				equip_suit_accessory(user)
	if(suit && !got_suit)
		equip_item(user, suit, slot_wear_suit)
		if(suit_accessory)
			equip_suit_accessory(user)

	if(belt)
		equip_item(user, belt, slot_belt)


	var/got_gloves = FALSE
	if(length(species_gloves))
		var/path = species_gloves[user.species.name]
		if(path)
			got_gloves = TRUE
			equip_item(user, path, slot_gloves)

	if(gloves && !got_gloves)
		equip_item(user, gloves, slot_gloves)

	if(wrist)
		equip_item(user, wrist, slot_wrists)


	var/got_shoes = FALSE
	if(length(species_shoes))
		var/path = species_shoes[user.species.name]
		if(path)
			got_shoes = TRUE
			equip_item(user, path, slot_shoes)
	if(shoes && !got_shoes)
		equip_item(user, shoes, slot_shoes)


	var/got_head = FALSE
	if(length(species_head))
		var/path = species_head[user.species.name]
		if(path)
			got_head = TRUE
			equip_item(user, path, slot_head)

	if(head && !got_head)
		equip_item(user, head, slot_head)


	if(mask)
		equip_item(user, mask, slot_wear_mask)

	if(l_ear)
		equip_item(user, l_ear, slot_l_ear)

	if(r_ear)
		equip_item(user, r_ear, slot_r_ear)

	if(glasses)
		equip_item(user, glasses, slot_glasses)

	if(suit_store)
		equip_item(user, suit_store, slot_s_store)

	//Hand equips. If person is missing an arm or hand it attempts to put it in the other hand.
	//Override_collect should attempt to collect any items that can't be equipped regardless of collect_not_del settings for the outfit.
	if(l_hand)
		var/obj/item/organ/external/O
		O = user.organs_by_name[BP_L_HAND]

		if(!O || !O.is_usable())
			equip_item(user, l_hand, slot_r_hand, override_collect = TRUE)

		else
			equip_item(user, l_hand, slot_l_hand, override_collect = TRUE)

	if(r_hand)
		var/obj/item/organ/external/O
		O = user.organs_by_name[BP_R_HAND]

		if(!O || !O.is_usable())
			equip_item(user, r_hand, slot_l_hand, override_collect = TRUE)

		else
			equip_item(user, r_hand, slot_r_hand, override_collect = TRUE)

	if(allow_pda_choice)
		switch(user.pda_choice)
			if (OUTFIT_NOTHING)
				pda = null
			if (OUTFIT_TABLET)
				pda = tablet
			if (OUTFIT_WRISTBOUND)
				pda = wristbound
			else
				pda = tab_pda

	if(pda && !visualsOnly)
		var/obj/item/I = new pda(user)
		switch(user.pda_choice)
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
		if(!user.wrists && user.pda_choice == OUTFIT_WRISTBOUND)
			user.equip_or_collect(I, slot_wrists)
		else
			user.equip_or_collect(I, slot_wear_id)

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			equip_item(user, l_pocket, slot_l_store)
		if(r_pocket)
			equip_item(user, r_pocket, slot_r_store)

		if(user.back) // you would think, right

			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				for(var/i in 1 to number)
					user.equip_or_collect(new path(user), slot_in_backpack)

		else
			var/obj/item/storage/storage_item
			if(!user.l_hand)
				storage_item = new /obj/item/storage/bag/plasticbag(user)
				user.equip_to_slot_or_del(storage_item, slot_l_hand)

			if(!storage_item && !user.r_hand)
				storage_item = new /obj/item/storage/bag/plasticbag(user)
				user.equip_to_slot_or_del(storage_item, slot_r_hand)

			if(storage_item)
				for(var/path in backpack_contents)
					var/number = backpack_contents[path]
					for(var/i in 1 to number)
						storage_item.handle_item_insertion(new path(user.loc), TRUE)


		for(var/path in belt_contents)
			var/number = belt_contents[path]
			for(var/i in 1 to number)
				user.equip_or_collect(new path(user), slot_in_belt)

		if(id)
			var/obj/item/modular_computer/personal_computer

			if(istype(user.wear_id, /obj/item/modular_computer))
				personal_computer = user.wear_id

			else if(istype(user.wrists, /obj/item/modular_computer))
				personal_computer = user.wrists

			var/obj/item/ID = new id(user)

			imprint_idcard(user, ID)

			if(personal_computer?.card_slot)
				addtimer(CALLBACK(src, PROC_REF(register_pda), personal_computer, ID), 2 SECOND)

			else
				user.equip_or_collect(ID, slot_wear_id)

	INVOKE_ASYNC(src, PROC_REF(post_equip), user, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(user)

		if(implants)
			for(var/implant_type in implants)
				var/obj/item/implant/I = new implant_type(user)
				if(I.implanted(user))
					I.forceMove(user)
					I.imp_in = user
					I.implanted = 1
					var/obj/item/organ/external/affected = user.get_organ(BP_HEAD)
					affected.implants += I
					I.part = affected

		if(spells)
			for(var/spell in spells)
				var/spell/new_spell = new spell
				user.add_spell(new_spell)
				if(spells[spell] > 1)
					for(var/i = 1 to spells[spell])
						new_spell.empower_spell()

	user.update_body()
	return TRUE

// this proc takes all the scattered voidsuit pieces and reassembles them into one piece
/datum/outfit/proc/organize_voidsuit(mob/living/carbon/human/user, var/add_magboots = TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/item/tank/T = user.s_store
	user.unEquip(T, TRUE)

	var/obj/item/clothing/suit/space/void/VS = user.wear_suit
	user.unEquip(VS, TRUE)

	var/obj/item/clothing/head/helmet/VH = user.head
	user.unEquip(VH, TRUE, VS)
	VS.helmet = VH

	T.forceMove(VS)
	VS.tank = T

	if(add_magboots)
		var/obj/item/clothing/shoes/magboots/M = new /obj/item/clothing/shoes/magboots(VH)
		VS.boots = M

	user.equip_to_slot_if_possible(VS, slot_wear_suit)

/**
 * Apply a fingerprint from the passed in human to all items in the outfit
 *
 * Used for forensics setup when the mob is first equipped at roundstart
 * essentially calls add_fingerprint to every defined item on the human
 *
 */
/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!istype(user))
		return
	if(user.back)
		user.back.add_fingerprint(user, 1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in user.back.contents)
			I.add_fingerprint(user, 1)
	if(user.wear_id)
		user.wear_id.add_fingerprint(user, 1)
	if(user.w_uniform)
		user.w_uniform.add_fingerprint(user, 1)
	if(user.wear_suit)
		user.wear_suit.add_fingerprint(user, 1)
	if(user.wear_mask)
		user.wear_mask.add_fingerprint(user, 1)
	if(user.head)
		user.head.add_fingerprint(user, 1)
	if(user.shoes)
		user.shoes.add_fingerprint(user, 1)
	if(user.gloves)
		user.gloves.add_fingerprint(user, 1)
	if(user.wrists)
		user.wrists.add_fingerprint(user, 1)
	if(user.l_ear)
		user.l_ear.add_fingerprint(user, 1)
	if(user.r_ear)
		user.r_ear.add_fingerprint(user, 1)
	if(user.glasses)
		user.glasses.add_fingerprint(user, 1)
	if(user.belt)
		user.belt.add_fingerprint(user, 1)
		for(var/obj/item/I in user.belt.contents)
			I.add_fingerprint(user, 1)
	if(user.s_store)
		user.s_store.add_fingerprint(user, 1)
	if(user.l_store)
		user.l_store.add_fingerprint(user, 1)
	if(user.r_store)
		user.r_store.add_fingerprint(user, 1)
	return 1

/datum/outfit/proc/imprint_idcard(mob/living/carbon/human/user, obj/item/card/id/idcard)
	SHOULD_NOT_SLEEP(TRUE)

	if(istype(idcard))
		idcard.access = get_id_access(user)
		idcard.rank = get_id_rank(user)
		idcard.assignment = get_id_assignment(user)
		addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, set_id_info), idcard), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		if(user.mind && user.mind.initial_account)
			idcard.associated_account_number = user.mind.initial_account.account_number

/datum/outfit/proc/register_pda(obj/item/modular_computer/computer_to_register, obj/item/card/id/idcard)
	SHOULD_NOT_SLEEP(TRUE)

	if(!computer_to_register.card_slot)
		return

	computer_to_register.card_slot.insert_id(idcard)
	if(computer_to_register.card_slot.stored_card && !computer_to_register.hidden)
		computer_to_register.set_autorun("ntnrc_client")

		// passing null because we don't want the UI to open
		INVOKE_ASYNC(computer_to_register, TYPE_PROC_REF(/obj/item/modular_computer, enable_computer), null, TRUE)

		INVOKE_ASYNC(computer_to_register, TYPE_PROC_REF(/obj/item/modular_computer, minimize_program))

/datum/outfit/proc/get_id_access(mob/living/carbon/human/user)
	SHOULD_NOT_SLEEP(TRUE)

	return list()

/datum/outfit/proc/get_id_assignment(mob/living/carbon/human/user, ignore_suffix = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	. = GetAssignment(user)

	if (. && . != "Unassigned" && user?.mind?.selected_faction && !ignore_suffix)
		if (user.mind.selected_faction.title_suffix)
			. += " ([user.mind.selected_faction.title_suffix])"

/datum/outfit/proc/get_id_rank(mob/living/carbon/human/user)
	SHOULD_NOT_SLEEP(TRUE)

	return GetAssignment(user)
