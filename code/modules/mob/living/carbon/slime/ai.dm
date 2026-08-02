// Polaris AI body adapter for xenobiology slimes. The holder owns decisions;
// this mob continues to own feeding, growth, friendship, and combat mechanics.

/mob/living/carbon/slime/AICanThink()
	return !victim && !SStun && stat == CONSCIOUS

/mob/living/carbon/slime/AICanMove()
	if(SStun || victim)
		return FALSE
	return ..()

/mob/living/carbon/slime/AIIsAlly(atom/possible_ally)
	if(possible_ally == src || isslime(possible_ally))
		return TRUE
	if(ai_holder?.leader == possible_ally)
		return TRUE
	return FALSE

/mob/living/carbon/slime/AICanAttack(atom/possible_target)
	if(!isliving(possible_target))
		return FALSE

	var/mob/living/living_target = possible_target
	if(living_target.stat == DEAD || living_target.is_asystole() || isslime(living_target))
		return FALSE
	if(is_friend(living_target))
		return FALSE
	if(isskrell(living_target))
		return FALSE
	if(ishuman(living_target))
		var/mob/living/carbon/human/human_target = living_target
		if(human_target.species?.name == SPECIES_SLIMEPERSON || content)
			return FALSE
	if(issilicon(living_target) && !rabid && !attacked)
		return FALSE

	for(var/mob/living/carbon/slime/other_slime in view(1, living_target))
		if(other_slime != src && other_slime.victim == living_target)
			return FALSE

	return ..()

/mob/living/carbon/slime/AIPickTarget(list/candidates, atom/current_target, atom/preferred_target)
	if(!length(candidates))
		return
	if(preferred_target in candidates)
		return preferred_target

	if(rabid || attacked || nutrition < get_starve_nutrition())
		return ..()

	var/list/nonhuman_targets = list()
	var/list/human_targets = list()
	for(var/mob/living/candidate as anything in candidates)
		if(ishuman(candidate))
			human_targets += candidate
		else
			nonhuman_targets += candidate

	if(length(nonhuman_targets))
		return ..(nonhuman_targets, current_target, preferred_target)
	if(length(human_targets) && prob(5))
		return ..(human_targets, current_target, preferred_target)
	return (current_target in candidates) ? current_target : null

/mob/living/carbon/slime/AITargetChanged(atom/old_target, atom/new_target, notify = TRUE)
	target = isliving(new_target) ? new_target : null
	AIUpdateSlimeMood()

/mob/living/carbon/slime/AIMeleeAttack(atom/attack_target)
	if(Atkcool)
		return AI_ATTACK_ON_COOLDOWN
	if(!attack_target?.Adjacent(src))
		return AI_ATTACK_FAILED

	Atkcool = TRUE
	addtimer(CALLBACK(src, PROC_REF(disable_attack_cooldown)), 4.5 SECONDS, TIMER_DELETE_ME)
	UnarmedAttack(attack_target)
	return AI_ATTACK_SUCCESS

/mob/living/carbon/slime/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	. = ..()
	if(. && user)
		attacked += 10
		ai_holder?.react_to_attack(user)

/mob/living/carbon/slime/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	var/mob/thrower = throwingdatum?.thrower?.resolve()
	if(thrower)
		attacked += 10
		ai_holder?.react_to_attack(thrower)

/mob/living/carbon/slime/AISlimeShouldHunt()
	var/hunger = 0
	if(nutrition < get_starve_nutrition())
		hunger = 2
	else if(nutrition < get_hunger_nutrition())
		hunger = 1
	return will_hunt(hunger)

/mob/living/carbon/slime/AISlimeReadyToGrow()
	return amount_grown >= 5

/mob/living/carbon/slime/AISlimeIsAdult()
	return is_adult

/mob/living/carbon/slime/AISlimeEvolve()
	if(is_adult || amount_grown < 5)
		return FALSE
	Evolve()
	return is_adult

/mob/living/carbon/slime/AISlimeReproduce()
	if(!is_adult || amount_grown < 5)
		return FALSE
	Reproduce()
	return TRUE

/mob/living/carbon/slime/AISlimeCanConsume(mob/living/possible_food)
	if(!istype(possible_food, /mob/living/carbon) && !istype(possible_food, /mob/living/simple_animal))
		return FALSE
	return !invalidFeedTarget(possible_food, FALSE)

/mob/living/carbon/slime/AISlimeIsConsuming()
	return !!victim

/mob/living/carbon/slime/AISlimeStopConsumption()
	Feedstop()
	return TRUE

/mob/living/carbon/slime/AISlimeSquish()
	emote("jiggle")
	return TRUE

/mob/living/carbon/slime/AISlimeGetRabid(default_value = FALSE)
	return rabid

/mob/living/carbon/slime/AISlimeSetRabid(value)
	rabid = value

/mob/living/carbon/slime/AISlimeGetDiscipline(default_value = 0)
	return discipline

/mob/living/carbon/slime/AISlimeSetDiscipline(value)
	discipline = value

/mob/living/carbon/slime/AISlimeCanCommand(mob/living/commander)
	return friends[commander] > 2

/mob/living/carbon/slime/AIUpdateSlimeMood()
	var/new_mood = ""
	var/datum/ai_holder/simple_animal/xenobio_slime/slime_ai = ai_holder
	if(slime_ai?.rabid || attacked)
		set_content(FALSE)
		new_mood = ANGRY
	else if(slime_ai?.target)
		new_mood = MISCHIEVOUS
	else if(slime_ai?.discipline)
		new_mood = POUT
	else if(content)
		new_mood = HAPPY
	else if(mood in list(POUT, SAD, HAPPY))
		new_mood = mood

	if(new_mood == mood)
		return
	mood = new_mood
	regenerate_icons()

/mob/living/carbon/slime/AIIdleSpeak()
	if(prob(35))
		emote(pick("bounce", "sway", "light", "vibrate", "jiggle"))
		return

	var/list/phrases = list("Rawr...", "Blop...", "Blorble...")
	if(nutrition < get_starve_nutrition())
		phrases += list("So... hungry...", "Very... hungry...", "Need... food...", "Must... eat...")
	else if(nutrition < get_hunger_nutrition())
		phrases += list("Hungry...", "Where is the food?", "I want to eat...")
	if(rabid || attacked)
		phrases += list("Hrr...", "Nhuu...", "Unn...")
	if(mood == HAPPY)
		phrases += "Purr..."
	if(getToxLoss() > 30)
		phrases += "Cold..."
	if(getToxLoss() > 60)
		phrases += list("So... cold...", "Very... cold...")
	if(powerlevel > 3)
		phrases += "Bzzz..."
	if(powerlevel > 5)
		phrases += "Zap..."
	say(pick(phrases))

/mob/living/carbon/slime/proc/adjust_slime_discipline(amount, silent = FALSE)
	var/datum/ai_holder/simple_animal/xenobio_slime/slime_ai = ai_holder
	if(slime_ai)
		slime_ai.adjust_discipline(amount, silent)
		return
	discipline = clamp(discipline + amount, 0, 10)

/mob/living/carbon/slime/proc/set_slime_rabid(value)
	var/datum/ai_holder/simple_animal/xenobio_slime/slime_ai = ai_holder
	if(!slime_ai)
		rabid = value
		return
	if(value)
		slime_ai.enrage()
		return
	slime_ai.rabid = FALSE
	slime_ai.hostile = TRUE
	slime_ai.retaliate = TRUE
	AISlimeSetRabid(FALSE)
	AIUpdateSlimeMood()
