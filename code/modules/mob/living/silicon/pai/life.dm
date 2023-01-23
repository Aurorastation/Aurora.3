/mob/living/silicon/pai/Life()

	if (src.stat == 2)
		return

	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf_or_move(src.loc)
			for (var/mob/M in viewers(T))
				M.show_message("<span class='warning'>The data cable rapidly retracts back into its spool.</span>", 3, "<span class='warning'>You hear a click and the sound of wire spooling rapidly.</span>", 2)
			qdel(src.cable)
			src.cable = null

	handle_regular_hud_updates()

	if(src.secHUD == 1)
		process_sec_hud(src, 1)

	if(src.medHUD == 1)
		process_med_hud(src, 1)

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_statuses()

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getBruteLoss() - getFireLoss()

/mob/living/silicon/pai/Stat()
	..()

	if(istype(card.loc, /mob/living/bot))
		var/mob/living/bot/B = card.loc
		stat(null, "Piloting: [B.name]")
		stat(null, "Bot Status: [B.on ? "Active" : "Inactive"]")
		stat(null, "Maintenance Hatch: [B.open ? "Open" : "Closed"]")
		stat(null, "Maintenance Lock: [B.locked ? "Locked" : "Unlocked"]")
		if(B.emagged)
			stat(null, "Bot M#$FUN90: MALFUNC--")
	if(istype(card.loc, /mob/living/bot/floorbot))
		var/mob/living/bot/floorbot/F = card.loc
		stat(null, "Metal Count: [F.amount]/[F.maxAmount]")
