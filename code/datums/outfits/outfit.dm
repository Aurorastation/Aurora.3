#define OUTFIT_NOTHING 1

#define OUTFIT_BACKPACK 2
#define OUTFIT_SATCHEL 3
#define OUTFIT_SATCHEL_ALT 4
#define OUTFIT_DUFFELBAG 5
#define OUTFIT_MESSENGERBAG 6
#define OUTFIT_RUCKSACK 7
#define OUTFIT_BLUERUCKSACK 8
#define OUTFIT_GREENRUCKSACK 9
#define OUTFIT_NAVYRUCKSACK 10
#define OUTFIT_TANRUCKSACK 11
#define OUTFIT_KHAKISATCHEL 12
#define OUTFIT_BLACKSATCHEL 13
#define OUTFIT_NAVYSATCHEL 14
#define OUTFIT_OLIVESATCHEL 15
#define OUTFIT_AUBURNSATCHEL 16
#define OUTFIT_POCKETBOOK 17
#define OUTFIT_BROWNPOCKETBOOK 18
#define OUTFIT_AUBURNPOCKETBOOK 19
#define OUTFIT_CLASSICSATCHEL 20

#define OUTFIT_TAB_PDA 2
#define OUTFIT_PDA_OLD 3
#define OUTFIT_PDA_RUGGED 4
#define OUTFIT_PDA_SLATE 5
#define OUTFIT_PDA_SMART 6
#define OUTFIT_TABLET 7
#define OUTFIT_WRISTBOUND 8

#define OUTFIT_HEADSET 2
#define OUTFIT_BOWMAN 3
#define OUTFIT_DOUBLE 4
#define OUTFIT_WRISTRAD 5

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
	var/satchel = /obj/item/storage/backpack/satchel_norm
	var/satchel_alt = /obj/item/storage/backpack/satchel/leather
	var/dufflebag = /obj/item/storage/backpack/duffel
	var/messengerbag = /obj/item/storage/backpack/messenger
	var/rucksack = /obj/item/storage/backpack/rucksack
	var/bluerucksack = /obj/item/storage/backpack/rucksack/blue
	var/greenrucksack = /obj/item/storage/backpack/rucksack/green
	var/navyrucksack = /obj/item/storage/backpack/rucksack/navy
	var/tanrucksack = /obj/item/storage/backpack/rucksack/tan
	var/khakisatchel = /obj/item/storage/backpack/satchel/leather/khaki
	var/blacksatchel = /obj/item/storage/backpack/satchel/leather/black
	var/navysatchel = /obj/item/storage/backpack/satchel/leather/navy
	var/olivesatchel = /obj/item/storage/backpack/satchel/leather/olive
	var/auburnsatchel = /obj/item/storage/backpack/satchel/leather/reddish
	var/pocketbook = /obj/item/storage/backpack/satchel/pocketbook
	var/brownpocketbook = /obj/item/storage/backpack/satchel/pocketbook/brown
	var/auburnpocketbook = /obj/item/storage/backpack/satchel/pocketbook/reddish
	var/classicsatchel = /obj/item/storage/backpack/satchel

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

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for customization depending on client prefs,species etc
	if(allow_backbag_choice)
		var/use_job_specific = H.backbag_style == TRUE
		switch(H.backbag)
			if (OUTFIT_NOTHING)
				back = null
			if (OUTFIT_BACKPACK)
				back = use_job_specific ? backpack : /obj/item/storage/backpack
			if (OUTFIT_SATCHEL)
				back = use_job_specific ? satchel : /obj/item/storage/backpack/satchel_norm
			if (OUTFIT_SATCHEL_ALT)
				back = use_job_specific ? satchel_alt : /obj/item/storage/backpack/satchel/leather
			if (OUTFIT_DUFFELBAG)
				back = use_job_specific ? dufflebag : /obj/item/storage/backpack/duffel
			if (OUTFIT_MESSENGERBAG)
				back = use_job_specific ? messengerbag : /obj/item/storage/backpack/messenger
			if (OUTFIT_RUCKSACK)
				back = use_job_specific ? rucksack : /obj/item/storage/backpack/rucksack
			if (OUTFIT_BLUERUCKSACK)
				back = use_job_specific ? bluerucksack : /obj/item/storage/backpack/rucksack/blue
			if (OUTFIT_GREENRUCKSACK)
				back = use_job_specific ? greenrucksack : /obj/item/storage/backpack/rucksack/green
			if (OUTFIT_NAVYRUCKSACK)
				back = use_job_specific ? navyrucksack : /obj/item/storage/backpack/rucksack/navy
			if (OUTFIT_TANRUCKSACK)
				back = use_job_specific ? tanrucksack : /obj/item/storage/backpack/rucksack/tan
			if (OUTFIT_KHAKISATCHEL)
				back = use_job_specific ? khakisatchel : /obj/item/storage/backpack/satchel/leather/khaki
			if (OUTFIT_BLACKSATCHEL)
				back = use_job_specific ? blacksatchel : /obj/item/storage/backpack/satchel/leather/black
			if (OUTFIT_NAVYSATCHEL)
				back = use_job_specific ? navysatchel : /obj/item/storage/backpack/satchel/leather/navy
			if (OUTFIT_OLIVESATCHEL)
				back = use_job_specific ? olivesatchel : /obj/item/storage/backpack/satchel/leather/olive
			if (OUTFIT_AUBURNSATCHEL)
				back = use_job_specific ? auburnsatchel : /obj/item/storage/backpack/satchel/leather/reddish
			if (OUTFIT_POCKETBOOK)
				back = use_job_specific ? pocketbook : /obj/item/storage/backpack/satchel/pocketbook
			if (OUTFIT_BROWNPOCKETBOOK)
				back = use_job_specific ? brownpocketbook : /obj/item/storage/backpack/satchel/pocketbook/brown
			if (OUTFIT_AUBURNPOCKETBOOK)
				back = use_job_specific ? auburnpocketbook : /obj/item/storage/backpack/satchel/pocketbook/reddish
			if (OUTFIT_CLASSICSATCHEL)
				back = use_job_specific ? classicsatchel : /obj/item/storage/backpack/satchel
			else
				back = backpack //Department backpack
	if(back)
		if(isvaurca(H, TRUE))
			equip_item(H, back, slot_r_hand)
		else
			equip_item(H, back, slot_back)

	if(istype(H.back,/obj/item/storage/backpack))
		var/obj/item/storage/backpack/B = H.back
		B.autodrobe_no_remove = TRUE

	if(allow_headset_choice)
		switch(H.headset_choice)
			if (OUTFIT_NOTHING)
				l_ear = null
			if (OUTFIT_BOWMAN)
				l_ear = bowman
			if (OUTFIT_DOUBLE)
				l_ear = double_headset
			if (OUTFIT_WRISTRAD)
				l_ear = null
				wrist = wrist_radio
			else
				l_ear = headset //Department headset
	if(l_ear)
		equip_item(H, l_ear, slot_l_ear, TRUE)
	else if (wrist)
		equip_item(H, wrist, slot_wrists, TRUE)

	return

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del. 
//override_collect temporarily allows equip_or_collect without enabling it for the job. Mostly used to prevent weirdness with hand equips when the player is missing one
/datum/outfit/proc/equip_item(mob/living/carbon/human/H, path, slot, var/set_no_remove = FALSE, var/override_collect = FALSE)
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

	if(set_no_remove)
		I.autodrobe_no_remove = TRUE

	if(collect_not_del || override_collect)
		H.equip_or_collect(I, slot)
	else
		H.equip_to_slot_or_del(I, slot)

/datum/outfit/proc/equip_uniform_accessory(mob/living/carbon/human/H)
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

/datum/outfit/proc/equip_suit_accessory(mob/living/carbon/human/H)
	if(!H)
		return

	var/obj/item/clothing/suit/S = H.get_equipped_item(slot_wear_suit)
	if(S)
		var/obj/item/clothing/accessory/A = new suit_accessory
		S.attach_accessory(H, A)

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for changing items post equip (such as toggeling internals, ...)

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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
				I.desc_fluff += "For its many years of service, this model has held a virtual monopoly for PDA models for NanoTrasen. The secret? A lapel pin affixed to the back."
			if(OUTFIT_PDA_OLD)
				I.icon = 'icons/obj/pda_old.dmi'
				I.desc_fluff += "Nicknamed affectionately as the 'Brick', PDA enthusiasts rejoice with the return of an old favorite, retrofitted to new modular computing standards."
			if(OUTFIT_PDA_RUGGED)
				I.icon = 'icons/obj/pda_rugged.dmi'
				I.desc_fluff += "EVA enthusiasts and owners of fat fingers just LOVE the huge tactile buttons provided by this model. Prone to butt-dialing, but don't let that hold you back."
			if(OUTFIT_PDA_SLATE)
				I.icon = 'icons/obj/pda_slate.dmi'
				I.desc_fluff += "A bet between an engineer and a disgruntled scientist, it turns out you CAN make a PDA out of an atmospherics scanner. Also, probably don't tell management, just enjoy."
			if(OUTFIT_PDA_SMART)
				I.icon = 'icons/obj/pda_smart.dmi'
				I.desc_fluff += "NanoTrasen originally designed this as a portable media player. Unfortunately, Royalty-free and corporate-approved ukulele isn't particularly popular."
		I.update_icon()
		if (H.pda_choice == OUTFIT_WRISTBOUND)
			H.equip_or_collect(I, slot_wrists)
		else
			H.equip_or_collect(I, slot_wear_id)

	if(id)
		var/obj/item/modular_computer/P = H.wear_id
		var/obj/item/I = new id(H)
		imprint_idcard(H,I)
		if(istype(P) && P.card_slot)
			addtimer(CALLBACK(src, .proc/register_pda, P, I), 2 SECOND)
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
/datum/outfit/proc/organize_voidsuit(mob/living/carbon/human/H, var/add_magboots = TRUE)
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

/datum/outfit/proc/imprint_idcard(mob/living/carbon/human/H, obj/item/card/id/C)
	if(istype(C))
		C.access = get_id_access(H)
		C.rank = get_id_rank(H)
		C.assignment = get_id_assignment(H)
		addtimer(CALLBACK(H, /mob/.proc/set_id_info, C), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		if(H.mind && H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number

/datum/outfit/proc/register_pda(obj/item/modular_computer/P, obj/item/card/id/I)
	if(!P.card_slot)
		return
	P.card_slot.insert_id(I)
	if(P.card_slot.stored_card && !P.hidden)
		P.set_autorun("ntnrc_client")
		P.enable_computer(null, TRUE) // passing null because we don't want the UI to open
		P.minimize_program()

/datum/outfit/proc/get_id_access(mob/living/carbon/human/H)
	return list()

/datum/outfit/proc/get_id_assignment(mob/living/carbon/human/H)
	. = GetAssignment(H)

	if (. && . != "Unassigned" && H?.mind?.selected_faction)
		if (!H.mind.selected_faction.is_default && H.mind.selected_faction.title_suffix)
			. += " ([H.mind.selected_faction.title_suffix])"

/datum/outfit/proc/get_id_rank(mob/living/carbon/human/H)
	return GetAssignment(H)
