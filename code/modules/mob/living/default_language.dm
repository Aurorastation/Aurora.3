/mob/living
	var/datum/language/default_language

/mob/living/verb/set_default_language_verb()
	set name = "Set Default Language"
	set category = "IC.Language"

	var/datum/language/language = input(src, "Choose a language.", "Set Default Language") as null|anything in languages
	if(!language)
		to_chat(src, SPAN_NOTICE("You will keep speaking your current default language, by default."))
		return

	var/set_result = set_default_language(language)

	if(set_result)
		to_chat(src, SPAN_NOTICE("You will now speak [language] if you do not specify a language when speaking."))
	else
		to_chat(src, SPAN_NOTICE("You are unable to speak [language], choose another one or keep using [default_language]."))

/mob/living/verb/check_default_language()
	set name = "Check Default Language"
	set category = "IC.Language"

	if(default_language)
		to_chat(src, SPAN_NOTICE("You are currently speaking [default_language] by default."))
	else
		to_chat(src, SPAN_NOTICE("Your current default language is your species or mob type default."))
