/obj/effect/rune/convert/do_rune_action(mob/living/user)
	var/mob/living/attacker = user
	var/mob/living/carbon/target = null
	for(var/mob/living/carbon/M in src.loc)
		if(!iscultist(M) && M.stat < DEAD && !(M in converting))
			target = M
			break

	if(!target) //didn't find any new targets
		if(!converting.len)
			fizzle(user)
		else
			to_chat(user, span("cult", "You sense that the power of the dark one is already working away at them."))
		return

	user.say("Mah[pick("'","`")]weyh pleggh at e'ntrath!")

	converting |= target
	var/list/waiting_for_input = list(target = 0) //need to box this up in order to be able to reset it again from inside spawn, apparently
	var/initial_message = 0
	while(target in converting)
		if(target.loc != src.loc || target.stat == DEAD)
			converting -= target
			if(target.getFireLoss() < 100)
				target.hallucination = min(target.hallucination, 500)
			return FALSE

		target.take_overall_damage(0, rand(5, 20)) // You dirty resister cannot handle the damage to your mind. Easily. - even cultists who accept right away should experience some effects
		// Resist messages go!
		if(initial_message) //don't do this stuff right away, only if they resist or hesitate.
			admin_attack_log(attacker, target, "Used a convert rune", "Was subjected to a convert rune", "used a convert rune on")
			switch(target.getFireLoss())
				if(0 to 25)
					to_chat(target, span("cult", "Your blood boils as you force yourself to resist the corruption invading every corner of your mind."))
					target.take_overall_damage(0, 3)
				if(25 to 45)
					to_chat(target, span("cult", "Your blood boils and your body burns as the corruption further forces itself into your body and mind."))
					target.take_overall_damage(0, 5)
				if(45 to 75)
					to_chat(target, span("cult", "You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble."))
					target.apply_effect(rand(1, 10), STUTTER)
					target.take_overall_damage(0, 10)
				if(75 to 100)
					to_chat(target, span("cult", "Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance."))
					//broken mind - 5000 may seem like a lot I wanted the effect to really stand out for maxiumum losing-your-mind-spooky
					//hallucination is reduced when the step off as well, provided they haven't hit the last stage...
					target.hallucination += 5000
					target.apply_effect(10, STUTTER)
					target.adjustBrainLoss(1)
				if(100 to INFINITY)
					to_chat(target, span("cult", "Your entire broken soul and being is engulfed in corruption and flames as your mind shatters away into nothing."))
					target.hallucination += 5000
					target.apply_effect(15, STUTTER)
					target.adjustBrainLoss(rand(1, 5))

		initial_message = TRUE
		if(!target.can_feel_pain())
			target.visible_message(span("warning", "The markings below [target] glow a bloody red."))
		else
			target.visible_message(span("warning", "[target] writhes in pain as the markings below \him glow a bloody red."), span("danger", "AAAAAAHHHH!"))

		if(!waiting_for_input[target]) //so we don't spam them with dialogs if they hesitate
			waiting_for_input[target] = TRUE

			if(!cult.can_become_antag(target.mind) || jobban_isbanned(target, "cultist"))//putting jobban check here because is_convertable uses mind as argument
				//waiting_for_input ensures this is only shown once, so they basically auto-resist from here on out. They still need to find a way to get off the freaking rune if they don't want to burn to death, though.
				to_chat(target, span("cult", "Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind, something sinister takes root."))
				to_chat(target, span("cult", "And you were able to force it out of your mind. Though the memory of that dark, horrible vision will surely haunt you for decades to come."))
				var/has_implant // we don't want people with loy implants to just get gibbed
				for(var/obj/item/implant/mindshield/L in target)
					if(L?.imp_in == target)
						has_implant = TRUE
				if(!has_implant)
					to_chat(target, span("cult", "..or will it?"))
					target.gib() // people who can't be cultists get gibbed to preserve cult anonymity
			else
				var/choice = alert(target,"Do you want to join the cult?", "Submit to Nar'Sie", "Resist", "Submit")
				waiting_for_input[target] = FALSE
				if(choice == "Submit") //choosing 'Resist' does nothing of course.
					cult.add_antagonist(target.mind)
					converting -= target
					target.hallucination = 0 //sudden clarity
					target.setBrainLoss(0) // nar'sie heals you
					sound_to(target, 'sound/effects/bloodcult.ogg')
		sleep(100) //proc once every 10 seconds
	return TRUE