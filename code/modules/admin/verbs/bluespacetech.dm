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

/client/proc/cmd_dev_bst()
	set category = "Debug"
	set name = "Spawn Bluespace Tech"
	set desc = "Spawns a Bluespace Tech to debug stuff"

	if(!check_rights(R_DEV|R_ADMIN))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << span("alert", "The game hasn't started yet!")
		return

	if(istype(mob, /mob/living))
		if(!holder.original_mob)
			holder.original_mob = mob

	//I couldn't get the normal way to work so this works.
	//This whole section looks like a hack, I don't like it.
	var/T = get_turf(usr)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, T)
	s.start()
	var/mob/living/carbon/human/bst/bst = new(get_turf(T))
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
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/holding/bst(bst), slot_back)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/clothing/shoes/black/bst(bst), slot_shoes)
	bst.equip_to_slot_or_del(new /obj/item/clothing/head/beret(bst), slot_head)
	bst.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/bst(bst), slot_glasses)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(bst), slot_belt)
	bst.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat/bst(bst), slot_gloves)
	if(bst.backbag == 1)
		bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(bst), slot_r_hand)
	else
		bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/t_scanner(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/pda/captain/bst(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/multitool(bst.back), slot_in_backpack)

		var/obj/item/weapon/storage/box/pills = new /obj/item/weapon/storage/box
		pills.name = "adminordrazine"
		for(var/i = 1, i < 12, i++)
			new /obj/item/weapon/reagent_containers/pill/adminordrazine(pills)
		bst.equip_to_slot_or_del(pills, slot_in_backpack)

  //Implant because access
  bst.implant_loyalty(bst,TRUE)

	//Sort out ID
	var/obj/item/weapon/card/id/bst/id = new/obj/item/weapon/card/id/bst(bst)
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
	bst.add_language(LANGUAGE_ROOTSONG)
	bst.add_language(LANGUAGE_VAURCA)
	bst.add_language(LANGUAGE_RESOMI)	// why not?
	// Synthetics
	bst.add_language(LANGUAGE_ROBOT)
	bst.add_language(LANGUAGE_DRONE)
	bst.add_language(LANGUAGE_EAL)
	// Antagonist languages
	bst.add_language(LANGUAGE_VOX)
	bst.add_language(LANGUAGE_XENOMORPH)
	bst.add_language(LANGUAGE_HIVEMIND)
	bst.add_language(LANGUAGE_CHANGELING)
	bst.add_language(LANGUAGE_BORER)

	spawn(5)
		s.start()
		bst.anchored = 0
		spawn(10)
			qdel(s)
	log_debug("Bluespace Tech Spawned: X:[bst.x] Y:[bst.y] Z:[bst.z] User:[src]")

	feedback_add_details("admin_verb","BST")
	return 1

/mob/living/carbon/human/bst
	universal_understand = 1
	status_flags = GODMODE

/mob/living/carbon/human/bst/can_inject(var/mob/user, var/error_msg, var/target_zone)
	user << span("alert", "The [src] disarms you before you can inject them.")
	user.drop_item()
	return 0

/mob/living/carbon/human/bst/binarycheck()
	return 1

/mob/living/carbon/human/bst/proc/suicide()
	if(key && species.name != "Human")
		switch(species.name)
			if("Tajara")
				bsc()
			if("Baseline Frame")
				bsb()
			if("Diona")
				bsd()
			if("Unathi")
				bsu()
			if("Skrell")
				bss()
			if("Vaurca")
				bsv()
		return

	src.custom_emote(1,"presses a button on their suit, followed by a polite bow.")
	spawn(10)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		spawn(5)
			qdel(s)
		if(key)
			if(client.holder && client.holder.original_mob)
				client.holder.original_mob.key = key
			else
				var/mob/dead/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
				ghost.key = key
				ghost.mind.name = "[ghost.key] BSTech"
				ghost.name = "[ghost.key] BSTech"
				ghost.real_name = "[ghost.key] BSTech"
				ghost.voice_name = "[ghost.key] BSTech"
		qdel(src)
	return

/mob/living/carbon/human/bst/proc/bsc() //because we all have our unrealistic snowflakes right?
	if(set_species("Tajara"))
		h_style = "Tajaran Ears"
		name = "Bluespace Cat"
		voice_name = "Bluespace Cat"
		real_name = "Bluespace Cat"
		mind.name = "Bluespace Cat"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Cat"
		gender = "female"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsb()
	if(set_species("Baseline Frame"))
		h_style = "blue IPC screen"
		name = "Bluespace Bot"
		voice_name = "Bluespace Bot"
		real_name = "Bluespace Bot"
		mind.name = "Bluespace Bot"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Bot"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsd()
	if(set_species("Diona"))
		name = "Bluespace Tree"
		voice_name = "Bluespace Tree"
		real_name = "Bluespace Tree"
		mind.name = "Bluespace Tree"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Tree"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsu()
	if(set_species("Unathi"))
		h_style = "Unathi Horns"
		name = "Bluespace Lizard"
		voice_name = "Bluespace Lizard"
		real_name = "Bluespace Lizard"
		mind.name = "Bluespace Lizard"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Lizard"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bss()
	if(set_species("Skrell"))
		h_style = "Skrell Male Tentacles"
		name = "Bluespace Squid"
		voice_name = "Bluespace Squid"
		real_name = "Bluespace Squid"
		mind.name = "Bluespace Squid"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Squid"
		gender = "female"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/proc/bsv()
	if(set_species("Vaurca Worker"))
		h_style = "Bald"
		name = "Bluespace Bug"
		voice_name = "Bluespace Bug"
		real_name = "Bluespace Bug"
		mind.name = "Bluespace Bug"
		if(wear_id)
			var/obj/item/weapon/card/id/id = wear_id
			if(istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				id = pda.id
			id.registered_name = "Bluespace Bug"
		regenerate_icons()
	else
		ghostize(0)
		key = null
		suicide()

/mob/living/carbon/human/bst/say(var/message)
	var/verb = "says in a subdued tone"
	..(message, verb)

/mob/living/carbon/human/bst/verb/bstwalk()
	set name = "Ruin Everything"
	set desc = "Uses bluespace technology to phase through solid matter and move quickly."
	set category = "BST"
	set popup_menu = 0

	if(!src.incorporeal_move)
		src.incorporeal_move = 2
		src << span("notice", "You will now phase through solid matter.")
	else
		src.incorporeal_move = 0
		src << span("notice", "You will no-longer phase through solid matter.")
	return

/mob/living/carbon/human/bst/verb/bstrecover()
	set name = "Rejuv"
	set desc = "Use the bluespace within you to restore your health"
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
	set desc = "Activate bluespace to leave and return to your original mob (if you have one)."
	set category = "BST"

	var/client/C = src.client
	if(C.holder && C.holder.original_mob)
		if(C.holder.original_mob.key)//Thanks for kicking Tish off the Server Meow, wouldn't have spotted this otherwise.
			//suicide()
			return

		C.holder.original_mob.key = key
		C.holder.original_mob = null
	suicide()

//Equipment. All should have canremove set to 0
//All items with a /bst need the attack_hand() proc overrided to stop people getting overpowered items.

//Bag o Holding
/obj/item/weapon/storage/backpack/holding/bst
	canremove = 0
	storage_slots = 56
	max_w_class = 400

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

//Headset
/obj/item/device/radio/headset/ert/bst
	name = "\improper Bluespace Technician's headset"
	desc = "A Bluespace Technician's headset. The letters 'BST' are stamped on the side."
	translate_binary = 1
	translate_hive = 1
	canremove = 0
	keyslot1 = new /obj/item/device/encryptionkey/binary
	keyslot2 = new /obj/item/device/encryptionkey/ert

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

//Clothes
/obj/item/clothing/under/rank/centcom_officer/bst
	name = "\improper Bluespace Technician's Uniform"
	desc = "A Bluespace Technician's Uniform. There is a logo on the sleeve that reads 'BST'."
	has_sensor = 0
	sensor_mode = 0
	canremove = 0
	siemens_coefficient = 0
	cold_protection = FULL_BODY
	heat_protection = FULL_BODY

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

//Gloves
/obj/item/clothing/gloves/swat/bst
	name = "\improper Bluespace Technician's gloves"
	desc = "A pair of modified gloves. The letters 'BST' are stamped on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

//Sunglasses
/obj/item/clothing/glasses/sunglasses/bst
	name = "\improper Bluespace Technician's Glasses"
	desc = "A pair of modified sunglasses. The word 'BST' is stamped on the side."
//	var/list/obj/item/clothing/glasses/hud/health/hud = null
	vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	canremove = 0
/*	New()
		..()
		src.hud += new/obj/item/clothing/glasses/hud/security(src)
		src.hud += new/obj/item/clothing/glasses/hud/health(src)
		return
*/
	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

//Shoes
/obj/item/clothing/shoes/black/bst
	name = "\improper Bluespace Technician's shoes"
	name = "A pair of Bluespace Technician's shoes with extra grip. The letters 'BST' are stamped on the side."
	icon_state = "black"
	desc = "A pair of black shoes. 'BST' marked on the side."
	flags = NOSLIP
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

		return 1 //Because Bluespace

//ID
/obj/item/weapon/card/id/bst
	icon_state = "centcom"
	desc = "An ID straight from Central Command. This one looks highly classified."
//	canremove = 0
	New()
		access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

/obj/item/device/pda/captain/bst
	hidden = 1
	message_silent = 1
//	ttone = "DO SOMETHING HERE"

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
			return
		else
			..()

/mob/living/carbon/human/bst/restrained()
	return 0
