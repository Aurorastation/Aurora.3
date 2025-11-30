#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	/// Fluff name of language if any.
	var/name = "an unknown language"

	/// a shortened name, for use when languages need to be identified
	var/short

	/// Short description for 'Check Languages'.
	var/desc = "A language."

	/// 'says', 'hisses', 'farts'.
	var/list/speech_verb = list("says")

	/// Used when sentence ends in a ?
	var/list/ask_verb = list("asks")

	/// Used when sentence ends in a !
	var/list/exclaim_verb = list("exclaims")

	/// Used when a sentence ends in !!
	var/list/shout_verb = list("shouts", "yells", "screams")

	/// Optional. When not specified speech_verb + quietly/softly is used instead.
	var/list/whisper_verb = null

	/// list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/list/signlang_verb = list("signs")

	/// The verb displayed when a user sings their message
	var/list/sing_verb = list("sings")

	/// 5 messages changing depending on the length of the signed language. A space should be added before the sentence as shown
	var/list/sign_adv_length = list(" briefly", " a short message", " a message", " a lengthy message", " a very lengthy message")

	/// CSS style to use for strings in this language.
	var/colour = "body"

	/// CSS style used when writing language down, can't be written if null
	var/written_style

	/// Character used to speak in language eg. :o for Unathi.
	var/key = "x"

	/// Various language flags.
	var/flags = 0

	/// If set, non-native speakers will have trouble speaking.
	var/native

	/// Used when scrambling text for a non-speaker.
	var/list/syllables

	/// Likelihood of getting a period and a space in the random scramble string
	var/period_chance = 5

	/// Likelihood of getting a space in the random scramble string
	var/space_chance = 55

	/// List of languages that can /somehwat/ understand it, format is: name = chance of understanding a word
	var/list/partial_understanding

	/// Whether machines can parse and understand this language
	var/machine_understands = TRUE

	/// Whether the accent tag will display when this language is used
	var/allow_accents = FALSE

	/// forces the language to parse for language keys even when a default is set
	var/always_parse_language = FALSE

	/// A map of unscrambled words -> scrambled words, for scrambling.
	var/list/scramble_cache = list()

/datum/language/proc/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor, 1),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"

/// Scrambles the spoken line by looping through every word in the line, calling scramble_word, and then returning the final result
/datum/language/proc/scramble(var/input, var/list/known_languages)

	// the chance that someone will recognize one of the words
	var/understand_chance = 0
	for(var/datum/language/L in known_languages)
		if(LAZYACCESS(partial_understanding, L.name))
			understand_chance += partial_understanding[L.name]

	// singing automatically adds musical notes to the line, we don't want to scramble those
	var/static/list/music_notes = list("\u2669", "\u266A", "\u266B")

	// splits the line into a list of words
	var/list/words_in_line = splittext(input, " ")

	// this list will be populated by the word created below
	var/list/scrambled_text = list()

	// marks the start of a new sentence in the for loop
	var/new_sentence = FALSE

	// loop through the list of words, scrambling it if the listener doesn't understand it, just putting it in if they can partially understand it
	var/word_index = 1
	for(var/word in words_in_line)
		var/list/scramble_results = process_word_prescramble(word, "[word] ", word_index, new_sentence, understand_chance, music_notes)
		var/new_word = scramble_results[1]
		new_sentence = scramble_results[2]
		scrambled_text += new_word
		word_index++

	. = jointext(scrambled_text, null)
	. = capitalize(.)
	. = trim(.)

/// Handles the word before it's scrambled, and then scrambles it if necessary. Returns the new word as the first result, and whether it's a new sentence or not as the second
/datum/language/proc/process_word_prescramble(var/original_word, var/new_word, var/word_index, var/new_sentence, var/understand_chance, var/list/music_notes)
	var/input_ending = copytext(original_word, length(original_word))
	var/ends_sentence = findtext(".?!", input_ending)
	if(!prob(understand_chance) && !(original_word in music_notes))
		new_word = scramble_word(original_word)
		if(new_sentence)
			new_word = capitalize(new_word)
			new_sentence = FALSE
		if(ends_sentence)
			new_word = trim(new_word)
			new_word = "[new_word][input_ending] "

	if(ends_sentence)
		new_sentence = TRUE

	return list(new_word, new_sentence)

/// Scrambles one single word by using the syllables within the syllable list to construct a new word of approximately the same length
/datum/language/proc/scramble_word(var/input)
	if(!length(syllables))
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/input_size = length(input)
	var/input_size_required = scrambled_word_size_requirement(input_size)
	var/scrambled_text = ""
	var/capitalize = FALSE

	// loops until the size of the text we've constructed is bigger than the word we're scrambling
	while(length(scrambled_text) < input_size_required)
		// selects one of the syllables out of the syllable list
		var/next = pick(syllables)

		// if we're starting a new sentence, capitalize the first word
		if(capitalize)
			next = capitalize(next)
			capitalize = FALSE

		// adds the picked syllable to the scramble list
		scrambled_text += next

		// we don't want to add any additional text if it pushes us over the size of the word itself,
		// otherwise the next word won't be capitalized, or will have a double space in front of itself
		if(length(scrambled_text) < input_size_required - 2)
			// returns a value between 1 and 100, which will be used to determine if we should add a period and start a new word
			var/chance = rand(100)

			// adds a period and starts a new sentence
			if(chance <= period_chance)
				scrambled_text += ". "
				capitalize = TRUE
			// just adds a space
			else if(chance <= space_chance)
				scrambled_text += " "

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(length(scramble_cache) > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, length(scramble_cache) - (SCRAMBLE_CACHE_LEN - 1))

	return scrambled_text

/datum/language/proc/scrambled_word_size_requirement(var/input_size)
	return input_size

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
	log_say("[key_name(speaker)] : ([name]) [message]")

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

/mob/abstract/ghost/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
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

/**
 * Check if the language can be spoken by the mob,
 * not the same thing as understood (you can understand a language without speaking it)
 *
 * * speaking - The `/datum/language` to check against, if the mob can speak it
 *
 * Returns `TRUE` if the mob speaks the language, `FALSE` otherwise
 */
/mob/proc/can_speak(datum/language/speaking)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(!istype(speaking))
		stack_trace("No language supplied to check if it can be spoken!")
		return FALSE

	return (speaking.check_speech_restrict(src) && (universal_speak || (speaking && speaking.flags & INNATE) || (speaking in src.languages)))

/mob/proc/get_language_prefix()
	if(client && client.prefs.language_prefixes && client.prefs.language_prefixes.len)
		return client.prefs.language_prefixes[1]

	return GLOB.config.language_prefixes[1]

/mob/proc/is_language_prefix(var/prefix)
	if(client && client.prefs.language_prefixes && client.prefs.language_prefixes.len)
		return prefix in client.prefs.language_prefixes

	return prefix in GLOB.config.language_prefixes

/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC.Language"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b><br/>[L.desc]<br/><br/>"
			if(L.written_style)
				dat += "You can write in this language on papers by writing \[lang=[L.key]\]YourTextHere\[/lang\].<br/><br/>"

	src << browse(HTML_SKELETON(dat), "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=[REF(src)];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			if(L == default_language)
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - default - <a href='byond://?src=[REF(src)];default_lang=reset'>reset</a><br/>[L.desc]<br/><br/>"
			else if(can_speak(L))
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - <a href='byond://?src=[REF(src)];default_lang=[REF(L)]'>set default</a><br/>[L.desc]<br/><br/>"
			else
				dat += "<b>[L.name] ([get_language_prefix()][L.key])</b> - cannot speak!<br/>[L.desc]<br/><br/>"
			if(L.written_style)
				dat += "You can write in this language on papers by writing \[lang=[L.key]\]YourTextHere\[/lang\].<br/><br/>"

	src << browse(HTML_SKELETON(dat), "window=checklanguage")

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
