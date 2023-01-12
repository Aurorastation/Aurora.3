// This mob is a lie. Similar to /mob/abstract it's not really supposed to do much.
// It is used as a fake announcer so that we have a lightweight mob to pass to radio broadcasts.
// To use it simply instantiate it, store a reference to it - it can be reused, so no reason
// to delete it immediately. Just before a broadcast call PrepareBroadcast with desired arguments,
// then right after the broadcast call ResetAfterBroadcast so you can re-use the mob without issues next time.

/mob/living/announcer
	name = "Announcer"
	voice_name = "synthesized voice"
	accent = ACCENT_TTS

	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
	gender = NEUTER

	status_flags = GODMODE|NO_ANTAG|NOFALL
	invisibility = INVISIBILITY_ABSTRACT
	mob_thinks = FALSE

	universal_understand = TRUE
	tesla_ignore = TRUE
	stop_sight_update = TRUE
	density = FALSE
	burn_mod = 0
	brute_mod = 0

/mob/living/announcer/Initialize()
	// we specifically do not call parent Initialize here because this mob should not need it and its point is to be lightweight
	SHOULD_CALL_PARENT(FALSE)
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE

	for(var/K in all_languages)
		add_language(K)
	default_language = all_languages[LANGUAGE_TCB]

	return INITIALIZE_HINT_NORMAL

/mob/living/announcer/Destroy()
	for(var/C in contents) // make doubly sure the contents don't get dropped on ground or something
		qdel(C)
	// calling parent shouldn't be required, but let's do it just in case; contains cleanup stuff
	return ..()

/mob/living/announcer/proc/PrepareBroadcast(var/name = "", var/datum/language/lang = null, var/voice_name = null, var/accent = null)
	src.name = name
	if(!isnull(lang))
		src.default_language = lang
	if(!isnull(voice_name))
		src.voice_name = voice_name
	if(!isnull(accent))
		src.accent = accent

/mob/living/announcer/proc/ResetAfterBroadcast()
	src.name = initial(name)
	src.default_language = all_languages[LANGUAGE_TCB]
	src.voice_name = initial(voice_name)
	src.accent = initial(accent)

/mob/living/announcer/Life()
	return

/mob/living/announcer/Move()
	return

/mob/living/announcer/zMove()
	return

/mob/living/announcer/getBruteLoss()
	return 0

/mob/living/announcer/burn_skin()
	return FALSE

/mob/living/announcer/adjustBodyTemp()
	return FALSE

/mob/living/announcer/get_contents()
	return list()

/mob/living/announcer/check_contents_for()
	return FALSE

/mob/living/announcer/can_inject()
	return FALSE

/mob/living/announcer/seizure()
	return FALSE

/mob/living/announcer/InStasis()
	return FALSE

/mob/living/announcer/apply_radiation_effects()
	return FALSE

/mob/living/announcer/flash_act()
	return FALSE

/mob/living/announcer/dust()
	qdel(src)

/mob/living/announcer/gib()
	qdel(src)

/mob/living/announcer/can_fall()
	return FALSE

/mob/living/announcer/conveyor_act()
	return

/mob/living/announcer/ex_act()
	return

/mob/living/announcer/singularity_act()
	return

/mob/living/announcer/singularity_pull()
	return

/mob/living/announcer/singuloCanEat()
	return FALSE
