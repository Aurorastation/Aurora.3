/// A single contiguous segment of an utterance, spoken in one language.
/// An ordered list of these makes up a /datum/say_message.
/datum/say_piece
	/// The segment's text.
	var/text

	/// The language this segment is spoken in.
	var/datum/language/language

/datum/say_piece/New(text, datum/language/language)
	. = ..()
	src.text = text
	src.language = language
