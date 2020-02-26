/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	maxHealth = 50
	health = 50
	universal_speak = 1
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "drained the life from"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "cult"
	status_flags = CANPUSH
	hunger_enabled = 0
	appearance_flags = NO_CLIENT_COLOR
	var/obj/item/residue = /obj/item/ectoplasm

/mob/living/simple_animal/shade/cultify()
	return

/mob/living/simple_animal/shade/death()
	. = ..()
	visible_message("<span class='warning'>[src] lets out a contented sigh as their form unwinds.</span>")
	new residue(loc)
	qdel(src)

/mob/living/simple_animal/shade/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = O;
		S.transfer_soul("SHADE", src, user)
		return

/mob/living/simple_animal/shade/can_fall()
	return FALSE

/mob/living/simple_animal/shade/can_ztravel()
	return TRUE

/mob/living/simple_animal/shade/CanAvoidGravity()
	return TRUE

/mob/living/simple_animal/shade/bluespace
	name = "space echo"
	real_name = "space echo"
	desc = "A figment of the imagination, a bluespace anomaly, or proof of God? You decide."
	icon = 'icons/mob/mob.dmi'
	icon_state = "blank"
	icon_living = "blank"
	icon_dead = "blank"
	maxHealth = 100
	health = 100
	universal_speak = 1
	universal_understand = 1
	speak_emote = list("echoes")
	emote_hear = list("echoes","echoes")
	response_help  = "brushes against"
	response_disarm = "brushes against"
	response_harm   = "brushes against"
	attacktext = "brushes against"
	melee_damage_lower = 0
	melee_damage_upper = 0
	status_flags = CANPUSH
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	unsuitable_atoms_damage = 0
	incorporeal_move = 3
	mob_size = 0
	density = 0
	speed = 1
	residue = /obj/item/ectoplasm/bs
	var/last_message_heard
	var/message_countdown = 300
	var/heard_dying_message = 0
	var/possession_heard_message = 0
	var/possessive = 0
	var/datum/weakref/original_body
	var/datum/weakref/possessed_body

/mob/living/simple_animal/shade/bluespace/apply_damage(var/damage_flags, var/def_zone, var/edge, var/sharp, var/used_weapon)
	return 0

/mob/living/simple_animal/shade/bluespace/adjustBruteLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustFireLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustToxLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustOxyLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustHalLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/attempt_grab()
	return 0

/mob/living/simple_animal/shade/bluespace/ex_act()
	return 0

/mob/living/simple_animal/shade/bluespace/crush_act()
	return 0

/mob/living/simple_animal/shade/bluespace/Initialize()
	. = ..()
	set_light(3, 1, l_color = LIGHT_COLOR_CYAN)

/mob/living/simple_animal/shade/bluespace/Stat()
	..()

	if(statpanel("Status"))
		stat(null, "Strength of Echoes: [message_countdown]")

/mob/living/simple_animal/shade/bluespace/updatehealth()
	if(!possessive)
		message_countdown = max(0, message_countdown - 2)
		if(message_countdown <= 0)
			adjustCloneLoss(2)
			if(!heard_dying_message)
				heard_dying_message = 1
				to_chat(src, "<span class='danger'>You feel yourself begin to fade away!</span>")
	..()

/mob/living/simple_animal/shade/bluespace/Life()
	if(possessive && possessed_body)
		update_possession()
	..()

/mob/living/simple_animal/shade/bluespace/proc/update_possession()
	var/mob/living/L = possessed_body
	if(L.stat == DEAD)
		adjustCloneLoss(2)
		if(!heard_dying_message)
			to_chat(src, "<span class='danger'>You feel yourself unable to sustain yourself on your host, and begin to fade away!</span>")
			heard_dying_message = 1

	else if(L.sleeping)
		adjustCloneLoss(2)
		possession_heard_message = 0
		if(!heard_dying_message)
			to_chat(src, "<span class='danger'>Your host's lifestream is obfuscated in their dreams as they sleep, and you begin to fade away!</span>")
			heard_dying_message = 1

	else
		heard_dying_message = 0
		if(isunathi(L))
			var/mob/living/carbon/human/H = L
			H.stamina = min(H.max_stamina, H.stamina+(6 * H.stamina_recovery))
			H.adjustBruteLoss(-1)
			H.adjustFireLoss(-1)
			H.adjustToxLoss(-1)
			H.adjustOxyLoss(-1)
			adjustCloneLoss(-2)
			var/list/nagging_doubts = list("You feel empowered by the ancestors!","You feel ancestral might flowing through your veins!","You feel the power of your forebears!", \
											"You feel the blood of the warrior!", "You feel the glory of a warrior's death!", "You feel mighty!","You feel the strength of the spirits!")
			if(prob(5) || !possession_heard_message)
				to_chat(H, "<span class='danger'>[pick(nagging_doubts)]</span>")
				possession_heard_message = 1

		else
			if(prob(20) || !possession_heard_message)
				L.adjustCloneLoss(2)
				adjustCloneLoss(-2)
				var/list/nagging_doubts = list("You feel a nagging doubt in the back of your head.","You feel a vacancy in your thoughts.","You feel momentarily forgetful.", \
												"You feel temporarily occupied.", "You feel a little worried.", "You feel a hostile presence.","You feel watched.")
				if(prob(5) || !possession_heard_message)
					to_chat(L, "<span class='notice'>[pick(nagging_doubts)]</span>")
					possession_heard_message = 1

/mob/living/simple_animal/shade/bluespace/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(speaker && speaker != src && !possessive)
		last_message_heard = message
		message_countdown = min(300, message_countdown + 35)
		adjustCloneLoss(-2)
		if(heard_dying_message)
			heard_dying_message = 0
			to_chat(src, "<span class='notice'>The soothing echoes of life reinvigorate you.</span>")

/mob/living/simple_animal/shade/bluespace/say(var/message)
	if(!possessive)
		var/new_last_message_heard = sanitizeName(last_message_heard)
		var/new_message = sanitizeName(message)

		var/list/words_in_memory = dd_text2List(new_last_message_heard, " ")
		var/list/words_in_message = dd_text2List(new_message, " ")
		for(var/word1 in words_in_message)
			var/valid = 0
			for(var/word2 in words_in_memory)
				if(lowertext(word1) != lowertext(word2))
					continue
				else
					valid = 1
					break
			if(!valid)
				message = replacetext(message, word1, pick(words_in_memory))
		message = slur(message,15)
		..()
	else
		to_chat(src, "<span class='warning'>You cannot muster a voice when possessing another!</span>")

/mob/living/simple_animal/shade/bluespace/verb/show_last_message()
	set name = "Current Echo"
	set category = "Bluespace Echo"
	set desc = "Privately display the last message you heard."

	to_chat(src, "<span class='notice'><b>[last_message_heard]</b></span>")

/mob/living/simple_animal/shade/bluespace/verb/flicker()
	set name = "Flicker Lights"
	set category = "Bluespace Echo"
	set desc = "Oh, Nosferatu!"

	if(possessive)
		to_chat(src, "<span class='warning'>You cannot affect the world outside your host!</span>")
		return

	visible_message("<span class ='notice'>\The [src] pulses.</span>")
	for(var/obj/machinery/light/L in view(5, src))
		L.flicker()

/mob/living/simple_animal/shade/bluespace/verb/move_item()
	set category = "Bluespace Echo"
	set name = "Warp Item"
	set desc = "Teleport a small item to where you are."

	if(possessive)
		to_chat(src, "<span class='warning'>You cannot affect the world outside your host!</span>")
		return

	if(message_countdown < 20)
		to_chat(src, "<span class='warning'>You are too faded to warp an item through bluespace.</span>")
		return

	var/list/obj/item/choices = list()
	for(var/obj/item/I in view(7, src))
		if(I.w_class <= 2)
			choices += I

	if(!choices.len)
		to_chat(src, "<span class='warning'>There are no suitable items nearby.</span>")
		return

	var/obj/item/choice = input(src, "What item would you like to warp?") as null|anything in choices
	if(!choice || !(choice in view(7, src)) || choice.w_class > 2)
		return

	do_teleport(choice, get_turf(src))
	visible_message("<span class ='notice'>\The [src] pulses.</span>")

	message_countdown = max(0, message_countdown - 20)

/mob/living/simple_animal/shade/bluespace/verb/lifeline()
	set category = "Bluespace Echo"
	set name = "Lifeline"
	set desc = "Draw yourself towards the original cradle of your soul."

	if(possessive)
		to_chat(src, "<span class='warning'>You cannot affect the world outside your host!</span>")
		return

	if(!original_body)
		to_chat(src, "<span class='danger'>You feel an immeasurable hollowness as you realize that the original cradle of your soul is no more.</span>")
		return


	var/turf/T1 = get_turf(original_body)
	var/turf/T2 = get_turf(src)

	if(T1.z != T2.z)
		to_chat(src, "<span class='warning'>The original cradle of your soul is too distant from you, perhaps somewhere above or below?</span>")
		return

	forceMove(get_step(src, get_dir(T2, T1)))

/mob/living/simple_animal/shade/bluespace/verb/possession()
	set category = "Bluespace Echo"
	set name = "Mind Meld"
	set desc = "Meld into the mind of another, sustaining yourself off of their lifeforce."

	if(possessive)
		to_chat(src, "<span class='warning'>You are already possessing a host!</span>")
		return

	if(message_countdown < 50)
		to_chat(src, "<span class='warning'>You are too faded to squeeze into another's lifestream.</span>")
		return

	var/list/mob/living/carbon/human/choices = list()
	for(var/mob/living/carbon/human/H in view(1, src))
		if(!isSynthetic(H) && !isvaurca(H) && !H.is_diona())
			choices += H

	if(!choices.len)
		to_chat(src, "<span class='warning'>There are no suitable lifestreams nearby.</span>")
		return

	var/mob/living/carbon/human/H = input(src, "What lifestream would you like to meld with?") as null|anything in choices
	if(!H || !(H in view(7, src)))
		return

	possessed_body = H
	possessive = 1
	anchored = 1
	canmove = 0
	forceMove(possessed_body)
	heard_dying_message = 0
	possession_heard_message = 0
	last_message_heard = null
	message_countdown = max(0, message_countdown - 50)

/mob/living/simple_animal/shade/bluespace/verb/divorce()
	set category = "Bluespace Echo"
	set name = "Divorce of Echoes"
	set desc = "Seperate yourself from the lifestream of another."

	if(!possessive)
		to_chat(src, "<span class='warning'>You are not currently possessing a host!</span>")
		return

	forceMove(get_turf(possessed_body))
	possessed_body = null
	possessive = 0
	anchored = 0
	canmove = 1
	heard_dying_message = 0
	possession_heard_message = 0

	message_countdown = min(message_countdown, 100)

/obj/item/ectoplasm/bs
	name = "bluespace residue"
	desc = "spoopy"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "blectoplasm"

/obj/item/ectoplasm/bs/Initialize()
	. = ..()
	create_reagents(8)
	reagents.add_reagent("bluespace_dust", 8)
