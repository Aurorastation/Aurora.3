/*
// Bluespace Technition and all their items.
// Only avaliable to people with +DEV and +DEVELOPER
// All items are ave canremove = 0 to avoid loos and thefts
// They are invincible.
// Suicide with them to exit in an rp way
//
// I really didn't expect most of this to work right but hey it does.
// - SoundScopes
*/

/client
	var/bst_cooldown	// So people can't spam BSTs.

/client/proc/bst_spawn_cooldown()
	bst_cooldown = null

/client/proc/cmd_dev_bst()
	set category = "Debug"
	set name = "Spawn Bluespace Tech"
	set desc = "Spawns a Bluespace Tech to debug stuff"

	if (bst_cooldown)
		to_chat(src, "You've used this verb too recently, please wait a moment before trying again.")
		return

	if(!check_rights(R_DEV|R_ADMIN))	return

	if(!holder)
		return //how did they get here?

	if(!ROUND_IS_STARTED)
		to_chat(src, SPAN_ALERT("The game hasn't started yet!"))
		return

	bst_cooldown = TRUE

	if(istype(mob, /mob/living))
		if(!holder.original_mob)
			holder.original_mob = mob

	//I couldn't get the normal way to work so this works.
	//This whole section looks like a hack, I don't like it.
	var/T = get_turf(usr)
	var/mob/living/carbon/human/bst/bst = new(T)
//	bst.original_mob = usr
	bst.anchored = 1
	bst.ckey = usr.ckey
	bst.name = "Bluespace Technician"
	bst.real_name = "Bluespace Technician"
	bst.voice_name = "Bluespace Technician"
	bst.h_style = "Crewcut"

	//Items
	var/obj/item/clothing/under/U = new /obj/item/clothing/under/rank/centcom_officer/bst(bst)
	bst.equip_to_slot_or_del(U, slot_w_uniform)
	bst.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert/bst(bst), slot_l_ear)
	bst.equip_to_slot_or_del(new /obj/item/storage/backpack/holding/bst(bst), slot_back)
	bst.equip_to_slot_or_del(new /obj/item/storage/box/survival(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/clothing/shoes/black/bst(bst), slot_shoes)
	bst.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer/bst(bst), slot_head)
	bst.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/bst(bst), slot_glasses)
	bst.equip_to_slot_or_del(new /obj/item/storage/belt/utility/very_full(bst), slot_belt)
	bst.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat/bst(bst), slot_gloves)
	if(bst.backbag == 1)
		bst.equip_to_slot_or_del(new /obj/item/storage/box/ids(bst), slot_r_hand)
	else
		bst.equip_to_slot_or_del(new /obj/item/storage/box/ids(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/t_scanner(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/modular_computer/handheld/pda/command/bst(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/research(bst.back), slot_in_backpack)

		var/obj/item/storage/box/pills = new /obj/item/storage/box(null, TRUE)
		pills.name = "adminordrazine"
		for(var/i = 1, i < 12, i++)
			new /obj/item/reagent_containers/pill/adminordrazine(pills)
		bst.equip_to_slot_or_del(pills, slot_in_backpack)

	//Implant because access
	bst.implant_loyalty(bst,TRUE)

	//Sort out ID
	var/obj/item/card/id/bst/id = new/obj/item/card/id/bst(bst)
	id.registered_name = bst.real_name
	id.assignment = "Bluespace Technician"
	id.name = "[id.assignment]"
	bst.equip_to_slot_or_del(id, slot_wear_id)
	bst.update_inv_wear_id()
	bst.regenerate_icons()

	//Add the rest of the languages
	//Because universal speak doesn't work right.

	bst.add_language(LANGUAGE_TCB)
	bst.add_language(LANGUAGE_GUTTER)
	bst.add_language(LANGUAGE_SIGN)
	bst.add_language(LANGUAGE_TRADEBAND)
	// Unathi languages
	bst.add_language(LANGUAGE_UNATHI)
	bst.add_language(LANGUAGE_AZAZIBA)
	// Tajara languages
	bst.add_language(LANGUAGE_SIIK_MAAS)
	bst.add_language(LANGUAGE_SIIK_TAJR)
	bst.add_language(LANGUAGE_SIGN_TAJARA)
	// Other station species' languages
	bst.add_language(LANGUAGE_SKRELLIAN)
	bst.add_language(LANGUAGE_SOL_COMMON)
	bst.add_language(LANGUAGE_ELYRAN_STANDARD)
	bst.add_language(LANGUAGE_ROOTSONG)
	bst.add_language(LANGUAGE_VAURCA)
	// Synthetics
	bst.add_language(LANGUAGE_ROBOT)
	bst.add_language(LANGUAGE_DRONE)
	bst.add_language(LANGUAGE_EAL)
	// Antagonist languages
	bst.add_language(LANGUAGE_CHANGELING)
	bst.add_language(LANGUAGE_BORER)

	addtimer(CALLBACK(src, .proc/bst_post_spawn, bst), 5)
	addtimer(CALLBACK(src, .proc/bst_spawn_cooldown), 5 SECONDS)

	log_debug("Bluespace Tech Spawned: X:[bst.x] Y:[bst.y] Z:[bst.z] User:[src]")

	feedback_add_details("admin_verb","BST")

	return 1

/client/proc/bst_post_spawn(mob/living/carbon/human/bst/bst)
	spark(bst, 3, alldirs)
	bst.anchored = FALSE

/mob/living/carbon/human/bst
	universal_understand = 1
	status_flags = GODMODE|NOFALL

/mob/living/carbon/human/bst/can_inject(var/mob/user, var/error_msg, var/target_zone)
	to_chat(user, SPAN_ALERT("The [src] disarms you before you can inject them."))
	user.drop_item()
	return 0

/mob/living/carbon/human/bst/binarycheck()
	return 1

/mob/living/carbon/human/bst/proc/suicide()
	if(key && species.name != SPECIES_HUMAN)
		switch(species.name)
			if(SPECIES_TAJARA)
				bsc()
			if(SPECIES_IPC)
				bsb()
			if(SPECIES_DIONA)
				bsd()
			if(SPECIES_UNATHI)
				bsu()
			if(SPECIES_SKRELL)
				bss()
			if(SPECIES_VAURCA_WORKER)
				bsv()
		return

	src.custom_emote(VISIBLE_MESSAGE,"presses a button on their suit, followed by a polite bow.")
	spark(src, 5, alldirs)
	QDEL_IN(src, 10)
	animate(src, alpha = 0, time = 9, easing = QUAD_EASING)
	if(key)
		if(client.holder && client.holder.original_mob)
			client.holder.original_mob.key = key
		else
			var/mob/abstract/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
			ghost.key = key
			ghost.mind.name = "[ghost.key] BSTech"
			ghost.name = "[ghost.key] BSTech"
			ghost.real_name = "[ghost.key] BSTech"
			ghost.voice_name = "[ghost.key] BSTech"

/mob/living/carbon/human/bst/proc/bsc() //because we all have our unrealistic snowflakes right?
	if(set_species(SPECIES_TAJARA))
		h_style = "Tajaran Ears"
		name = "Bluespace Cat"
		voice_name = "Bluespace Cat"
		real_name = "Bluespace Cat"
		mind.name = "Bluespace Cat"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Cat"
		gender = "female"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsb()
	if(set_species(SPECIES_IPC))
		h_style = "blue IPC screen"
		name = "Bluespace Bot"
		voice_name = "Bluespace Bot"
		real_name = "Bluespace Bot"
		mind.name = "Bluespace Bot"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Bot"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsd()
	if(set_species(SPECIES_DIONA))
		name = "Bluespace Tree"
		voice_name = "Bluespace Tree"
		real_name = "Bluespace Tree"
		mind.name = "Bluespace Tree"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Tree"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsu()
	if(set_species(SPECIES_UNATHI))
		h_style = "Unathi Horns"
		name = "Bluespace Lizard"
		voice_name = "Bluespace Lizard"
		real_name = "Bluespace Lizard"
		mind.name = "Bluespace Lizard"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Lizard"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bss()
	if(set_species(SPECIES_SKRELL))
		h_style = "Skrell Average Tentacles"
		name = "Bluespace Squid"
		voice_name = "Bluespace Squid"
		real_name = "Bluespace Squid"
		mind.name = "Bluespace Squid"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Squid"
		gender = "female"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsv()
	if(set_species(SPECIES_VAURCA_WORKER))
		h_style = "Bald"
		name = "Bluespace Bug"
		voice_name = "Bluespace Bug"
		real_name = "Bluespace Bug"
		mind.name = "Bluespace Bug"
		if(GetIdCard())
			var/obj/item/card/id/id = GetIdCard()
			id.registered_name = "Bluespace Bug"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/verb/antigrav()
	set name = "Toggle Falling"
	set desc = "Use bluespace technology to ignore gravity."
	set category = "BST"

	status_flags ^= NOFALL
	to_chat(src, SPAN_NOTICE("You will [status_flags & NOFALL ? "no longer fall" : "now fall normally"]."))

/mob/living/carbon/human/bst/verb/bstwalk()
	set name = "Toggle Incorporeal Movement"
	set desc = "Use bluespace technology to phase through solid matter and move quickly."
	set category = "BST"
	set popup_menu = 0

	if(!src.incorporeal_move)
		src.incorporeal_move = INCORPOREAL_BSTECH
		to_chat(src, SPAN_NOTICE("You will now phase through solid matter."))
	else
		src.incorporeal_move = INCORPOREAL_DISABLE
		to_chat(src, SPAN_NOTICE("You will no-longer phase through solid matter."))
	return

/mob/living/carbon/human/bst/verb/bstrecover()
	set name = "Restore Health"
	set desc = "Use bluespace to teleport in a fresh, healthy body."
	set category = "BST"
	set popup_menu = 0

	src.revive()

/mob/living/carbon/human/bst/verb/bstawake()
	set name = "Wake up"
	set desc = "This is a quick fix to the relogging sleep bug"
	set category = "BST"
	set popup_menu = 0

	src.sleeping = 0

/mob/living/carbon/human/bst/verb/bstquit()
	set name = "Teleport out"
	set desc = "Jump into bluespace and continue wherever you left off. Deletes the BSTech and returns to your original mob if you have one."
	set category = "BST"

	var/client/C = src.client
	if(C.holder && C.holder.original_mob)
		if(C.holder.original_mob.key)//Thanks for kicking Tish off the Server Meow, wouldn't have spotted this otherwise.
			//suicide()
			return

		C.holder.original_mob.key = key
		C.holder.original_mob = null
	suicide()

/mob/living/carbon/human/bst/verb/tgm()
	set name = "Toggle Godmode"
	set desc = "For when you want to be vulnerable."
	set category = "BST"

	status_flags ^= GODMODE
	to_chat(src, SPAN_NOTICE("God mode is now [status_flags & GODMODE ? "enabled" : "disabled"]"))

//Equipment. All should have canremove set to 0
//All items with a /bst need the attack_hand() proc overrided to stop people getting overpowered items.

//Bag o Holding
/obj/item/storage/backpack/holding/bst
	canremove = 0
	storage_slots = 56
	max_w_class = ITEMSIZE_IMMENSE

/obj/item/device/radio/headset/ert/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

//Headset
/obj/item/device/radio/headset/ert/bst
	name = "bluespace technician's headset"
	desc = "A Bluespace Technician's headset. The letters 'BST' are stamped on the side."
	translate_binary = 1
	translate_hivenet = 1
	canremove = 0
	keyslot1 = new /obj/item/device/encryptionkey/binary
	keyslot2 = new /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/ert/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

// overload this so we can force translate flags without the required keys
/obj/item/device/radio/headset/ert/bst/recalculateChannels(var/setDescription = 0)
	..(setDescription)
	translate_binary = 1
	translate_hivenet = 1

//Clothes
/obj/item/clothing/under/rank/centcom_officer/bst
	name = "bluespace technician's uniform"
	desc = "A Bluespace Technician's Uniform. There is a logo on the sleeve that reads 'BST'."
	has_sensor = 0
	sensor_mode = 0
	canremove = 0
	siemens_coefficient = 0
	cold_protection = FULL_BODY
	heat_protection = FULL_BODY

/obj/item/clothing/under/rank/centcom_officer/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

//Gloves
/obj/item/clothing/gloves/swat/bst
	name = "bluespace technician's gloves"
	desc = "A pair of modified gloves. The letters 'BST' are stamped on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0
	canremove = 0

/obj/item/clothing/gloves/swat/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

//Sunglasses
/obj/item/clothing/glasses/sunglasses/bst
	name = "bluespace technician's glasses"
	desc = "A pair of modified sunglasses. The word 'BST' is stamped on the side."
	vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	canremove = 0
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/glasses/sunglasses/bst/verb/toggle_xray(mode in list("X-Ray without Lighting", "X-Ray with Lighting", "Darkvision", "Normal vision"))
	set name = "Change Vision Mode"
	set desc = "Changes your glasses' vision mode."
	set category = "BST"
	set src in usr

	switch (mode)
		if ("X-Ray without Lighting")
			vision_flags = SEE_TURFS|SEE_OBJS|SEE_MOBS|SEE_BLACKNESS|SEE_SELF
			see_invisible = SEE_INVISIBLE_NOLIGHTING
		if ("X-Ray with Lighting")
			vision_flags = SEE_TURFS|SEE_OBJS|SEE_MOBS|SEE_BLACKNESS|SEE_SELF
			see_invisible = -1
		if ("Darkvision")
			vision_flags = SEE_BLACKNESS|SEE_SELF
			see_invisible = SEE_INVISIBLE_NOLIGHTING
		if ("Normal vision")
			vision_flags = 0
			see_invisible = -1

	to_chat(usr, "<span class='notice'>\The [src]'s vision mode is now <b>[mode]</b>.</span>")

/obj/item/clothing/glasses/sunglasses/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

//Shoes
/obj/item/clothing/shoes/black/bst
	name = "bluespace technician's shoes"
	desc = "A pair of black shoes with extra grip. The letters 'BST' are stamped on the side."
	icon_state = "black"
	item_flags = NOSLIP
	canremove = 0

/obj/item/clothing/shoes/black/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

	return 1 //Because Bluespace

/obj/item/clothing/head/beret/centcom/officer/bst
	name = "bluespace technician's beret"
	desc = "A Bluespace Technician's beret. The letters 'BST' are stamped on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0
	canremove = 0

/obj/item/clothing/head/beret/centcom/officer/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

//ID
/obj/item/card/id/bst
	icon_state = "centcom"
	desc = "An ID straight from Central Command. This one looks highly classified."

/obj/item/card/id/bst/Initialize(mapload)
	. = ..()
	access = get_all_accesses() + get_all_centcom_access() + get_all_syndicate_access()

/obj/item/card/id/bst/verb/swap_access()
	set name = "Change ID Access"
	set desc = "Change your ID access to one of various jobs."
	set category = "BST"
	set src in usr

	var/list/possible_access = list()
	possible_access["== Default BSTech =="] = get_all_accesses() + get_all_centcom_access() + get_all_syndicate_access()
	for(var/job in subtypesof(/datum/job))
		var/datum/job/J = new job
		possible_access[J.title] = J.access
	var/chosen_access = input(usr, "Which access do you want your ID to have?", "ID Access") as null|anything in possible_access
	if(!chosen_access)
		return
	to_chat(usr, SPAN_WARNING("Your ID now has the access of \a [chosen_access]."))
	access = possible_access[chosen_access]

/obj/item/card/id/bst/attack_hand(mob/user)
	if(!istype(user, /mob/living/carbon/human/bst))
		to_chat(user, SPAN_ALERT("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return
	else
		..()

/mob/living/carbon/human/bst/restrained()
	return 0
