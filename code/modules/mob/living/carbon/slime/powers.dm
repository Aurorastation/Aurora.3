/mob/living/carbon/slime/proc/Wrap(var/mob/living/M) // This is a proc for the clicks
	if(victim == M || src == M)
		Feedstop()
		return

	if(victim)
		to_chat(src, span("warning", "I am already feeding..."))
		return

	var/target = invalidFeedTarget(M)
	if(target)
		to_chat(src, target)
		return

	Feedon(M)

/mob/living/carbon/slime/proc/invalidFeedTarget(var/mob/living/M)
	if(!M || !istype(M))
		return "This subject is incompatible.."
	if(istype(M, /mob/living/carbon/slime)) // No cannibalism... yet
		return "I cannot feed on other slimes..."
	if(!Adjacent(M))
		return "This subject is too far away..."
	if(ishuman(M) && !istype(M, /mob/living/carbon/human/monkey) && content) // don't eat humans while content
		return "I'm already content..."
	if(istype(M, /mob/living/carbon) && M.getCloneLoss() >= M.maxHealth * 2 || istype(M, /mob/living/simple_animal) && M.stat == DEAD)
		return "This subject does not have any edible life energy..."
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/human/H = M
		if(istype(H) && (H.species.flags & NO_SCAN))
			return "This subject has nothing for us to take..."
	for(var/mob/living/carbon/slime/met in view())
		if(met.victim == M && met != src)
			return "The [met.name] is already feeding on this subject..."
	return FALSE

/mob/living/carbon/slime/proc/Feedon(var/mob/living/M)
	victim = M
	loc = M.loc
	canmove = FALSE
	anchored = TRUE
	visible_message(span("danger", "\The [src] leaps onto [victim], feeding on them!"), span("warning", "You start feeding on [victim]."))

	regenerate_icons()

	while(victim && !invalidFeedTarget(M) && stat != DEAD && nutrition != get_max_nutrition())
		canmove = FALSE

		if(Adjacent(M))
			UpdateFeed(M)

			if(istype(M, /mob/living/carbon))
				victim.adjustCloneLoss(rand(5,6))
				victim.adjustToxLoss(rand(3,6))
				victim.adjustBruteLoss(is_adult ? rand(2, 4) : rand(1, 3))
				if(victim.health <= 0)
					victim.adjustToxLoss(rand(6,9))
				if(prob(20) && !isSynthetic(victim))
					victim.emote(pick("scream", "whimper", "gasp", "choke", "twitch"))

			else if(istype(M, /mob/living/simple_animal))
				victim.adjustBruteLoss(is_adult ? rand(9, 17) : rand(6, 14))

			else
				to_chat(src, span("warning", "[pick("This subject is incompatible", "This subject does not have a life energy", "This subject is empty", "I am not satisfied", "I can not feed from this subject", "I do not feel nourished", "This subject is not food")]..."))
				Feedstop()
				break

			if(prob(15) && M.client && istype(M, /mob/living/carbon))
				var/painMes = pick("You can feel your body becoming weak!", "You feel like you're about to die!", "You feel every part of your body screaming in agony!", "A low, rolling pain passes through your body!", "Your body feels as if it's falling apart!", "You feel extremely weak!", "A sharp, deep pain bathes every inch of your body!")
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.custom_pain(painMes, 100)
				else if (istype(M, /mob/living/carbon))
					var/mob/living/carbon/C = M
					if(!(C.species && (C.species.flags & NO_PAIN)))
						to_chat(M, span("danger", "[painMes]"))

			gain_nutrition(rand(20,25))

			adjustOxyLoss(-10) //Heal yourself
			adjustBruteLoss(-10)
			adjustFireLoss(-10)
			adjustCloneLoss(-10)
			updatehealth()
			if(victim)
				victim.updatehealth()

			if(nutrition == get_max_nutrition())
				visible_message(span("warning", "\The [src] releases [victim], content and full."), span("warning", "You are full."))
				break

			sleep(30) // Deal damage every 3 seconds
		else
			break

	canmove = TRUE
	anchored = FALSE

	if(M && invalidFeedTarget(M)) // This means that the slime drained the victim
		if(!client)
			if(victim && !rabid && !attacked && victim.LAssailant && victim.LAssailant != victim && prob(50))
				var/real_assailant = victim.LAssailant.resolve()
				if(real_assailant)
					if(!(real_assailant in friends))
						friends[real_assailant] = TRUE
					else
						++friends[real_assailant]

		else
			to_chat(src, span("notice", "This subject does not have a strong enough life energy anymore..."))

	victim = null

/mob/living/carbon/slime/proc/Feedstop()
	if(victim)
		if(victim.client)
			to_chat(victim, span("warning", "\The [src] has let go of your head!"))
		victim = null

/mob/living/carbon/slime/proc/UpdateFeed(var/mob/M)
	if(victim)
		if(victim == M)
			loc = M.loc // simple "attach to head" effect!

/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		to_chat(src, span("notice", "I must be conscious to do this..."))
		return

	if(!is_adult)
		if(amount_grown >= 5)
			is_adult = TRUE
			mob_size = 6 // Adult slimes are bigger
			maxHealth = 200
			health = maxHealth
			amount_grown = 0
			regenerate_icons()
			name = text("[colour] [is_adult ? "adult" : "baby"] slime ([number])")
			real_name = name
			set_content(TRUE)
			addtimer(CALLBACK(src, .proc/set_content, FALSE), 1200) // You get two minutes of safety
		else
			to_chat(src, span("notice", "I am not ready to evolve yet..."))
	else
		to_chat(src, span("notice", "I have already evolved..."))

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes."

	if(stat)
		to_chat(src, span("notice", "I must be conscious to do this..."))
		return

	if(is_adult)
		if(amount_grown >= 5)
			if(stat)
				to_chat(src, span("notice", "I must be conscious to do this..."))
				return

			var/list/babies = list()
			var/new_nutrition = round(nutrition * 0.9)
			var/new_powerlevel = round(powerlevel / 4)
			for(var/i = 1, i <= 4, i++)
				var/t = colour
				if(prob(mutation_chance))
					t = slime_mutation[rand(1,4)]
				var/mob/living/carbon/slime/M = new /mob/living/carbon/slime(loc, t)
				if(ckey)
					M.nutrition = new_nutrition //Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
				M.powerlevel = new_powerlevel
				if(i != 1)
					step_away(M, src)
				M.friends = friends.Copy()
				babies += M
				M.set_content(TRUE)
				addtimer(CALLBACK(M, .proc/set_content, FALSE), 1200) // You get two minutes of safety
				feedback_add_details("slime_babies_born", "slimebirth_[replacetext(M.colour," ","_")]")

			var/mob/living/carbon/slime/new_slime = pick(babies)
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			to_chat(src, span("notice", "I am not ready to reproduce yet..."))
	else
		to_chat(src, span("notice", "I am not old enough to reproduce yet..."))
