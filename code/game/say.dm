/**
 * Shared local speech for mobs and objects. Message modifiers belong to the event.
 * speaking: optional forced language; null uses the speaker's language configuration.
 * message_mods: attribution (SAY_MOD_VERB), name suffix, and amplified presentation.
 * ghost_hearing: whether player-controlled speakers may reach distant ghost ears.
 * whisper: reduce local range; skip_edit: skip living speech impediments, not markup.
 * message_range: optional initial tile range, independent of speech-sound volume.
 */
/atom/movable/proc/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null)
	if(QDELETED(src) || !istext(text))
		return FALSE
	if(!isnull(message_range) && (!isnum(message_range) || message_range < 0))
		return FALSE
	// Player input is already HTML-encoded by say_verb; strip unsafe markup without double encoding.
	text = trim(copytext_char(sanitize(text, encode = FALSE), 1, MAX_MESSAGE_LEN))
	if(!length(text))
		return FALSE
	if(!ismob(src) && !can_speak(speaking || get_default_language()))
		return FALSE

	var/datum/language/forced_language = (speaking && !speaking.always_parse_language) ? speaking : null
	var/datum/say_message/msg = build_say_message(text, forced_language)
	msg.message_mods = message_mods ? message_mods.Copy() : list()
	msg.message_mode = msg.message_mods[SAY_MOD_MESSAGE_MODE]
	msg.whisper = whisper
	msg.message_range = isnull(message_range) ? world.view : message_range
	if(!length(msg.to_string()))
		return FALSE
	var/datum/language/primary = msg.segments[1].language
	if(copytext(msg.segments[1].text, 1, 2) == "%")
		msg.segments[1].text = copytext(msg.segments[1].text, 2)
		if(primary?.sing_verb)
			msg.singing = TRUE
			msg.sing_note = pick("\u2669", "\u266A", "\u266B")

	var/list/used_radios = list()
	var/prepared = prepare_say_message(msg, skip_edit, used_radios)
	if(prepared == SAY_PREPARE_HANDLED)
		return TRUE
	if(prepared != SAY_PREPARE_CONTINUE || QDELETED(src))
		return FALSE
	return send_speech(msg, used_radios, ghost_hearing)

/// Objects speak their configured language only; they do not inherit private mob channels.
/atom/movable/proc/get_default_language()
	return GLOB.all_languages[speech_language]

/atom/movable/proc/can_speak(datum/language/speaking)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	return speaking && speaking == get_default_language() && !(speaking.flags & (HIVEMIND|SIGNLANG))

/// Objects do not interpret player language prefixes. Mobs override both parser hooks.
/atom/movable/proc/get_language_trigger_regex()
	return regex("(?!)", "g")

/atom/movable/proc/resolve_language_key(key)
	return null

/atom/movable/proc/prepare_say_message(datum/say_message/msg, skip_edit, list/used_radios)
	var/datum/language/primary = msg.segments[1].language
	if(!msg.message_mods[SAY_MOD_VERB])
		msg.message_mods[SAY_MOD_VERB] = say_quote(msg.to_string(), primary, msg.singing, msg.whisper)
	if(msg.message_mods[MODE_AMPLIFIED])
		msg.font_size = FONT_SIZE_HUGE
	SEND_SIGNAL(src, COMSIG_MOVABLE_SAY_QUOTE, msg)
	if(QDELETED(src))
		return FALSE
	return finalize_say_message(msg, skip_edit) ? SAY_PREPARE_CONTINUE : FALSE

/atom/movable/proc/finalize_say_message(datum/say_message/msg, skip_edit = FALSE)
	for(var/datum/say_segment/segment as anything in msg.segments)
		segment.text = process_chat_markup(segment.text, list("~", "_"))
	return length(msg.to_string()) ? TRUE : FALSE

/// Physical propagation is shared; recipient-specific clarity remains with the receiver.
/atom/movable/proc/send_speech(datum/say_message/msg, list/used_radios, ghost_hearing)
	var/turf/origin = get_turf(src)
	if(!origin)
		return FALSE
	if(msg.whisper)
		msg.message_range = min(msg.message_range, 1)
		msg.italics = TRUE
	if(!(msg.single_language?.flags & PRESSUREPROOF))
		var/datum/gas_mixture/environment = origin.return_air()
		var/pressure = SAFE_XGM_PRESSURE(environment)
		if(pressure < SOUND_MINIMUM_PRESSURE)
			msg.message_range = min(msg.message_range, 1)
		if(pressure < ONE_ATMOSPHERE * 0.4)
			msg.italics = TRUE
			msg.sound_vol *= 0.5

	var/list/listening = get_speech_listeners(msg, used_radios, ghost_hearing)
	var/list/hear_clients = deliver_say_message(msg, listening)
	if(QDELETED(src))
		return FALSE
	present_say_message(msg, get_hearers_in_view(msg.message_range, src), hear_clients)
	finish_say_message(msg)
	return TRUE

/// Render speech at this emitter. Radio playback reuses presentation without repeating local delivery.
/atom/movable/proc/present_say_message(datum/say_message/msg, list/listeners, list/hear_clients)
	show_speech_bubble(msg, msg.to_string(), hear_clients)
	var/list/styles = list()
	if(istype(msg.single_language, /datum/language/noise))
		styles = list("emote", "langchat_small")
	if(msg.whisper)
		styles = list("langchat_italic")
	var/datum/language/primary = msg.segments[1].language
	if(primary && (msg.message_mods[SAY_MOD_VERB] in primary.shout_verb))
		styles = list("langchat_yell")
	if(msg.message_mods[MODE_AMPLIFIED] || msg.say_mode == SAYMODE_RADIO)
		styles += "radio"
	langchat_say_message(msg, listeners, additional_styles = styles)

/atom/movable/proc/get_speech_listeners(datum/say_message/msg, list/used_radios, ghost_hearing)
	var/list/listening = get_hearers_in_view(msg.message_range, src)
	return mergelists(listening, get_intent_listeners(src, msg.message_range + 1), TRUE)

/// Consume the local recipient list so older whisper adapters cannot dispatch it twice.
/atom/movable/proc/deliver_say_message(datum/say_message/msg, list/listeners)
	var/list/heard = list()
	for(var/atom/movable/listener as anything in listeners.Copy())
		if(QDELETED(listener))
			continue
		var/received = listener.Hear(msg)
		if(received && ismob(listener))
			var/mob/hearing_mob = listener
			if(hearing_mob.client)
				heard |= hearing_mob.client
	listeners.Cut()
	return heard

/atom/movable/proc/Hear(datum/say_message/msg)
	if(!istype(msg) || (QDELETED(msg.speaker) && msg.say_mode != SAYMODE_RADIO) || msg.delivered_to[src])
		return FALSE
	msg.delivered_to[src] = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, msg)
	return TRUE

/mob/Hear(datum/say_message/msg)
	if(!..())
		return FALSE
	return hear_message(msg)

/obj/Hear(datum/say_message/msg)
	if(!..())
		return FALSE
	if(msg.single_language?.flags & PASSLISTENOBJ)
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(hear_talk), msg.speaker, msg.to_string(), msg.message_mods[SAY_MOD_VERB], msg.segments[1].language, msg)
	return TRUE

/atom/movable/proc/show_speech_bubble(datum/say_message/msg, message, list/show_to)
	return

/atom/movable/proc/finish_say_message(datum/say_message/msg)
	log_say("[src] ([type]) : [msg.raw_message]")

/atom/movable/proc/has_speech_client()
	return FALSE

/mob/has_speech_client()
	return !isnull(client)

/atom/movable/proc/GetVoice()
	return name

/atom/movable/proc/get_accent_icon(datum/language/speaking, mob/hearer, force_accent)
	return null

/// Splits a message into per-language /datum/say_segment, switching language at each spoken prefix.
/// A forced language takes the whole message with no prefix parsing.
/atom/movable/proc/build_say_message(message, datum/language/forced_language)
	RETURN_TYPE(/datum/say_message)
	var/datum/say_message/say_message = new
	say_message.speaker = src
	say_message.raw_message = message

	if(!forced_language && !ismob(src))
		forced_language = get_default_language()
	if(forced_language)
		say_message.collapse_to(forced_language, message)
		return say_message

	var/datum/language/current = get_default_language()
	if(copytext(message, 1, 2) == "!")
		current = GLOB.all_languages[LANGUAGE_NOISE]
		message = trim_left(copytext(message, 2))

	var/regex/trigger = get_language_trigger_regex()
	trigger.next = 1

	var/segment_start = 1
	var/list/datum/say_segment/segments = list()

	while(trigger.Find(message))
		var/lead = trigger.group[1]	//empty at the start of the message, otherwise the whitespace before the prefix
		var/prefix_pos = trigger.index + length(lead)
		var/key_pos = prefix_pos + 1

		var/key_len = 2
		var/datum/language/found = resolve_language_key(copytext(message, key_pos, key_pos + 2))
		if(!found)
			key_len = 1
			found = resolve_language_key(copytext(message, key_pos, key_pos + 1))
		if(!found)
			continue	//not a language we can speak, leave it as literal text and keep scanning

		var/before = copytext(message, segment_start, prefix_pos)

		var/after = key_pos + key_len
		if(copytext(message, after, after + 1) == " ")
			after++

		// If LANG_NO_MULTILANG is present, it must be first. If first,
		// set the whole message to that language. If not, skip it.
		if(found.flags & LANG_NO_MULTILANG)
			if(!length(segments) && !length(before))
				say_message.collapse_to(found, copytext(message, after))
				return say_message
			continue

		segments += new /datum/say_segment(before, current)
		segment_start = after
		current = found
		trigger.next = after

	segments += new /datum/say_segment(copytext(message, segment_start), current)
	say_message.segments = clean_segments(segments)
	say_message.single_language = (length(say_message.segments) == 1) ? say_message.segments[1].language : null
	return say_message
