/// A single spoken utterance, modelled as an ordered list of /datum/say_piece
/// segments so that multiple languages can be interspersed in one message.
/// A single-language message is just the one-piece case.
/datum/say_message
	/// The mob speaking.
	var/mob/speaker

	/// Ordered list of /datum/say_piece making up the utterance.
	var/list/say_piece/pieces = list()

	/// Resolved once from punctuation and the primary (first) piece's language.
	var/verb = "says"

	/// Whether the utterance is whispered.
	var/whisper = FALSE

	/// Whether the utterance is sung (the '%' prefix).
	var/is_singing = FALSE

	/// Radio channel mode parsed from the message, if any.
	var/message_mode

	/// How far the utterance carries, in tiles.
	var/message_range

	/// Sound played to listeners alongside the message, if any.
	var/sound/speech_sound

	/// Volume of speech_sound.
	var/sound_vol

	/// Whether the message is rendered in italics.
	var/italics = FALSE

	/// Optional font size override for the rendered message.
	var/font_size

	/// Which ghosts hear this utterance.
	var/ghost_hearing = GHOSTS_ALL_HEAR

	/// The typed string after radio-prefix stripping but before language splitting. Used for logging.
	var/raw_message

/// Returns the flattened raw text of every piece, for logging and language-agnostic consumers.
/datum/say_message/proc/to_string()
	var/list/out = list()
	for(var/datum/say_piece/piece as anything in pieces)
		out += piece.text
	return jointext(out, "")

/// Returns the first SIGNLANG or HIVEMIND language present in any piece, or null.
/// Such languages cannot be interspersed and route the whole message to their special path.
/datum/say_message/proc/special_language()
	for(var/datum/say_piece/piece as anything in pieces)
		if(piece.language && (piece.language.flags & (SIGNLANG|HIVEMIND)))
			return piece.language
	return null
