/mob/living/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC"

	if(say_disabled)
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)
	message = formalize_text(message)

	if(client.handle_spam_prevention(message, MUTE_IC))
		return

	whisper(message)

/mob/living/whisper(var/message, var/datum/language/speaking, var/is_singing = FALSE, var/say_verb = FALSE)
	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	if(silent)
		to_chat(src, SPAN_WARNING("You try to speak, but nothing comes out!"))
		return

	var/had_speaking = !!speaking
	speaking = speaking ? speaking : parse_language(message)

	if(!had_speaking)
		if(speaking)
			message = copytext_char(message, 2 + length(speaking.key))
		else
			speaking = get_default_language()

	if(length_char(message) >= 1 && copytext_char(message, 1, 2) == "%")
		if(speaking?.sing_verb)
			is_singing = TRUE

	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5

	var/whisper_text = "whispers"
	var/not_heard = "[whisper_text] something"
	if(speaking)
		if(speaking.whisper_verb)
			whisper_text = pick(speaking.whisper_verb)
			not_heard = "[whisper_text] something"
		else
			var/adverb = pick("quietly", "softly")
			var/speak_text = pick(speaking.speech_verb)
			if(is_singing && speaking?.sing_verb)
				speak_text = pick(speaking.sing_verb)
			whisper_text = "[speak_text] [adverb]"
			not_heard = "[speak_text] something [adverb]"

	// Check to see who hears the full whisper message, and who just gets the not_heard message
	var/list/eavesdropping = list()
	var/list/watching = list()
	var/list/observers = list()
	var/list/all_in_range = hearers(watching_range, src)
	for(var/mob/M as anything in all_in_range)
		// If they got sensitive hearing enabled, increase the whisper hearing range by one
		var/sensitive = astype(M, /mob/living/carbon/human)?.is_listening() ? 1 : 0
		//Preventing duplicate messages to ghostear'd observers
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			continue
		if(get_dist(src, M) <= (message_range + sensitive)) //In range to hear
			continue
		else if(get_dist(src, M) <= (eavesdropping_range + sensitive))
			if(M.stat == DEAD && M.client)
				observers += M
			else
				eavesdropping += M
		else if(get_dist(src, M) <= watching_range)
			if(M.stat == DEAD && M.client)
				observers += M
			else
				watching += M

	var/datum/say_message/msg = build_say_message(message, speaking)
	msg.whisper = TRUE
	msg.say_mode = SAYMODE_SPOKEN
	msg.verb = "whispers"
	msg.italics = TRUE

	if(length(observers))
		// For ghosts who do NOT have ghost ears.
		// They will see the whole message if nearby, no *s or not_heard messages.
		for(var/mob/M in observers)
			M.hear_message(msg)

	if(length(eavesdropping))
		msg.base_clarity = CLARITY_FAINT
		for(var/mob/M in eavesdropping)
			M.hear_message(msg)

	if(length(watching))
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> [not_heard].</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)

	say(message, speaking, whisper_text, whisper = TRUE, skip_edit = say_verb)
