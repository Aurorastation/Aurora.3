/var/global/asfx_togs = list(
//	/client/proc/Toggle_asfx,
//	/client/proc/Toggle_footsteps,
	/client/proc/Toggle_asfx_vote,
	/client/proc/toggle_vox_voice,
	/client/proc/Toggle_dropsounds
)

/client/verb/asf_toggle()
	set name = "Open ASFX Tab"
	set category = "Preferences"
	set desc = "Open the ambiance sound effects toggle tab"

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
		to_chat(src, "<font color='red'>You will no longer hear ambient sounds.</font>")
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
		to_chat(src, "<font color='red'>You will no longer hear footstep sounds.</font>")
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
		to_chat(src, "<font color='red'>You will no longer hear the vote alarm.</font>")
	feedback_add_details("admin_verb","TSFXFV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_vox_voice()
	set name = "Toggle VOX Voice"
	set category = "SoundFx Prefs"
	set desc = "Toggles the announcement voice."

	prefs.asfx_togs ^= ASFX_VOX
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.asfx_togs & ASFX_VOX) ? "now" : "no longer"] hear the VOX voice.")

/client/proc/Toggle_dropsounds()
	set name = "Hear/Silence Drop Sounds"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing dropping and throwing sound effects"

	prefs.asfx_togs ^= ASFX_DROPSOUND
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_DROPSOUND)
		to_chat(src, "You will now hear dropping and throwing sounds.")
	else
		to_chat(src, "<font color='red'>You will no longer hear dropping and throwing sounds.</font>")