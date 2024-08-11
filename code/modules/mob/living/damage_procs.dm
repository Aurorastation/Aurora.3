
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/

/mob/living/proc/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, blocked, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	if(!damage)
		return FALSE

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3] // args modifications in case of parent calls
	if(!damage)
		return FALSE

	switch(damagetype)
		if(DAMAGE_BRUTE)
			adjustBruteLoss(damage)
		if(DAMAGE_BURN)
			if((mutations & COLD_RESISTANCE))
				damage = 0
			adjustFireLoss(damage)
		if(DAMAGE_TOXIN)
			adjustToxLoss(damage)
		if(DAMAGE_OXY)
			adjustOxyLoss(damage)
		if(DAMAGE_CLONE)
			adjustCloneLoss(damage)
		if(DAMAGE_PAIN)
			adjustHalLoss(damage)
		if(DAMAGE_RADIATION)
			apply_radiation(damage)

	updatehealth()
	return TRUE

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone, var/damage_flags = 0)
	if(brute)	apply_damage(brute, DAMAGE_BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, DAMAGE_BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, DAMAGE_TOXIN, def_zone, blocked)
	if(oxy)		apply_damage(oxy, DAMAGE_OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, DAMAGE_CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, DAMAGE_PAIN, def_zone, blocked)
	return TRUE

/**
 * Apply an effect to the mob
 *
 * * effect - The amount of effect to apply, a number
 * * effect_type - An effect eg. `STUN`, `WEAKEN`; see `code\__DEFINES\damage_organs.dm` for relative defines
 * * blocked - The amount of effect that was blocked, eg. by armor, a number, percentage
 *
 * Returns `TRUE` if the effect was applied, `FALSE` otherwise
 */
/mob/living/proc/apply_effect(effect = 0, effect_type = STUN, blocked = 0)
	SHOULD_NOT_SLEEP(TRUE)

	//Check that noone fucked up the vars
	if(!isnum(effect))
		stack_trace("Passed a wrong value in the proc for the effect var, it must be a number!")
		return FALSE

	if(!isnum(blocked))
		stack_trace("Passed a wrong value in the proc for the blocked var, it must be a number!")
		blocked = 0

	if(!istext(effect_type))
		stack_trace("Passed a wrong value in the proc for the effect_type var, it must be an effect!")
		return FALSE

	//If the armor blocked it all, no effect is to be applied
	if(blocked >= 100)
		return FALSE

	//Apply the effect based on type, accounting for the blocked percentage
	switch(effect_type)

		if(STUN)
			Stun(effect * BLOCKED_MULT(blocked))

		if(WEAKEN)
			Weaken(effect * BLOCKED_MULT(blocked))

		if(PARALYZE)
			Paralyse(effect * BLOCKED_MULT(blocked))

		if(DAMAGE_PAIN)
			adjustHalLoss(effect * BLOCKED_MULT(blocked)) //Changed this to use the wrapper function, it shouldn't directly alter the value

		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering, effect * BLOCKED_MULT(blocked))

		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect * BLOCKED_MULT(blocked))

		if(DROWSY)
			drowsiness = max(drowsiness, effect * BLOCKED_MULT(blocked))

		if(INCINERATE)
			IgniteMob(effect * BLOCKED_MULT(blocked))

	//Update health for the mob
	updatehealth()

	return TRUE


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/incinerate = 0, var/blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, DAMAGE_PAIN, blocked)
	if(incinerate) apply_effect(incinerate, INCINERATE, blocked)
	return 1

// overridden by human
/mob/living/proc/apply_radiation(var/rads)
	total_radiation += rads
	if (total_radiation < 0)
		total_radiation = 0
