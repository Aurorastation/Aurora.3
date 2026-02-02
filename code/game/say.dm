/**
 * What makes things... talk.
 *
 * * message - The message to say.
 * * bubble_type - The type of speech bubble to use when talking
 * * spans - A list of spans to attach to the message. Includes the atom's speech span by default
 * * sanitize - Should we sanitize the message? Only set to FALSE if you have ALREADY sanitized it
 * * language - The language to speak in. Defaults to the atom's selected language
 * * ignore_spam - Should we ignore spam checks?
 * * forced - What was it forced by? null if voluntary. (NOT a boolean!)
 * * filterproof - Do we bypass the filter when checking the message?
 * * message_range - The range of the message. Defaults to 7
 * * saymode - Saymode passed to the speech
 * This is usually set automatically and is only relevant for living mobs.
 * * message_mods - A list of message modifiers, i.e. whispering/singing.
 * Most of these are set automatically but you can pass in your own pre-say.
 */
/atom/movable/proc/say(
	message,
	bubble_type,
	list/spans = list(),
	sanitize = TRUE,
	datum/language/language,
	ignore_spam = FALSE,
	forced,
	filterproof = FALSE,
	message_range = 7,
	datum/saymode/saymode,
	list/message_mods = list(),
)
	if(!try_speak(message, ignore_spam, forced, filterproof))
		return
	if(sanitize)
		message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message || message == "")
		return
	spans |= speech_span
	//language ||= get_selected_language()
	send_speech(message, message_range, src, bubble_type, spans, language, message_mods, forced = forced)
	return

/// Called when this movable hears a message from a source.
/// Returns TRUE if the message was received and understood.
/atom/movable/proc/Hear(atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range=0)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)
	return TRUE

/**
 * Checks if our movable can speak the provided message, passing it through filters
 * and spam detection. Does not call can_speak. CAN include feedback messages about
 * why someone can or can't speak
 *
 * Used in [proc/say] and other methods of speech (radios) after a movable has inputted some message.
 * If you just want to check if the movable is able to speak in character, use [proc/can_speak] instead.
 *
 * Parameters:
 * - message (string): the original message
 * - ignore_spam (bool): should we ignore spam?
 * - forced (null|string): what was it forced by? null if voluntary
 * - filterproof (bool): are we filterproof?
 *
 * Returns:
 * 	TRUE of FASE depending on if our movable can speak
 */
/atom/movable/proc/try_speak(message, ignore_spam = FALSE, forced = null, filterproof = FALSE)
	return can_speak()

/**
 * Checks if our movable can currently speak, vocally, in general.
 * Should NOT include feedback messages about why someone can or can't speak

 * Used in various places to check if a movable is simply able to speak in general,
 * regardless of OOC status (being muted) and regardless of what they're actually saying.
 */
/atom/movable/proc/can_speak()
	SHOULD_BE_PURE(TRUE)
	return !HAS_TRAIT(src, TRAIT_MUTE)


//Aurora Snowflake: Removed TTS
/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language, list/message_mods = list(), forced = FALSE)
	for(var/atom/movable/hearing_movable as anything in get_hearers_in_view(range, source))
		if(!hearing_movable)//theoretically this should use as anything because it shouldnt be able to get nulls but there are reports that it does.
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue
		hearing_movable.Hear(null, src, message_language, message, null, null, null, spans, message_mods, range)

/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), visible_name = FALSE)
	//This proc uses [] because it is faster than continually appending strings. Thanks BYOND.
	//Basic span
	//var/freq_color = get_radio_color(radio_freq, radio_freq_color)
	//var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "game say"]' [freq_color ? "style='color:[freq_color];'" : ""]>"
	var/spanpart1 = "<span class='game say'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	//var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq, radio_freq_name)]\] " : ""
	//Speaker name
	var/namepart = speaker.get_message_voice(visible_name)

	//End name span.
	var/endspanpart = "</span>"

//	// Language icon.
//	var/languageicon = ""
//	if(!message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
//		var/datum/language/dialect = GLOB.language_datum_instances[message_language]
//		if(istype(dialect) && dialect.display_icon(src))
//			languageicon = "[dialect.get_icon()] "

	/** AURORA SNOWFLAKE */

/** 	// Accent icon.
	var/accenticon = ""
	if(!message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		var/datum/language/dialect = GLOB.language_datum_instances[message_language]
		if(istype(dialect) && dialect.display_icon(src))
			accenticon = "[dialect.get_icon()] " */

	/** END AURORA SNOWFLAKE */

	// The actual message part.
	var/messagepart = speaker.generate_messagepart(raw_message, spans, message_mods)
	messagepart = " <span class='message'>[messagepart]</span></span>"

	//return "[spanpart1][spanpart2][freqpart][languageicon][accenticon][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_language, raw_message, radio_freq)][endspanpart][messagepart]"
	return "[spanpart1][spanpart2][compose_track_href(speaker, namepart)][namepart][endspanpart][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/**
 * Works out and returns which prefix verb the passed message should use.
 *
 * input - The message for which we want the verb.
 * message_mods - A list of message modifiers, i.e. whispering/singing.
 */
/atom/movable/proc/say_mod(input, list/message_mods = list())
	var/ending = copytext_char(input, -1)
	if(copytext_char(input, -2) == "!!")
		return verb_yell
	else if(message_mods[MODE_SING])
		. = verb_sing
	else if(message_mods[WHISPER_MODE])
		. = verb_whisper
	else if(ending == "?")
		return verb_ask
	else if(ending == "!")
		return verb_exclaim
	else
		return get_default_say_verb()

/**
 * Gets the say verb we default to if no special verb is chosen.
 * This is primarily a hook for inheritors,
 * like human_say.dm's tongue-based verb_say changes.
 */
/atom/movable/proc/get_default_say_verb()
	return verb_say

/**
 * This proc is used to generate the 'message' part of a chat message.
 * Generates the `says, "<span class='red'>meme</span>"` part of the `Grey Tider says, "meme"`,
 * or the `taps their microphone.` part of `Grey Tider taps their microphone.`.
 *
 * input - The message to be said
 * spans - A list of spans to attach to the message. Includes the atom's speech span by default
 * message_mods - A list of message modifiers, i.e. whispering/singing
 */
/atom/movable/proc/generate_messagepart(input, list/spans = list(speech_span), list/message_mods = list())
	// If we only care about the emote part, early return.
	if(message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		return apply_message_emphasis(message_mods[MODE_CUSTOM_SAY_EMOTE])

	// Otherwise, we format our full quoted message.
	if(!input)
		input = "..."

	var/say_mod = message_mods[MODE_CUSTOM_SAY_EMOTE] || message_mods[SAY_MOD_VERB] || say_mod(input, message_mods)

	SEND_SIGNAL(src, COMSIG_MOVABLE_SAY_QUOTE, args)

	if(copytext_char(input, -2) == "!!")
		spans |= SPAN_YELL

	/* all inputs should be fully figured out past this point */

	var/processed_input = apply_message_emphasis(input) //This MUST be done first so that we don't get clipped by spans
	processed_input = attach_spans(processed_input, spans)

	var/processed_say_mod = apply_message_emphasis(say_mod)

	return "[processed_say_mod], \"[processed_input]\""

/// Transforms the message emphasis mods from [/atom/proc/apply_message_emphasis] into the appropriate HTML tags. Includes escaping.
#define ENCODE_HTML_EMPHASIS(input, char, html, varname) \
	var/static/regex/##varname = regex("(?<!\\\\)[char](.+?)(?<!\\\\)[char]", "g");\
	input = varname.Replace_char(input, "<[html]>$1</[html]>&#8203;") //zero-width space to force maptext to respect closing tags.

/// Scans the input sentence for message emphasis modifiers, notably |italics|, +bold+, and _underline_ -mothblocks
/atom/proc/apply_message_emphasis(input)
	ENCODE_HTML_EMPHASIS(input, "\\|", "i", italics)
	ENCODE_HTML_EMPHASIS(input, "\\+", "b", bold)
	ENCODE_HTML_EMPHASIS(input, "\\_", "u", underline)
	var/static/regex/remove_escape_backlashes = regex("\\\\(\\_|\\+|\\|)", "g") // Removes backslashes used to escape text modification.
	input = remove_escape_backlashes.Replace_char(input, "$1")
	return input

#undef ENCODE_HTML_EMPHASIS

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	var/ending = copytext_char(text, -1)
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/**
 * Get what this atom sounds like when speaking
 *
 * * add_id_name - If TRUE, ID information such as honorifics are added into the voice
 */
/atom/proc/get_voice(add_id_name = FALSE)
	return "[src]" //Returns the atom's name, prepended with 'The' if it's not a proper noun

/**
 * Get what this atom appears like in chat when speaking
 *
 * * visible_name - If TRUE, returns the visible name rather than the voice
 */
/atom/proc/get_message_voice(visible_name)
	return visible_name ? get_visible_name(add_id_name = TRUE) : get_voice(add_id_name = TRUE)
