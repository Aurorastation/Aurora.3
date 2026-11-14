// Behavior while stunned, restrained, trapped, or confused.

/datum/ai_holder/proc/can_act()
	if(QDELETED(holder) || holder.stat != CONSCIOUS)
		return FALSE
	return !holder.AIIsDisabled()

/datum/ai_holder/proc/is_disabled()
	return !can_act() || is_confused()

/datum/ai_holder/proc/is_confused()
	return respect_confusion && holder.confused > 0

/datum/ai_holder/proc/handle_disabled()
	if(!holder || holder.stat != CONSCIOUS)
		return
	if(is_confused() && !holder.AIIsDisabled())
		dangerous_wander()

/datum/ai_holder/proc/handle_resist()
	if(holder)
		holder.execute_resist()

/datum/ai_holder/proc/escape_confinement()
	if(!holder)
		return FALSE
	if(holder.buckled_to || length(holder.grabbed_by))
		handle_resist()
		return TRUE
	if(istype(holder.loc, /obj/structure/closet))
		var/obj/structure/closet/container = holder.loc
		if(container.opened)
			return FALSE
		holder.execute_resist()
		return TRUE
	return FALSE

/datum/ai_holder/proc/dangerous_wander()
	if(!isturf(holder.loc) || world.time < next_movement)
		return

	if(intelligence_level >= AI_INTELLIGENCE_SMART)
		for(var/direction in GLOB.cardinals)
			var/turf/test_turf = get_step(holder, direction)
			if(!holder.AIIsSafeTurf(test_turf))
				return
			for(var/mob/living/ally in test_turf)
				if(holder.AIIsAlly(ally))
					return

	var/turf/destination_turf = get_step(holder, pick(GLOB.cardinals))
	if(!destination_turf)
		return
	var/mob/living/bumped_mob = locate() in destination_turf
	if(bumped_mob)
		melee_attack(bumped_mob)
		return
	holder.AIMove(destination_turf, FALSE)
	next_movement = world.time + holder.AIMovementDelay()
