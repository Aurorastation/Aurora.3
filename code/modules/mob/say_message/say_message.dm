/// A complete audible message made of a list of /datum/say_segment.
/datum/say_message
	/// The mob saying the message.
	var/mob/speaker

	/// Name shown instead of the speaker's real name, if any.
	var/alt_name = ""

	/// The raw string that was typed. Used in the admin log.
	var/raw_message

	/// The list of segments that make up the message body.
	var/list/datum/say_segment/segments = list()

	/// The sole language of this message, or null if it interleaves more than one.
	var/datum/language/single_language

	/// Which verb to use. Determined by punctuation and language of the first piece.
	var/verb = "says"

	/// Is the message being whispered?
	var/whisper = FALSE

	/// Is the message being sung?
	var/singing = FALSE

	/// The musical note bracketing a sung message.
	var/sing_note

	/// Should the message render as italic?
	var/italics = FALSE

	/// Optional font size override for the rendered message.
	var/font_size

	/// Optional range limit for hearing the message.
	var/message_range

	/// The requested mode for this message.
	var/message_mode

	/// Sound played to listeners alongside the message, if any.
	var/sound/speech_sound

	/// Volume of speech_sound.
	var/sound_vol

	/// Which ghosts can hear this message?
	var/ghost_hearing = GHOSTS_ALL_HEAR

	/// How the message is reaching the listener.
	var/say_mode = SAYMODE_SPOKEN

	/// Initial clarity. Most of the time this is clear. Sometimes the radio will degrade it.
	var/base_clarity = CLARITY_CLEAR

	/// Radio envelope parts. This must live here for performance reasons pending a telecomms rewrite.
	var/list/radio_parts

/// Returns the complete message as the given listener perceives it.
/datum/say_message/proc/render_for(mob/listener, clarity = CLARITY_CLEAR)
	if(clarity == CLARITY_DROWSY)
		return render_drowsy(listener)

	var/list/plain = list()
	for(var/datum/say_segment/segment as anything in segments)
		plain += segment.render_for(listener, speaker)

	// INNATE (audible emotes) are narration, never garbled even when faint
	if(clarity == CLARITY_FAINT && !(single_language?.flags & INNATE))
		var/joined = jointext(plain, "")
		return length(joined) ? stars(joined) : ""

	var/list/out = list()
	var/first = TRUE
	for(var/i in 1 to length(segments))
		var/datum/say_segment/segment = segments[i]
		var/rendered = plain[i]
		if(first && length(rendered))
			rendered = capitalize(rendered)
			first = FALSE
		out += segment.language ? segment.language.colourize(rendered) : rendered
	var/body = listener.hallucinate_heard(jointext(out, ""), speaker)
	if(singing && length(body))
		body = "[sing_note] <span class='singing'>[body]</span> [sing_note]"
	return body

/// Special rendering for drowsy mobs. They almost hear individual words.
/datum/say_message/proc/render_drowsy(mob/listener)
	if(isdeaf(listener))
		return ""
	if(!prob(15))
		return "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	var/list/plain = list()
	for(var/datum/say_segment/segment as anything in segments)
		plain += segment.render_for(listener, speaker)
	var/list/messages = text2list(jointext(plain, ""), " ")
	if(!length(messages))
		return "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	var/list/punctuation = list(",", "!", ".", ";", "?")
	var/heardword = messages[rand(1, messages.len)]
	if(copytext(heardword, 1, 1) in punctuation)
		heardword = copytext(heardword, 2)
	if(copytext(heardword, -1) in punctuation)
		heardword = copytext(heardword, 1, length(heardword))
	return "<span class = 'game_say'>...You hear something about...[heardword]</span>"

/// Returns a flat string with languages stripped out.
/datum/say_message/proc/to_string()
	var/list/out = list()
	for(var/datum/say_segment/segment as anything in segments)
		out += segment.text
	return jointext(out, "")

/// Collapses the whole message into a single segment in the given language.
/datum/say_message/proc/collapse_to(datum/language/language, text)
	single_language = language
	segments = list(new /datum/say_segment(text, language))

/// Returns a shallow copy.
/datum/say_message/proc/copy()
	var/datum/say_message/copy = new
	copy.speaker = speaker
	copy.alt_name = alt_name
	copy.raw_message = raw_message
	copy.segments = segments
	copy.single_language = single_language
	copy.verb = verb
	copy.whisper = whisper
	copy.singing = singing
	copy.sing_note = sing_note
	copy.italics = italics
	copy.font_size = font_size
	copy.message_range = message_range
	copy.message_mode = message_mode
	copy.speech_sound = speech_sound
	copy.sound_vol = sound_vol
	copy.ghost_hearing = ghost_hearing
	copy.say_mode = say_mode
	copy.base_clarity = base_clarity
	copy.radio_parts = radio_parts
	return copy
