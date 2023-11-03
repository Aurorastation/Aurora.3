//
// ASFX Toggles
//

// Ambience plays on channel 2.
// Ambient hum plays on channel 3.
// Music plays on channel 4.

// ASFX Toggles List
/var/global/sfx_toggles = list(
	/client/proc/toggle_footsteps,
	/client/proc/toggle_asfx_vote,
	/client/proc/toggle_messagesounds,
	/client/proc/toggle_dropsounds,
	/client/proc/toggle_arcadesounds,
	/client/proc/toggle_radiosounds,
	/client/proc/toggle_instrumentsounds
)

/client/var/has_sfx_verbs = FALSE
// ASFX Tab Toggle
/client/verb/toggle_asfx_tab()
	set name = "Toggle SFX Preferences Tab"
	set category = "Preferences"
	set desc = "Toggle the SFX preferences tab"

	if(!has_sfx_verbs)
		add_verb(src, sfx_toggles)
		has_sfx_verbs = TRUE
	else
		remove_verb(src, sfx_toggles)
		has_sfx_verbs = FALSE

// Ambience Toggle
/client/verb/toggle_asfx()
	set name = "Toggle Ambience SFX"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"

	prefs.sfx_toggles ^= ASFX_AMBIENCE
	prefs.save_preferences()
	if(prefs.sfx_toggles & ASFX_AMBIENCE)
		to_chat(src, SPAN_INFO("You will now hear ambient sounds."))
	else
		to_chat(src, SPAN_INFO("You will no longer hear ambient sounds."))
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2) // Ambience plays on channel 2.

// Ambient Hum Toggle
/client/verb/toggle_asfx_hum()
	set name = "Toggle Ambient Hum SFX"
	set category = "Preferences"
	set desc = "Toggles hearing the ambient hum sound effect"

	prefs.sfx_toggles ^= ASFX_HUM
	prefs.save_preferences()
	if(prefs.sfx_toggles & ASFX_HUM)
		to_chat(src, SPAN_INFO("You will now hear the ambient hum sound."))
	else
		to_chat(src, SPAN_INFO("You will no longer hear the ambient hum sound."))
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 3) // Ambient hum plays on channel 3.
		ambient_hum_playing = FALSE

/client/verb/toggle_sfx_music()
	set name = "Toggle Music SFX"
	set category = "Preferences"
	set desc = "Toggles hearing music"

	prefs.sfx_toggles ^= ASFX_MUSIC
	prefs.save_preferences()
	src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 4) // Music plays on channel 4.
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_MUSIC) ? "now" : "no longer"] hear music (such as from jukeboxes)."))

/client/verb/toggle_asfx_console()
	set name = "Toggle Console Ambience SFX"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects from consoles"

	prefs.sfx_toggles ^= ASFX_CONSOLE_AMBIENCE
	prefs.save_preferences()
	if(prefs.sfx_toggles & ASFX_CONSOLE_AMBIENCE)
		to_chat(src, SPAN_INFO("You will now hear ambient sounds from consoles."))
	else
		to_chat(src, SPAN_INFO("You will no longer hear ambient sounds from consoles."))
//
// SFX Toggles
//

/client/proc/toggle_footsteps()
	set name = "Toggle Footsteps SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing footstep sound effects"

	prefs.sfx_toggles ^= ASFX_FOOTSTEPS
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_FOOTSTEPS) ? "now" : "no longer"] hear footstep sounds."))

/client/proc/toggle_asfx_vote()
	set name = "Toggle Vote Alarm SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing of the vote alarm"

	prefs.sfx_toggles ^= ASFX_VOTE
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_VOTE) ? "now" : "no longer"] hear the vote alarm."))

/client/proc/toggle_messagesounds()
	set name = "Toggle Message SFX"
	set category = "SFX Preferences"
	set desc = "Toggles the message sounds"

	prefs.sfx_toggles ^= ASFX_VOX
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_VOX) ? "now" : "no longer"] hear chat voices."))

/client/proc/toggle_dropsounds()
	set name = "Toggle Item Dropping SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing dropping and throwing sound effects"

	prefs.sfx_toggles ^= ASFX_DROPSOUND
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_DROPSOUND) ? "now" : "no longer"] hear dropping and throwing sounds."))

/client/proc/toggle_arcadesounds()
	set name = "Toggle Arcade SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing noises made by arcades"

	prefs.sfx_toggles ^= ASFX_ARCADE
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_ARCADE) ? "now" : "no longer"] hear arcade sounds."))

/client/proc/toggle_radiosounds()
	set name = "Toggle Radio SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing noises made by radios"

	prefs.sfx_toggles ^= ASFX_RADIO
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_RADIO) ? "now" : "no longer"] hear radio sounds."))

/client/proc/toggle_instrumentsounds()
	set name = "Toggle Instrument SFX"
	set category = "SFX Preferences"
	set desc = "Toggles hearing noises made by instruments"

	prefs.sfx_toggles ^= ASFX_INSTRUMENT
	prefs.save_preferences()
	to_chat(src, SPAN_INFO("You will [(prefs.sfx_toggles & ASFX_INSTRUMENT) ? "now" : "no longer"] hear instrument sounds."))
