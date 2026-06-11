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

/mob/living/whisper(var/text, var/datum/language/speaking, var/is_singing = FALSE, var/say_verb = FALSE, var/datum/say_message/msg = null)
	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	if(silent)
		to_chat(src, SPAN_WARNING("You try to speak, but nothing comes out!"))
		return

	// A reroute from say() hands us its already-built say_message.
	// Otherwise, build one.
	var/from_say = !isnull(msg)
	if(!msg)
		var/datum/language/forced = (speaking && !speaking.always_parse_language) ? speaking : null
		msg = build_say_message(text, forced)

	if(!length(msg.to_string()))
		return

	var/datum/language/primary = msg.segments[1].language

	if(!from_say)
		if(copytext(msg.segments[1].text, 1, 2) == "%")
			msg.segments[1].text = copytext(msg.segments[1].text, 2)
			if(primary?.sing_verb)
				msg.singing = TRUE
				msg.sing_note = pick("\u2669", "\u266A", "\u266B")
		if(is_singing && primary?.sing_verb)
			msg.singing = TRUE

		// Hivemind has no distance. It always broadcasts.
		if(msg.single_language?.flags & HIVEMIND)
			if(msg.single_language.name == LANGUAGE_VAURCA && within_jamming_range(src))
				to_chat(src, SPAN_WARNING("Your head buzzes as your message is blocked with jamming signals."))
				return
			msg.single_language.broadcast(src, trim(msg.to_string()))
			return TRUE

	var/whisper_text = "whispers"
	var/not_heard = "[whisper_text] something"
	if(primary)
		if(primary.whisper_verb)
			whisper_text = pick(primary.whisper_verb)
			not_heard = "[whisper_text] something"
		else
			var/adverb = pick("quietly", "softly")
			var/speak_text = pick(primary.speech_verb)
			if(msg.singing && primary.sing_verb)
				speak_text = pick(primary.sing_verb)
			whisper_text = "[speak_text] [adverb]"
			not_heard = "[speak_text] something [adverb]"

	msg.whisper = TRUE
	msg.say_mode = SAYMODE_SPOKEN
	msg.verb = whisper_text
	msg.italics = TRUE
	msg.message_range = 1
	msg.alt_name = ""

	if(!from_say && !finalize_say_message(msg, say_verb))
		return

	var/list/handle_v = handle_speech_sound()
	msg.speech_sound = handle_v[1]
	msg.sound_vol = handle_v[2]
	if(handle_v[3])
		msg.italics = TRUE
	msg.font_size = get_font_size_modifier()

	// Sign language is visual and whole-message. It routes separately.
	if(msg.single_language?.flags & SIGNLANG)
		msg.say_mode = SAYMODE_SIGN
		msg.verb = pick(msg.single_language.signlang_verb)
		return say_signlang(msg)

	var/eavesdropping_range = 2
	var/watching_range = 5

	// Inner ring is everybody who clearly hears the whisper.
	var/list/inner = get_hearers_in_view(msg.message_range, src)
	inner = mergelists(inner, get_intent_listeners(src, msg.message_range + 1), TRUE)

	// Outer ring is for those further away.
	var/list/eavesdropping = list()
	var/list/watching = list()
	var/list/observers = list()
	for(var/mob/M as anything in hearers(watching_range, src))
		if(M in inner)
			continue
		var/sensitive = astype(M, /mob/living/carbon/human)?.is_listening() ? 1 : 0
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			continue
		if(get_dist(src, M) <= (msg.message_range + sensitive))
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

	// Ghost ears hear all speech. They hear it from any distance.
	if(client)
		for(var/mob/player_mob in GLOB.player_list)
			if(!player_mob || player_mob.stat != DEAD || (player_mob in inner))
				continue
			if(player_mob.client?.prefs.toggles & CHAT_GHOSTEARS)
				inner |= player_mob

	msg.base_clarity = CLARITY_CLEAR
	var/list/hear_clients = deliver_say_message(msg, inner)

	// Nearby ghosts without ghost ears hear it clearly.
	for(var/mob/M in observers)
		M.hear_message(msg)

	// Eavesdroppers can only hear the message faintly.
	if(length(eavesdropping))
		var/datum/say_message/faint = msg.copy()
		faint.base_clarity = CLARITY_FAINT
		for(var/mob/M in eavesdropping)
			M.hear_message(faint)

	if(length(watching))
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> [not_heard].</span>"
		for(var/mob/M in watching)
			M.show_message(rendered, 2)

	show_speech_bubble(msg, msg.to_string(), hear_clients)
	langchat_say_message(msg, get_hearers_in_view(msg.message_range, src), additional_styles = list("langchat_italic"))

	if(!(msg.single_language && (msg.single_language.flags & PASSLISTENOBJ)))
		for(var/obj/O as anything in inner)
			if(O)
				INVOKE_ASYNC(O, TYPE_PROC_REF(/obj, hear_talk), src, msg.to_string(), msg.verb, primary)

	if(mind)
		mind.last_words = msg.to_string()

	log_whisper("[key_name(src)] : [msg.raw_message]")
	return TRUE
