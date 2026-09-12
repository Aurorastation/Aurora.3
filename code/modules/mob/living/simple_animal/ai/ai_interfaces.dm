// Mob-side interfaces used by /datum/ai_holder. Keeping body implementation
// here lets holder logic remain reusable and independently testable.

/mob/living/proc/AICanThink()
	return !stat

/mob/living/proc/AICanMove()
	return canmove && !anchored && !buckled_to && !incapacitated(INCAPACITATION_DISABLED)

/mob/living/proc/AIIsDisabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/living/proc/AIMove(turf/new_location, safety = TRUE)
	if(!AICanMove() || !istype(new_location))
		return AI_MOVEMENT_FAILED
	var/turf/old_location = get_turf(src)
	if(!old_location?.Adjacent(new_location))
		return AI_MOVEMENT_FAILED
	if(safety && !AIIsSafeTurf(new_location))
		return AI_MOVEMENT_FAILED
	return SelfMove(new_location) ? AI_MOVEMENT_SUCCESS : AI_MOVEMENT_FAILED

/mob/living/proc/AIIsSafeTurf(turf/new_location)
	if(!new_location || new_location.density)
		return FALSE
	if(istype(new_location, /turf/space) && !Allow_Spacemove())
		return FALSE
	return TRUE

/mob/living/proc/AIMovementDelay()
	return max(1, movement_delay())

/mob/living/proc/AIListTargets(distance = world.view, ignore_opacity = FALSE)
	if(ignore_opacity)
		return range(distance, src)
	return get_hearers_in_LOS(distance, src)

/mob/living/proc/AIPickTarget(list/candidates, atom/current_target, atom/preferred_target)
	if(!length(candidates))
		return
	if(preferred_target in candidates)
		return preferred_target

	var/closest_distance = INFINITY
	var/list/closest = list()
	for(var/atom/candidate as anything in candidates)
		var/distance = get_dist(src, candidate)
		if(distance < closest_distance)
			closest_distance = distance
			closest = list(candidate)
		else if(distance == closest_distance)
			closest += candidate
	return pick(closest)

/mob/living/proc/AICanAttack(atom/target)
	if(!isliving(target))
		return FALSE
	var/mob/living/living_target = target
	if(living_target.stat == DEAD)
		return FALSE
	if(living_target.key && !living_target.client)
		return FALSE
	return !AIIsAlly(living_target)

/mob/living/proc/AIIsAlly(atom/target)
	if(!isliving(target))
		return FALSE
	var/mob/living/living_target = target
	return faction && faction == living_target.faction

/mob/living/proc/AITargetChanged(atom/old_target, atom/new_target, notify = TRUE)
	return

/mob/living/proc/AIMeleeRange()
	return 1

/mob/living/proc/AIMeleeAttack(atom/target)
	return AI_ATTACK_FAILED

/mob/living/proc/AICheckRangedAttack(atom/target)
	return FALSE

/mob/living/proc/AIRangedRange(atom/target)
	return 1

/mob/living/proc/AIRangedAttack(atom/target)
	return AI_ATTACK_FAILED

/mob/living/proc/AICheckSpecialAttack(atom/target)
	return FALSE

/mob/living/proc/AISpecialAttack(atom/target)
	return AI_ATTACK_FAILED

/mob/living/proc/AICheckFire(atom/target, conserve_ammo = FALSE)
	return TRUE

/mob/living/proc/AIBreakObstacles(atom/towards, violent = TRUE, demolish = FALSE)
	return FALSE

/mob/living/proc/AIGetID()
	return GetIdCard()

/mob/living/proc/AISetLegacyStance(new_stance)
	return

/mob/living/proc/AIThreaten(atom/target)
	visible_message(SPAN_WARNING("\The [src] watches \the [target] warily."))

/mob/living/proc/AIIdleSpeak()
	return

/mob/living/proc/AIContextSpeak(message)
	if(message)
		say(message)

/mob/living/proc/AIAudibleEmote(message)
	if(message)
		visible_message(null, message)

/mob/living/proc/AIVisualEmote(message)
	if(message)
		visible_message(message)

/mob/living/proc/AIShouldNeverFlee()
	return is_berserk()

/mob/living/proc/AIShouldSpecialFlee(atom/target)
	var/is_cloaked = invisibility > 0 || alpha < 255
	if(is_cloaked)
		return FALSE
	if(isliving(target))
		var/mob/living/living_target = target
		return !living_target.incapacitated(INCAPACITATION_DISABLED)
	return TRUE

/mob/living/proc/AIThreatLevel()
	var/threat = 0
	for(var/mob/living/possible_threat in view(world.view, src))
		if(possible_threat == src || AIIsAlly(possible_threat) || possible_threat.stat == DEAD)
			continue
		threat += possible_threat.maxhealth
	return threat

// Optional xenobiology-slime interfaces. Aurora's pet slimes do not currently
// expose growth or consumption systems, so compatible bodies opt in.
/mob/living/proc/AIIsSlimeFood(atom/possible_food)
	return FALSE

/mob/living/proc/AISlimeShouldHunt()
	return TRUE

/mob/living/proc/AISlimeConsume(atom/food)
	return FALSE

/mob/living/proc/AISlimeReadyToGrow()
	return FALSE

/mob/living/proc/AISlimeIsAdult()
	return FALSE

/mob/living/proc/AISlimeEvolve()
	return FALSE

/mob/living/proc/AISlimeReproduce()
	return FALSE

/mob/living/proc/AISlimeCanConsume(mob/living/target)
	return FALSE

/mob/living/proc/AISlimeIsHarmless()
	return FALSE

/mob/living/proc/AISlimeGetRabid(default_value = FALSE)
	return default_value

/mob/living/proc/AISlimeSetRabid(value)
	return

/mob/living/proc/AISlimeGetDiscipline(default_value = 0)
	return default_value

/mob/living/proc/AISlimeSetDiscipline(value)
	return

/mob/living/proc/AISlimeCanCommand(mob/living/commander)
	return FALSE

/mob/living/proc/AISlimeIsConsuming()
	return FALSE

/mob/living/proc/AISlimeStopConsumption()
	return FALSE

/mob/living/proc/AISlimeSquish()
	return FALSE

/mob/living/proc/AIUpdateSlimeMood()
	return


// Simple animal implementation.

/mob/living/simple_animal/react_to_message(datum/say_message/message)
	. = ..()
	if(ai_holder && isliving(message.speaker))
		ai_holder.on_hear_say(message.speaker, html_decode(message.to_string()))

/mob/living/simple_animal/AICanThink()
	return !stop_thinking && stat == CONSCIOUS

/mob/living/simple_animal/AICanMove()
	if(stop_automated_movement || resting || (pulledby && stop_automated_movement_when_pulled))
		return FALSE
	return ..()

/mob/living/simple_animal/AIMovementDelay()
	return max(1, movement_delay())

/mob/living/simple_animal/AIIsAlly(atom/target)
	return target == src

/mob/living/simple_animal/AIIdleSpeak()
	var/list/available_emotes = list()
	if(length(emote_see))
		available_emotes += "visible"
	if(length(emote_hear))
		available_emotes += "audible"

	if(length(speak) && (!length(available_emotes) || prob(50)))
		say(pick(speak))
	else if(length(available_emotes))
		switch(pick(available_emotes))
			if("visible")
				visible_emote("[pick(emote_see)].", 0)
			if("audible")
				audible_emote("[pick(emote_hear)].", 0)
	speak_audio()

/mob/living/simple_animal/AIAudibleEmote(message)
	audible_emote(message, 0)

/mob/living/simple_animal/AIVisualEmote(message)
	visible_emote(message, 0)

/mob/living/simple_animal/AIThreaten(atom/target)
	if(length(emote_see))
		visible_emote("[pick(emote_see)] at [target].", 0)
	else if(length(emote_hear))
		audible_emote("[pick(emote_hear)].", 0)
	else
		return ..()
	speak_audio()


// Hostile simple animal implementation.

/mob/living/simple_animal/hostile/AIListTargets(distance = world.view, ignore_opacity = FALSE)
	if(ignore_opacity)
		return range(distance, src)
	return get_targets(distance)

/mob/living/simple_animal/hostile/AIPickTarget(list/candidates, atom/current_target, atom/preferred_target)
	targets = candidates
	return ..()

/mob/living/simple_animal/hostile/AICanAttack(atom/target)
	if(QDELETED(target) || target == src)
		return FALSE
	if(isliving(target))
		return validator_living(target, null)
	if(istype(target, /obj/structure/machinery/bot))
		return validator_bot(target, null)
	if(istype(target, /obj/structure/machinery/porta_turret))
		return validator_turret(target, null)
	if(istype(target, /obj/effect/blob))
		return ai_holder?.destructive
	return FALSE

/mob/living/simple_animal/hostile/carp/AICanAttack(atom/target)
	if(istype(target, /obj/effect/energy_field))
		var/obj/effect/energy_field/field = target
		return field.density && !field.invisibility
	return ..()

/mob/living/simple_animal/hostile/bear/AICanAttack(atom/target)
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD || AIIsAlly(living_target))
			return FALSE
		return !!living_target.client
	return ..()

/mob/living/simple_animal/hostile/bear/AIPickTarget(list/candidates, atom/current_target, atom/preferred_target)
	var/list/conscious_targets = list()
	var/list/downed_targets = list()
	for(var/atom/candidate as anything in candidates)
		if(isliving(candidate))
			var/mob/living/living_candidate = candidate
			if(living_candidate.stat == CONSCIOUS)
				conscious_targets += living_candidate
			else if(living_candidate.stat != DEAD)
				downed_targets += living_candidate
		else
			conscious_targets += candidate
	if(length(conscious_targets))
		return ..(conscious_targets, current_target, preferred_target)
	if(length(downed_targets))
		return ..(downed_targets, current_target, preferred_target)
	return current_target

/mob/living/simple_animal/hostile/AIIsAlly(atom/target)
	if(target in friends)
		return TRUE
	if(isliving(target))
		var/mob/living/living_target = target
		return !attack_same && faction && faction == living_target.faction
	return FALSE

/mob/living/simple_animal/hostile/AITargetChanged(atom/old_target, atom/new_target, notify = TRUE)
	if(new_target)
		var/changed = set_last_found_target(new_target)
		targets |= new_target
		if(changed && notify)
			if(isliving(new_target))
				visible_message(SPAN_WARNING("\The [src] [attack_emote] [new_target]."))
				if(istype(new_target, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/hostile_target = new_target
					hostile_target.being_targeted(src)
		return

	if(last_found_target)
		unset_last_found_target()
	GLOB.move_manager.stop_looping(src)

/mob/living/simple_animal/hostile/AIMeleeRange()
	return melee_reach

/mob/living/simple_animal/hostile/AIMeleeAttack(atom/target)
	if(ON_ATTACK_COOLDOWN(src))
		return AI_ATTACK_ON_COOLDOWN
	if(last_found_target != target)
		set_last_found_target(target)
	targets |= target
	if(get_dist(src, target) > melee_reach)
		return AI_ATTACK_FAILED
	AttackingTarget()
	attacked_times++
	hostile_last_attack = world.time
	return AI_ATTACK_SUCCESS

/mob/living/simple_animal/hostile/AICheckRangedAttack(atom/target)
	return ranged && projectiletype

/mob/living/simple_animal/hostile/AIRangedRange(atom/target)
	return ranged ? ranged_attack_range : melee_reach

/mob/living/simple_animal/hostile/AIRangedAttack(atom/target)
	if(QDELETED(target) || ON_ATTACK_COOLDOWN(src) || !see_target(target))
		return AI_ATTACK_FAILED
	if(smart_ranged && !check_fire(target))
		return AI_ATTACK_FAILED

	visible_message(SPAN_DANGER("[capitalize_first_letters(name)] fires at \the [target]!"))
	hostile_last_attack = world.time
	if(rapid)
		var/datum/callback/shoot_callback = CALLBACK(src, PROC_REF(shoot_wrapper), target, loc, src)
		addtimer(shoot_callback, 1, TIMER_STOPPABLE|TIMER_DELETE_ME)
		addtimer(shoot_callback, 4, TIMER_STOPPABLE|TIMER_DELETE_ME)
		addtimer(shoot_callback, 6, TIMER_STOPPABLE|TIMER_DELETE_ME)
	else
		shoot_wrapper(target, loc, src)
	return AI_ATTACK_SUCCESS

/mob/living/simple_animal/hostile/AICheckFire(atom/target, conserve_ammo = FALSE)
	if(!smart_ranged && !conserve_ammo)
		return TRUE
	return check_fire(target)

/mob/living/simple_animal/hostile/AIBreakObstacles(atom/towards, violent = TRUE, demolish = FALSE)
	if(!isturf(loc) || !towards)
		return FALSE
	var/target_direction = get_dir(src, towards)
	var/list/directions = list(target_direction, turn(target_direction, 45), turn(target_direction, -45))
	for(var/direction in directions)
		if(AIClearDirection(direction, violent, demolish))
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/proc/AIClearDirection(direction, violent, demolish)
	var/turf/problem_turf = get_step(src, direction)
	if(!problem_turf)
		return FALSE

	if(!violent)
		for(var/obj/structure/machinery/door/door in problem_turf)
			if(door.density && door.allowed(src) && door.operable())
				return door.open()
		return FALSE

	for(var/obj/effect/energy_field/field in problem_turf)
		if(field.density && !field.invisibility)
			field.damage_field(rand(0.5, 1.5))
			do_attack_animation(field)
			visible_message(SPAN_DANGER("\The [src] [attacktext] \the [field]!"))
			hostile_last_attack = world.time
			return TRUE

	var/obj/obstacle
	for(var/obj/candidate in problem_turf)
		if(istype(candidate, /obj/structure/window) || istype(candidate, /obj/structure/window_frame) || istype(candidate, /obj/structure/closet) || istype(candidate, /obj/structure/table) || istype(candidate, /obj/structure/grille) || istype(candidate, /obj/structure/machinery/door))
			if(candidate.density)
				obstacle = candidate
				break
		if(demolish && (istype(candidate, /obj/structure/girder) || istype(candidate, /obj/structure/barricade) || istype(candidate, /obj/structure/flora/tree)))
			obstacle = candidate
			break
	if(obstacle)
		return AIAttackObstacle(obstacle)

	if(demolish && (istype(problem_turf, /turf/simulated/wall) || istype(problem_turf, /turf/simulated/mineral)))
		return AIAttackObstacle(problem_turf)
	return FALSE

/mob/living/simple_animal/hostile/proc/AIAttackObstacle(atom/obstacle)
	if(QDELETED(obstacle) || ON_ATTACK_COOLDOWN(src))
		return FALSE
	setClickCooldown(attack_delay)
	face_atom(obstacle)
	do_attack_animation(obstacle)
	obstacle.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE, armor_penetration, attack_flags, damage_type)
	if(attack_sound)
		playsound(loc, attack_sound, 50, TRUE)
	hostile_last_attack = world.time
	return TRUE

/mob/living/simple_animal/hostile/AISetLegacyStance(new_stance)
	switch(new_stance)
		if(AI_STANCE_IDLE, AI_STANCE_MOVE, AI_STANCE_FOLLOW)
			stance = HOSTILE_STANCE_IDLE
		if(AI_STANCE_ALERT)
			stance = HOSTILE_STANCE_ALERT
		if(AI_STANCE_APPROACH)
			stop_automated_movement = FALSE
			stance = HOSTILE_STANCE_ATTACK
		if(AI_STANCE_FIGHT, AI_STANCE_BLINDFIGHT, AI_STANCE_REPOSITION, AI_STANCE_FLEE)
			stop_automated_movement = FALSE
			stance = HOSTILE_STANCE_ATTACKING
		if(AI_STANCE_DISABLED, AI_STANCE_SPECIAL, AI_STANCE_SLEEP)
			stance = HOSTILE_STANCE_TIRED

/mob/living/simple_animal/hostile/AIThreaten(atom/target)
	visible_message(SPAN_WARNING("\The [src] [attack_emote] [target]."))
	speak_audio()
