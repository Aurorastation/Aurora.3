/mob/living/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC"

	if(say_disabled)
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	message = sanitize(message)
	message = formalize_text(message)

	set_typing_indicator(0)

	if(client.handle_spam_prevention(message, MUTE_IC))
		return

	whisper(message)

/mob/living/proc/whisper(var/message, var/datum/language/speaking, var/is_singing = FALSE)
	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
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

	var/list/listening = list(src)

	//ghosts
	for(var/mob/M in dead_mob_list)
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			listening |= M

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/living/C in L.contents)
			listening += C

	var/list/eavesdropping = list()
	var/list/watching = list()

	var/list/all_in_range = hearers(watching_range, src)
	for(var/mob/M as anything in all_in_range)
		if(get_dist(src, M) <= message_range)
			listening |= M
		else if(get_dist(src, M) <= eavesdropping_range)
			eavesdropping += M
		else if(get_dist(src, M) <= watching_range)
			watching += M

	if(length(eavesdropping))
		var/new_message = stars(message)
		for(var/mob/M in eavesdropping)
			M.hear_say(new_message, "whispers", speaking, "", TRUE, src)

	if(length(watching))
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> [not_heard].</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)

	say(message, speaking, whisper_text, whisper = TRUE)
