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


/// Returns a flat, language-agnostic string with the message body.
/datum/say_message/proc/to_string()
	var/list/out = list()
	for(var/datum/say_segment/segment as anything in segments)
		out += segment.text
	return jointext(out, "")

/// Returns the first incompatible language in the message pieces or null.
/// Incompatible languages like hivenet can't support multi-language messages.
/datum/say_message/proc/special_language()
	for(var/datum/say_segment/segment as anything in segments)
		if(segment.language && (segment.language.flags & (SIGNLANG|HIVEMIND)))
			return segment.language
	return null

/// True if every segment's language carries the given flag.
/datum/say_message/proc/all_segments_flagged(flag)
	for(var/datum/say_segment/segment as anything in segments)
		if(!segment.language || !(segment.language.flags & flag))
			return FALSE
	return length(segments) > 0

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
