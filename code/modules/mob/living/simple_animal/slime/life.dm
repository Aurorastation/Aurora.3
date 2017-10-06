/mob/living/simple_animal/slime/proc/adjust_nutrition(input)
	nutrition = between(0, nutrition + input, get_max_nutrition())

	if(input > 0)
		if(prob(input * 2)) // Gain around one level per 50 nutrition
			power_charge = min(power_charge++, 10)
			if(power_charge == 10)
				adjustToxLoss(-10)


/mob/living/simple_animal/slime/proc/get_max_nutrition() // Can't go above it
	if(is_adult)
		return 1200
	return 1000

/mob/living/simple_animal/slime/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	if(is_adult)
		return 1000
	return 800

/mob/living/simple_animal/slime/proc/get_hunger_nutrition() // Below it we will always eat
	if(is_adult)
		return 600
	return 500

/mob/living/simple_animal/slime/proc/get_starve_nutrition() // Below it we will eat before everything else
	if(is_adult)
		return 300
	return 200

/mob/living/simple_animal/slime/proc/handle_nutrition()
	if(docile)
		return
	if(prob(15))
		adjust_nutrition(-1 - is_adult)

	if(nutrition <= get_starve_nutrition())
		handle_starvation()

	else if(nutrition >= get_grow_nutrition() && amount_grown < 10)
		adjust_nutrition(-20)
		amount_grown = between(0, amount_grown + 1, 10)

/mob/living/simple_animal/slime/proc/handle_starvation()
	if(nutrition < get_starve_nutrition() && !client) // if a slime is starving, it starts losing its friends
		if(friends.len && prob(1))
			var/mob/nofriend = pick(friends)
			if(nofriend)
				friends -= nofriend
				say("[nofriend]... food now...")

	if(nutrition <= 0)
		adjustToxLoss(rand(1,3))
		if(client && prob(5))
			to_chat(src, "<span class='danger'>You are starving!</span>")

/mob/living/simple_animal/slime/proc/handle_discipline()
	if(discipline > 0)
		update_mood()
	//	if(discipline >= 5 && rabid)
	//		if(prob(60))
	//			rabid = 0
	//			adjust_discipline(1) // So it stops trying to murder everyone.

		// Handle discipline decay.
		if(!prob(75 + (obedience * 5)))
			adjust_discipline(-1)
	if(!discipline)
		update_mood()

/mob/living/simple_animal/slime/handle_regular_status_updates()
	if(stat != DEAD)
		handle_nutrition()

		handle_discipline()

		if(prob(30))
			adjustOxyLoss(-1)
			adjustToxLoss(-1)
			adjustFireLoss(-1)
			adjustCloneLoss(-1)
			adjustBruteLoss(-1)

		if(victim)
			handle_consumption()

		if(amount_grown >= 10 && !target_mob && !client)
			if(is_adult)
				reproduce()
			else
				evolve()

		handle_stuttering()

	..()


// This is to make slime responses feel a bit more natural and not instant.
/mob/living/simple_animal/slime/proc/delayed_say(var/message, var/mob/target)
	sleep(rand(1 SECOND, 2 SECONDS))
	if(target)
		face_atom(target)
	say(message)

//Commands, reactions, etc
/mob/living/simple_animal/slime/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if((findtext(message, num2text(number)) || findtext(message, name) || findtext(message, "slimes"))) // Talking to us

		// Say hello back.
		if(findtext(message, "hello") || findtext(message, "hi") || findtext(message, "greetings"))
			delayed_say(pick("Hello...", "Hi..."), speaker)

		// Follow request.
		if(findtext(message, "follow") || findtext(message, "come with me"))
			if(!can_command(speaker))
				delayed_say(pick("No...", "I won't follow..."), speaker)
				return

			delayed_say("Yes... I follow \the [speaker]...", speaker)
			set_follow(speaker)
			FollowTarget()

		// Stop request.
		if(findtext(message, "stop") || findtext(message, "halt") || findtext(message, "cease"))
			if(victim) // We're being asked to stop eatting someone.
				if(!can_command(speaker))
					delayed_say("No...", speaker)
					return
				else
					delayed_say("Fine...", speaker)
					stop_consumption()
					adjust_discipline(1, TRUE)

			if(target_mob) // We're being asked to stop chasing someone.
				if(!can_command(speaker))
					delayed_say("No...", speaker)
					return
				else
					delayed_say("Fine...", speaker)
					LoseTarget()
					adjust_discipline(1, TRUE)

			if(follow_mob) // We're being asked to stop following someone.
				if(follow_mob == speaker)
					delayed_say("Yes... I'll stop...", speaker)
					LoseFollow()
				else
					delayed_say("No... I'll keep following \the [follow_mob]...", speaker)

		// Help request
		if(findtext(message, "help"))
			if(!can_command(speaker))
				delayed_say("No...", speaker)
				return
			else
				delayed_say("I will protect \the [speaker].", speaker)

		// Murder request
		if(findtext(message, "harm") || findtext(message, "kill") || findtext(message, "murder") || findtext(message, "eat") || findtext(message, "consume"))
			if(!can_command(speaker))
				delayed_say("No...", speaker)
				return

		//LoseFollow()

	/*
	if(reacts && speaker && (message in reactions) && (!hostile || isliving(speaker)) && say_understands(speaker,language))
		var/mob/living/L = speaker
		if(L.faction == faction)
			spawn(10)
				face_atom(speaker)
				say(reactions[message])
	*/