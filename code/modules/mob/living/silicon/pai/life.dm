/mob/living/silicon/pai/Life(seconds_per_tick, times_fired)
	SHOULD_CALL_PARENT(FALSE)

	if(src.stat == DEAD)
		return FALSE

	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf_or_move(src.loc)
			for (var/mob/M in viewers(T))
				M.show_message(SPAN_WARNING("The data cable rapidly retracts back into its spool."), 3, SPAN_WARNING("You hear a click and the sound of wire spooling rapidly."), 2)
			QDEL_NULL(src.cable)

	handle_regular_hud_updates()

	if(src.secHUD)
		process_sec_hud(src, TRUE)

	if(src.medHUD)
		process_med_hud(src, TRUE)

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_statuses()

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

	return TRUE

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getBruteLoss() - getFireLoss()
