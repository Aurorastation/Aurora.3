/// A complete audible message made of a list of /datum/say_segment.
/datum/say_message
	/// The mob saying the message.
	var/mob/speaker

	/// Name shown instead of the speaker's real name, if any.
	var/alt_name = ""

	/// The raw string that was typed. Used in the admin log.
	var/raw_message

	/// The list of segments that make up the message body.
	var/list/say_segment/segments = list()

	/// The sole language of this message, or null if it interleaves more than one.
	var/datum/language/single_language

	/// Which verb to use. Determined by punctuation and language of the first piece.
	var/verb = "says"

	/// Is the message being whispered?
	var/whisper = FALSE

	/// Is the message being sung?
	var/singing = FALSE

	/// Should the message render as italic?
	var/italics = FALSE

	/// Optional font size override for the rendered message.
	var/font_size

	/// Optional range limit for hearing the message.
	var/message_range

	/// The channel used for this message, if any.
	var/message_mode

	/// Sound played to listeners alongside the message, if any.
	var/sound/speech_sound

	/// Volume of speech_sound.
	var/sound_vol

	/// Which ghosts can hear this message?
	var/ghost_hearing = GHOSTS_ALL_HEAR

	/// Say mode.
	var/mode = SAYMODE_SPOKEN

	/// Reception. A damaged radio message may decrease this, for example.
	var/reception = RECEPTION_CLEAR

/// Returns the complete message as the given listener perceives it.
/datum/say_message/proc/render_for(mob/listener)
	var/list/out = list()
	var/first = TRUE
	for(var/datum/say_segment/segment as anything in segments)
		var/rendered = segment.render_for(listener, speaker)
		if(first && length(rendered))
			rendered = capitalize(rendered)
			first = FALSE
		out += segment.language ? segment.language.colourize(rendered) : rendered
	return jointext(out, "")

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
