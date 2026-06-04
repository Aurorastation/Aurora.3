/// A single contiguous segment of spoken text in a single language.
/datum/say_segment
	/// The segment's text.
	var/text

	/// The language this segment is spoken in.
	var/datum/language/language

/// Constructs a new segment of spoken text in the given language.
/datum/say_segment/New(text, datum/language/language)
	. = ..()
	src.text = text
	src.language = language

/// Returns the segment as the given listener perceives it.
/datum/say_segment/proc/render_for(mob/listener, mob/speaker)
	if(language && (language.flags & KNOWONLYHEAR) && !listener.say_understands(speaker, language))
		return ""
	var/rendered = text
	if(language && (language.flags & NONVERBAL))
		if((!speaker || (listener.sdisabilities & BLIND) || listener.blinded || !(speaker in view(listener))) && !isghost(listener))
			rendered = stars(rendered)
	if(!(language && (language.flags & INNATE)) && !listener.say_understands(speaker, language))
		rendered = language ? language.scramble(rendered, listener.languages) : stars(rendered)
	if(copytext(text, length(text)) == " " && copytext(rendered, length(rendered)) != " ")
		rendered += " "
	return rendered
