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

/mob/living/simple_animal/shade/cultify()
	return

/mob/living/simple_animal/shade/death()
	visible_message("<span class='warning'>[src] lets out a contented sigh as their form unwinds.</span>")
	new /obj/item/weapon/ectoplasm(loc)
	. = ..()

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
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	icon_living = "bluespace"
	icon_dead = "bluespace"
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
	speed = 1
	status_flags = CANPUSH
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	unsuitable_atoms_damage = 0
	incorporeal_move = 3
	mob_size = 0
	density = 0
	var/last_message_heard
	var/message_countdown = 300
	var/heard_dying_message = 0

/mob/living/simple_animal/shade/bluespace/apply_damage()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustBruteLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustFireLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustToxLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustOxyLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustCloneLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/adjustHalLoss()
	return 0

/mob/living/simple_animal/shade/bluespace/attempt_grab()
	return 0

/mob/living/simple_animal/shade/bluespace/Stat()
	..()

	if(statpanel("Status"))
		stat(null, "Strength of Echoes: [message_countdown]")

/mob/living/simple_animal/shade/bluespace/Life()
	message_countdown = min(0, message_countdown--)
	if(message_countdown <= 0)
		health = max(0, health - rand(2, 10))
		if(!heard_dying_message)
			heard_dying_message = 1
			to_chat(src, "<span class='danger'>You feel yourself begin to fade away!</span>")
	..()

/mob/living/simple_animal/shade/bluespace/hear_say(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	if(speaker != src)
		last_message_heard = message
		message_countdown = min(300, message_countdown + 50)
		health = min(maxHealth, health + 5)
		if(heard_dying_message)
			heard_dying_message = 0
			to_chat(src, "<span class='notice'>The soothing echoes of life reinvigorate you.</span>")
	..()

/mob/living/simple_animal/shade/bluespace/say(var/message)
	var/list/words = list()
	for(var/word in last_message_heard)
		words += word
	for(var/word1 in message)
		var/valid = 0
		for(var/word2 in last_message_heard)
			if(lowertext(word1) != lowertext(word2))
				continue
			else
				valid = 1
				break
		if(!valid)
			message = replacetext(message, word1, pick(words))
	message = slur(message,rand(20,80))
	..()

/mob/living/simple_animal/shade/bluespace/verb/show_last_message()
	set name = "Current Echo"
	set category = "Bluespace Echo"
	set desc = "Privately display the last message you heard."

	to_chat(src, "<span class='notice'><b>[last_message_heard]</b></span>")

/mob/living/simple_animal/shade/bluespace/verb/flicker()
	set name = "Flicker Lights"
	set category = "Bluespace Echo"

	visible_message("<span class ='notice'>\The [src] pulses.</span>")
	for(var/obj/machinery/light/L in view(5, src))
		L.flicker()

/mob/living/simple_animal/shade/bluespace/verb/move_item()
	set category = "Bluespace Echo"
	set name = "Warp Item"
	set desc = "Teleport a small item to where you are."

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

/mob/living/simple_animal/shade/bluespace/verb/mass_warp()
	set category = "Bluespace Echo"
	set name = "Warp Vortex"
	set desc = "Teleport items wildly."

	if(message_countdown < 200)
		to_chat(src, "<span class='warning'>You are too faded to warp an item through bluespace.</span>")
		return

	var/list/liable_turfs = list()

	for(var/turf/T in view(4, src))
		liable_turfs += T

	if(liable_turfs.len)
		visible_message("<span class ='danger'>\The [src] pulses violently!</span>")
		for(var/atom/movable/M in view(7, src))
			if(!M.anchored)
				do_teleport(M, pick(liable_turfs))
				message_countdown = max(0, message_countdown - 20)

/mob/living/simple_animal/shade/bluespace/verb/force_message()
	set category = "Bluespace Echo"
	set name = "Force Message"
	set desc = "Force a coherent message of your own choosing."

	if(message_countdown < 300)
		to_chat(src, "<span class='warning'>You are too faded to force a message out.</span>")
		return

	var/message = input("Write out a message", "Forceful Message")

	if(message)
		visible_message("<span class ='danger'>\The [src] screeches, [message]!</span>")
		message_countdown = max(0, message_countdown - 300)