/var/global/asfx_togs = list(
//	/client/proc/Toggle_asfx,
//	/client/proc/Toggle_footsteps,
	/client/proc/Toggle_asfx_vote,
	/client/proc/Toggle_messagesounds,
	/client/proc/Toggle_dropsounds,
	/client/proc/Toggle_arcadesounds,
	/client/proc/Toggle_radiosounds,
	/client/proc/Toggle_instrumentsounds
)

/client/verb/asf_toggle()
	set name = "Open ASFX Tab"
	set category = "Preferences"
	set desc = "Open the ambience sound effects toggle tab"

	verbs ^= asfx_togs
	return

/client/verb/Toggle_asfx() //Allgnew ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
//	set category = "SoundFx Prefs"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.asfx_togs ^= ASFX_AMBIENCE
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_AMBIENCE)
		to_chat(src, "You will now hear ambient sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear ambient sounds.</span>")
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","TSFXAmbi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Toggle_footsteps()
	set name = "Hear/Silence Footsteps"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing footstep sound effects"

	prefs.asfx_togs ^= ASFX_FOOTSTEPS
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_FOOTSTEPS)
		to_chat(src, "You will now hear footstep sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear footstep sounds.</span>")
	feedback_add_details("admin_verb","TSFXFS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Toggle_asfx_vote()
	set name = "Hear/Silence Vote Alarm"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing of the vote alarm"
	prefs.asfx_togs ^= ASFX_VOTE
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_VOTE)
		to_chat(src, "You will now hear the vote alarm.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear the vote alarm.</span>")
	feedback_add_details("admin_verb","TSFXFV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Toggle_messagesounds()
	set name = "Toggle Message SFX"
	set category = "SoundFx Prefs"
	set desc = "Toggles the message sounds."

	prefs.asfx_togs ^= ASFX_VOX
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.asfx_togs & ASFX_VOX) ? "now" : "no longer"] hear chat voices.")

/client/proc/Toggle_dropsounds()
	set name = "Hear/Silence Drop Sounds"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing dropping and throwing sound effects"

	prefs.asfx_togs ^= ASFX_DROPSOUND
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_DROPSOUND)
		to_chat(src, "You will now hear dropping and throwing sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear dropping and throwing sounds.</span>")

/client/proc/Toggle_arcadesounds()
	set name = "Toggle Arcade SFX"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing noises made by arcades."

	prefs.asfx_togs ^= ASFX_ARCADE
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_ARCADE)
		to_chat(src, "You will now hear arcade sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear arcade sounds.</span>")

/client/proc/Toggle_radiosounds()
	set name = "Toggle Radio SFX"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing noises made by radios."

	prefs.asfx_togs ^= ASFX_RADIO
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_RADIO)
		to_chat(src, "You will now hear radio sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear radio sounds.</span>")

/client/proc/Toggle_instrumentsounds()
	set name = "Toggle Instrument SFX"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing noises made by instruments."

	prefs.asfx_togs ^= ASFX_INSTRUMENT
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_INSTRUMENT)
		to_chat(src, "You will now hear instrument sounds.")
	else
		to_chat(src, "<span class='warning'>You will no longer hear instrument sounds.</span>")
