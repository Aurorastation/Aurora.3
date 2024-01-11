#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language"  // Fluff name of language if any.
	var/short                         // a shortened name, for use when languages need to be identified
	var/desc = "A language."          // Short description for 'Check Languages'.
	var/list/speech_verb = list("says")          // 'says', 'hisses', 'farts'.)
	var/list/ask_verb = list("asks")  // Used when sentence ends in a ?
	var/list/exclaim_verb = list("exclaims") // Used when sentence ends in a !
	var/list/shout_verb = list("shouts", "yells", "screams") //Used when a sentence ends in !!
	var/list/whisper_verb = null  // Optional. When not specified speech_verb + quietly/softly is used instead.
	var/list/signlang_verb = list("signs") // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/list/sing_verb = list("sings")
	var/list/sign_adv_length = list(" briefly", " a short message", " a message", " a lengthy message", " a very lengthy message") // 5 messages changing depending on the length of the signed language. A space should be added before the sentence as shown
	var/colour = "body"               // CSS style to use for strings in this language.
	var/written_style                 // CSS style used when writing language down, can't be written if null
	var/key = "x"                     // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                     // Various language flags.
	var/native                        // If set, non-native speakers will have trouble speaking.
	var/list/syllables                // Used when scrambling text for a non-speaker.
	var/list/space_chance = 55        // Likelihood of getting a space in the random scramble string
	var/list/partial_understanding				  // List of languages that can /somehwat/ understand it, format is: name = chance of understanding a word
	var/machine_understands = TRUE	// Whether machines can parse and understand this language
	var/allow_accents = FALSE
	var/always_parse_language = FALSE // forces the language to parse for language keys even when a default is set
	var/list/scramble_cache = list()  // A map of unscrambled words -> scrambled words, for scrambling.

/datum/language/proc/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"

/datum/language/proc/scramble(var/input, var/list/known_languages)

	var/understand_chance = 0
	for(var/datum/language/L in known_languages)
		if(LAZYACCESS(partial_understanding, L.name))
			understand_chance += partial_understanding[L.name]

	var/static/list/music_notes = list("\u2669", "\u266A", "\u266B")

	var/list/words = splittext(input, " ")
	var/list/scrambled_text = list()
	var/new_sentence = 0
	for(var/w in words)
		var/nword = "[w] "
		var/input_ending = copytext(w, length(w))
		var/ends_sentence = findtext(".?!",input_ending)
		if(!prob(understand_chance) && !(w in music_notes))
			nword = scramble_word(w)
			if(new_sentence)
				nword = capitalize(nword)
				new_sentence = FALSE
			if(ends_sentence)
				nword = trim(nword)
				nword = "[nword][input_ending] "

		if(ends_sentence)
			new_sentence = TRUE

		scrambled_text += nword

	. = jointext(scrambled_text, null)
	. = capitalize(.)
	. = trim(.)

/datum/language/proc/scramble_word(var/input)
	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/input_size = length(input)
	var/scrambled_text = ""
	var/capitalize = 0

	while(length(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = 0
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= 5)
			scrambled_text += ". "
			capitalize = 1
		else if(chance > 5 && chance <= space_chance)
			scrambled_text += " "

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

	return scrambled_text

/datum/language/proc/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[capitalize(message)]\"</span></span>"

/datum/language/proc/format_message_plain(message, verb)
	return "[verb], \"[capitalize(message)]\""

/datum/language/proc/format_message_radio(message, verb)
	return "[verb], <span class='[colour]'>\"[capitalize(message)]\"</span>"

/datum/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/datum/language/proc/broadcast(var/mob/living/speaker, var/message, var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]",ckey=key_name(speaker))

	if(!speaker_mask)
		speaker_mask = speaker.name
	message = format_message(message, get_spoken_verb(message))

	for(var/mob/player in GLOB.player_list)
		player.hear_broadcast(src, speaker, speaker_mask, message)

/mob/proc/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if((language in languages) && language.check_special_condition(src))
		var/msg = "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>"
		to_chat(src, msg)

/mob/abstract/new_player/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	return

/mob/abstract/observer/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if(speaker.name == speaker_name || antagHUD)
		to_chat(src, "[ghost_follow_link(speaker, src)] <i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>")
	else
		to_chat(src, "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>")

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end, var/pre_end, var/singing = FALSE, var/whisper = FALSE)
	var/chosen_verb = speech_verb
	if(singing)
		return pick(sing_verb)
	if(whisper)
		return pick(whisper_verb)
	switch(msg_end)
		if("!")
			if(pre_end == "!" || pre_end == "?")
				chosen_verb = shout_verb
			else
				chosen_verb = exclaim_verb
		if("?")
			if(pre_end == "!")
				chosen_verb = shout_verb
			else
				chosen_verb = ask_verb
		else
			chosen_verb = speech_verb
	return pick(chosen_verb)

/datum/language/proc/handle_message_mode(var/message_mode)
	return list(src, message_mode)

/**
 * Checks if a language with special physical requirements can be spoken by a mob
 * Returns `TRUE` if allowed to, `FALSE` otherwise
 *
 * * speaker - A `mob` to check for the ability to speak the language
 */
/datum/language/proc/check_speech_restrict(mob/speaker)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/**
 * Adds a language to the known ones for the mob, returns `TRUE` if added successfully, `FALSE` otherwise
 *
 * Does NOT make it the default language
 *
 * * language - The language to add, can either be a `/datum/language` or a string, see the LANGUAGE_* defines in `code\__DEFINES\species_languages.dm` for the strings
 */
/mob/proc/add_language(language)
	SHOULD_NOT_SLEEP(TRUE)

	var/datum/language/new_language
	if(istype(language, /datum/language))
		new_language = language
	else
		new_language = GLOB.all_languages[language]

	if(!istype(new_language) || !new_language)
		crash_with("ERROR: Language [language] not found in list of all languages. The language you're looking for may have been moved, renamed, or removed. Please recheck the spelling of the name.")

	if(new_language in languages)
		return FALSE

	languages.Add(new_language)
	return TRUE

/**
 * Set default language for a `/mob/living`, return `TRUE` if set successfully, `FALSE` otherwise
 *
 * * language - The language to set as default, can either be a `/datum/language`, a string as per `LANGUAGE_*` defines in `code\__DEFINES\species_languages.dm`,
 * or `null` to remove the default language
 */
/mob/living/proc/set_default_language(language)
	SHOULD_NOT_SLEEP(TRUE)

	var/datum/language/new_default_language
	if(istype(language, /datum/language))
		new_default_language = language
	else
		new_default_language = GLOB.all_languages[language]

	if(!isnull(new_default_language) && !istype(new_default_language))
		stack_trace("ERROR: Language [language] not found in list of all languages. The language you're looking for may have been moved, renamed, or removed. Please recheck the spelling of the name.")
		return FALSE

	if(!isnull(new_default_language) && !(new_default_language in languages))
		stack_trace("Trying to set a default language that is not known by the mob! The language must first be added for it to be set as default!")
		return FALSE

	default_language = new_default_language
	return TRUE

//Silicons can only speak languages listed in the `speech_synthesizer_langs`, even if they can understand more
/mob/living/silicon/set_default_language(language)

	//Return FALSE if they can't speak this language
	if(!(language in speech_synthesizer_langs))
		return FALSE

	. = ..()

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = GLOB.all_languages[rem_language]
	. = (L in languages)
	languages.Remove(L)

/mob/living/remove_language(rem_language)
	var/datum/language/L = GLOB.all_languages[rem_language]
	if(default_language == L)
		default_language = null
	return ..()

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (speaking.check_speech_restrict(src) && (universal_speak || (speaking && speaking.flags & INNATE) || (speaking in src.languages)))

/mob/proc/get_language_prefix()
	if(client && client.prefs.language_prefixes && client.prefs.language_prefixes.len)
		return client.prefs.language_prefixes[1]

	return GLOB.config.language_prefixes[1]

/mob/proc/is_language_prefix(var/prefix)
	if(client && client.prefs.language_prefixes && client.prefs.language_prefixes.len)
		return prefix in client.prefs.language_prefixes

	return prefix in GLOB.config.language_prefixes

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b><br/>[L.desc]<br/><br/>"
			if(L.written_style)
				dat += "You can write in this language on papers by writing \[lang=[L.key]\]YourTextHere\[/lang\].<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			if(L == default_language)
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/>[L.desc]<br/><br/>"
			else if(can_speak(L))
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a><br/>[L.desc]<br/><br/>"
			else
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - cannot speak!<br/>[L.desc]<br/><br/>"
			if(L.written_style)
				dat += "You can write in this language on papers by writing \[lang=[L.key]\]YourTextHere\[/lang\].<br/><br/>"

	src << browse(dat, "window=checklanguage")

/mob/living/Topic(href, href_list)
	if(href_list["default_lang"])
		if(href_list["default_lang"] == "reset")
			set_default_language(null)
		else
			var/datum/language/L = locate(href_list["default_lang"])
			if(L && (L in languages))
				set_default_language(L)
		check_languages()
		return 1
	else
		return ..()

/proc/transfer_languages(var/mob/source, var/mob/target, var/except_flags)
	for(var/datum/language/L in source.languages)
		if(L.flags & except_flags)
			continue
		target.add_language(L.name)

#undef SCRAMBLE_CACHE_LEN
