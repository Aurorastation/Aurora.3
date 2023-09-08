/mob/living/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC"

	if(say_disabled)
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)
	message = formalize_text(message)

	SStyping.set_indicator_state(client, FALSE)

	if(client.handle_spam_prevention(message, MUTE_IC))
		return

	whisper(message)

/mob/living/whisper(var/message, var/datum/language/speaking, var/is_singing = FALSE)
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
			message = copytext(message,2+length(speaking.key))
		else
			speaking = get_default_language()

	if(length(message) >= 1 && copytext(message, 1, 2) == "%")
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

	//Check to see who hears the full whisper message, and who just gets the not_heard message
	var/list/eavesdropping = list()
	var/list/watching = list()
	var/list/observers = list()
	var/list/all_in_range = hearers(watching_range, src)
	for(var/mob/M as anything in all_in_range)
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS)) //Preventing duplicate messages to ghostear'd observers
			continue
		if(get_dist(src, M) <= message_range) //In range to hear
			continue
		else if(get_dist(src, M) <= eavesdropping_range)
			if(M.stat == DEAD && M.client)
				observers += M
			else
				eavesdropping += M
		else if(get_dist(src, M) <= watching_range)
			if(M.stat == DEAD && M.client)
				observers += M
			else	
				watching += M

	if(length(observers)) //For ghosts who do NOT have ghost ears. They will see the whole message if nearby, no *s or not_heard messages.
		for(var/mob/M in observers)
			M.hear_say(message, "whispers", speaking, "", TRUE, src)

	if(length(eavesdropping))
		var/new_message = stars(message)
		for(var/mob/M in eavesdropping)
			M.hear_say(new_message, "whispers", speaking, "", TRUE, src)

	if(length(watching))
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> [not_heard].</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)

	say(message, speaking, whisper_text, whisper = TRUE)
