/mob/Logout()
	SSnanoui.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	player_list -= src
	disconnect_time = world.realtime
	log_access("Logout: [key_name(src)]",ckey=key_name(src))
	SSfeedback.update_status()

	if(admin_datums[src.ckey])
		if (SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			var/admins_number = 0
			var/admins_number_afk = 0
			for (var/client/C in clients)
				if (C.holder && (C.holder.rights & (R_MOD|R_ADMIN)))
					admins_number++
					if (C.is_afk())
						admins_number_afk++

			message_admins("Admin logout: [key_name(src)]")

			if (admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
				post_webhook_event(WEBHOOK_ADMIN_IMPORTANT, list("title"="Admin has logged out", "message"="**[key_name(src)]** logged out - no more admins online."))
				discord_bot.send_to_admins("@here [key_name(src)] logged out - no more admins online.")
			else if ((admins_number - admins_number_afk) <= 0)
				post_webhook_event(WEBHOOK_ADMIN, list("title"="Admin has logged out", "message"="**[key_name(src)]** logged out - only AFK admins _([admins_number_afk])_ are online."))
				discord_bot.send_to_admins("[key_name(src)] logged out - only AFK admins ([admins_number_afk]) are online.")

	if (mob_thinks)
		MOB_START_THINKING(src)
	..()
	return 1
