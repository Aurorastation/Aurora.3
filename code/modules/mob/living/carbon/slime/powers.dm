/mob/living/carbon/slime/proc/Wrap(var/mob/living/M) // This is a proc for the clicks
	if(victim == M || src == M)
		Feedstop()
		return

	if(victim)
		to_chat(src, SPAN_WARNING("I am already feeding..."))
		return

	var/target = invalidFeedTarget(M)
	if(target)
		to_chat(src, target)
		return

	Feedon(M)

/mob/living/carbon/slime/proc/invalidFeedTarget(var/mob/living/M, require_adjacent = TRUE)
	if(!M || !istype(M) || istype(M, /mob/living/bot))
		return "This subject is incompatible.."
	if(istype(M, /mob/living/carbon/slime)) // No cannibalism... yet
		return "I cannot feed on other slimes..."
	if(require_adjacent && !Adjacent(M))
		return "This subject is too far away..."
	if(ishuman(M) && !istype(M, /mob/living/carbon/human/monkey) && content) // don't eat humans while content
		return "I'm already content..."
	if((istype(M, /mob/living/carbon) && M.getCloneLoss() >= M.maxhealth * 2) || (istype(M, /mob/living/simple_animal) && M.stat == DEAD))
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
	if(victim || invalidFeedTarget(M))
		return FALSE

	victim = M
	loc = M.loc
	canmove = FALSE
	anchored = TRUE
	visible_message(SPAN_DANGER("\The [src] leaps onto [victim], feeding on them!"), SPAN_WARNING("You start feeding on [victim]."))
	regenerate_icons()
	process_feed()
	return TRUE

/mob/living/carbon/slime/proc/process_feed()
	feeding_timer = null
	var/mob/living/food = victim
	if(!food || stat == DEAD || invalidFeedTarget(food) || nutrition >= get_max_nutrition())
		Feedstop()
		return

	canmove = FALSE
	anchored = TRUE
	UpdateFeed(food)

	if(istype(food, /mob/living/carbon))
		food.adjustCloneLoss(rand(5,6))
		food.adjustToxLoss(rand(3,6))
		food.adjustBruteLoss(is_adult ? rand(2, 4) : rand(1, 3))
		if(food.health <= 0)
			food.adjustToxLoss(rand(6,9))
		if(prob(20) && !food.isSynthetic())
			food.emote(pick("scream", "whimper", "gasp", "choke", "twitch"))
	else if(istype(food, /mob/living/simple_animal))
		food.adjustBruteLoss(is_adult ? rand(9, 17) : rand(6, 14))
	else
		to_chat(src, SPAN_WARNING("[pick("This subject is incompatible", "This subject does not have a life energy", "This subject is empty", "I am not satisfied", "I can not feed from this subject", "I do not feel nourished", "This subject is not food")]..."))
		Feedstop()
		return

	if(prob(15) && food.client && istype(food, /mob/living/carbon))
		var/pain_message = pick("You can feel your body becoming weak!", "You feel like you're about to die!", "You feel every part of your body screaming in agony!", "A low, rolling pain passes through your body!", "Your body feels as if it's falling apart!", "You feel extremely weak!", "A sharp, deep pain bathes every inch of your body!")
		if(ishuman(food))
			var/mob/living/carbon/human/human_food = food
			human_food.custom_pain(pain_message, 100)
		else
			var/mob/living/carbon/carbon_food = food
			if(!(carbon_food.species && (carbon_food.species.flags & NO_PAIN)))
				to_chat(food, SPAN_DANGER("[pain_message]"))

	gain_nutrition(rand(20,25))
	adjustOxyLoss(-10)
	adjustBruteLoss(-10)
	adjustFireLoss(-10)
	adjustCloneLoss(-10)
	updatehealth()
	food.updatehealth()

	if(nutrition >= get_max_nutrition())
		visible_message(SPAN_WARNING("\The [src] releases [food], content and full."), SPAN_WARNING("You are full."))
		check_friendship_increase()
		Feedstop()
		return

	feeding_timer = addtimer(CALLBACK(src, PROC_REF(process_feed)), 3 SECONDS, TIMER_STOPPABLE)

/mob/living/carbon/slime/proc/Feedstop()
	if(feeding_timer)
		deltimer(feeding_timer)
		feeding_timer = null
	var/mob/living/old_victim = victim
	if(old_victim?.client)
		to_chat(old_victim, SPAN_WARNING("\The [src] has let go of your head!"))
	victim = null
	canmove = TRUE
	anchored = FALSE
	regenerate_icons()
	if(ai_holder?.target == old_victim)
		ai_holder.remove_target(FALSE)

/mob/living/carbon/slime/proc/UpdateFeed(var/mob/M)
	if(victim)
		if(victim == M)
			loc = M.loc // simple "attach to head" effect!

/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		to_chat(src, SPAN_NOTICE("I must be conscious to do this..."))
		return

	if(!is_adult)
		if(amount_grown >= 5)
			is_adult = TRUE
			mob_size = 6 // Adult slimes are bigger
			maxhealth = 200
			health = maxhealth
			amount_grown = 0
			regenerate_icons()
			name = "[colour] [is_adult ? "adult" : "baby"] slime ([number])"
			real_name = name
			set_content(TRUE)
			addtimer(CALLBACK(src, PROC_REF(set_content), FALSE), 1200, TIMER_DELETE_ME) // You get two minutes of safety
		else
			to_chat(src, SPAN_NOTICE("I am not ready to evolve yet..."))
	else
		to_chat(src, SPAN_NOTICE("I have already evolved..."))

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes."

	if(stat)
		to_chat(src, SPAN_NOTICE("I must be conscious to do this..."))
		return

	if(is_adult)
		if(amount_grown >= 5)
			if(stat)
				to_chat(src, SPAN_NOTICE("I must be conscious to do this..."))
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
				M.mutation_chance = clamp(mutation_chance + rand(-3, 3), 0, 100)
				babies += M
				M.set_content(TRUE)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living/carbon/slime, set_content), FALSE), 1200, TIMER_DELETE_ME) // You get two minutes of safety
				feedback_add_details("slime_babies_born", "slimebirth_[replacetext(M.colour," ","_")]")

			var/mob/living/carbon/slime/new_slime = pick(babies)
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			to_chat(src, SPAN_NOTICE("I am not ready to reproduce yet..."))
	else
		to_chat(src, SPAN_NOTICE("I am not old enough to reproduce yet..."))
