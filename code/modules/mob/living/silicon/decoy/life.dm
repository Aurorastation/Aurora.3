/mob/living/silicon/decoy/Life(seconds_per_tick, times_fired)
	SHOULD_CALL_PARENT(FALSE)

	if (src.stat == DEAD)
		return FALSE
	else
		if (src.health <= GLOB.config.health_threshold_dead && src.stat != DEAD)
			death()
			return FALSE

	return TRUE


/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
