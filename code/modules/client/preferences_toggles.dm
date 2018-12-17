//toggles

/client/verb/toggle_ghost_ears()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.toggles ^= CHAT_GHOSTEARS
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_sight()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.toggles ^= CHAT_GHOSTSIGHT
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set name = "Enable/Disable GhostRadio"
	set category = "Preferences"
	set desc = ".Toggle between hearing all radio chatter, or only from nearby speakers"
	prefs.toggles ^= CHAT_GHOSTRADIO
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTRADIO) ? "hear all radio chat in the world" : "only hear from nearby speakers"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGR")

/client/proc/toggle_hear_radio()
	set name = "Show/Hide RadioChatter"
	set category = "Preferences"
	set desc = "Toggle seeing radiochatter from radios and speakers"
	if(!holder) return
	prefs.toggles ^= CHAT_RADIO
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers"
	feedback_add_details("admin_verb","THR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!holder)	return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive."
	feedback_add_details("admin_verb","AHS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/deadchat() // Deadchat toggle is usable by anyone.
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc ="Toggles seeing deadchat"
	prefs.toggles ^= CHAT_DEAD
	prefs.save_preferences()

	if(src.holder)
		src << "You will [(prefs.toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat."
	else
		src << "As a ghost, you will [(prefs.toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat."

	feedback_add_details("admin_verb","TDV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences"
	set desc = "Toggles seeing prayers"
	prefs.toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat."
	feedback_add_details("admin_verb","TP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		src << "You will now hear music in the game lobby."
		if(istype(mob, /mob/abstract/new_player))
			playtitlemusic()
	else
		src << "You will no longer hear music in the game lobby."
		if(istype(mob, /mob/abstract/new_player))
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jamsz
	feedback_add_details("admin_verb","TLobby") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglemidis()
	set name = "Hear/Silence Midis"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	prefs.toggles ^= SOUND_MIDI
	prefs.save_preferences()
	if(prefs.toggles & SOUND_MIDI)
		src << "You will now hear any sounds uploaded by admins."
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = 777)
		break_sound.priority = 250
		src << break_sound	//breaks the client's sound output on channel 777
	else
		src << "You will no longer hear sounds uploaded by admins; any currently playing midis have been disabled."
	feedback_add_details("admin_verb","TMidi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.toggles ^= CHAT_OOC
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel."
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/listen_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles seeing Local OutOfCharacter chat"
	prefs.toggles ^= CHAT_LOOC
	prefs.save_preferences()

	src << "You will [(prefs.toggles & CHAT_LOOC) ? "now" : "no longer"] see messages on the LOOC channel."
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_chattags()
	set name = "Show/Hide Chat Tags"
	set category = "Preferences"
	set desc = "Toggles seeing chat tags/icons"
	prefs.toggles ^= CHAT_NOICONS
	prefs.save_preferences()

	src << "You will [!(prefs.toggles & CHAT_NOICONS) ? "now" : "no longer"] see chat tag icons."
	feedback_add_details("admin_verb","TCTAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles & SOUND_AMBIENCE)
		src << "You will now hear ambient sounds."
	else
		src << "You will no longer hear ambient sounds."
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","TAmbi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_space_parallax()
	set name = "Show/Hide Space Parallax"
	set category = "Preferences"
	set desc = "Toggles space parallax effects."
	prefs.toggles_secondary ^= PARALLAX_SPACE
	prefs.save_preferences()
	if (prefs.toggles_secondary & PARALLAX_SPACE)
		src << "You will now see space parallax effects."
	else
		src << "You will no longer see space parallax effects."

	if (mob.hud_used)
		mob.hud_used.update_parallax()


/client/verb/toggle_space_dust()
	set name = "Show/Hide Space Dust"
	set category = "Preferences"
	set desc = "Toggles space parallax dust."
	prefs.toggles_secondary ^= PARALLAX_DUST
	prefs.save_preferences()
	if (prefs.toggles_secondary & PARALLAX_DUST)
		src << "You will now see space parallax dust effects."
	else
		src << "You will no longer see space parallax dust effects."

	if (mob.hud_used)
		mob.hud_used.update_parallax()

/client/verb/set_parallax_speed()
	set name = "Set Parallax Speed"
	set category = "Preferences"
	set desc = "Sets the movement speed of the space parallax effect."
	var/choice = input("What speed do you want to use for space parallax? (default 2)", "SPAAACE") as num|null
	if (!choice || choice < 0)
		src << "Invalid input."
		return

	prefs.parallax_speed = choice
	prefs.save_preferences()

	if (mob.hud_used)
		mob.hud_used.update_parallax()

/client/verb/toggle_progress()
	set name = "Show/Hide Progress Bars"
	set category = "Preferences"
	set desc = "Toggles progress bars on slow actions."

	prefs.toggles_secondary ^= PROGRESS_BARS
	prefs.save_preferences()
	if (prefs.toggles_secondary & PROGRESS_BARS)
		src << "You will now see progress bars on delayed actions."
	else
		src << "You will no longer see progress bars on delayed actions."

/client/verb/toggle_static_spess()
	set name = "Toggle Parallax Movement"
	set category = "Preferences"
	set desc = "Toggles movement of parallax space."

	prefs.toggles_secondary ^= PARALLAX_IS_STATIC
	prefs.save_preferences()

	if (prefs.toggles_secondary & PARALLAX_IS_STATIC)
		src << "Space will no longer move."
	else
		src << "Space will now move."

/client/verb/toggle_safety_check()

	set name = "Toggle Gun Safety Check"
	set category = "Preferences"
	set desc = "Toggles firing guns on intents other than help."

	prefs.toggles_secondary ^= SAFETY_CHECK //Held in Parallax because we don't want to deal with an SQL migration right now.
	prefs.save_preferences()
	src << "You will [(prefs.toggles_secondary & SAFETY_CHECK) ? "no longer" : "now"] fire your weapon on intents other than harm."

/client/verb/toggle_mid_round_antagonist()

	set name = "Toggle Mid Round Antagonist"
	set category = "Preferences"
	set desc = "Enables or disables mid round antagonist spawning"

	prefs.toggles_secondary ^= DISABLE_MID_ROUND_ANTAGONIST //Held in Parallax because we don't want to deal with an SQL migration right now.
	prefs.save_preferences()
	src << "You will [(prefs.toggles_secondary & DISABLE_MID_ROUND_ANTAGONIST) ? "no longer" : "now"] be considered a candidate for mid-round antagonist spawning."
