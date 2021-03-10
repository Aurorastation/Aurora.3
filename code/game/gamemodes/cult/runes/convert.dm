/datum/rune/convert
	name = "conversion rune"
	desc = "A rune used to convert the Unenlightened."
	rune_flags = NO_TALISMAN | CAN_MEMORIZE

	var/list/converting

/datum/rune/convert/do_rune_action(mob/living/user, atom/movable/A)
	LAZYINITLIST(converting)
	var/mob/living/carbon/target
	for(var/mob/living/carbon/M in get_turf(A))
		if(!iscultist(M) && M.stat < DEAD && !(M in converting))
			target = M
			break

	if(!target) //didn't find any new targets
		if(!converting.len)
			fizzle(user, A)
			LAZYCLEARLIST(converting)
		else
			to_chat(user, SPAN_CULT("They are already being enlightened by the Dark One."))
		return

	user.say("Mah'weyh pleggh at e'ntrath!")

	LAZYDISTINCTADD(converting, target)
	var/list/waiting_for_input = list(target = 0) //need to box this up in order to be able to reset it again from inside spawn, apparently
	var/initial_message = 0
	while(target in converting)
		if(get_turf(target) != get_turf(A) || target.stat == DEAD)
			converting -= target
			if(target.getFireLoss() < 100)
				target.hallucination = min(target.hallucination, 500)
			return FALSE

		target.take_overall_damage(0, rand(5, 20)) // You dirty resister cannot handle the damage to your mind. Easily. - even cultists who accept right away should experience some effects
		// Resist messages go!
		if(initial_message) //don't do this stuff right away, only if they resist or hesitate.
			admin_attack_log(user, target, "Used a convert rune", "Was subjected to a convert rune", "used a convert rune on")
			switch(target.getFireLoss())
				if(0 to 25)
					to_chat(target, SPAN_CULT("Your blood boils as you force yourself to resist the corruption invading every corner of your mind."))
					target.take_overall_damage(0, 3)
				if(25 to 45)
					to_chat(target, SPAN_CULT("Your blood boils and your body burns as the corruption further forces itself into your body and mind."))
					target.take_overall_damage(0, 5)
				if(45 to 75)
					to_chat(target, SPAN_CULT("You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble."))
					target.apply_effect(rand(1, 10), STUTTER)
					target.take_overall_damage(0, 10)
				if(75 to 100)
					to_chat(target, SPAN_CULT("Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance."))
					//broken mind - 5000 may seem like a lot I wanted the effect to really stand out for maxiumum losing-your-mind-spooky
					//hallucination is reduced when the step off as well, provided they haven't hit the last stage...
					target.hallucination += 5000
					target.apply_effect(10, STUTTER)
					target.adjustBrainLoss(1)
				if(100 to INFINITY)
					to_chat(target, SPAN_CULT("Your entire broken soul and being is engulfed in corruption and flames as your mind shatters away into nothing."))
					target.hallucination += 5000
					target.apply_effect(15, STUTTER)
					target.adjustBrainLoss(rand(1, 5))

		initial_message = TRUE
		if(!target.can_feel_pain())
			target.visible_message(SPAN_WARNING("The markings below [target] glow a bloody red."))
		else
			target.visible_message(SPAN_WARNING("[target] writhes in pain as the markings below [target.get_pronoun("him")] glow a bloody red."), SPAN_DANGER("AAAAAAHHHH!"))

		if(!waiting_for_input[target]) //so we don't spam them with dialogs if they hesitate
			waiting_for_input[target] = TRUE

			if(!cult.can_become_antag(target.mind) || player_is_antag(target.mind))
				if(jobban_isbanned(target.mind, "cultist"))
					shard_player(target, A)
				else
					//waiting_for_input ensures this is only shown once, so they basically auto-resist from here on out. They still need to find a way to get off the freaking rune if they don't want to burn to death, though.
					to_chat(target, SPAN_CULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind, something sinister takes root."))
					to_chat(target, SPAN_CULT("And you were able to force it out of your mind. Though the memory of that dark, horrible vision will surely haunt you for decades to come."))
					target.visible_message(SPAN_WARNING("The markings below [target] lose their glow, this unworthy offering has been rejected!"))
			else
				var/choice = alert(target,"Do you want to join the cult? (Choosing ghost will ghost you and spawn a shade)", "Submit to Nar'Sie", "Resist", "Submit", "Ghost")
				waiting_for_input[target] = FALSE
				switch(choice)
					if("Submit")
						cult.add_antagonist(target.mind)
						converting -= target
						target.hallucination = 0 //sudden clarity
						target.setBrainLoss(0) // nar'sie heals you
						sound_to(target, 'sound/effects/bloodcult.ogg')
					if("Ghost")
						shard_player(target, A)

		sleep(100) //proc once every 10 seconds
	LAZYCLEARLIST(converting)
	return TRUE

/datum/rune/convert/proc/shard_player(var/mob/living/target, atom/movable/A)
	converting -= target
	var/obj/item/device/soulstone/stone = new /obj/item/device/soulstone(get_turf(A))
	target.death()
	stone.transfer_human(target)
	var/mob/living/simple_animal/shade/shade = locate() in stone
	announce_ghost_joinleave(shade)
	shade.ghostize(FALSE)
	target.dust()