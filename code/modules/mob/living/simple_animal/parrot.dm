/* Parrots!
 * Contains
 * * Defines
 * * Inventory (headset stuff)
 * * Attack responces
 * * AI
 * * Procs / Verbs (usable by players)
 * * Sub-types
 */

/*
 * Defines
 */

//Only a maximum of one action and one intent should be active at any given time.
//Actions
#define PARROT_PERCH 1		//Sitting/sleeping, not moving
#define PARROT_SWOOP 2		//Moving towards or away from a target
#define PARROT_WANDER 4		//Moving without a specific target in mind

//Intents
#define PARROT_STEAL 8		//Flying towards a target to steal it/from it
#define PARROT_ATTACK 16	//Flying towards a target to attack it
#define PARROT_RETURN 32	//Flying towards its perch
#define PARROT_FLEE 64		//Flying away from its attacker

/datum/ai_holder/simple_animal/passive/parrot
	wander = FALSE
	can_flee = FALSE
	var/parrot_state = PARROT_WANDER
	var/parrot_sleep_dur = 0
	var/parrot_been_shot = 0
	var/atom/movable/parrot_interest

/datum/ai_holder/simple_animal/passive/parrot/attune_to_holder()
	. = ..()
	var/mob/living/simple_animal/parrot/parrot = holder
	parrot_sleep_dur = parrot.parrot_sleep_max
	set_parrot_state(PARROT_WANDER)

/datum/ai_holder/simple_animal/passive/parrot/Destroy()
	parrot_interest = null
	return ..()

/datum/ai_holder/simple_animal/passive/parrot/react_to_attack(atom/attacker)
	return TRUE

/datum/ai_holder/simple_animal/passive/parrot/proc/set_parrot_state(new_state)
	parrot_state = new_state

/datum/ai_holder/simple_animal/passive/parrot/proc/set_interest(atom/movable/new_interest)
	parrot_interest = new_interest

/datum/ai_holder/simple_animal/passive/parrot/proc/react_to_melee(mob/living/attacker, fight_back = FALSE)
	var/mob/living/simple_animal/parrot/parrot = holder
	if(parrot_state == PARROT_PERCH)
		parrot_sleep_dur = parrot.parrot_sleep_max
	set_interest(attacker)
	set_parrot_state(PARROT_SWOOP | (fight_back ? PARROT_ATTACK : PARROT_FLEE))
	parrot.icon_state = "parrot_fly"
	if(!fight_back)
		parrot.drop_held_item(FALSE)

/datum/ai_holder/simple_animal/passive/parrot/proc/react_to_projectile()
	var/mob/living/simple_animal/parrot/parrot = holder
	if(parrot_state == PARROT_PERCH)
		parrot_sleep_dur = parrot.parrot_sleep_max
	set_interest(null)
	set_parrot_state(PARROT_WANDER)
	parrot_been_shot += 5
	parrot.icon_state = "parrot_fly"
	parrot.drop_held_item(FALSE)

/datum/ai_holder/simple_animal/passive/parrot/handle_special_tactic()
	var/mob/living/simple_animal/parrot/parrot = holder
	if(parrot.pulledby && parrot.stat == CONSCIOUS)
		parrot.icon_state = "parrot_fly"
		set_parrot_state(PARROT_WANDER)
		return
	if(parrot.client || parrot.stat || !isturf(parrot.loc) || !parrot.canmove || parrot.buckled_to)
		return

	if(length(parrot.speech_buffer) && prob(10))
		if(length(parrot.speak))
			parrot.speak.Remove(pick(parrot.speak))
		parrot.speak.Add(pick(parrot.speech_buffer))
		LAZYCLEARLIST(parrot.speech_buffer)

	switch(parrot_state)
		if(PARROT_PERCH)
			if(parrot.parrot_perch && parrot.parrot_perch.loc != parrot.loc)
				if(parrot.parrot_perch in view(parrot))
					set_parrot_state(PARROT_SWOOP | PARROT_RETURN)
				else
					set_parrot_state(PARROT_WANDER)
				parrot.icon_state = "parrot_fly"
				return
			parrot_sleep_dur--
			if(parrot_sleep_dur > 0)
				return
			parrot_sleep_dur = parrot.parrot_sleep_max
			update_radio_speech(parrot)
			set_interest(parrot.search_for_item())
			if(parrot_interest)
				parrot.visible_emote("looks in [parrot_interest]'s direction and takes flight", 0)
				set_parrot_state(PARROT_SWOOP | PARROT_STEAL)
				parrot.icon_state = "parrot_fly"

		if(PARROT_WANDER)
			GLOB.move_manager.stop_looping(parrot)
			set_interest(null)
			if(prob(90))
				step(parrot, pick(GLOB.cardinals))
				return
			if(!parrot.held_item && !parrot.parrot_perch)
				var/atom/movable/new_interest = parrot.search_for_perch_and_item()
				if(!new_interest)
					return
				if(istype(new_interest, /obj/item) || isliving(new_interest))
					set_interest(new_interest)
					parrot.visible_emote("turns and flies towards [parrot_interest]", 0)
					set_parrot_state(PARROT_SWOOP | PARROT_STEAL)
				else
					parrot.parrot_perch = new_interest
					set_parrot_state(PARROT_SWOOP | PARROT_RETURN)
				return
			if(parrot.parrot_perch && (parrot.parrot_perch in view(parrot)))
				set_parrot_state(PARROT_SWOOP | PARROT_RETURN)
				return
			parrot.parrot_perch = parrot.search_for_perch()
			if(parrot.parrot_perch)
				set_parrot_state(PARROT_SWOOP | PARROT_RETURN)

		if(PARROT_SWOOP | PARROT_STEAL)
			GLOB.move_manager.stop_looping(parrot)
			if(!parrot_interest || parrot.held_item || !(parrot_interest in view(parrot)))
				set_parrot_state(PARROT_SWOOP | PARROT_RETURN)
				return
			if(in_range(parrot, parrot_interest))
				if(isliving(parrot_interest))
					parrot.steal_from_mob()
				else if(!parrot.parrot_perch || parrot_interest.loc != parrot.parrot_perch.loc)
					parrot.held_item = parrot_interest
					parrot_interest.forceMove(parrot)
					parrot.visible_message("[parrot] grabs the [parrot.held_item]!", SPAN_NOTICE("You grab the [parrot.held_item]!"), "You hear the sounds of wings flapping furiously.")
				set_interest(null)
				set_parrot_state(PARROT_SWOOP | PARROT_RETURN)
				return
			GLOB.move_manager.move_to(parrot, parrot_interest, 1, parrot.parrot_speed)

		if(PARROT_SWOOP | PARROT_RETURN)
			GLOB.move_manager.stop_looping(parrot)
			if(!parrot.parrot_perch || !isturf(parrot.parrot_perch.loc))
				parrot.parrot_perch = null
				set_parrot_state(PARROT_WANDER)
				return
			if(in_range(parrot, parrot.parrot_perch))
				parrot.forceMove(parrot.parrot_perch.loc)
				parrot.drop_held_item()
				set_parrot_state(PARROT_PERCH)
				parrot.icon_state = "parrot_sit"
				return
			GLOB.move_manager.move_to(parrot, parrot.parrot_perch, 1, parrot.parrot_speed)

		if(PARROT_SWOOP | PARROT_FLEE)
			GLOB.move_manager.stop_looping(parrot)
			if(!parrot_interest || !isliving(parrot_interest))
				set_interest(null)
				set_parrot_state(PARROT_WANDER)
				return
			GLOB.move_manager.move_away(parrot, parrot_interest, 1, max(1, parrot.parrot_speed - parrot_been_shot))
			parrot_been_shot = max(0, parrot_been_shot - 1)

		if(PARROT_SWOOP | PARROT_ATTACK)
			if(!isliving(parrot_interest))
				set_interest(null)
				set_parrot_state(PARROT_WANDER)
				return
			var/mob/living/attack_target = parrot_interest
			if(in_range(parrot, attack_target))
				if(attack_target.stat)
					set_interest(null)
					if(!parrot.held_item)
						parrot.held_item = parrot.steal_from_ground()
						if(!parrot.held_item)
							parrot.held_item = parrot.steal_from_mob()
					set_parrot_state((parrot.parrot_perch in view(parrot)) ? (PARROT_SWOOP | PARROT_RETURN) : PARROT_WANDER)
					return
				parrot.AIParrotAttack(attack_target)
				return
			GLOB.move_manager.move_to(parrot, attack_target, 1, parrot.parrot_speed)

		else
			GLOB.move_manager.stop_looping(parrot)
			set_interest(null)
			parrot.parrot_perch = null
			parrot.drop_held_item()
			set_parrot_state(PARROT_WANDER)

/datum/ai_holder/simple_animal/passive/parrot/proc/update_radio_speech(mob/living/simple_animal/parrot/parrot)
	if(!length(parrot.speak))
		return
	var/list/new_speech = list()
	if(length(parrot.available_channels) && parrot.ears)
		for(var/possible_phrase in parrot.speak)
			var/use_radio = prob(50)
			if(copytext(possible_phrase, 1, 3) in department_radio_keys)
				possible_phrase = "[use_radio ? pick(parrot.available_channels) : ""] [copytext(possible_phrase, 3, length(possible_phrase) + 1)]"
			else
				possible_phrase = "[use_radio ? pick(parrot.available_channels) : ""] [possible_phrase]"
			new_speech.Add(possible_phrase)
	else
		for(var/possible_phrase in parrot.speak)
			if(copytext(possible_phrase, 1, 3) in department_radio_keys)
				possible_phrase = copytext(possible_phrase, 3, length(possible_phrase) + 1)
			new_speech.Add(possible_phrase)
	parrot.speak = new_speech


/mob/living/simple_animal/parrot
	ai_holder_type = /datum/ai_holder/simple_animal/passive/parrot
	name = "\improper Parrot"
	desc = "The parrot squaks, \"It's a Parrot! BAWWK!\""
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "parrot_fly"
	icon_living = "parrot_fly"
	icon_dead = "parrot_dead"
	pass_flags = PASSTABLE | PASSRAILING
	mob_size = MOB_TINY

	speak = list("Hi","Hello!","Cracker?","BAWWWWK george mellons griffing me")
	speak_emote = list("squawks","says","yells")
	emote_hear = list("squawks","bawks")
	emote_see = list("flutters its wings")

	speak_chance = 1//1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	universal_speak = TRUE
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/cracker/

	organ_names = list("torso", "left wing", "right wing", "head")
	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = 1
	canbrush = TRUE

	flying = TRUE

	var/parrot_sleep_max = 25 //The time the parrot sits while perched before looking around. Mosly a way to avoid the parrot's AI in life() being run every single tick.
	var/parrot_dam_zone = list(BP_CHEST, BP_HEAD, BP_L_ARM, BP_L_LEG, BP_R_ARM, BP_R_LEG) //For humans, select a bodypart to attack

	var/parrot_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.

	var/list/speech_buffer = list()
	var/list/available_channels = list()

	var/obj/item/radio/headset/ears = null

	//The thing the parrot is currently interested in. This gets used for items the parrot wants to pick up, mobs it wants to steal from,
	//mobs it wants to attack or mobs that have attacked it
	//Parrots will generally sit on their pertch unless something catches their eye.
	//These vars store their preffered perch and if they dont have one, what they can use as a perch
	var/obj/parrot_perch = null
	var/obj/desired_perches = list(/obj/structure/computerframe, 		/obj/structure/displaycase, \
									/obj/structure/filingcabinet,		/obj/structure/machinery/teleport, \
									/obj/structure/machinery/computer,			/obj/structure/machinery/clonepod, \
									/obj/structure/machinery/dna_scannernew,		/obj/structure/machinery/telecomms, \
									/obj/structure/machinery/nuclearbomb,			/obj/structure/machinery/particle_accelerator, \
									/obj/structure/machinery/recharge_station,	/obj/structure/machinery/smartfridge, \
									/obj/structure/machinery/suit_storage_unit)

	//Parrots are kleptomaniacs. This variable ... stores the item a parrot is holding.
	var/obj/item/held_item = null
	emote_sounds = list('sound/effects/creatures/parrot.ogg')


/mob/living/simple_animal/parrot/Initialize()
	. = ..()
	if(!ears)
		var/headset = pick(/obj/item/radio/headset/headset_sec, \
						/obj/item/radio/headset/headset_eng, \
						/obj/item/radio/headset/headset_med, \
						/obj/item/radio/headset/headset_sci, \
						/obj/item/radio/headset/headset_cargo)
		ears = new headset(src)

	verbs.Add(
				/mob/living/simple_animal/parrot/proc/steal_from_ground, \
				/mob/living/simple_animal/parrot/proc/steal_from_mob, \
				/mob/living/simple_animal/parrot/verb/drop_held_item_player, \
				/mob/living/simple_animal/parrot/proc/perch_player
			)

/mob/living/simple_animal/parrot/Destroy()
	QDEL_NULL(ears)
	parrot_perch = null
	return ..()

/mob/living/simple_animal/parrot/death()
	if(held_item)
		held_item.forceMove(src.loc)
		held_item = null
	GLOB.move_manager.stop_looping(src)
	..()

/mob/living/simple_animal/parrot/get_status_tab_items()
	. = ..()
	. += "Held Item: [held_item]"

/*
 * Inventory
 */
/mob/living/simple_animal/parrot/show_inv(mob/user as mob)
	user.set_machine(src)
	if(user.stat) return

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(ears)
		dat +=	"<br><b>Headset:</b> [ears] (<a href='byond://?src=[REF(src)];remove_inv=ears'>Remove</a>)"
	else
		dat +=	"<br><b>Headset:</b> <a href='byond://?src=[REF(src)];add_inv=ears'>Nothing</a>"

	user << browse(HTML_SKELETON(dat), "window=mob[name];size=325x500")
	onclose(user, "mob[real_name]")
	return

/mob/living/simple_animal/parrot/Topic(href, href_list)

	//Can the usr physically do this?
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		return

	//Is the usr's mob type able to do this?
	if(ishuman(usr) || issmall(usr) || isrobot(usr))

		//Removing from inventory
		if(href_list["remove_inv"])
			var/remove_from = href_list["remove_inv"]
			switch(remove_from)
				if("ears")
					if(ears)
						if(available_channels.len)
							src.say("[pick(available_channels)] BAWWWWWK LEAVE THE HEADSET BAWKKKKK!")
						else
							src.say("BAWWWWWK LEAVE THE HEADSET BAWKKKKK!")
						ears.forceMove(src.loc)
						ears = null
						for(var/possible_phrase in speak)
							if(copytext(possible_phrase,1,3) in department_radio_keys)
								possible_phrase = copytext(possible_phrase,3,length(possible_phrase))
					else
						to_chat(usr, SPAN_WARNING("There is nothing to remove from its [remove_from]."))
						return

		//Adding things to inventory
		else if(href_list["add_inv"])
			var/add_to = href_list["add_inv"]
			if(!usr.get_active_hand())
				to_chat(usr, SPAN_WARNING("You have nothing in your hand to put on its [add_to]."))
				return
			switch(add_to)
				if("ears")
					if(ears)
						to_chat(usr, SPAN_WARNING("It's already wearing something."))
						return
					else
						var/obj/item/item_to_add = usr.get_active_hand()
						if(!item_to_add)
							return

						if( !istype(item_to_add,  /obj/item/radio/headset) )
							to_chat(usr, SPAN_WARNING("This object won't fit."))
							return

						var/obj/item/radio/headset/headset_to_add = item_to_add

						usr.drop_from_inventory(headset_to_add,src)
						src.ears = headset_to_add
						to_chat(usr, "You fit the headset onto [src].")

						LAZYCLEARLIST(available_channels)
						for(var/ch in headset_to_add.channels)
							switch(ch)
								if("Engineering")
									available_channels.Add(":e")
								if("Command")
									available_channels.Add(":c")
								if("Security")
									available_channels.Add(":s")
								if("Science")
									available_channels.Add(":n")
								if("Medical")
									available_channels.Add(":m")
								if("Mining")
									available_channels.Add(":d")
								if("Operations")
									available_channels.Add(":q")
		else
			..()


/*
 * Attack responces
 */
//Humans, monkeys, aliens
/mob/living/simple_animal/parrot/attack_hand(mob/living/carbon/M as mob)
	..()
	if(client) return
	if(!stat && M.a_intent == I_HURT)
		var/datum/ai_holder/simple_animal/passive/parrot/parrot_ai = ai_holder
		parrot_ai?.react_to_melee(M, M.health < 50)
	return

//Mobs with objects
/mob/living/simple_animal/parrot/attackby(obj/item/attacking_item, mob/user)
	..()
	if(!stat && !client && !istype(attacking_item, /obj/item/stack/medical))
		if(attacking_item.force)
			var/datum/ai_holder/simple_animal/passive/parrot/parrot_ai = ai_holder
			parrot_ai?.react_to_melee(user, FALSE)
	return

//Bullets
/mob/living/simple_animal/parrot/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(!stat && !client)
		var/datum/ai_holder/simple_animal/passive/parrot/parrot_ai = ai_holder
		parrot_ai?.react_to_projectile()


/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */

/*
 * Procs
 */

/mob/living/simple_animal/parrot/movement_delay()
	if(client && stat == CONSCIOUS && icon_state != "parrot_fly")
		icon_state = "parrot_fly"
	..()

/mob/living/simple_animal/parrot/proc/AIParrotAttack(mob/living/attack_target)
	var/damage = rand(5, 10)
	if(ishuman(attack_target))
		var/mob/living/carbon/human/human_target = attack_target
		var/obj/item/organ/external/affecting = human_target.get_organ(ran_zone(pick(parrot_dam_zone)))
		human_target.apply_damage(damage, DAMAGE_BRUTE, affecting, damage_flags = DAMAGE_FLAG_SHARP)
		visible_emote(pick("pecks [human_target]'s [affecting].", "cuts [human_target]'s [affecting] with its talons."))
	else
		attack_target.adjustBruteLoss(damage)
		visible_emote(pick("pecks at [attack_target].", "claws [attack_target]."))

/mob/living/simple_animal/parrot/proc/search_for_item()
	for(var/atom/movable/AM in view(src))
		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class < 2)
				return I

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if((C.l_hand && C.l_hand.w_class <= 2) || (C.r_hand && C.r_hand.w_class <= 2))
				return C
	return null

/mob/living/simple_animal/parrot/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null

//This proc was made to save on doing two 'in view' loops seperatly
/mob/living/simple_animal/parrot/proc/search_for_perch_and_item()
	for(var/atom/movable/AM in view(src))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				return AM

		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class <= 2)
				return I

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if(C.l_hand && C.l_hand.w_class <= 2 || C.r_hand && C.r_hand.w_class <= 2)
				return C
	return null


/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled parrots.
 */
/mob/living/simple_animal/parrot/proc/steal_from_ground()
	set name = "Steal from ground"
	set category = "Parrot"
	set desc = "Grabs a nearby item."

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_WARNING("You are already holding the [held_item]"))
		return 1

	for(var/obj/item/I in view(1,src))
		//Make sure we're not already holding it and it's small enough
		if(I.loc != src && I.w_class <= 2)

			//If we have a perch and the item is sitting on it, continue
			if(!client && parrot_perch && I.loc == parrot_perch.loc)
				continue

			held_item = I
			I.forceMove(src)
			visible_message("[src] grabs the [held_item]!", SPAN_NOTICE("You grab the [held_item]!"), "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, SPAN_WARNING("There is nothing of interest to take."))
	return 0

/mob/living/simple_animal/parrot/proc/steal_from_mob()
	set name = "Steal from mob"
	set category = "Parrot"
	set desc = "Steals an item right out of a person's hand!"

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_WARNING("You are already holding the [held_item]"))
		return 1

	var/obj/item/stolen_item = null

	for(var/mob/living/carbon/C in view(1,src))
		if(C.l_hand && C.l_hand.w_class <= 2)
			stolen_item = C.l_hand

		if(C.r_hand && C.r_hand.w_class <= 2)
			stolen_item = C.r_hand

		if(stolen_item)
			C.remove_from_mob(stolen_item)
			held_item = stolen_item
			stolen_item.forceMove(src)
			visible_message("[src] grabs the [held_item] out of [C]'s hand!", SPAN_NOTICE("You snag the [held_item] out of [C]'s hand!"), "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, SPAN_WARNING("There is nothing of interest to take."))
	return 0

/mob/living/simple_animal/parrot/verb/drop_held_item_player()
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	src.drop_held_item()

	return

/mob/living/simple_animal/parrot/proc/drop_held_item(var/drop_gently = 1)
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return -1

	if(!held_item)
		to_chat(usr, SPAN_WARNING("You have nothing to drop!"))
		return 0

	if(!drop_gently)
		if(istype(held_item, /obj/item/grenade))
			var/obj/item/grenade/G = held_item
			G.forceMove(src.loc)
			G.prime()
			to_chat(src, "You let go of the [held_item]!")
			held_item = null
			return 1

	to_chat(src, "You drop the [held_item].")

	held_item.forceMove(src.loc)
	held_item = null
	return 1

/mob/living/simple_animal/parrot/proc/perch_player()
	set name = "Sit"
	set category = "Parrot"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	if(icon_state == "parrot_fly")
		for(var/atom/movable/AM in view(src,1))
			for(var/perch_path in desired_perches)
				if(istype(AM, perch_path))
					src.forceMove(AM.loc)
					icon_state = "parrot_sit"
					return
	to_chat(src, SPAN_WARNING("There is no perch nearby to sit on."))
	return

/mob/living/simple_animal/parrot/say(var/text, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)

	if(stat)
		return

	if(speak_emote.len)
		verb = pick(speak_emote)


	var/message_mode=""
	if(copytext(text,1,2) == ";")
		message_mode = "headset"
		text = copytext(text,2)

	if(length(text) >= 2)
		var/channel_prefix = copytext(text, 1 ,3)
		message_mode = department_radio_keys[channel_prefix]

	if(copytext(text,1,2) == ":")
		var/positioncut = 3
		text = trim(copytext(text,positioncut))

	text = capitalize(trim_left(text))

	if(message_mode)
		if(message_mode in radiochannels)
			if(ears && istype(ears,/obj/item/radio))
				ears.talk_into(src,sanitize(text), message_mode, verb, null)


	..(text)


/mob/living/simple_animal/parrot/react_to_message(datum/say_message/msg)
	if(prob(50))
		if(msg.say_mode == SAYMODE_RADIO)
			parrot_hear("[pick(available_channels)] [msg.to_string()]")
		else
			parrot_hear(msg.to_string())


/mob/living/simple_animal/parrot/proc/parrot_hear(var/message="")
	if(!message || stat)
		return
	speech_buffer.Add(message)

/mob/living/simple_animal/parrot/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	var/success = ..()

	if(client)
		return success

	if(!success)
		return 0

	var/datum/ai_holder/simple_animal/passive/parrot/parrot_ai = ai_holder
	parrot_ai?.react_to_melee(user, TRUE)
	return success
