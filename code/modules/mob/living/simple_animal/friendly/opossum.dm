/mob/living/simple_animal/opossum
	name = "opossum"
	real_name = "opossum"
	desc = "It's a opossum, a small scavenging marsupial."
	icon_state = "opossum"
	item_state = "opossum"
	icon_living = "opossum"
	icon_dead = "opossum_dead"
	icon = 'icons/mob/opossum.dmi'
	speak = list("Hiss!", "Aaa!", "Aaa?")
	speak_emote = list("hisses")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")
	pass_flags = PASSTABLE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	maxHealth = 50
	health = 50
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = FALSE
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	mob_size = MOB_SMALL
	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	var/is_angry = FALSE

/mob/living/simple_animal/opossum/Life()
	. = ..()
	if(. && !ckey && stat != DEAD && prob(1))
		resting = (stat == UNCONSCIOUS)
		if(!resting)
			wander = initial(wander)
			speak_chance = initial(speak_chance)
			stat = CONSCIOUS
			if(prob(10))
				is_angry = TRUE
			else
				is_angry = FALSE
		else
			wander = FALSE
			speak_chance = 0
			stat = UNCONSCIOUS
			is_angry = FALSE
		update_icon()

/mob/living/simple_animal/opossum/adjustBruteLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/adjustFireLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		if(!is_angry)
			is_angry = TRUE
			custom_emote(src, "hisses!")
		else
			resting = TRUE
			custom_emote(src, "dies!")
		update_icon()

/mob/living/simple_animal/opossum/looks_dead()
	if(is_angry && resting)
		return TRUE
	return ..()

/mob/living/simple_animal/opossum/poke()
	return

/mob/living/simple_animal/opossum/update_icon()
	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

/mob/living/simple_animal/opossum/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/opossum/poppy
	name = "Poppy"
	desc = "It's an opossum, a small scavenging marsupial. It's wearing appropriate personal protective equipment, though."
	icon = 'icons/mob/poppy_opossum.dmi'
	var/list/aaa_words = list("delaminat", "meteor", "fire", "breach")

/mob/living/simple_animal/opossum/poppy/Initialize(mapload)
	. = ..()

	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/mob/living/simple_animal/opossum/poppy/LateInitialize()
	if(length(all_trash_piles))
		var/obj/structure/trash_pile/TP = pick(all_trash_piles)
		forceMove(TP)
		TP.hider = src

/mob/living/simple_animal/opossum/poppy/hear_broadcast(datum/language/language, mob/speaker, speaker_name, message)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/opossum/poppy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/opossum/poppy/proc/check_keywords(var/message)
	if(!client && stat == CONSCIOUS)
		message = lowertext(message)
		for(var/aaa in aaa_words)
			if(findtext(message, aaa))
				respond_to_damage()