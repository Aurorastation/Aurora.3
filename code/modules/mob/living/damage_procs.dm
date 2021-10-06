
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/

/mob/living/proc/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone, var/used_weapon, var/damage_flags = 0, var/armor_pen, var/silent = FALSE)
	if(!damage)
		return FALSE

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3] // args modifications in case of parent calls
	if(!damage)
		return FALSE

	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			if(COLD_RESISTANCE in mutations)
				damage = 0
			adjustFireLoss(damage)
		if(TOX)
			adjustToxLoss(damage)
		if(OXY)
			adjustOxyLoss(damage)
		if(CLONE)
			adjustCloneLoss(damage)
		if(PAIN)
			adjustHalLoss(damage)
		if(IRRADIATE)
			apply_radiation(damage)

	updatehealth()
	return TRUE

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone, var/damage_flags = 0)
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, PAIN, def_zone, blocked)
	return TRUE

/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return 0
	switch(effecttype)
		if(STUN)
			Stun(effect * BLOCKED_MULT(blocked))
		if(WEAKEN)
			Weaken(effect * BLOCKED_MULT(blocked))
		if(PARALYZE)
			Paralyse(effect * BLOCKED_MULT(blocked))
		if(PAIN)
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
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/incinerate = 0, var/blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, PAIN, blocked)
	if(incinerate) apply_effect(incinerate, INCINERATE, blocked)
	return 1

// overridden by human
/mob/living/proc/apply_radiation(var/rads)
	total_radiation += rads
	if (total_radiation < 0)
		total_radiation = 0
