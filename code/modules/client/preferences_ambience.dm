/var/global/asfx_togs = list(
//	/client/proc/Toggle_asfx,
//	/client/proc/Toggle_footsteps,
	/client/proc/Toggle_asfx_vote
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
		src << "You will now hear ambient sounds."
	else
		src << "<font color='red'>You will no longer hear ambient sounds.</font>"
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
		src << "You will now hear footstep sounds."
	else
		src << "<font color='red'>You will no longer hear footstep sounds.</font>"
	feedback_add_details("admin_verb","TSFXFS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Toggle_asfx_vote()
	set name = "Hear/Silence Vote Alarm"
	set category = "SoundFx Prefs"
	set desc = "Toggles hearing of the vote alarm"
	prefs.asfx_togs ^= ASFX_VOTE
	prefs.save_preferences()
	if(prefs.asfx_togs & ASFX_VOTE)
		src << "You will now hear the vote alarm."
	else
		src << "<font color='red'>You will no longer hear the vote alarm.</font>"
	feedback_add_details("admin_verb","TSFXFV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
