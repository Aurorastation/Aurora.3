/mob/living/simple_animal/hostile/mech
	icon = 'icons/mob/npc/toy_mech.dmi'

	accent = ACCENT_TTS
	speak_emote = list("announces")
	speak = list("You're going down!", "I'm taking you to poundtown!", "Die!", "Buy my merch!")
	var/list/victory_speech = list("HA-HA-HA!", "Six feet under!", "Weak!")
	speak_chance = 5
	universal_speak = FALSE

	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 2
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	attack_emote = "raises its fist at"
	attacktext = "smashed"
	attack_sound = 'sound/weapons/woodenhit.ogg'
	speed = 2
	mob_size = MOB_MINISCULE
	tameable = FALSE

	blood_overlay_icon = null

	var/seeking_targets = FALSE
	var/list/seeking_speech = list("ONWARDS!", "KILL!", "R-R-R-RUMBLE!", "WOO-HOO!")
	var/obj/item/toy/mech/contained_mech


/mob/living/simple_animal/hostile/mech/Initialize(mapload, var/obj/item/toy/mech/parent)
	. = ..()
	if(!parent)
		return INITIALIZE_HINT_QDEL

	name = replacetext(parent.name, "toy ", "")
	desc = parent.desc
	icon_state = initial(parent.icon_state)
	icon_living = initial(parent.icon_state)
	icon_dead = "[initial(parent.icon_state)]-dead"
	contained_mech = parent
	parent.forceMove(src)

/mob/living/simple_animal/hostile/mech/setup_target_type_validators()
	target_type_validator_map[/mob/living/simple_animal/hostile/mech] = CALLBACK(src, PROC_REF(validator_rival))

/mob/living/simple_animal/hostile/mech/proc/validator_rival(var/mob/living/rival, var/atom/current)
	if(!seeking_targets)
		return FALSE
	if(rival.stat)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/mech/on_attack_mob(mob/living/simple_animal/hostile/mech/rival)
	if(prob(5))
		switch(rand(1, 2))
			if(1)
				rival.forceMove(loc)
				visible_message("<b>[src]</b> lifts \the [rival] over its head and slams them down into the ground behind them!")
				rival.throw_at(get_step(src, reverse_dir[dir]), 1, 3, src, TRUE)
				playsound(loc, 'sound/effects/bang.ogg', 50, 1)
				rival.apply_damage(2, BRUTE)
			if(2)
				visible_message("<b>[src]</b> leaps into the air and superman punches \the [rival]!")
				animate(src, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
				animate(pixel_z = 0, time = 3, easing = SINE_EASING | EASE_OUT)
				playsound(loc, 'sound/weapons/cardboardhit.ogg', 50, 1)
				rival.apply_damage(2, BRUTE)
	if(rival.health <= 0)
		say(pick(victory_speech))

/mob/living/simple_animal/hostile/mech/attack_hand(mob/living/carbon/human/human)
	if(human.a_intent == I_HELP)
		human.put_in_hands(contained_mech)
		contained_mech = null
		qdel(src)
		return
	return ..()

/mob/living/simple_animal/hostile/mech/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!seeking_targets)
		addtimer(CALLBACK(src, PROC_REF(handle_hear_say), speaker, message), 0.5 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/mech/proc/handle_hear_say(var/mob/speaker, var/text)
	if(seeking_targets)
		return

	if(findtext(lowertext(text), "attack"))
		seeking_targets = TRUE
		say(pick(seeking_speech))

/mob/living/simple_animal/hostile/mech/Destroy()
	QDEL_NULL(contained_mech)
	return ..()
