/mob/proc/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	return

///what clients use to speak. when you type a message into the chat bar in say mode, this is the first thing that goes off serverside.
/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)

	if (src.client.handle_spam_prevention(message, MUTE_IC))
		return

	//queue this message because verbs are scheduled to process after SendMaps in the tick and speech is pretty expensive when it happens.
	//by queuing this for next tick the mc can compensate for its cost instead of having speech delay the start of the next tick
	if(message)
		QUEUE_OR_CALL_VERB_FOR(VERB_CALLBACK(src, PROC_REF(say), message), SSspeech_controller)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)

	if (src.client.handle_spam_prevention(message, MUTE_IC))
		return

	if(use_me)
		QUEUE_OR_CALL_VERB_FOR(VERB_CALLBACK(src, PROC_REF(client_emote), "me", usr.emote_type, message), SSspeech_controller)
	else
		QUEUE_OR_CALL_VERB_FOR(VERB_CALLBACK(src, PROC_REF(emote), message), SSspeech_controller)

/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."))
		return

	if(!src.client.holder)
		if(!GLOB.config.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat is globally muted."))
			return

	if(client && !(client.prefs.toggles & CHAT_DEAD))
		to_chat(usr, SPAN_DANGER("You have deadchat muted."))
		return

	message = process_chat_markup(message, list("~", "_"))

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message linkify'>\"[message]\"</span>", src)

/mob/proc/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(src.stat == DEAD)
		return TRUE

	// Universal speak makes everything understandable, for obvious reasons.
	if(src.universal_speak || src.universal_understand)
		return TRUE

	// Languages are handled after.
	if (!speaking)
		if(!other)
			return TRUE
		if(other.universal_speak)
			return TRUE
		if(isAI(src) && ispAI(other))
			return TRUE
		if (istype(other, src.type) || istype(src, other.type))
			return TRUE
		return FALSE

	if(speaking.flags & INNATE)
		return TRUE

	// Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return TRUE

	return FALSE

/*
	***Deprecated***
	let this be handled at the hear_say or hear_radio proc
	This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
	robot_talk() proc.
	There is no language handling build into it however there is at the /mob level so we accept the call
	for it but just ignore it.
*/

/mob/proc/say_quote(var/message, var/datum/language/speaking = null, var/singing = FALSE, var/whisper = FALSE)
	. = "says"
	if(singing)
		return "sings"
	if(whisper)
		return "whispers"
	var/ending = copytext(message, length(message))
	var/pre_ending = copytext(message, length(message) - 1, length(message))
	if(ending == "!")
		if(pre_ending == "!" || pre_ending == "?")
			. = pick("shouts", "yells")
		else
			. = "exclaims"
	else if(ending == "?")
		. ="asks"


/mob/proc/whisper(var/message, var/datum/language/speaking, var/is_singing = FALSE)
	set name = "Whisper"
	set category = "IC"
	return

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode="headset")
	if(length(message) >= 1 && copytext(message,1,2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		return department_radio_keys[channel_prefix]

	return null

/**
 * Parses the language code (e.g. :j) from text, such as that supplied to say
 *
 * Returns a `/datum/language` only if the code corresponds to a language that src can speak, otherwise `null`
 *
 * * message - A string, the message to parse
 */
/mob/proc/parse_language(message)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	RETURN_TYPE(/datum/language)

	var/prefix = copytext(message,1,2)
	if(length(message) >= 1 && prefix == "!")
		return GLOB.all_languages[LANGUAGE_NOISE]

	//Check that the message is at least 2 characters long and is there's a prefix starting it
	if(length(message) >= 2 && is_language_prefix(prefix))

		//Get the first 2 letters after the prefix (position 2 and 3)
		var/language_prefix = lowertext(copytext(message, 2, 4))

		//Try to grab a language associated with said prefix
		var/datum/language/L = GLOB.language_keys[language_prefix]

		//If we didn't find a language, or we found one we cannot speak, try with a single letter identification
		if(!istype(L) || (istype(L) && !can_speak(L)))
			language_prefix = lowertext(copytext(message, 2, 3))
			L = GLOB.language_keys[language_prefix]

		//Check if we can speak the language, otherwise return null
		if(istype(L) && can_speak(L))
			return L
		else
			return null
