/mob/living/carbon/slime/Life()
	set background = BACKGROUND_ENABLED

	if(src.transforming)
		return
	..()

	if(stat != DEAD)
		handle_nutrition()
		if(!is_ventcrawling) // Stops sight returning to normal if inside a vent
			sight = initial(sight)

/mob/living/carbon/slime/think()
	..()
	handle_targets()
	if(!AIproc || last_AI > world.time + 1 MINUTE)
		handle_AI()
	handle_speech_and_mood()

/mob/living/carbon/slime/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		adjustToxLoss(rand(10,20))
		return

	//var/environment_heat_capacity = environment.heat_capacity()
	var/loc_temp = T0C
	if(istype(get_turf(src), /turf/space))
		//environment_heat_capacity = loc:heat_capacity
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature
	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		var/obj/machinery/atmospherics/unary/cryo_cell/C = loc
		loc_temp = C.air_contents?.temperature
	else
		loc_temp = environment.temperature

	if(loc_temp < 310.15) // a cold place
		bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1)
	else // a hot place
		bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1)

	//Account for massive pressure differences

	if(bodytemperature < (T0C + 5)) // start calculating temperature damage etc
		if(bodytemperature <= hurt_temperature)
			if(bodytemperature <= die_temperature)
				adjustToxLoss(200)
			else
				// could be more fancy, but doesn't worth the complexity: when the slimes goes into a cold area
				// the damage is mostly determined by how fast its body cools
				adjustToxLoss(30)

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change

/mob/living/carbon/slime/handle_chemicals_in_body()
	chem_effects.Cut()
	analgesic = FALSE

	if(touching)
		touching.metabolize()
	if(ingested)
		ingested.metabolize()
	if(bloodstr)
		bloodstr.metabolize()
	if(breathing)
		breathing.metabolize()

	if(CE_PAINKILLER in chem_effects)
		analgesic = chem_effects[CE_PAINKILLER]

	src.updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/handle_regular_status_updates()

	src.blinded = null

	health = maxHealth - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

	if(health < 0 && stat != DEAD)
		death()
		return

	if(prob(30))
		adjustOxyLoss(-1)
		adjustToxLoss(-1)
		adjustFireLoss(-1)
		adjustCloneLoss(-1)
		adjustBruteLoss(-1)

	if(src.stat == DEAD)
		src.lying = TRUE
		src.blinded = TRUE
	else
		if(src.paralysis || src.stunned || src.weakened || (status_flags && FAKEDEATH)) //Stunned etc.
			if(src.stunned > 0)
				AdjustStunned(-1)
				src.stat = CONSCIOUS
			if(src.weakened > 0)
				AdjustWeakened(-1)
				src.lying = FALSE
				src.stat = FALSE
			if(src.paralysis > 0)
				AdjustParalysis(-1)
				src.blinded = FALSE
				src.lying = FALSE
				src.stat = FALSE
		else
			src.lying = FALSE
			src.stat = FALSE

	if(src.stuttering)
		src.stuttering = FALSE

	if(src.eye_blind)
		src.eye_blind = FALSE
		src.blinded = TRUE

	if(src.ear_deaf > 0)
		src.ear_deaf = FALSE
	if(src.ear_damage < 25)
		src.ear_damage = FALSE

	src.density = !src.lying

	if(src.sdisabilities & BLIND)
		src.blinded = TRUE
	if(src.sdisabilities & DEAF)
		src.ear_deaf = TRUE

	if(src.eye_blurry > 0)
		src.eye_blurry = FALSE

	if(src.druggy > 0)
		src.druggy = FALSE

	return TRUE

/mob/living/carbon/slime/proc/handle_nutrition()
	if(prob(15))
		adjustNutritionLoss(1 + is_adult)

	if(nutrition <= 0)
		nutrition = 0
		adjustToxLoss(rand(1,3))
		if(client && prob(5))
			to_chat(src, span("danger", "You are starving!"))

	else if(nutrition >= get_grow_nutrition() && amount_grown < 5)
		adjustNutritionLoss(20)
		amount_grown++

/mob/living/carbon/slime/proc/handle_targets()
	if(attacked > 50)
		attacked = 50 // Let's not get into absurdly long periods of rage

	if(attacked > 0)
		attacked--

	if(discipline > 0)
		if(discipline >= 5 && rabid)
			if(prob(60))
				rabid = 0
		if(prob(10))
			discipline--

	if(!canmove)
		return

	if(victim)
		return // if it's eating someone already, continue eating!

	if(target)
		--target_patience
		if(target_patience <= 0 || SStun || discipline || attacked) // Tired of chasing or something draws out attention
			target_patience = 0
			target = null

	var/hungry = 0 // determines if the slime is hungry

	if(nutrition < get_starve_nutrition())
		hungry = 2
	else if(nutrition < get_grow_nutrition() && prob(25) || nutrition < get_hunger_nutrition())
		hungry = 1

	if(hungry == 2 && !client) // if a slime is starving, it starts losing its friends
		if(friends.len > 0 && prob(1))
			var/mob/nofriend = pick(friends)
			if(nofriend && friends[nofriend])
				friends[nofriend] -= 1
				if (friends[nofriend] <= 0)
					friends[nofriend] = null
					friends -= nofriend
					friends -= null

	if(!target)
		if(will_hunt(hungry) || attacked || rabid) // Only add to the list if we need to
			var/list/targets = list()

			for(var/mob/living/L in view(7,src))
				if(isslime(L) || L.stat == DEAD || L.is_asystole()) // Ignore other slimes and dead mobs
					continue
				if(isskrell(L)) // we do not attack skrell - lore reason.
					continue
				if(L in friends) // No eating friends!
					continue

				if(issilicon(L) && (rabid || attacked)) // They can't eat silicons, but they can glomp them in defence
					targets += L // Possible target found!

				if(ishuman(L)) //Ignore slime(wo)men
					var/mob/living/carbon/human/H = L
					if(H.species.name == "Slime")
						continue

				if(!L.canmove) // Only one slime can latch on at a time.
					var/notarget = FALSE
					for(var/mob/living/carbon/slime/M in view(1,L))
						if(M.victim == L)
							notarget = TRUE
					if(notarget)
						continue

				targets += L // Possible target found!

			if(targets.len > 0)
				if(attacked || rabid || hungry == 2)
					target = targets[1] // I am attacked and am fighting back or so hungry I don't even care
				else
					for(var/mob/living/carbon/C in targets)
						if(ishuman(C) && !discipline && prob(5))
							target = C
							break

						if(isalien(C) || issmall(C) || isanimal(C))
							target = C
							break

		if(target)
			target_patience = rand(5,7)
			if (is_adult)
				target_patience += 3

	if(!target) // If we have no target, we are wandering or following orders
		if(leader)
			if(holding_still)
				holding_still = max(holding_still - 1, 0)
			else if(canmove && isturf(loc))
				step_to(src, leader)

		else if(hungry)
			if(holding_still)
				holding_still = max(holding_still - 1 - hungry, 0)
			else if(canmove && isturf(loc) && prob(50))
				step(src, pick(cardinal))

		else
			if(holding_still)
				holding_still = max(holding_still - 1, 0)
			else if(canmove && isturf(loc) && prob(33))
				step(src, pick(cardinal))

/mob/living/carbon/slime/proc/handle_AI() // the master AI process
	if(victim?.stat & DEAD)
		victim = null

	last_AI = world.time

	if(stat == DEAD || client || victim)
		return // If we're dead or have a client, we don't need AI, if we're feeding, we continue feeding
	AIproc = TRUE

	if(amount_grown >= 5)
		if(is_adult)
			Reproduce()
		else
			Evolve()
		AIproc = FALSE
		return

	if(target) // We're chasing the target
		if(target.stat == DEAD || target.is_asystole())
			target = null
			AIproc = FALSE
			return

		for(var/mob/living/carbon/slime/M in view(1, target))
			if(M.victim == target)
				target = null
				AIproc = FALSE
				return

		if(target.Adjacent(src))
			if(istype(target, /mob/living/silicon)) // Glomp the silicons
				if(!Atkcool)
					a_intent = I_HURT
					UnarmedAttack(target)
					Atkcool = TRUE
					spawn(45)
						Atkcool = FALSE
				AIproc = FALSE
				return

			if(target.client && !target.lying && prob(60 + powerlevel * 4)) // Try to take down the target first
				if(!Atkcool)
					Atkcool = TRUE
					spawn(45)
						Atkcool = FALSE

					a_intent = I_DISARM
					UnarmedAttack(target)

			else
				if(!Atkcool)
					a_intent = I_GRAB
					UnarmedAttack(target)

		else if(target in view(7, src))
			step_to(src, target)

		else
			target = null
			AIproc = FALSE
			return

	else
		var/mob/living/carbon/slime/frenemy
		for(var/mob/living/carbon/slime/S in view(1, src))
			if(S != src)
				frenemy = S
		if(frenemy && prob(1))
			if(frenemy.colour == colour)
				a_intent = I_HELP
			else
				a_intent = I_HURT
			UnarmedAttack(frenemy)

	var/sleeptime = movement_delay()
	if(sleeptime <= 5)
		sleeptime = 5 // Maximum one action per half a second
	spawn(sleeptime)
		handle_AI()
	return

/mob/living/carbon/slime/proc/handle_speech_and_mood()
	//Mood starts here
	var/newmood = ""
	a_intent = I_HELP
	if(rabid || attacked)
		set_content(FALSE)
		newmood = ANGRY
		a_intent = I_HURT
	else if(target)
		newmood = MISCHIEVOUS

	if(!newmood)
		if(discipline && prob(25))
			newmood = POUT
		else if(prob(1))
			newmood = pick(SAD, HAPPY, POUT)

	if((mood == SAD || mood == HAPPY || mood == POUT) && !newmood)
		if(prob(75))
			newmood = mood

	if(!newmood && !mood && content)
		mood = HAPPY

	if(newmood != mood) // This is so we don't redraw them every time
		mood = newmood
		regenerate_icons()

	//Speech understanding starts here
	var/to_say
	if(speech_buffer.len > 0)
		var/who = speech_buffer[1] // Who said it?
		var/phrase = speech_buffer[2] // What did they say?
		if((findtext(phrase, num2text(number)) || findtext(phrase, "slimes"))) // Talking to us
			if(findtext(phrase, "hello") || findtext(phrase, "hi"))
				to_say = pick("Hello...", "Hi...")
			else if(findtext(phrase, "follow"))
				if(leader)
					if(leader == who) // Already following him
						to_say = pick("Yes...", "Lead...", "Following...")
					else if(friends[who] > friends[leader]) // VIVA
						leader = who
						to_say = "Yes... I follow [who]..."
					else
						to_say = "No... I follow [leader]..."
				else
					if(friends[who] > 2)
						leader = who
						to_say = "I follow..."
					else // Not friendly enough
						to_say = pick("No...", "I won't follow...")
			else if(findtext(phrase, "stop"))
				if(victim) // We are asked to stop feeding
					if(friends[who] > 4)
						victim = null
						target = null
						if(friends[who] < 7)
							--friends[who]
							to_say = "Grrr..." // I'm angry but I do it
						else
							to_say = "Fine..."
				else if(target) // We are asked to stop chasing
					if(friends[who] > 3)
						target = null
						if(friends[who] < 6)
							--friends[who]
							to_say = "Grrr..." // I'm angry but I do it
						else
							to_say = "Fine..."
				else if(leader) // We are asked to stop following
					if(leader == who)
						to_say = "Yes... I'll stay..."
						leader = null
					else
						if(friends[who] > friends[leader])
							leader = null
							to_say = "Yes... I'll stop..."
						else
							to_say = "No... I'll keep following..."
			else if(findtext(phrase, "stay"))
				if(leader)
					if(leader == who)
						holding_still = friends[who] * 10
						to_say = "Yes... Staying..."
					else if(friends[who] > friends[leader])
						holding_still = (friends[who] - friends[leader]) * 10
						to_say = "Yes... Staying..."
					else
						to_say = "No... I'll keep following..."
				else
					if(friends[who] > 2)
						holding_still = friends[who] * 10
						to_say = "Yes... Staying..."
					else
						to_say = "No... I won't stay..."
		speech_buffer = list()

	//Speech starts here
	if(to_say)
		say(to_say)
	else if(prob(1))
		emote(pick("bounce","sway","light","vibrate","jiggle"))
	else
		var/t = 10
		var/slimes_near = -1 // Don't count myself
		var/dead_slimes = 0
		var/friends_near = list()
		for(var/mob/living/carbon/M in view(7,src))
			if(isslime(M))
				++slimes_near
				if(M.stat == DEAD)
					++dead_slimes
			if(M in friends)
				t += 20
				friends_near += M
		if(nutrition < get_hunger_nutrition())
			t += 10
		if(nutrition < get_starve_nutrition())
			t += 10
		if(prob(2) && prob(t))
			var/phrases = list()
			if(target)
				phrases += "[target]... looks tasty..."
			if(nutrition < get_starve_nutrition())
				phrases += "So... hungry..."
				phrases += "Very... hungry..."
				phrases += "Need... food..."
				phrases += "Must... eat..."
			else if(nutrition < get_hunger_nutrition())
				phrases += "Hungry..."
				phrases += "Where is the food?"
				phrases += "I want to eat..."
			phrases += "Rawr..."
			phrases += "Blop..."
			phrases += "Blorble..."
			if(rabid || attacked)
				phrases += "Hrr..."
				phrases += "Nhuu..."
				phrases += "Unn..."
			if(mood == HAPPY)
				phrases += "Purr..."
			if(attacked)
				phrases += "Grrr..."
			if(getToxLoss() > 30)
				phrases += "Cold..."
			if(getToxLoss() > 60)
				phrases += "So... cold..."
				phrases += "Very... cold..."
			if(getToxLoss() > 90)
				phrases += "..."
				phrases += "C... c..."
			if(victim)
				phrases += "Nom..."
				phrases += "Tasty..."
			if(powerlevel > 3)
				phrases += "Bzzz..."
			if(powerlevel > 5)
				phrases += "Zap..."
			if(powerlevel > 8)
				phrases += "Zap... Bzz..."
			if(mood == "sad")
				phrases += "Bored..."
			if(slimes_near)
				phrases += "Brother..."
			if(slimes_near > 1)
				phrases += "Brothers..."
			if(dead_slimes)
				phrases += "What happened?"
			if(!slimes_near)
				phrases += "Lonely..."
			for(var/M in friends_near)
				phrases += "[M]... friend..."
				if(nutrition < get_hunger_nutrition())
					phrases += "[M]... feed me..."
			say(pick(phrases))

/mob/living/carbon/slime/proc/get_max_nutrition() // Can't go above it
	if(is_adult)
		return 1200
	else
		return 1000

/mob/living/carbon/slime/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	if(is_adult)
		return 1000
	else
		return 800

/mob/living/carbon/slime/proc/get_hunger_nutrition() // Below it we will always eat
	if(is_adult)
		return 600
	else
		return 500

/mob/living/carbon/slime/proc/get_starve_nutrition() // Below it we will eat before everything else
	if(is_adult)
		return 300
	else
		return 200

/mob/living/carbon/slime/proc/will_hunt(var/hunger) // Check for being stopped from feeding and chasing
	if(hunger == 2 || rabid || attacked)
		return TRUE
	if(nutrition == get_max_nutrition())
		return FALSE
	if(leader)
		return FALSE
	if(holding_still)
		return FALSE
	if(hunger == 1 || prob(25))
		return TRUE
	return FALSE

/mob/living/carbon/slime/slip() //Can't slip something without legs.
	return FALSE