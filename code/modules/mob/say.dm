/mob/proc/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	return

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)

	set_typing_indicator(0)

	if (src.client.handle_spam_prevention(message, MUTE_IC))
		return

	usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='warning'>Speech is currently admin-disabled.</span>")
		return

	message = sanitize(message)

	set_typing_indicator(0)

	if (src.client.handle_spam_prevention(message, MUTE_IC))
		return

	if(use_me)
		usr.emote("me",usr.emote_type,message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(client && !(client.prefs.toggles & CHAT_DEAD))
		to_chat(usr, "<span class='danger'>You have deadchat muted.</span>")
		return

	message = process_chat_markup(message, list("~", "_"))

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message linkify'>\"[message]\"</span>", src)

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (src.stat == 2)		//Dead
		return TRUE

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return TRUE

	//Languages are handled after.
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

	//Language check.
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

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	var/prefix = copytext(message,1,2)
	if(length(message) >= 1 && prefix == "!")
		return all_languages["Noise"]

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext(message, 2, 4))
		var/datum/language/L = language_keys[language_prefix]
		if(!L || !can_speak(L))
			language_prefix = lowertext(copytext(message, 2, 3))
			L = language_keys[language_prefix]
		if(can_speak(L))
			return L

	return null
