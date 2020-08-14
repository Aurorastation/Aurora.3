// At minimum every mob has a hear_say proc.

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!istype(src, /mob/living/test) && (!client && !vr_mob))
		return

	if(speaker && !istype(speaker, /mob/living/test) && (!speaker.client && istype(src,/mob/abstract/observer) && client.prefs.toggles & CHAT_GHOSTEARS && !(speaker in view(src))))
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
		return

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if ((T) && (!(isobserver(src)))) //Ghosts can hear even in vacuum.
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	if((sleeping && !vr_mob) || stat == 1)
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if((!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src))) && !isobserver(src))
			message = stars(message)

	if(!(language && (language.flags & INNATE))) // skip understanding checks for INNATE languages
		if(!say_understands(speaker,language))
			if(istype(speaker,/mob/living/simple_animal))
				var/mob/living/simple_animal/S = speaker
				message = pick(S.speak)
			else
				if(language)
					message = language.scramble(message, languages)
				else
					message = stars(message)

	var/accent_icon = speaker.get_accent_icon(language)
	var/speaker_name = speaker.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null
	if(isobserver(src))
		if(italics && client.prefs.toggles & CHAT_GHOSTRADIO)
			return
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[ghost_follow_link(speaker, src)] "
		if((client.prefs.toggles & CHAT_GHOSTEARS) && (speaker in view(src)))
			message = "<b>[message]</b>"

	if(isdeaf(src))
		if(!language || !(language.flags & INNATE)) // INNATE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
			if(speaker == src)
				to_chat(src, "<span class='warning'>You cannot hear yourself speak!</span>")
			else
				to_chat(src, "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear \him.")
	else
		if(language)
			on_hear_say("[track][accent_icon ? accent_icon + " " : ""]<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [language.format_message(message, verb)]</span>")
		else
			on_hear_say("[track]<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [verb], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
		if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			playsound_simple(source, speech_sound, sound_vol, use_random_freq = TRUE)
		return TRUE

/mob/proc/on_hear_say(var/message)
	to_chat(src, message)
	if(vr_mob)
		to_chat(vr_mob, message)

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	to_chat(src, "[time] [message]")
	if(vr_mob)
		to_chat(vr_mob, "[time] [message]")

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")
	if(!client && !vr_mob)
		return

	if((sleeping && !vr_mob) || stat==1) //If unconscious or sleeping
		hear_sleep(message)
		return

	var/track = null

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!(language && (language.flags & INNATE))) // skip understanding checks for INNATE languages
		if(!say_understands(speaker,language))
			if(istype(speaker,/mob/living/simple_animal))
				var/mob/living/simple_animal/S = speaker
				if(S.speak && S.speak.len)
					message = pick(S.speak)
				else
					return
			else
				if(language)
					message = language.scramble(message, languages)
				else
					message = stars(message)

		if(hard_to_hear)
			message = stars(message)

	var/speaker_name
	if(speaker != null)
		speaker_name = speaker.name
	else
		speaker_name = "Unknown"

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(vname)
		speaker_name = vname

	if(hard_to_hear)
		speaker_name = "Unknown"

	var/changed_voice
	var/accent_icon

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crew member being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if(H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice))
				changed_voice = 1
				var/list/impersonated = list()
				var/mob/living/carbon/human/I = impersonated[speaker_name]
				if(!I)
					for(var/mob/living/carbon/human/M in mob_list)
						if(M.real_name == speaker_name)
							I = M
							impersonated[speaker_name] = I
							break

				// If I's display name is currently different from the voice name and using an agent ID then don't impersonate
				// as this would allow the AI to track I and realize the mismatch.
				if(I && !(I.name != speaker_name && I.wear_id && istype(I.wear_id,/obj/item/card/id/syndicate)))
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Cyborg"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/abstract/observer))
		if(speaker != null)
			if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
				speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[ghost_follow_link(speaker, src)] "

	var/formatted
	if(language)
		formatted = language.format_message_radio(message, verb)
	else
		formatted = "[verb], <span class=\"body\">\"[message]\"</span>"
	if(isdeaf(src))
		if(prob(20))
			to_chat(src, "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>")
	else
		on_hear_radio(part_a, speaker_name, track, part_b, formatted, accent_icon)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[worldtime2text()]\]</span>"

/mob/proc/on_hear_radio(part_a, speaker_name, track, part_b, formatted, accent_icon)
	var/accent_tag
	if(accent_icon)
		accent_tag = "<IMG src='\ref['./icons/accent_tags.dmi']' class='text_tag' iconstate='[accent_icon]'>"
	to_chat(src, "[part_a][speaker_name][part_b][formatted]")
	if(vr_mob)
		to_chat(vr_mob, "[part_a][accent_tag][speaker_name][part_b][formatted]")

/mob/abstract/observer/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	to_chat(src, "[track][part_a][speaker_name][part_b][formatted]")

/mob/living/silicon/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	to_chat(src, "[time][part_a][speaker_name][part_b][formatted]")
	if(vr_mob)
		to_chat(vr_mob, "[time][part_a][speaker_name][part_b][formatted]")

/mob/living/silicon/ai/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	to_chat(src, "[time][part_a][track][part_b][formatted]")
	if(vr_mob)
		to_chat(vr_mob, "[time][part_a][track][part_b][formatted]")

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client || !speaker)
		return

	if(say_understands(speaker, language))
		message = "<B>[speaker]</B> [verb], \"[message]\""
	else
		var/adverb
		var/length = length(message) * pick(0.8, 0.9, 1.0, 1.1, 1.2)	//Inserts a little fuzziness.
		switch(length)
			if(0 to 12) 	adverb = " briefly"
			if(12 to 30)	adverb = " a short message"
			if(30 to 48)	adverb = " a message"
			if(48 to 90)	adverb = " a lengthy message"
			else        	adverb = " a very lengthy message"
		message = "<B>[speaker]</B> [verb][adverb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = text2list(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,length(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)
