/// Resolves how clearly this listener perceives the message.
/mob/proc/get_clarity(datum/say_message/msg)
	var/mob/speaker = msg.speaker

	if(msg.mode == SAYMODE_SIGN)
		if(isghost(src))
			return msg.base_clarity
		if((src.sdisabilities & BLIND) || src.blinded || !speaker || !(speaker in view(src)))
			return CLARITY_NONE
		return msg.base_clarity

	if(!(msg.single_language?.flags & PRESSUREPROOF) && !isghost(src))
		var/turf/T = get_turf(src)
		if(T)
			var/pressure = SAFE_XGM_PRESSURE(T.return_air())
			if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
				if(get_dist(speaker, src) <= 4 && !msg.italics)
					to_chat(src, SPAN_NOTICE("[speaker?.name] talks, but you're in a vacuum. Maybe if you were close enough for the sound to transmit through touch..."))
				return CLARITY_NONE

	// vr_mob entails a Psionic mob. They hear clearly even when not conscious.
	if(!vr_mob && (sleeping || stat == UNCONSCIOUS))
		return CLARITY_DROWSY

	if(isdeaf(src))
		// INNATE is an audible emote. Gives no 'cannot hear' message.
		if(!(msg.single_language?.flags & INNATE))
			if(speaker == src)
				to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
			else
				to_chat(src, "<span class='name'>[speaker?.name]</span>[msg.alt_name] talks but you cannot hear them.")
			return CLARITY_NONE
		return msg.base_clarity

	return msg.base_clarity

/// Whether a message can be shown to this mob at all.
/mob/proc/has_chat_sink()
	return client || vr_mob

/mob/living/carbon/has_chat_sink()
	. = ..()
	if(.)
		return TRUE
	var/datum/dionastats/DS = get_dionastats()
	return DS?.nym ? TRUE : FALSE

/mob/living/carbon/alien/diona/has_chat_sink()
	. = ..()
	if(.)
		return TRUE
	return (detached && gestalt) ? TRUE : FALSE

/// Builds the correct envelope around the body depending on SAYMODE.
/mob/proc/format_envelope(datum/say_message/msg, body, muffled = FALSE)
	switch(msg.mode)
		if(SAYMODE_SIGN)
			return format_envelope_sign(msg, body)
		if(SAYMODE_RADIO)
			return format_envelope_radio(msg, body)
		else
			return format_envelope_spoken(msg, body, muffled)

/// Wraps a say envelope around the message body.
/mob/proc/format_envelope_spoken(datum/say_message/msg, body, muffled = FALSE)
	var/mob/speaker = msg.speaker
	var/speaker_name = speaker?.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	var/datum/language/accent_language
	for(var/datum/say_segment/segment as anything in msg.segments)
		if(segment.language?.allow_accents)
			accent_language = segment.language
			break
	var/accent_icon = accent_language ? speaker?.get_accent_icon(accent_language, src) : null

	if(msg.italics || muffled)
		body = "<i>[body]</i>"

	var/track = null
	if(isghost(src))
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[ghost_follow_link(speaker, src)] "
		if((client.prefs.toggles & CHAT_GHOSTEARS) && (get_turf(speaker) in view(src)))
			body = "<b>[body]</b>"

	var/font_open = msg.font_size ? "<font size='[msg.font_size]'>" : ""
	var/font_close = msg.font_size ? "</font>" : ""
	return "[track][accent_icon ? accent_icon + " " : ""][font_open]<span class='game say'><span class='name'>[speaker_name]</span>[msg.alt_name] [msg.verb], <span class='message'>\"[body]\"</span></span>[font_close]"

/// Wraps a radio envelope around the message body.
/mob/proc/format_envelope_radio(datum/say_message/msg, body)
	var/mob/speaker = msg.speaker
	var/hard_to_hear = (msg.base_clarity == CLARITY_FAINT)
	var/list/radio_parts = msg.radio_parts
	var/part_a = LAZYACCESS(radio_parts, 1)
	var/part_b = LAZYACCESS(radio_parts, 2)
	var/part_c = LAZYACCESS(radio_parts, 3)

	var/speaker_name = speaker ? speaker.name : "Unknown"
	if(ishuman(speaker))
		speaker_name = speaker.GetVoice()
	if(hard_to_hear)
		speaker_name = "Unknown"

	var/datum/language/language = msg.single_language
	var/accent_icon = speaker?.get_accent_icon(language, src)
	accent_icon = accent_icon ? accent_icon + " " : ""
	part_a = replacetext(part_a, "%ACCENT%", accent_icon)

	var/track = null
	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/changed_voice
		var/jobname
		var/mob/living/carbon/human/impersonating

		if(ishuman(speaker))
			var/mob/living/carbon/human/H = speaker
			if(H.wear_mask && istype(H.wear_mask, /obj/item/clothing/mask/gas/voice))
				changed_voice = 1
				var/mob/living/carbon/human/I
				for(var/mob/living/carbon/human/M in GLOB.mob_list)
					if(M.real_name == speaker_name)
						I = M
						break
				if(I && !(I.name != speaker_name && I.wear_id && istype(I.wear_id, /obj/item/card/id/syndicate)))
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()
		else if(iscarbon(speaker))
			jobname = "No id"
		else if(isAI(speaker))
			jobname = "AI"
		else if(isrobot(speaker))
			jobname = "Cyborg"
		else if(istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a class='ai_tracking' href='byond://?src=[REF(src)];trackname=[html_encode(speaker_name)];track=[REF(impersonating)]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a class='ai_tracking' href='byond://?src=[REF(src)];trackname=[html_encode(speaker_name)];track=[REF(speaker)]'>[speaker_name] ([jobname])</a>"

	if(isghost(src))
		if(speaker != null)
			if(speaker_name != speaker.real_name && !isAI(speaker))
				speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[ghost_follow_link(speaker, src)] "

	var/formatted
	if(language)
		formatted = language.format_message_radio(body, msg.verb)
	else
		formatted = "[msg.verb], <span class=\"body\">\"[body]\"</span>"
	formatted += part_c

	if(istype(src, /mob/living/silicon/ai) && track && !hard_to_hear)
		return "[part_a][track][part_b][formatted]"
	if(isghost(src))
		return "[track][part_a][speaker_name][part_b][formatted]"
	return "[part_a][speaker_name][part_b][formatted]"

/mob/proc/format_envelope_sign(datum/say_message/msg, body)
	var/mob/speaker = msg.speaker
	if(say_understands(speaker, msg.single_language))
		return "<B>[speaker]</B> [msg.verb], \"[body]\""
	var/list/sign_adv_length = msg.single_language?.sign_adv_length
	if(length(sign_adv_length) <= 4)
		sign_adv_length = list(" briefly", " a short message", " a message", " a lengthy message", " a very lengthy message")
	var/adverb
	var/length = length(body) * pick(0.8, 0.9, 1.0, 1.1, 1.2) // a little fuzziness
	switch(length)
		if(0 to 12)		adverb = sign_adv_length[1]
		if(12 to 30)	adverb = sign_adv_length[2]
		if(30 to 48)	adverb = sign_adv_length[3]
		if(48 to 90)	adverb = sign_adv_length[4]
		else			adverb = sign_adv_length[5]
	return "<B>[speaker]</B> [msg.verb][adverb]."

/// Handles a mob receiving a say.
/mob/proc/hear_message(datum/say_message/msg)
	var/clarity = get_clarity(msg)
	if(clarity == CLARITY_NONE)
		return FALSE
	. = FALSE
	if(has_chat_sink())
		display_message(msg, clarity)
		. = TRUE
	react_to_message(msg)

/// Noop by default. Overriden by clientless mobs that react to speech.
/mob/proc/react_to_message(datum/say_message/msg)
	return

/// Renders the body for this listener, then decorates and outputs it.
/mob/proc/display_message(datum/say_message/msg, clarity)
	var/mob/speaker = msg.speaker
	// Ghosts skip clientless out-of-view chatter.
	if(isghost(src) && speaker && !speaker.client && (client?.prefs.toggles & CHAT_GHOSTEARS) && !(speaker in view(src)))
		return

	var/body = msg.render_for(src, clarity)
	if(!length(body))
		return

	if(clarity == CLARITY_DROWSY)
		on_hear_message(body)
		return


	// In thin air, non-pressureproof languages are muffled.
	var/muffled = FALSE
	var/sound_vol = msg.sound_vol
	if(!isghost(src) && !(msg.single_language?.flags & PRESSUREPROOF))
		var/turf/T = get_turf(src)
		if(T && SAFE_XGM_PRESSURE(T.return_air()) < ONE_ATMOSPHERE * 0.4)
			muffled = TRUE
			sound_vol *= 0.5

	var/envelope = format_envelope(msg, body, muffled)
	on_hear_message(envelope)
	// This is a special case for internal mobs like cortical borers.
	// They see through the eyes of their host so we must relay the message.
	if(msg.mode == SAYMODE_SIGN && (status_flags & PASSEMOTES))
		for(var/obj/item/holder/H in contents)
			H.show_message(envelope)
		for(var/mob/living/M in contents)
			M.show_message(envelope)
	play_speech_sound(msg, sound_vol)

/// Plays the speech sound for a given message.
/mob/proc/play_speech_sound(datum/say_message/msg, sound_vol)
	var/mob/speaker = msg.speaker
	if(msg.speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker?.z))
		var/turf/source = speaker ? get_turf(speaker) : get_turf(src)
		playsound(source, msg.speech_sound, sound_vol, vary = TRUE)

/// The output sink for a given message.
/mob/proc/on_hear_message(message)
	to_chat(src, message)
	if(vr_mob)
		to_chat(vr_mob, message)

/// Dionae require special treatment. Messages should be forwarded to the nymph.
/mob/living/carbon/on_hear_message(message)
	..()
	var/datum/dionastats/DS = get_dionastats()
	if(DS?.nym)
		var/mob/living/carbon/alien/diona/D = DS.nym.resolve()
		if(D)
			to_chat(D, message)

/// A detached gestalt should be forwarded heard messages.
/mob/living/carbon/alien/diona/on_hear_message(message)
	to_chat(src, message)
	if(detached && gestalt)
		to_chat(gestalt, message)

/// Silicons receive a timestamp with heard messages.
/mob/living/silicon/on_hear_message(message)
	var/time = say_timestamp()
	to_chat(src, "[time] [message]")
	if(vr_mob)
		to_chat(vr_mob, "[time] [message]")
